const CheckoutStage = {
    CHECK_VALIDITY_UPDATE: 'CHECK_VALIDITY_UPDATE',
    REPORT_VALIDITY_SAVE: 'REPORT_VALIDITY_SAVE',
    BEFORE_PAYMENT: 'BEFORE_PAYMENT',
    PAYMENT: 'PAYMENT',
    BEFORE_PLACE_ORDER: 'BEFORE_PLACE_ORDER',
    PLACE_ORDER: 'PLACE_ORDER'
  };

const AddressTypes = {
    SHIPPING: 'Shipping',
    BILLING: 'Billing'
};

const CheckoutError = {
    CHECKOUT_FORM_BUSY: 'CHECKOUT_FORM_BUSY'
};

const SHIPPING_ADDRESS_GROUP_CODE = 'ShippingAddress';

/**
 * 
 * Find the first object in the array that has all of the keys for the obj param
 * and has the same values for that key. If not found, return -1.
 * The object in the array can have additional values other than those
 * present in the obj.
 * 
 */
function findIndexWithSameValues(array, obj, keysToIgnore = []) {
    // console.log('shippingAddressUtils findIndexWithSameValues');
    for (let i = 0; i < array.length; i++) {
        const currentObj = array[i];
        if (Object.keys(obj).every(key => {
            // console.log('shippingAddressUtils i: '+i+', key: '+key+', obj[key]: '+obj[key]+', currentObj[key]: '+currentObj[key]);
            return  (
                keysToIgnore.includes(key) || 
                (currentObj.hasOwnProperty(key) && 
                obj[key] === currentObj[key]) ||
                ((!obj[key]) && (!currentObj[key]))
            );
        })) {
            return i;
        }
    }
    return -1; // If not found
}


/**
 * 
 * Returns whether the address has a ContactPointAddress addressId value
 * and so has been created already
 * 
 */
function isAlreadyContactPointAddress(address){
    return Boolean(address['addressId']);
}

/**
 * 
 * This component uses the Contact Point Address attribute names by default. 
 * The deliveryAddress attributes are differnt and must be mapped.
 * This routine maps the attributes for a ContactPointAddress to a Delivery Address.
 * 
 */
function mapContactPointAddressToDeliveryAddress(cpa){
    return {
        name: cpa['Name'],
        firstName: cpa['AddressFirstName'], 
        lastName: cpa['AddressLastName'],
        street: cpa['Street'],
        city: cpa['City'],
        region: cpa['StateCode'],
        postalCode: cpa['PostalCode'],
        country: cpa['CountryCode'],
        isDefault: cpa['IsDefault']
        }
}

/**
 * 
 * Builds a data structure from the retrived, dependent picklist values for StateCode. 
 * Example is [{'US': {'attributes': null, 'label': 'United States', 'value': 'US', validFor[235]}}]
 * The data structure supports the requirements of the ModalCheckoutAddressForm component
 */

function mapRegionCodes(pickListInfo) {

    function swapKeysAndValues(obj) {
        const swappedObject = {};
        for (const [key, value] of Object.entries(obj)) {
            if (typeof value === 'string' || typeof value === 'number') {
                swappedObject[value] = key;
            } else {
                throw new Error('All values must be strings or numbers to be used as keys in the resulting object');
            }
        }
        return swappedObject;
    };

    function groupByTopLevelKey(data) {
        const result = {};
    
        data.forEach(item => {
            // Get the top level key (e.g., "BR", "IT", etc.)
            const topLevelKey = Object.keys(item)[0];
            // Get the value object associated with the top level key
            const valueObject = item[topLevelKey];
    
            // Check if the key already exists in the result
            if (!result[topLevelKey]) {
                // If it doesn't exist, initialize it with an empty array
                result[topLevelKey] = [];
            }
            // Add the value object to the array for this key
            result[topLevelKey].push(valueObject);
        });
    
        return result;
    }

    if (!pickListInfo['controllerValues'] || !pickListInfo['values']) {
        console.error('shippingAddresses no valid state picklist information');
        return [];
    }

    // flip the controller info from [{countryCode: validForIndex}] to [{validForIndex: countryCode}]
    const validForIndexToCode = swapKeysAndValues(pickListInfo.controllerValues);

    // create a structure with countyCode as the key and the list of valid region picklist values 
    // as a child object
    // [{countryCode: {label: 'label', value: 'value', ...}}]
    const regionsWithCountry =  pickListInfo.values.map((entry) => {
        const key = validForIndexToCode[entry.validFor[0]];
        let newEntry = {};

        newEntry[key] = entry;

        return newEntry;
    });

    return groupByTopLevelKey(regionsWithCountry);
}

/**
 * 
 * Determine if a passed in object is empty.
 * 
 */
function isEmptyObj(obj){
    return (Object.keys(obj).length === 0) 
}


/**
 * 
 * @param {*} compareObj object to see if it is contained within the targetObj
 * @param {*} targetObj  reference object to compare against, can have extra keys
 * @param {*} keysToIgnore array of keys to ignore in the compareObj 
 * @returns boolen whether compareObj is contained in the targetObj
 */
function objShallowContains ( compareObj = {}, targetObj = {}, keysToIgnore = []) {
    return Object.keys(compareObj).every(key => {
        return  (keysToIgnore.includes(key) || (targetObj.hasOwnProperty(key) && (compareObj[key] === targetObj[key])));
    });
};

/**
 * 
 * Determine if the newAddress is different in its values from the 
 * originalAddress
 * 
 */
function addressChanged ( originalAddress = {}, newAddress ={} ) {
    return !objShallowContains (newAddress, originalAddress, ['name']);
}

export {
    CheckoutStage,
    AddressTypes,
    CheckoutError,
    SHIPPING_ADDRESS_GROUP_CODE,
    isAlreadyContactPointAddress,
    mapContactPointAddressToDeliveryAddress,
    findIndexWithSameValues,
    mapRegionCodes,
    isEmptyObj,
    objShallowContains,
    addressChanged
};