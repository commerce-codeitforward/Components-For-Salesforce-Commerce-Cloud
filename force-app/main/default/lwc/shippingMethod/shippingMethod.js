import { LightningElement, wire, api, track } from 'lwc';
import getCommerceCheckout from "@salesforce/apex/CommerceCheckout.getCommerceCheckout";
import updateCommerceDeliveryMethodCheckout from "@salesforce/apex/CommerceCheckout.updateCommerceDeliveryMethodCheckout";
import communityId from '@salesforce/community/Id';

export default class ShippingMethod extends LightningElement {
    shippingInstructions;
    parsedData;
    showComp = true;
    showHeaderLabel = true;
    isDisabled = true;
    showError = false;
    _checkoutMode = 1;
    _isShowEmptyMessage = false;
    _emptyMessage = '';
    @api transformedOptions;
    @api name = 'delivery-method';
    @api selectedOption;
    @track currentCommunityId;

    connectedCallback() {
        this.currentCommunityId = communityId;
        console.log("communityId: "+communityId);
    }

    /**
     * 
     * Get the active checkout data for the user
     */
    @wire(getCommerceCheckout, { communityId: '$currentCommunityId' })
    myShippingMethodCheckout({ error, data }) {
        this.isPreview = this.isInSitePreview();
        if (!this.isPreview) {
            if (data) {
                this.parsedData = JSON.parse(data);
                console.log('delivery methods: '+ this.parsedData);
                this.deliveryGroups = this.parsedData.deliveryGroups.items[0].availableDeliveryMethods;
                const tempTransformedOptions = this.transformedMethods(this.parsedData);
                console.log('tempTransformedOptions: '+ tempTransformedOptions);
                this.isDisabled = false;

                // ensure the values are unique before passing them to the frontend
                const arrUniq = [...new Map(tempTransformedOptions.map(v => [v.id, v])).values()]
                this.transformedOptions = arrUniq;

            } else if (error) {
                _isShowEmptyMessage = true;
                _emptyMessage = 'There are no available delivery methods. Reach out to your administrator.'
                console.log('##There are no available delivery methods.');
                throw new 
                Error(
                'There must be delivery methods setup in order to proceed.');
            }
        }else{
            // if you are in experience builder, use these sample values so the component shows
            this.transformedOptions = [
                {
                    id: '2Dmxx0000004CFVCA2',
                    name: 'UPS Ground 3-5 business days',
                    shippingFee: '3.14',
                    currencyIsoCode: 'USD',
                    carrier: 'UPS',
                    classOfService: 'Same day UPS Ground',
                    selected: false,
                },
                {
                    id: '2Dmxx0000005DEWDB3',
                    name: 'UPS Next Day 2 business days',
                    shippingFee: '2.03',
                    currencyIsoCode: 'USD',
                    carrier: 'UPS',
                    classOfService: 'Next day UPS Ground',
                    selected: true,
                },
            ];
        }
    };

    /**
     * Consumes the raw api data and transforms into formated delivery options for frontend
     */
    transformedMethods(deliveryMethods){
      var deliveryGroups = deliveryMethods.deliveryGroups.items[0].availableDeliveryMethods;
      var selectedGroup = deliveryMethods.deliveryGroups.items[0].selectedDeliveryMethod;
      var selectedGroupArray = [selectedGroup];
      
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
        this.selectedOption = event.target.value;
        this.updateOptions(this.selectedOption);

        const deliveryAddressGroup = {
            deliveryMethodId: event.target.value
        }
        
        updateCommerceDeliveryMethodCheckout({communityId: this.currentCommunityId, payload : JSON.stringify(deliveryAddressGroup)})
        .then(result => {
            this.dispatchEvent(new CustomEvent('dataready', { bubbles: true, composed: true }));
            // enable the fields once the api responds
            this.isDisabled = false;
        })
        .catch(error => {
            console.log("Error in Submit call back:", error);
            this.isDisabled = false;
        })
    }

    /**
     * The current checkout mode for this component
     *
     * @type {CheckoutMode}
     */
    @api get checkoutMode() {
        return this._checkoutMode;
    }

    /**
     * Handles the checkout mode and puts the component in the right state
     * If the component is not currently being edited it'll go into disbaled state
     */
    set checkoutMode(value) {
        switch(value){
            case 1:
                this.isDisabled = false;
                break;
            case 2:
                this.isDisabled = true;
                break;
            case 3:
                this.isDisabled = true;
                break;
            default:
                this.isDisabled = false;
        }
        this._checkoutMode = value;
    }

    /**
     * Report false and show the error message until the user accepts the Terms
     */
    @api
    get checkValidity() {
        return true;
    }
  
    /**
     * Report false and show the error message until the shopper accepts the 
     * Terms Checkout has reportValidity functionality.
     * 
     * One-page Layout: reportValidity is triggered clicking place order.
     * 
     * Accordion Layout: reportValidity is triggered clicking each section's 
     * proceed button.
     *
     * @returns boolean
     */
    @api
    reportValidity() {
        return true;
    }
 
   /**
    * Works in Accordion when terms component before payment component.
    * 
    * Works in One Page when terms component placed anywhere.
    * 
    * Can be in same step/section as payment component as long as it is placed 
    * before payment info.
    *
    * (In this case this method is redundant and optional but shows as an 
    * example of how checkoutSave can also throw an error to temporarily halt 
    * checkout on the ui)
    */
    @api
    checkoutSave() {
        if (!this.checkValidity) {
            throw new 
            Error(
            'A delivery method must be selected');
        }
    }
}