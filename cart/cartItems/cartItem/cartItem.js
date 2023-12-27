import { LightningElement, api } from 'lwc';
import { updateItemInCart, deleteItemFromCart } from 'commerce/cartApi';

const DELETE_ITEM_EVENT = 'deletecartitem';
const NAVIGATE_PRODUCT_EVENT = 'navigatetoproduct';

/**
 * UI component for an individual cart item. Handles deletion,
 * quantity update, product navigation and fields to display per item.
 */
export default class CartItem extends LightningElement {
    /**
     * @description UI labels, to be replaced by Custom Labels and their translations
     */
    @api labels;

    /**
     * @description Current Cart Item
     */
    @api item;

    /**
     * @description Show the "Delete" button
     */
    @api showRemoveItemOption;
    
    /**
     * @description Show Line Item Total
     */
    @api showLineItemTotal;

    /**
     * @description Show Original Price
     */
    @api showOriginalPrice;

    /**
     * @description Show Product SKU
     */
    @api showSku;

    /**
     * @description Show Product Thumbnail Image
     */
    @api showProductImage;

    /**
     * @description List of fields (Api Names) to display for each Item
     */
    @api productFields;

    /**
     * @description Show Price per Unit
     */
    @api showPricePerUnit;

    /**
     * @description Show Actual Price
     */
    @api showActualPrice;

    /**
     * @description Hide/Show the Quantity Selector
     */
    @api hideQuantitySelector;

    /**
     * @description Show Promotions per Item
     */
    @api showPromotions;

    /**
     * @description Preview mode if component is rendered in the Builder
     */
    @api isPreview;

    /**
     * @description Minimum quantity from purchaseQuantityRule if provided
     */
    minQuantity;

    /**
     * @description Maximum quantity from purchaseQuantityRule if provided
     */
    maxQuantity;

    /**
     * @description Increment step from purchaseQuantityRule if provided
     */
    incrementStep;

    connectedCallback() {
        // minQuantity falls back to 1 if purchaseQuantityRule is not provided
        this.minQuantity = Number(this.item.ProductDetails.purchaseQuantityRule?.minimum || 1);
        // ommit maxQuantity if purchaseQuantityRule is not provided
        this.maxQuantity = Number(this.item.ProductDetails.purchaseQuantityRule?.maximum) || undefined;
        // incrementStep falls back to 1 if purchaseQuantityRule is not provided
        this.incrementStep = Number(this.item.ProductDetails.purchaseQuantityRule?.increment || 1);
    }

    renderedCallback() {
        // report invalid quantities after rendering the item
        this.refs.quantitySelector?.reportValidity();
    }

    /**
     * @description Returns current cart item currency code
     * @returns {String}
     */
    get currencyCode() {
        return this.item.ProductDetails.fields.CurrencyIsoCode;
    }

    /**
     * @description Fixes the promotion badge under the quantity selector
     * @returns {String}
     */
    get additionalBadgeStyle() {
        return !this.hideQuantitySelector ? 'top: -20px' : 'top: 10px';
    }

    /**
     * @description Returns current item quantity
     * @returns {Number}
     */
    get quantity() {
        return Number(this.item.quantity);
    }
    
    /**
     * @description Returns if a quantity rule exists for the current item,
     * an existent one should have the required field maxQuantity
     * @returns {Boolean}
     */
    get hasQuantityRule() {
        return this.maxQuantity;
    }

    /**
     * @description Returns help text which describes the quantity rule
     * @returns {String}
     */
    get quantityRuleHelpText() {
        return `${this.labels.minQty}: ${this.minQuantity}, ${this.labels.maxQty}: ${this.maxQuantity}, ${this.labels.incrementStep}: ${this.incrementStep}`;
    }

    /**
     * @description Returns true if minQuantity is reached or the closest possible value to it
     * @returns {Boolean}
     */
    get stopDecreaseQuantity() {
        return this.item.quantity === this.minQuantity || this.item.quantity-this.incrementStep<this.minQuantity;
    }

    /**
     * @description Returns true if maxQuantity is reached or the closest possible value to it
     * @returns {Boolean}
     */
    get stopIncreaseQuantity() {
        return this.item.quantity === this.maxQuantity || this.item.quantity+this.incrementStep>this.maxQuantity;
    }

