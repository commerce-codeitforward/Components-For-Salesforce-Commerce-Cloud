import { wire, api, track } from "lwc";
import { CheckoutInformationAdapter, CheckoutComponentBase } from 'commerce/checkoutApi';
import { mockedAddressData } from './shippingAddressMock';

const CheckoutStage = {
  CHECK_VALIDITY_UPDATE: 'CHECK_VALIDITY_UPDATE',
  REPORT_VALIDITY_SAVE: 'REPORT_VALIDITY_SAVE',
  BEFORE_PAYMENT: 'BEFORE_PAYMENT',
  PAYMENT: 'PAYMENT',
  BEFORE_PLACE_ORDER: 'BEFORE_PLACE_ORDER',
  PLACE_ORDER: 'PLACE_ORDER'
};

export default class ShippingAddress extends CheckoutComponentBase {
    shippingAddress = {};
    @track shippingAddresses = [];
    @track name;
    @track firstName;
    @track lastName;
    @track newAddress = {
        validity: false
    };
    @track deliveryAddress = {};
    @track addressPicked;

    isNewAddress = false;
    @track isDisabled = false;
    @track isSummary = false;

    cartData;
    isPreview;

    @track showError = false;
    @track error;

    @api noShippingMessage = '';

    /**
     * 
     * Get the CheckoutData from the standard salesforce adapter
     * Response is expected to be 202 while checkout is starting
     * Response will be 200 when checkout start is complete and we can being processing checkout data 
     * 
     */
    @wire(CheckoutInformationAdapter, { })
    checkoutInfo({ error, data }) {
      this.isPreview = this.isInSitePreview();
      this.showError = false;
      if (!this.isPreview) {
          console.log('shippingAddress checkoutInfo');
          if (data) {
              console.log('shippingAddress checkoutInfo checkoutInfo: '+ JSON.stringify(data));
              if(data.checkoutStatus === 200){
                    console.log('shippingAddress checkoutInfo checkoutInfo 200');
                    this.deliveryAddress = data.deliveryGroups.items[0].deliveryAddress;
                    this.getAddressData();
              }
          } else if (error) {
                console.log('##shippingAddress checkoutInfo Error: '+error);
                this.showError = true;
                this.error = "Checkout encountered an error, please reload the page and try again. If this issue persists, please contact your administrator and provide this error. "+error;
          }
      } else {
        this.isLoading = false;
        this.shippingAddress = mockedAddressData;
        this.shippingAddresses.push(this.shippingAddress);
      }
    }

    /**
     * handles the aspects changing on the site.
     */
    setAspect(newAspect) {
        console.log('shippingAddress: inside setAspect'+ JSON.stringify(newAspect));
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
     * get the contact point / address data to show to the user
     */
    getAddressData() {
        if (!this.isPreview) {
            // currently this example is just pushing in mocked data, this would be where you plug in your own data
            this.shippingAddress = mockedAddressData;
            this.shippingAddresses.push(mockedAddressData);
        }
    }

    /**
     * handles when an address is picked from the address list
     */
    handleAddressPick(event){
        console.log('shippingAddress handleAddressPick: '+ JSON.stringify(event.detail));
    }

    /**
     * update form when our container asks us to
     */
    stageAction(checkoutStage /*CheckoutStage*/) {
        switch (checkoutStage) {
            case CheckoutStage.CHECK_VALIDITY_UPDATE:
                return Promise.resolve(this.checkValidity());
            case CheckoutStage.REPORT_VALIDITY_SAVE:
                return Promise.resolve(this.reportValidity());
            default:
                return Promise.resolve(true);
        }
    }

    /**
     * Return true 
     */
    checkValidity() {
        console.log('shippingAddress checkValidity');
        return true;
    }

    /**
     * Return true when at least one address exists
     */
    reportValidity() {
        console.log('shippingAddress reportValidity');
        let isValid = false;
        if(this.shippingAddresses.length > 0){
            isValid = true;
        }else{
            this.dispatchUpdateErrorAsync({
                groupId: 'ShippingAddress',
                type: '/commerce/errors/checkout-failure',
                exception: 'An Address must be filled in.',
            });
            isValid = false;
        }

        return isValid;
    }

    /**
     * helper class that checks if we are in site preview mode
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