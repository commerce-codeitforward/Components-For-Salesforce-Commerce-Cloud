import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import microformScript from '@salesforce/resourceUrl/CybersourceMicroform';
import communityId from '@salesforce/community/Id';
import { getSessionContext } from 'commerce/contextApi';
import { useCheckoutComponent, CheckoutInformationAdapter, postAuthorizePayment } from 'commerce/checkoutApi';
import getStateOptions from '@salesforce/apex/CybersourceController.getStateOptions';
import generateKey from '@salesforce/apex/CybersourceController.generateKey';
import authorizeCard from '@salesforce/apex/CybersourceController.authorizeCard';
import { CartSummaryAdapter } from 'commerce/cartApi';

// Error Constants
const NAME_ERROR = 'Name fields are required';
const ADDRESS_ERROR = 'Address fields are required';
const CARD_EXPIRED_ERROR = 'Credit Card is expired';
const CARD_INVALID_ERROR = 'Invalid Card Number';
const CVV_INVALID_ERROR = 'Invalid Security Code';

export default class CybersourceCreditCard extends NavigationMixin(useCheckoutComponent(LightningElement)) {
    @api checkoutDetails;
    
    _checkoutMode = 1;
    transientToken;
    microform;
    firstName = '';
    lastName = '';
    nickname = '';
    street = '';
    city = '';
    state = '';
    postalCode = '';
    expMonth = '01';
    expYear = '2023';
    monthOptions = [
        { label: '01', value: '01' },
        { label: '02', value: '02' },
        { label: '03', value: '03' },
        { label: '04', value: '04' },
        { label: '05', value: '05' },
        { label: '06', value: '06' },
        { label: '07', value: '07' },
        { label: '08', value: '08' },
        { label: '09', value: '09' },
        { label: '10', value: '10' },
        { label: '11', value: '11' },
        { label: '12', value: '12' }
    ];
    yearOptions = [];
    stateOptions = [];

    effectiveAccountId;
    // cartAmount = 0.00;

    @track checkoutId;
    @track shippingAddress;
    @track errorMessages = [];
    @track billingAddress;
    @track grandTotalAmount;
    
    /**
     * 
     * Get the CheckoutData from the standard salesforce adapter
     * Response is expected to be 202 while checkout is starting
     * Response will be 200 when checkout start is complete and we can being processing checkout data 
     */
    @wire(CheckoutInformationAdapter, {})
    checkoutInfo({ error, data }) {
        if (!this.isInSitePreview()) {
            console.log('cybersourcePayment checkoutInfo');
            if (data) {
                this.checkoutId = data.checkoutId;
                console.log('cybersourcePayment checkoutInfo checkoutInfo: ' +JSON.stringify(data));
                this.shippingAddress = data.deliveryGroups.items[0].deliveryAddress;
                if (data.checkoutStatus == 200) {
                    console.log('cybersourcePayment checkoutInfo checkoutInfo 200');
                }
            } else if (error) {
            console.log('##cybersourcePayment checkoutInfo Error: ' + error);
            }
        }
    }

    // retrieve the cart summary information
    @wire(CartSummaryAdapter, {})
    cartSummary({error, data}){
        if (!this.isInSitePreview()){
            if (data) {
                this.grandTotalAmount = data.grandTotalAmount;
            } else if (error) {
                console.log('##cybersourcePayment checkoutInfo Error: ' + error);
            }
        }
    }

    async connectedCallback() {
        this.currentCommunityId = communityId;
        // populate this.yearOptions
        const currentYear = new Date().getFullYear();
        this.expYear = ''+currentYear;
        for (let i = 0; i < 15; i++) {
            const yearString = '' + (currentYear + i);
            this.yearOptions.push({ label: yearString, value: yearString });
        }

        getStateOptions()
        .then(res => {
            this.stateOptions = (res || []).map(state => {return { label: state.State_Name__c, value: (state.Abbreviation__c + ':' + state.Country_Code__r.Alpha2Code__c)};});
        })
        .catch(err => {
            console.log(err);
        })

        getSessionContext().then(ctx => {    
            console.log(ctx);
            this.effectiveAccountId = ctx.effectiveAccountId;
        }).catch(err => {
            console.log('Error getting Session Context:', err);
        });

        await loadScript(this, microformScript)
        .then(() => {
            this.setupMicroform();
        }).catch(err => {
            console.log(err);
        });
    }

