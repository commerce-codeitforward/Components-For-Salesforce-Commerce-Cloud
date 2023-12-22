import { LightningElement, api } from 'lwc';

import {
    updateItemInCart,
    deleteItemFromCart
} from 'commerce/cartApi';

const DELETE_ITEM_EVENT = 'deletecartitem';
const NAVIGATE_PRODUCT_EVENT = 'navigatetoproduct';

export default class CartItem extends LightningElement {
    pageReference;

    @api item;
    @api currencyCode;
    @api showRemoveItemOption;
    @api showLineItemTotal;
    @api showOriginalPrice;
    @api showSku;
    @api showProductImage;
    @api productFields;
    @api showPricePerUnit;
    @api showActualPrice;
    @api hideQuantitySelector;
    @api showPromotions;
    @api isPreview;
    @api mapCartItem;

    minQuantity;
    maxQuantity;
    incrementStep;

    connectedCallback() {
        this.minQuantity = Number(this.item.productDetails.purchaseQuantityRule?.minimum || 1);
        this.maxQuantity = Number(this.item.productDetails.purchaseQuantityRule?.maximum) || undefined;
        this.incrementStep = Number(this.item.productDetails.purchaseQuantityRule?.increment || 1);
    }

    // fix for the promotion badge under the quantity selector
    get additionalBadgeStyle() {
        return !this.hideQuantitySelector ? 'top: -20px' : 'top: 10px';
    }

    renderedCallback() {
        // report invalid quantities after rendering the item
        this.refs.quantitySelector?.reportValidity();
    }

    get quantity() {
        return Number(this.item.quantity);
    }

    get hasQuantityRule() {
        return this.maxQuantity;
    }

    get quantityRuleHelpText() {
        return `Min Qty: ${this.minQuantity}, Max Qty: ${this.maxQuantity}, Increment step: ${this.incrementStep}`;
    }

    get stopDecreaseQuantity() {
        return this.item.quantity === this.minQuantity || this.item.quantity-this.incrementStep<this.minQuantity;
    }

    get stopIncreaseQuantity() {
        return this.item.quantity === this.maxQuantity || this.item.quantity+this.incrementStep>this.maxQuantity;
    }

    decreaseQty(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = this.quantity - this.incrementStep;
            this.updateQty(newQty);
        }
    }

    increaseQty(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = this.quantity + this.incrementStep;
            this.updateQty(newQty);
        }
    }

    handleQtyChange(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = Number(this.refs.quantitySelector.value);
            this.updateQty(newQty);
        }
    }

    updateQty(newQty) {
        updateItemInCart(this.item.id, newQty).then((result) => {
            let updatedCartItem = {cartItem: result};
            updatedCartItem.cartItem.productDetails.fields = this.item.productDetails.fields;
            this.item = [updatedCartItem].map(this.mapCartItem)[0];
        }).catch((e) => {
            console.error(e);
        });
    }

    handleDelete(e) {
        e.stopPropagation();
        if (!this.isPreview) {
            deleteItemFromCart(this.item.id).then(() => {
                this.dispatchEvent(
                    new CustomEvent(DELETE_ITEM_EVENT, {
                        detail: this.item.id,
                        composed: true,
                        bubbles: true,
                    })
                );
            }).catch((e) => {
                console.error(e);
            });
        }
    }

    handleProductRedirection(){
        this.dispatchEvent(
            new CustomEvent(NAVIGATE_PRODUCT_EVENT, {
                detail: {
                    id: this.item.productDetails.productId,
                    name: this.item.productDetails.name
                },
                composed: true,
                bubbles: true,
            })
        );
    }

    get savedAmount() {
        if (this.showPromotions && this.item.adjustmentAmount !== 0) {
            return this.item.adjustmentAmount*-1;
        }
        return undefined;
    }

    get needsOriginalPrice() {
        return this.showOriginalPrice && this.item.listPrice !== 0;
    }

    /**
     * 1 - Extract fields from productFields property
     * 2 - Set label (switch from camelCase to normal phrase) + value for cart item
     * 3 - Sort items by the order in productFields property
     */
    get fieldsWithLabels() {
        let productFieldsNames = this.productFields.split(';');
        return Object.entries(this.item.productDetails.fields)
            // include only fields marked in parameter productFields
            .filter(([label]) => productFieldsNames.includes(label))
            .map(([lbl, value]) => ({
                // Add space before capital letters
                label: lbl.replace(/([A-Z])/g, ' $1').replace(/^./, (str) => str.toUpperCase()).trim(),
                key: lbl,
                value
            })).sort((a, b) => {
                const indexA = productFieldsNames.indexOf(a.key);
                const indexB = productFieldsNames.indexOf(b.key);
                return indexA - indexB;
            });
    }
}