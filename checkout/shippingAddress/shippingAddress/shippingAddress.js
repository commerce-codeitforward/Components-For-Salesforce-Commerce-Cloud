import { wire, api, track } from "lwc";
import { 
    CheckoutInformationAdapter,
    CheckoutComponentBase,
    createContactPointAddress,
    CheckoutAddressAdapter,
    updateContactPointAddress
    } from 'commerce/checkoutApi';
import communityId from '@salesforce/community/Id';

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CONTACTPOINTADDRESS_OBJECT from '@salesforce/schema/ContactPointAddress';
import COUNTRY_CODE_FIELD from '@salesforce/schema/ContactPointAddress.CountryCode';
import STATE_CODE_FIELD from '@salesforce/schema/ContactPointAddress.StateCode';
import { SessionContextAdapter } from 'commerce/contextApi';
import getValidCountryCodes from '@salesforce/apex/StoreCountryStateCodes.getValidCountryCodes';
import getValidStateCodesByCode from '@salesforce/apex/StoreCountryStateCodes.getValidStateCodesByCode';
import { 
    CheckoutStage, 
    AddressTypes,
    CheckoutError,
    SHIPPING_ADDRESS_GROUP_CODE,
    findIndexWithSameValues,
    mapRegionCodes,
    isEmptyObj
    } from './shippingAddressUtils';
import { WireStatus } from './wireStatus';
import ModalCheckoutAddressForm from 'c/modalCheckoutAddressForm';
import { mockedAddressData } from './shippingAddressMock';

export default class ShippingAddress extends CheckoutComponentBase {
    currentCommunityId;
    webstoreId;
    cpaRecordTypeId;

    workingAddress = {};

    @track shippingAddresses = [];
    checkoutAddresses = [];

    checkoutAddressesLoaded = false;
    deliveryAddressLoaded = false;

    countryCodePicklistInfo;
    stateCodePicklistInfo;

    @track validCountryCodes = [];
    @track validRegionCodeData = [];

    showNewAddress = false;

    isDisabled = false;
    isSummary = false;

    isPreview;

    showError = false;
    error;

    @api filterCountries;
    @api filterRegions;
    @api noShippingMessage = '';
    @api checkoutCart;

    checkoutAddressStatus = new WireStatus();
    checkoutInfoStatus = new WireStatus();

    sessionContext; 

    deliveryIndex = 0;

    /**
     * 
     * Set the communityId when the component is connected
     * 
     */
    connectedCallback() {
        this.currentCommunityId = communityId;
    }

    /**
     * 
     * When checkoutCart is populated, grab the webstoreId
     * 
     */
    renderedCallback() {
        if (this.checkoutCart) {
            this.webstoreId = this.checkoutCart.webstoreId;
        }
        this.setCountryCodes();
        this.setRegionCodes();
    }

    /**
     * 
     * Get the defaultRecordTypeId for the ContactPointAddress object to use in other calls
     * 
     */
    @wire(getObjectInfo, { objectApiName: CONTACTPOINTADDRESS_OBJECT })
    results({ error, data }) {
      if (data) {
        this.cpaRecordTypeId = data.defaultRecordTypeId;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.accountRecordTypeId = undefined;
      }
    }

    /**
     * 
     * Get the standard picklist values for the Country Field for the defaultRecordTypeId
     * 
     */
    @wire(getPicklistValues, {
        recordTypeId: "$cpaRecordTypeId", // Default record type Id
        fieldApiName: COUNTRY_CODE_FIELD
    })
    getCountryPicklistValues({ error, data }) {
        if (data) {
            this.countryCodePicklistInfo = data;        
            this.setCountryCodes();
        } else if (error) {
            // Handle error
            console.error('shippingAddress error getting country code values: '+JSON.stringify(error));
        }
    }

    /**
     * 
     * Get the standard picklist values for the Region for the defaultRecordTypeId. Also transform them 
     * to what the address modal expects 
     * 
     */
    @wire(getPicklistValues, {
        recordTypeId: "$cpaRecordTypeId", // Default record type Id
        fieldApiName: STATE_CODE_FIELD
    })
    getStatePicklistValues({ error, data }) {
        if (data) {
            this.stateCodePicklistInfo = mapRegionCodes(data);
            this.setRegionCodes();
        } else if (error) {
            // Handle error
            console.error('shippingAddress error getting state code values: '+JSON.stringify(error));
        }
    }

