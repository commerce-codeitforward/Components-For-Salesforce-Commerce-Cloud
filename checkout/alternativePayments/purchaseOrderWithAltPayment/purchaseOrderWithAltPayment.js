import { LightningElement, api, wire, track } from 'lwc';
import { CheckoutInformationAdapter, simplePurchaseOrderPayment, useCheckoutComponent } from 'commerce/checkoutApi';
import { NavigationMixin } from "lightning/navigation";
import { refreshCartSummary } from "commerce/cartApi";
import communityId from "@salesforce/community/Id";

import preAuthorizePayment from '@salesforce/apex/AlternativePaymentController.preAuthorize';
import getCartData from "@salesforce/apex/CommerceCheckout.getCartData";

import MAIN_TEMPLATE from "./purchaseOrderWithAltPayment.html";
import STENCIL from "./purchaseOrderWithAltPaymentStencil.html";

const CheckoutStage = {
    CHECK_VALIDITY_UPDATE: 'CHECK_VALIDITY_UPDATE',
    REPORT_VALIDITY_SAVE: 'REPORT_VALIDITY_SAVE',
    BEFORE_PAYMENT: 'BEFORE_PAYMENT',
    PAYMENT: 'PAYMENT',
    BEFORE_PLACE_ORDER: 'BEFORE_PLACE_ORDER',
    PLACE_ORDER: 'PLACE_ORDER'
};

export default class CheckoutTerms extends NavigationMixin(useCheckoutComponent) {
    _checkedByDefault = false;
    checked = false;

    isLoading = false;
    firstLoad = false;
    _checkoutMode = 1;
    _isShowEmptyMessage = false;
    _emptyMessage = "";
    currentUserId;
    parsedData;
    cartData;

    @track checkoutId;
    @track shippingAddress;
    @track showError = false;
    @track error;
    @track cartAddress = {}

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

    connectedCallback() {
        this.isPreview = this.isInSitePreview();
        this.currentCommunityId = communityId;
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
        if (!this.isPreview) {
            this.isLoading = true;
            console.log("purchaseOrderWithAltPayment checkoutInfo");
            if (data) {
                this.checkoutId = data.checkoutId;
                console.log("purchaseOrderWithAltPayment checkoutInfo checkoutInfo: " +JSON.stringify(data));
                this.shippingAddress = data.deliveryGroups.items.deliveryAddress;
                if (data.checkoutStatus === 200) {
                    console.log("purchaseOrderWithAltPayment checkoutInfo checkoutInfo 200");
                    this.isLoading = false;
                    this.getCart();
                }
            } else if (error) {
                console.log("##purchaseOrderWithAltPayment checkoutInfo Error: " + error);
            }
        } else {
            this.isLoading = false;
        }
    }

    getCart(){
        getCartData({ communityId: this.currentCommunityId })
        .then((data2) => {
            if (data2) {
            this.cartData = JSON.parse(data2);
            }
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
            case CheckoutStage.PAYMENT:
                return Promise.resolve(this.authorizePayment());
            default:
                return Promise.resolve(true);
        }
    }

    /**
     * Return true when terms checkoutbox is checked
     */
    checkValidity() {
        console.log('purchaseOrderWithAltPayment checkValidity');
        return true;
    }

    /**
     * Return true when terms checkoutbox is checked
     */
    reportValidity() {
        console.log('purchaseOrderWithAltPayment reportValidity');
        /* this.dispatchUpdateErrorAsync({
            groupId: 'Payment',
            type: '/commerce/errors/checkout-failure',
            exception: 'Purchase number must be filled in.',
        }); */

        return true;
    }

    /**
     * Place Order
     */
    async placedOrder(){
        let address = this.shippingAddress;
        const purchaseOrderInputValue = this.getPurchaseOrderInput().value;
        let poValue;
        if(purchaseOrderInputValue == null || purchaseOrderInputValue == ''){
            poValue = 'NO PO';
        }else{
            poValue = purchaseOrderInputValue;
        }

        let po = await simplePurchaseOrderPayment(this.checkoutId, poValue, address);
        console.log('saltboxPurchaseOrder completePayment po return: '+JSON.stringify(po));
        const orderConfirmation = await this.dispatchPlaceOrderAsync();

        if (orderConfirmation.orderReferenceNumber) {
            refreshCartSummary();
            this.navigateToOrder(orderConfirmation.orderReferenceNumber);
            console.log('purchaseOrderWithAltPayment orderReferenceNumber: '+orderConfirmation.orderReferenceNumber);
        } else {
            throw new Error("Required orderReferenceNumber is missing");
        }
    }

    /**
     * Authorize payment
     * @returns Bool - successed or fail on update
     */
    async authorizePayment(){
        await preAuthorizePayment({
            billingContactPointAddressId: this.shippingAddress,
            cartId: this.cartData.cartId,
            paymentMethod: 'Purchase Order'
          }).then(response => {
            // authorization is complete, move to complete the order
            this.placedOrder();
            return true;
          }).catch(error => {
            return false;
        });
    }

    /**
     * Get purchase order input
     * @returns purchaseOrderInput - payment component
     */
    getPurchaseOrderInput() {
        return this.refs.poInput;
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

}