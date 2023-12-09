import { wire, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { CheckoutInformationAdapter, simplePurchaseOrderPayment, CheckoutComponentBase } from "commerce/checkoutApi";
import { refreshCartSummary } from "commerce/cartApi";

import MAIN_TEMPLATE from "./simplePurchaseOrder.html";
import STENCIL from "./simplePurchaseOrderStencil.html";

const CheckoutStage = {
    CHECK_VALIDITY_UPDATE: 'CHECK_VALIDITY_UPDATE',
    REPORT_VALIDITY_SAVE: 'REPORT_VALIDITY_SAVE',
    BEFORE_PAYMENT: 'BEFORE_PAYMENT',
    PAYMENT: 'PAYMENT',
    BEFORE_PLACE_ORDER: 'BEFORE_PLACE_ORDER',
    PLACE_ORDER: 'PLACE_ORDER'
};

export default class SimplePurchaseOrder extends NavigationMixin(CheckoutComponentBase){

    isLoading = false;
    firstLoad = false;

    @track checkoutId;
    @track shippingAddress;
    @track showError = false;
    @track error;

    @api headerLabel;
    @api inputLabel;
    @api placeholderLabel;
    @api hideHeading = false;

    render() {
        if(this.isLoading){
            return STENCIL;
        }else{
            return MAIN_TEMPLATE;
        }
    }

    /**
     * 
     * Get the CheckoutData from the standard salesforce adapter
     * Response is expected to be 202 while checkout is starting
     * Response will be 200 when checkout start is complete and we can being processing checkout data 
     * 
     */
    @wire(CheckoutInformationAdapter, {})
    checkoutInfo({ error, data }) {
        this.isPreview = this.isInSitePreview();
            if (!this.isPreview) {
                this.isLoading = true;
                console.log("simplePurchaseOrder checkoutInfo");
                if (data) {
                    this.checkoutId = data.checkoutId;
                    console.log("simplePurchaseOrder checkoutInfo checkoutInfo: " +JSON.stringify(data));
                    this.shippingAddress = data.deliveryGroups.items.deliveryAddress;
                    if (data.checkoutStatus == 200) {
                        console.log("simplePurchaseOrder checkoutInfo checkoutInfo 200");
                        this.isLoading = false;
                    }
                } else if (error) {
                    console.log("##simplePurchaseOrder checkoutInfo Error: " + error);
                }
            } else {
                this.isLoading = false;
            }
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
            case CheckoutStage.PAYMENT:
                return Promise.resolve(this.paymentProcess());
            default:
                return Promise.resolve(true);
        }
    }

    /**
     * report validity
     *
     * @returns boolean
     */
    @api
    reportValidity() {
        console.log('simplePurchaseOrder: in reportValidity');
        const purchaseOrderInput = this.getPurchaseOrderInput().value;
        let isValid = false;

        if (purchaseOrderInput) {
            console.log('simplePurchaseOrder purchaseOrderInput: '+JSON.stringify(purchaseOrderInput));
            isValid = true;
            this.showError = false;
        } else {
            console.log('simplePurchaseOrder purchaseOrderInput not found: '+JSON.stringify(purchaseOrderInput));
            this.showError = true;
            this.error = "Please enter a purchase order number.";
        }
        return isValid;
    }

    /**
    * checkout save
    */
    @api
    async paymentProcess() {
        console.log('simplePurchaseOrder: in checkout save');

        if (!this.reportValidity()) {
            throw new Error('Required data is missing');
        }

        console.log('simplePurchaseOrder checkoutSave in try');
        await this.completePayment();

        const orderConfirmation = await this.dispatchPlaceOrderAsync();

        if (orderConfirmation.orderReferenceNumber) {
            refreshCartSummary();
            this.navigateToOrder(orderConfirmation.orderReferenceNumber);
            console.log('simplePurchaseOrder orderReferenceNumber: '+orderConfirmation.orderReferenceNumber);
        } else {
            throw new Error("Required orderReferenceNumber is missing");
        }
    }


    /**
     * complete payment
     */
    @api
    async completePayment(){
        let address = this.shippingAddress;
        const purchaseOrderInputValue = this.getPurchaseOrderInput().value;

        let po = await simplePurchaseOrderPayment(this.checkoutId, purchaseOrderInputValue, address);
        return po;
    }


    /**
     * Get purchase order input
     * @returns purchaseOrderInput - payment component
     */
    getPurchaseOrderInput() {
        return this.refs.poInput;
    }

    /**
     * Determines if you are in the experience builder currently
     */
    isInSitePreview() {
        let url = document.URL;

        return (
        url.indexOf("sitepreview") > 0 ||
        url.indexOf("livepreview") > 0 ||
        url.indexOf("live-preview") > 0 ||
        url.indexOf("live.") > 0 ||
        url.indexOf(".builder.") > 0
        );
    }

    /**
     * Naviagte to the order confirmation page
     * @param navigationContext lightning naviagtion context
     * @param orderNumber the order number from place order api response
     */
    navigateToOrder(orderNumber) {
        this[NavigationMixin.Navigate]({
        type: "comm__namedPage",
        attributes: {
            name: "Order"
        },
        state: {
            orderNumber: orderNumber
        }
        });
    }
}