    /**
     * @description Returns saved amount (adjustment amount)
     * @returns {Number | undefined}
     */
    get savedAmount() {
        if (this.showPromotions && this.item.adjustmentAmount !== 0) {
            return this.item.adjustmentAmount*-1;
        }
        return undefined;
    }

    /**
     * @description Returns whether or not to display original item price
     * @returns {Boolean}
     */
    get needsOriginalPrice() {
        return this.showOriginalPrice && this.item.listPrice !== 0;
    }

    /**
     * @description Shows current items based on configuration:
     * 1 - Extract fields from productFields property
     * 2 - Set label + value (switch from camelCase to sentence case)
     * 3 - Sort items by the order in productFields property
     * 
     * @returns {List}
     */
    get fieldsWithLabels() {
        let productFieldsNames = this.productFields.split(';');
        return Object.entries(this.item.ProductDetails.fields)
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

    /**
     * @description Decreases the quantity by the value in incrementStep
     * @param {CustomEvent} e
     */
    decreaseQty(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = this.quantity - this.incrementStep;
            this._updateQty(newQty);
        }
    }

    /**
     * @description Increases the quantity by the value in incrementStep
     * @param {CustomEvent} e
     */
    increaseQty(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = this.quantity + this.incrementStep;
            this._updateQty(newQty);
        }
    }

    /**
     * @description Updates the quantity by the new value in the quantity input
     * @param {CustomEvent} e
     */
    handleQtyChange(e) {
        e.stopPropagation();
        if (!this.isPreview && this.refs.quantitySelector.validity.valid) {
            const newQty = Number(this.refs.quantitySelector.value);
            this._updateQty(newQty);
        }
    }

    /**
     * @description Updates the quantity by the new value in parameter
     * @param {Number} newQty
     * @private
     */
    _updateQty(newQty) {
        updateItemInCart(this.item.id, newQty).then((result) => {
            let updatedCartItem = {cartItem: result};
            updatedCartItem.cartItem.productDetails.fields = this.item.ProductDetails.fields;
            this.item = [updatedCartItem].map(this.mapCartItem)[0];
        }).catch((e) => {
            console.error(e);
        });
    }

    /**
     * @description Sends an event to the parent component to delete the current item
     * @param {CustomEvent} e
     */
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

    /**
     * @description Sends an event to the parent component to navigate to the current item
     * @param {CustomEvent} e
     */
    handleProductRedirection(e){
        e.stopPropagation();
        this.dispatchEvent(
            new CustomEvent(NAVIGATE_PRODUCT_EVENT, {
                detail: {
                    id: this.item.ProductDetails.productId,
                    name: this.item.ProductDetails.name
                },
                composed: true,
                bubbles: true,
            })
        );
    }

    // Cart item mapping function
    mapCartItem = (sourceCartItem) => {
        const {
            cartItem: {
                cartItemId: id,
                name,
                quantity,
                type,
                itemizedAdjustmentAmount,
                salesPrice,
                totalAdjustmentAmount: adjustmentAmount,
                totalAmount: totalAmount,
                totalListPrice: listPrice,
                totalPrice: price,
                totalTax: tax,
                unitAdjustedPrice,
                unitAdjustmentAmount,
                productDetails,
            },
            messages,
            subscriptionId,
            subscriptionTermUnit,
            subscriptionTerm,
            subscriptionType,
        } = sourceCartItem;

        return {
            id,
            name,
            quantity,
            type,
            itemizedAdjustmentAmount,
            salesPrice,
            adjustmentAmount,
            totalAmount,
            listPrice,
            price,
            tax,
            unitAdjustedPrice,
            unitAdjustmentAmount,
            ProductDetails: {
                name: productDetails.fields.Name,
                productId: productDetails.productId,
                purchaseQuantityRule: productDetails.purchaseQuantityRule,
                sku: productDetails.sku,
                fields: productDetails.fields,
                thumbnailImage: productDetails.thumbnailImage,
                variationAttributes: productDetails.variationAttributes,
                productSubscriptionInformation: productDetails.productSubscriptionInformation,
            },
            Messages: messages,
            subscriptionId,
            subscriptionTermUnit,
            subscriptionTerm,
            subscriptionType,
        };
    };
}