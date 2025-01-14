import { api } from 'lwc';
import { mockData } from './shippingMethodMockData';
import { CheckoutComponentBase, updateDeliveryMethod, loadCheckout} from 'commerce/checkoutApi';
import { refreshCartSummary } from "commerce/cartApi";

const CheckoutStage = {
    CHECK_VALIDITY_UPDATE: "CHECK_VALIDITY_UPDATE",
    REPORT_VALIDITY_SAVE: "REPORT_VALIDITY_SAVE",
    BEFORE_PAYMENT: "BEFORE_PAYMENT",
    PAYMENT: "PAYMENT",
    BEFORE_PLACE_ORDER: "BEFORE_PLACE_ORDER",
    PLACE_ORDER: "PLACE_ORDER",
  };

export default class ShippingMethod extends CheckoutComponentBase {
    parsedData;
    isDisabled = true;
    _errorMessage = '';
    isSummary = false;
    selectedGroup;
    @api transformedOptions;

    // this variable can be removed if you don't plan to use the expression, but loadCheckout instead
    @api checkoutData;

    async connectedCallback() {
        if(!this.isInSitePreview()) {
            this.getCommerceCheckoutInfo();
        } else {
            this.transformedOptions = mockData;
        }
    }

    /**
     * 
     * Get the checkout data for the user
     */
    async getCommerceCheckoutInfo() {
        // there is an option to use the exppression data binding to get the checkout data
        // this value starts as undefined, make sure to check for it before using it
        // console.log('checkoutData: '+JSON.stringify(this.checkoutData));

        this.parsedData = await loadCheckout();
        this.deliveryGroups = this.parsedData.deliveryGroups.items[0].availableDeliveryMethods;
        if(this.deliveryGroups.length !== 0){
            // clear any errors before proceeding
            this.clearCheckoutError();

            // transforms the data into a format that the frontend can use
            const tempTransformedOptions = this.transformedMethods(this.parsedData);
            this.isDisabled = false;

            // ensure the values are unique before passing them to the frontend
            const arrUniq = [...new Map(tempTransformedOptions.map(v => [v.id, v])).values()]
            this.transformedOptions = arrUniq;
        }else{
            this._errorMessage = 'There are no available delivery methods. Reach out to your administrator.'
            console.log('##There are no available delivery methods.');
            
            this.dispatchUpdateErrorAsync({
                    groupId: 'ShippingMethod',
                    type: '/commerce/errors/checkout-failure',
                    exception:  this._errorMessage
            });
        }
    }

    /**
     * Consumes the raw api data and transforms into formated delivery options for frontend
     */
    transformedMethods(deliveryMethods){
      var deliveryGroups = deliveryMethods.deliveryGroups.items[0].availableDeliveryMethods;
      this.selectedGroup = deliveryMethods.deliveryGroups.items[0].selectedDeliveryMethod;
      var selectedGroupArray = [this.selectedGroup];
      
      let options = [];
      deliveryGroups.forEach(newOption => {
        var selected = !!selectedGroupArray.find(e => e.id === newOption.id);
        
        let option = {
          'key': Math.random().toString(36).substring(2, 15),
          'id': newOption.id,
          'name': newOption.name,
          'shippingFee': newOption.shippingFee,
          'currencyIsoCode': newOption.currencyIsoCode,
          'selected': selected ? true : false,
        }
        options.push(option);
       });
      
      return options;
    }

    /**
     * Determines if you are in the experience builder currently
     */
    isInSitePreview() {
        let url = document.URL;
        
        return (url.indexOf('sitepreview') > 0 
            || url.indexOf('livepreview') > 0
            || url.indexOf('live-preview') > 0 
            || url.indexOf('live.') > 0
            || url.indexOf('.builder.') > 0);
    }

    /**
     * Updates the exisitng options and rebuilds the array to keep the selection
     */
    updateOptions(value){
        const newtransformedOptions = [];

        this.transformedOptions.forEach(option => {
            if(option.id == value){
                const newOption = {...option, selected:true};
                newtransformedOptions.push(newOption);
                this.selectedGroup = newOption;
            }else{
                const newOption = {...option, selected:false};
                newtransformedOptions.push(newOption);
            }
            this.transformedOptions = newtransformedOptions
        });
    }

    /**
     * 
     * handle event for any change in selection of the shipping options
     */
    handleChange(event){
        // disable while the component is saving the values
        this.isDisabled = true;
        this.updateOptions(event.target.value);
        
        updateDeliveryMethod(event.target.value)
        .then(result => {
            this.dispatchEvent(new CustomEvent('dataready', { bubbles: true, composed: true }));
            this.doRefreshCartSummary();
            // enable the fields once the api responds
        })
        .catch(error => {
            console.log("Error in Submit call back:", error);
            this.isDisabled = false;
            this._errorMessage = 'There was an error updating the shipping method. Please try again.';

            this.dispatchUpdateErrorAsync({
                groupId: 'ShippingMethod',
                type: '/commerce/errors/checkout-failure',
                exception:  this._errorMessage
            });
        })
    }

    /**
     * 
     * Refreshes the cart summary after the shipping method has been updated
     * 
     */
    async doRefreshCartSummary() {
        await refreshCartSummary();
        this.isDisabled = false;
    }

    /**
     * 
     * Clears any ShippingMethod errors
     * 
     */
    clearCheckoutError() {
        this.dispatchUpdateErrorAsync({
            groupId: ShippingMethod
        });

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
     * handles the aspects changing on the site.
     */
    setAspect(newAspect) {
        if (!this.isInSitePreview()) {
            if(newAspect.summary){
                this.isSummary = true;
            }else {
                this.isSummary = false;
                this.getCommerceCheckoutInfo();
            }
        }
    }

    /**
     * checkValidity 
     */
    @api
    checkValidity() {
        return true;
    }
  
    /**
     * reportValidity
     */
    @api
    reportValidity() {
        return true;
    }
}