    /**
     * 
     * Get the Session Context information
     * 
     */
    @wire(SessionContextAdapter)
    setSessionContext({ error, data }){
        if (data) {
            this.sessionContext = data;
        } else {
            console.log('##shippingAddress SessionContextAdapter Error: '+JSON.stringify(error));
        }
    }

    /**
     * 
     * Populate the Shipping Addresses for the account and call prepareAddressData to merge with
     * DeliveryAddress information 
     * 
     */
    @wire(CheckoutAddressAdapter, {addressType: AddressTypes.SHIPPING})
    checkoutAddress({ error, data }){
        this.isPreview = this.isInSitePreview();
        this.showError = false;

        if (!this.isPreview) {
            if (data) {
                // create clone to allow manipulation of address information
                this.checkoutAddresses = JSON.parse(JSON.stringify(data.items));

                // if we initiated the wire update, swallow the first set of data as it is not current
                if (this.checkoutAddressStatus.selfTriggered && (this.checkoutAddressStatus.triggerCount < 1)) {
                    this.checkoutAddressStatus.increment();
                    return; 
                }

                this.checkoutAddressStatus.reset()

                if (!isEmptyObj(this.workingAddress) && (this.checkoutAddresses.length === 0)) {
                    return; 
                }
                // signal to prepareAddressData that we have CheckoutAddress info for call to prepareAddressData.
                this.checkoutAddressesLoaded = true;
                this.prepareAddressData();
            } else if (error) {
                console.error('##shippingAddress CheckoutAddressAdapter Error: '+JSON.stringify(error));
                this.checkoutAddresses = [];
                // signal to prepareAddressData that we have CheckoutAddress info and call prepareAddressData.
                this.checkoutAddressesLoaded = true;
                this.prepareAddressData();
            }
        }
    }

    /**
     * 
     * Get the CheckoutData from the standard salesforce adapter
     * Response is expected to be 202 while checkout is starting
     * Response will be 200 when checkout start is complete and we can begin processing checkout data. 
     * Upon recieving data, call prepareAddressData to merge with CheckoutAddress information. 
     * 
     */
    @wire(CheckoutInformationAdapter, { })
    async checkoutInfo({ error, data }) {
        this.isPreview = this.isInSitePreview();
        this.showError = false;
        if (!this.isPreview) {
            if (data) {
                if(data.checkoutStatus === 200){
                    // if we initiated the wire update, swallow the first set of data as it is not current
                    if (this.checkoutInfoStatus.selfTriggered && (this.checkoutInfoStatus.triggerCount < 1)) {
                        this.checkoutInfoStatus.increment();
                        return; 
                    }

                    this.checkoutInfoStatus.reset();

                    this.workingAddress = data.deliveryGroups.items[0]['deliveryAddress'] ? data.deliveryGroups.items[0]['deliveryAddress']: {};

                    // signal to prepareAddressData that we have Checkout Information info and call prepareAddressData.
                    this.deliveryAddressLoaded = true;
                    this.prepareAddressData();
                }
          } else if (error) {
                console.error('##shippingAddress checkoutInfo Error: '+error);
                this.showError = true;
                this.error = "Checkout encountered an error, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
          }
      } else {
        this.shippingAddress = mockedAddressData;
        this.shippingAddresses.push(mockedAddressData);
      }
    }

    /**
     * 
     * Handles the aspects changing on the site.
     * 
     */
    setAspect(newAspect) {
        // If the aspect is a summary, we disable the form
        if(newAspect.summary){
            this.isDisabled = true;
            this.isSummary = true;
        }else {
            this.isDisabled = false;
            this.isSummary = false;
        }
    }

