import { LightningElement, api, track, wire } from 'lwc';
import { getAppContext, getSessionContext } from 'commerce/contextApi';
import { navigate, NavigationContext } from 'lightning/navigation';
import { currentRelease } from 'commerce/config';
import { previewData } from './mockData';
import basePathName from '@salesforce/community/basePath';
const API_VERSION = currentRelease.apiVersion;

export default class CartItems extends LightningElement {
    @api pageSize;
    @api showRemoveItemOption;
    @api showLineItemTotal;
    @api showMoreItemsOption;
    @api showOriginalPrice;
    @api showSKU;
    @api showProductImage;
    @api productFields;
    @api showPricePerUnit;
    @api showActualPrice;
    @api hideQuantitySelector;
    @api showPromotions;

    isPreview;
    cartId;
    webstoreId;
    nextPageToken;
    currencyCode;

    @track cartItems = [];

    @wire(NavigationContext)
    navContext;

    /**
     * Get webstore id, then either return mock data if it's a preview site, or retrieve real data
     */
    async connectedCallback(){
        const [appContext, sessionContext] = await Promise.all([getAppContext(), getSessionContext()]);
        this.isPreview = sessionContext.isPreview;
        if (this.isPreview) {
            this.cartItems = previewData;
            return;
        }
        this.webstoreId = appContext.webstoreId;
        this.getCartItems();
    }

    /**
     * Retrieve cart items from the API, method supports getting additional items whenever the user clicks 'Show more'
     */
    async getCartItems() {
        let baseURL = `${basePathName}/webruntime/api/services/data/${API_VERSION}/commerce/webstores/${this.webstoreId}/carts/current/cart-items`;
        // these hardcoded parameters can always be dynamically configured
        baseURL += `?includePromotions=true&includeCoupons=true&sort=CreatedDateDesc&productFields=*&pageSize=${this.pageSize}`;
        // append nextPageToken if it's required (not required the first time the component is loaded)
        const response = await fetch(baseURL + (this.nextPageToken ? `&page=${this.nextPageToken}` : ''));
        const cartItemsData = await response.json();
        // map content
        if (cartItemsData) {
            this.cartItems = [...this.cartItems, ...cartItemsData.cartItems.map(this.mapCartItem)];
            this.currencyCode = cartItemsData.cartSummary.currencyIsoCode;
            this.nextPageToken = cartItemsData.nextPageToken;
        } else {
            this.cartItems = [];
        }
    }

    get needsToShowMore() {
        return this.showMoreItemsOption && (this.nextPageToken || this.isPreview);
    }

    async handleShowMoreButton() {
        if (!this.isPreview) {
            this.getCartItems();
        }
    }

    handleDeleteCartItem(e) {
        e.stopPropagation();
        const cartItemId = e.detail;
        this.cartItems = this.cartItems.filter(item => item.id !== cartItemId);
    }

    handleProductNavigation(e) {
        navigate(this.navContext, {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Product2',
                recordId: e.detail.id,
                recordName: e.detail.name,
                actionName: 'view',
            },
        });
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
            productDetails: {
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