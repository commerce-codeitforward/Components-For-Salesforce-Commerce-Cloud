import { LightningElement, wire, api, track } from 'lwc';
import getCommerceCheckout from "@salesforce/apex/CommerceCheckout.getCommerceCheckout";
import updateCommerceCheckout from "@salesforce/apex/CommerceCheckout.updateCommerceCheckout";
import communityId from '@salesforce/community/Id';

export default class ShippingInstructions extends LightningElement {

    shippingInstructions;
    parsedData;
    showComp = true;
    showHeaderLabel = true;
    isDisabled = false;
    showError = false;
    _checkoutMode = 1;
    @api title;
    @api placeholderInstructions;
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
    myCheckout({ error, data }) {
        if (data) {
            this.parsedData = JSON.parse(data);
            this.shippingInstructions = this.parsedData.deliveryGroups.items[0].shippingInstructions;
            console.log(this.parsedData);
            console.log(this.shippingInstructions);

        } else if (error) {
            console.log('##no delivery instructions: ');
            this.shippingInstructions = '';
        }
    };

    /**
     * 
     * handle event for any changes to the shipping instruction field
     */
    handleShippingInstructionChange(event){
        console.log(event.target.value);
        //this.isDisabled = true;
        const deliveryAddressGroup = {
            shippingInstructions: event.target.value
        }
        
        updateCommerceCheckout({communityId: this.currentCommunityId, payload : JSON.stringify(deliveryAddressGroup)})
        .then(result => {
            console.log('Update: '+ JSON.stringify(result));
            this.dispatchEvent(new CustomEvent('dataready', { bubbles: true, composed: true }));
            //this.refresh();
            //this.isDisabled = false;
        })
        .catch(error => {
            console.log("Error in Submit call back:", error);
            //this.isDisabled = false;
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
        //this._isReadOnly = value === CheckoutMode.SUMMARY;
    }

    /**
     * Report false and show the error message until the user accepts the Terms
     */
    @api
    get checkValidity() {
        //this.showError = !this.checked;
        console.log('check validity');
        //this.isDisabled = true;
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
        //this.showError = !this.checked;
        console.log('report validity');

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
        console.log('checkoutsave');
      if (!this.checkValidity) {
        throw new 
          Error(
          'Shipping Instructions must be filled out first.');
        }
    }
 
    /**
     * The method is called in one-page layout only when the place order button 
     * is clicked. Used in conjunction with the payment component/section for 
     * checkout one-page layout.
     *
     * Must be placed before the payment component in the same payment section 
     * or any prior section.
     *
     * @type Promise<void>
     */
     @api
    placeOrder() {
        console.log('placeorder');
        return this.reportValidity();
    }

}