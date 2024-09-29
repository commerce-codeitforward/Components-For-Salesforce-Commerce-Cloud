import { LightningElement, api, wire } from 'lwc';
import { getObjectInfos  } from 'lightning/uiObjectInfoApi';
import { useCheckoutComponent, notifyAndPollCheckout } from "commerce/checkoutApi";
import { CartSummaryAdapter } from "commerce/cartApi";
import CART_OBJECT from "@salesforce/schema/WebCart";
import CART_DELIVERY_GROUP_OBJECT from "@salesforce/schema/CartDeliveryGroup";
import updateGenericRecordByCartId from '@salesforce/apex/GenericFieldInputController.updateGenericRecordByCartId';

const CheckoutStage = {
    CHECK_VALIDITY_UPDATE: "CHECK_VALIDITY_UPDATE",
    REPORT_VALIDITY_SAVE: "REPORT_VALIDITY_SAVE",
    ABORT_PAYMENT_SESSION: "ABORT_PAYMENT_SESSION",
    BEFORE_PAYMENT: "BEFORE_PAYMENT",
    PAYMENT: "PAYMENT",
    BEFORE_PLACE_ORDER: "BEFORE_PLACE_ORDER",
    PLACE_ORDER: "PLACE_ORDER",
};


export default class GenericCommerceFieldInput extends useCheckoutComponent(LightningElement) {
    @api objectApiName;
    @api fieldName;
    @api overrideLabel;
    @api isRequired;
    @api fieldErrorMessage;
    @api isError = false;
    @api showError = false;
    objectApiNames = [];
    objectTypeMapping = [];

    dataTypeMapping = {
        String: 'text',
        TextArea: 'text',
        Date: 'date',
        Currency: 'number',
        Double: 'number',
        DateTime: 'datetime',
        Phone: 'phone',
        Boolean: 'checkbox',
        Url: 'url',
        Int: 'number'
    }

    @wire(getObjectInfos, { objectApiNames: "$objectApiNames" })
    objectInfo;

    @wire(CartSummaryAdapter)
    setCartSummary({ data, error }) {
        debugger;
        if (data) {
            console.log("Cart Id", data.cartId);
            this.cartId = data.cartId;
        } else if (error) {
            console.error(error);
        }
    }

    objectTypeMapping = {
        'WebCart': CART_OBJECT,
        'CartDeliveryGroup': CART_DELIVERY_GROUP_OBJECT
    }

    connectedCallback() {
        debugger;
        if (this.objectApiName) {
            let objectApiNameArray = [];
            if (this.objectApiName.includes(';')) {
                objectApiNameArray = this.objectApiName.split(';');
            }
            else {
                objectApiNameArray.push(this.objectApiName);
            }
            for (const objectName of objectApiNameArray) {
                this.objectApiNames.push(this.objectTypeMapping[objectName]);
            }
        }
    }

    get fieldInfo() {
        debugger;
        if (this.objectInfo && this.objectInfo.data && this.objectInfo.data.results) {
            let field;
            for (const info of this.objectInfo.data.results) {
                if (info && info.result && info.result.fields && this.fieldName) {
                    this.isError = false;
                    field = info.result.fields[this.fieldName];
                    field = JSON.parse(JSON.stringify(field));
                    field.dataType = this.dataTypeMapping[field.dataType];
                    field.label = this.overrideLabel ? this.overrideLabel : field.label;
                    field.required = this.isRequired ? true : field.required;
                    if (this.objectApiNames.length == 1) {
                        return field;
                    }
                }
                else {
                    this.isError = true;
                }
            }
            if (!this.isError) {
                return field;
            }  
        }     
        else {
            this.isError = true;
        }  
        
        return {};
    }

    handleChange(event) {
        let value;
        if (event.target.type === 'checkbox' || event.target.type === 'checkbox-button' || event.target.type === 'toggle') {
            value = event.target.checked;
        } else {
            value = event.target.value;
        }
        this.dispatchEvent(new CustomEvent('change', { detail: value }));
    }

    stageAction(checkoutStage) {
        debugger;
        console.log('checkoutStage: '+ checkoutStage);
        switch (checkoutStage) {
            case CheckoutStage.CHECK_VALIDITY_UPDATE:
                return Promise.resolve(this.checkValidity());
            case CheckoutStage.REPORT_VALIDITY_SAVE:
                return Promise.resolve(this.reportValidity());
            case CheckoutStage.BEFORE_PLACE_ORDER:
                return Promise.resolve(this.updateGenericRecord());
            case CheckoutStage.ABORT_PAYMENT_SESSION:
                return Promise.resolve(false);
            default:
                return Promise.resolve(true);
        }
    }

    checkValidity() {
        let field = this.template.querySelector('[data-id="genericFieldInput"]');
        if (this.isError) {
            this.errorMessage = "Unfortunately, you are unable to checkout. Please go to the design attributes and put correct values to Object API Name and Field API Name."; 
        }
        if (!field.checkValidity()) {
            this.isInvalidInput = true;
            this.errorMessage = this.fieldErrorMessage;
        } else {
            this.isInvalidInput = false;
            this.errorMessage = "";
            this.isError = false;
            this.showError = false;
        }
        return (!this.isError && !this.isInvalidInput);
    }

    reportValidity() {
        this.showError = this.isError;
        if (!this.checkValidity()){
            this.dispatchUpdateErrorAsync({
                groupId: "genericFieldInput",
                type: "/commerce/errors/checkout-failure",
                exception: this.errorMessage,
            });
        } else {
            this.dispatchUpdateErrorAsync({
                groupId: "genericFieldInput"
            });
        }
        return !(this.isError || this.isInvalidInput);
    }

    updateGenericRecord() {
        debugger;
        let genericFieldInputValue = this.template.querySelector('[data-id="genericFieldInput"]').value;
        if (genericFieldInputValue) {
            return updateGenericRecordByCartId({ cartId: this.cartId, objectApiNamesJson : JSON.stringify(this.objectApiNames), fieldName : this.fieldName, value: genericFieldInputValue })
            .then(result => {
                console.log('result = ' + result);
                this.showError = false;
                notifyAndPollCheckout();
                return true;
            })
            .catch(error => {
                console.log('error = ' + JSON.stringify(error));
                this.errorMessage = JSON.stringify(error);
                this.showError = true;
                notifyAndPollCheckout();
                return false;
            })
        } else {
            return !this.isRequired;
        }
    }
}