    /**
     * 
     * Build the address information combining the CheckoutAddress info with the DeliveryAddress information. 
     * When the information is build, set shippingAddresses to trigger rendering. 
     * 
     */
    prepareAddressData(){
        // only process information when we have both sets of current information. 
        if (this.checkoutAddressesLoaded && this.deliveryAddressLoaded) {

            let workingAddresses = JSON.parse(JSON.stringify(this.checkoutAddresses));
            this.showNewAddress = false;

            const deliveryIndex = Boolean(this.workingAddress && !isEmptyObj(this.workingAddress)) ?
                    findIndexWithSameValues(workingAddresses, this.workingAddress, ['name','isDefault', 'fields', 'isDelivery']) :
                    -1;

            if (deliveryIndex > -1) {
                workingAddresses[deliveryIndex].isDelivery = true;

                // point the deliverAddress to the shipping address record with extra attributes. 
                this.workingAddress = workingAddresses[deliveryIndex];
                this.deliveryIndex = deliveryIndex;
            } else {
                // Adding delivery address (if present) into the addresss list if not found in the contact point addresses. 
                if (!isEmptyObj(this.workingAddress)) {
                    const nameElement = this.workingAddress.name ?
                        {} :
                        {name: this.workingAddress.firstName+' '+this.workingAddress.lastName};
                    this.workingAddress = {isDelivery: true, ...this.workingAddress, ...nameElement};
                    workingAddresses.unshift(this.workingAddress);
                } 
                
                // No address information present from checkout addresses or checkout information, so show new address form
                if (!workingAddresses.length > 0) {
                    this.showNewAddress = true; 
                }
            }
            this.shippingAddresses = workingAddresses;
        }
    }

    /**
     * Handles when an address is picked from the address list
     */
    async handleAddressPick(event){
        const selectedIndex = this.shippingAddresses.findIndex(addr => {
            return addr.addressId === event.target.value;
        });

        if (selectedIndex < 0) return console.error('Unable to find address with Id :'+event.target.value);

        this.deliveryIndex = selectedIndex;

        try {

            this.workingAddress = JSON.parse(JSON.stringify(this.shippingAddresses[selectedIndex]));

            this.checkoutAddresses = this.checkoutAddresses.filter((addr) => {
                return addr['addressId'] ? addr : null;
            });

            const updateResult = await this.updateDataProvider(this.workingAddress);
            this.dispatchCommit();
        } catch (error) {
            console.error('shippingAddress Error Updating Shipping Address: '+error);
            this.showError = true;
            this.error = "Error updating shipping address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
        }
    }


    /**
     * 
     * Handles when the edit address button is clicked 
     * 
     */
    async handleEditAddressClick(event) {
        //get addresss information for selected address
        
        const editIndex = Number(event.target.dataset.index);
        let editAddress = this.shippingAddresses[editIndex];

        const modalResult = await ModalCheckoutAddressForm.open({
            size: 'small',
            description: 'Enter Shipping Address',
            content: '',
            address: editAddress,
            label: 'Enter Shipping Address',
            title: 'Enter Shipping Address',
            countryOptions: this.validCountryCodes,
            allRegionOptions: this.validRegionCodeData,
            required: true
        });

        if (modalResult['changed']) {
            try {
                editAddress = { ...editAddress, ...modalResult['address'] };
                // we updated the current delivery address, so need to keep workingAddress current
                if (editIndex == this.deliveryIndex) {
                    this.workingAddress = editAddress;
                }
                this.updateAddresses(editAddress);                
            } catch (error) {
                console.error('shippingAddress Error Updating Shipping Address: '+error);
                this.showError = true;
                this.error = "Error editing the address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
            }           
        }
    }

    /**
     * 
     * Handles when the New Address button is clicked 
     * 
     */
    async handleNewAddressClick() {
        const modalResult = await ModalCheckoutAddressForm.open({
            size: 'small',
            description: 'Enter New Shipping Address',
            content: '',
            address: { },
            label: 'Enter Shipping Address',
            title: 'Enter Shipping Address',
            countryOptions: this.validCountryCodes,
            allRegionOptions: this.validRegionCodeData,
            required: true
        });
        if (modalResult.changed) {
            try {
                this.workingAddress = JSON.parse(JSON.stringify(modalResult.address));
                await this.updateDataProvider(this.workingAddress);
                // not expecting delivery addresses to be refreshed
                await this.createContactPointAddressForUser(this.workingAddress);
                this.dispatchCommit();
            } catch (error) {
                console.error('shippingAddress Error Creating Shipping Address: '+error);
                this.showError = true;
                this.error = "Error adding the address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
            }           
        }
    }