    // create the Cybersource form and add the fields
    setupMicroform() {
        generateKey().then(res => {
            const flex = new Flex(res);
            const microform = flex.microform({'iframe': {'line-height': '1.875rem'} });
            const number = microform.createField('number');
            const securityCode = microform.createField('securityCode', { maxLength: 4 });
            const numberElement = this.template.querySelector('.number-container');
            const securityCodeElement = this.template.querySelector('.securityCode-container');
            number.load(numberElement);
            securityCode.load(securityCodeElement);
            this.microform = microform;
        })
        .catch(err => {
            console.log(err);
        });
    }

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleFirstNameBlur(event) {
        this.firstName = event.target.value.trim();
        if (this.firstName && this.lastName) {
            this.errorMessages = this.errorMessages.filter(m => m != NAME_ERROR);
        }
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleLastNameBlur(event) {
        this.lastName = event.target.value.trim();
        if (this.firstName && this.lastName) {
            this.errorMessages = this.errorMessages.filter(m => m != NAME_ERROR);
        }
    }

    handleStreetChange(event) {
        this.street = event.target.value;
    }

    handleStreetBlur(event) {
        this.street = event.target.value.trim();
        if (this.isCCAddressValid()) {
            this.errorMessages = this.errorMessages.filter(m => m != ADDRESS_ERROR);
        }
    }

    handleCityChange(event) {
        this.city = event.target.value;
    }

    handleCityBlur(event) {
        this.city = event.target.value.trim();
        if (this.isCCAddressValid()) {
            this.errorMessages = this.errorMessages.filter(m => m != ADDRESS_ERROR);
        }
    }

    handleStateChange(event) {
        this.state = event.target.value;
    }

    handleStateBlur(event) {
        this.state = event.target.value.trim().toLocaleUpperCase();
        if (this.isCCAddressValid()) {
            this.errorMessages = this.errorMessages.filter(m => m != ADDRESS_ERROR);
        }
    }

    handlePostalCodeChange(event) {
        this.postalCode = event.target.value;
    }

    handlePostalCodeBlur(event) {
        this.postalCode = event.target.value.trim();
        if (this.isCCAddressValid()) {
            this.errorMessages = this.errorMessages.filter(m => m != ADDRESS_ERROR);
        }
    }

    isCCAddressValid() {
        let isValid = this.street.length > 0 && this.city.length > 0 && this.state.length > 2 && this.postalCode.length > 4 
        return isValid;
    }

    handleExpMonthChange(event) {
        this.expMonth = event.target.value;
        const currentDate = new Date();
        if (!(currentDate.getFullYear() > +this.expYear || (currentDate.getFullYear() == +this.expYear && currentDate.getMonth() >= +this.expMonth))) {
            this.errorMessages = this.errorMessages.filter(m => m != CARD_EXPIRED_ERROR);
        }
    }

    handleExpYearChange(event) {
        this.expYear = event.target.value;
        const currentDate = new Date();
        if (!(currentDate.getFullYear() > +this.expYear || (currentDate.getFullYear() == +this.expYear && currentDate.getMonth() >= +this.expMonth))) {
            this.errorMessages = this.errorMessages.filter(m => m != CARD_EXPIRED_ERROR);
        }
    }

    handleNicknameChange(event) {
        this.nickname = event.target.value;
    }

    stageAction(checkoutStage) {
        
        console.log('checkoutStage: ' + checkoutStage);
        switch (checkoutStage) {
            case 'CHECK_VALIDITY_UPDATE':
                return Promise.resolve(this.checkValidity());
            case 'REPORT_VALIDITY_SAVE':
                return Promise.resolve(this.reportValidity());
            case 'BEFORE_PAYMENT':
                return Promise.resolve(this.createTransientToken());
            case 'PAYMENT':
                return Promise.resolve(this.authPayment());
            default:
                return Promise.resolve(true);
        }
    }

    createTransientToken() {
        this.errorMessages = [];
        if (this.firstName.length < 1 || this.lastName.length < 1) {
            this.errorMessages.push(NAME_ERROR);
        }
        if (!this.isCCAddressValid()) {
            this.errorMessages.push(ADDRESS_ERROR);
        }
        const currentDate = new Date();
        if (currentDate.getFullYear() > +this.expYear || (currentDate.getFullYear() == +this.expYear && currentDate.getMonth() >= +this.expMonth)) {
            this.errorMessages.push(CARD_EXPIRED_ERROR);
        }
        console.log('Microform:', this.microform);
        const options = {
            expirationMonth: this.expMonth,
            expirationYear: this.expYear
        };
        return new Promise((resolve, reject) => this.microform.createToken(options, (err, token) => {
            if (err) {
                if (err.details && err.details.length > 0) {
                    for (let i=0; i < err.details.length; i++) {
                        if (err.details[i].message == 'Validation error' && err.details[i].location == 'number') {
                            // this.errorMessages.push(CARD_INVALID_ERROR);
                        } else if (err.details[i].message == 'Validation error' && err.details[i].location == 'securityCode') {
                            // this.errorMessages.push(CVV_INVALID_ERROR);
                        } else {
                            this.errorMessages.push(err.details[i].message);
                        }
                    }
                } else {
                    this.errorMessages.push(err.message);
                }
                console.log('Error:', this.errorMessages);
                this.createTokenReturned = true;
            }
            console.log('Token:', token);
            this.transientToken = token;
            resolve(true);
        }));
    }

    get showCardErrors() {
        return this.errorMessages.length > 0;
    }

    /**
     * Determines if you are in the experience builder currently
     */
    isInSitePreview() {
        let url = document.URL;
        return (
        url.indexOf('sitepreview') > 0 ||
        url.indexOf('livepreview') > 0 ||
        url.indexOf('live-preview') > 0 ||
        url.indexOf('live.') > 0 ||
        url.indexOf('.builder.') > 0
        );
    }

    /**
     * The current checkout mode for this component
     *
     * @type {CheckoutMode}
     */
    get checkoutMode() {
        
        return this._checkoutMode;
    }

    validateShippingAddress(){
        let isValidShipping = false;
        if(
            this.shippingAddress.street.length > 0
            && this.shippingAddress.city.length > 0
            && this.shippingAddress.region.length > 0
            && this.shippingAddress.country.length > 0
        ){
            isValidShipping = true;
        }
        return isValidShipping;
    }

    checkValidity() {
        let isValid = true;
        isValid = isValid && (
            this.firstName.length > 0 
            && this.lastName.length > 0
            && this.street.length > 0
            && this.city.length > 0
            && this.state.length > 0
            && this.postalCode > 0
            );
            
        const currentDate = new Date();
        if (currentDate.getFullYear() > +this.expYear || (currentDate.getFullYear() == +this.expYear && currentDate.getMonth() >= +this.expMonth)) {
            isValid = false;
            this.errorMessages.push(CARD_EXPIRED_ERROR);
        }
        
        return isValid && this.errorMessages.length < 1;
    }

    reportValidity() {
        this.errorMessages = [];
        let isValid = true;
        let isShippingValid = this.validateShippingAddress();
        
        isValid = isValid && this.checkValidity();

        if(!isShippingValid){
            this.errorMessages.push('Please select a valid Shipping Address');
        }

        return isValid && isShippingValid && this.errorMessages.length < 1;
    }

    async authPayment(){
        const stateCode = this.state.split(':')[0];
        const countryCode = this.state.split(':')[1];
        const billingAddress = {
                        "name": this.firstName + " " + this.lastName,
                        "street": this.street,
                        "city":this.city,
                        "region": stateCode,
                        "country": countryCode,
                        "postalCode": this.postalCode
                    };
        const isValid = this.checkValidity();
        if (isValid) {       
            const paymentData = {
                token: this.transientToken, 
                createToken: true,
                accountId: this.effectiveAccountId, 
                currencyISOCode: 'USD', 
                addressString: JSON.stringify(billingAddress), 
                expirationMonth: this.expMonth, 
                expirationYear: this.expYear,
                firstName: this.firstName, 
                lastName: this.lastName, 
                communityId: this.currentCommunityId,
                amount: this.grandTotalAmount
            };

            const authorizeResponse = await Promise.resolve(authorizeCard(
                {paymentsData: paymentData}
            ));
            
            if (authorizeResponse == null) {
                this.errorMessages.push('Error: Unknown error processing card');
                return this.errorMessages;
            }
            console.log('authorizeResponse:' + authorizeResponse);
            
            let paymentId = authorizeResponse.id;
            console.log('paymentId:' + paymentId);

            const paymentResult = await postAuthorizePayment(this.checkoutId, paymentId);
            console.log(paymentResult);
            return {
                    responseCode: paymentId
                };
        } else {
            this.errorMessages = ['Error: Unknown error processing card'];
            return this.errorMessages;
        }
    }
}