    /**
     * 
     * For inline address form processes address update commits comming from the address form. 
     * 
     */
    async handleAddressCommitEvent(event) {
        const addressForm = this.template.querySelector("c-address-form");
        this.workingAddress = addressForm.getAddress();
        try {
            await this.updateDataProvider(this.workingAddress);
            this.dispatchCommit();
        } catch (error) {
            console.error('shippingAddress Error updating deliver address from address form: '+error);
            this.showError = true;
            this.error = "Error adding the address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
        }  
    }

    /**
     * 
     * For inline address form processes address update commits comming from the address form. 
     * 
     */
    async updateAddresses(address) {


        this.checkoutAddressesLoaded = false;
        this.deliveryAddressLoaded = true;

        let workingAddress = JSON.parse(JSON.stringify(address));
        
        // if the record has an addressId, it came from contact point addresses and needs to be updated.
        if (address['addressId']) {
            try {
                const addressResult = await this.updateContactPointAddressWrapper(workingAddress);
            } catch (error) {
                if (error === CheckoutError.CHECKOUT_FORM_BUSY) {
                    setTimeout(() => {
                        this.updateContactPointAddressWrapper(workingAddress);
                    }, 1000);
                    return;
                }
                this.showError = true;
                this.error = "Error updating the address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
            }
             
        } else this.checkoutAddressesLoaded = true;
        
        // if the address has isDelivery as true, it is the current shipping address and should be updated.
        if (address['isDelivery']) {
            try {
                const deliveryResult = await this.updateDataProvider(address);
            } catch (error) {
                if (error === CheckoutError.CHECKOUT_FORM_BUSY) {
                    setTimeout(() => {
                        this.updateDataProvider(address);
                    }, 1000);
                    return;
                }
                this.showError = true;
                this.error = "Error updating the address, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
            }
        }
        this.dispatchCommit();
    }

    /**
     * 
     * Update the contact point address for
     * information entered.
     * 
     **/
    async updateContactPointAddressWrapper(address) {
        try{
            this.checkoutAddressStatus.reset();
            this.checkoutAddressStatus.selfTriggered = true;
            delete address['isDelivery'];
            const result = await updateContactPointAddress(address);
            return result;
        }
        catch (error) {
            const msg = 'shippingAddress Error updating address';
            console.error(msg+': '+error);
            throw new Error(msg, {cause: error});
        }
    }

    /**
     * 
     * Create the contact point address if there is a logged in user. 
     * information entered.
     * 
     **/
    async createContactPointAddressForUser() {
        // is a new address
        if (!this.sessionContext['guestUser']) {
            try {
                this.deliveryAddressLoaded = true;
                this.checkoutAddressStatus.reset();
                this.checkoutAddressStatus.selfTriggered = true;
                const createResult = await createContactPointAddress({...this.workingAddress, addressType: AddressTypes.SHIPPING});
            } catch (error) {
                const msg = 'shippingAddress Error creating new address';
                console.error(msg+': '+error);
                throw new Error(msg, {cause: error});
            }
        } else this.checkoutAddressesLoaded = true;
    }

    /**
     * 
     * update delivery information data provider component with new deliveryAddress information
     * 
     */
    async updateDataProvider(address) {
        const formRequest = {
            defaultDeliveryGroup: {
                deliveryAddress: address
            }
        }
        try {
            this.checkoutInfoStatus.reset();
            this.checkoutInfoStatus.selfTriggered = true;
            await this.dispatchUpdateAsync(formRequest);
        } catch (error) {
            const msg = 'shippingAddress Error updating delivery address information';
            console.error(msg+': '+error);
            throw new Error(msg, {cause: error});
        }
    }

    /**
     * 
     * returns the set of valid country options for filtered values. If the filterCountries option is 
     * selected, the options are retrived via a call to getValidCountryCodes. Otherwise, the options are 
     * retrived from the picklist values in metadata for the field. 
     * 
     */
    async getFilteredCountryOptions () {
        try {
            let sfCountryCodes = await getValidCountryCodes({storeId: this.webstoreId});
            return sfCountryCodes;
        } catch (error) {
            console.error ('shippingAddress error getting country codes: '+error);
            return [];
        }
    }

    /**
     * 
     * returns the set of all valid region options for the State/Province picklist. If the filterStates option is 
     * selected, the options are retrived via a call to getValidStateCodes. Otherwise, the options are 
     * retrived from the picklist values in metadata for the field. 
     * 
     */
    async getFilteredRegionOptions(){    
        try {
            const sfRegionCodes = await getValidStateCodesByCode({storeId: this.webstoreId});
            return sfRegionCodes;
        } catch (error) {
            console.error ('shippingAddress error getting country codes: '+error);
            return [];
        }
    }

    /**
     * 
     * sets the Country Code picklist values for forms. If the filterCountries option is 
     * selected, the options are retrived via a call to getValidCountryCodes. Otherwise, the options are 
     * retrived from the picklist values in metadata for the field. 
     * 
     */
    async setCountryCodes() { 
        if (this.filterCountries) {
            this.validCountryCodes = await this.getFilteredCountryOptions();
            return;
        }

        // use default list of country codes
        if (this.countryCodePicklistInfo) {
            this.validCountryCodes =  this.countryCodePicklistInfo.values;
            return; 
        }
    }

    /**
     * 
     * sets the region code picklist values for forms. If the filterRegions option is 
     * selected, the options are retrived via a call to getFilteredRegionOptions. Otherwise, the options are 
     * retrived from the picklist values in metadata for the field. 
     * 
     */
    async setRegionCodes() {
        if (this.filterRegions) {
            this.validRegionCodeData = await this.getFilteredRegionOptions();
            return; 
        }

        if (this.stateCodePicklistInfo) {
            this.validRegionCodeData = this.stateCodePicklistInfo;
            return; 
        }
    }

    /**
     * update form when our container asks us to and create Contact Point Address
     * for new addresses not created yet. 
     */
    stageAction(checkoutStage /*CheckoutStage*/) {
        // console.log('shippingAddress stageAction received stage: '+checkoutStage);
        switch (checkoutStage) {
            case CheckoutStage.CHECK_VALIDITY_UPDATE:
                if (this.checkValidity()) this.clearCheckoutError();
                return Promise.resolve(this.checkValidity());
            case CheckoutStage.REPORT_VALIDITY_SAVE:
                // mimics default behavior of creating the initial contact point address when the delivery address is commited
                if (this.checkValidity() && this.showNewAddress) {
                    this.createContactPointAddressForUser(this.workingAddress);
                }
                return Promise.resolve(this.reportValidity());
            default:
                return Promise.resolve(true);
        }
    }

    /**
     * 
     * determine if an address is valid.
     *  
     */
    isValidAddress(address) {
        const isValid = Boolean( 
            address['firstName'] && 
            address['lastName'] &&
            address['country'] &&
            address['street'] &&
            address['city'] &&
            address['region'] &&
            address['postalCode'] );

        return isValid
    }

    /**
     * 
     * Return whether we have a current, valid shippingAddress 
     * 
     */
    checkValidity() {
        return this.isValidAddress(this.workingAddress);
    }

    /**
     * 
     * Return true when at least one address exists
     * 
     */
    reportValidity() {
        const isValid = this.checkValidity();

        if (isValid) {
            return isValid; 
        }

        this.dispatchUpdateErrorAsync({
            groupId: SHIPPING_ADDRESS_GROUP_CODE,
            type: '/commerce/errors/checkout-failure',
            exception: 'An Address must be present and selected.',
        });
        
        return false; 
    }

    /**
     * 
     * Clears any ShippingAddress error
     * 
     */
    clearCheckoutError() {
        this.dispatchUpdateErrorAsync({
            groupId: SHIPPING_ADDRESS_GROUP_CODE
        });

    }

    /**
     * 
     * helper class that checks if we are in site preview mode
     * 
     */
    isInSitePreview() {
        let url = document.URL;
        
        return (url.indexOf('sitepreview') > 0 
            || url.indexOf('livepreview') > 0
            || url.indexOf('live-preview') > 0 
            || url.indexOf('live.') > 0
            || url.indexOf('.builder.') > 0);
    }
}