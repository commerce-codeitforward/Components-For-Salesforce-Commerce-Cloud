import { LightningElement, api, track, wire } from 'lwc';
import { navigate, NavigationContext } from 'lightning/navigation';
import { getSessionContext } from 'commerce/contextApi';
import { createCartItemsLoadAction, dispatchActionAsync } from 'commerce/actionApi';
import { previewData } from './mockData';

/**
 * UI component that displays current cart items
 */
export default class CartItems extends LightningElement {
    /**
     * @description Enable the component to render as light DOM
     */
    static renderMode = 'light';

    /**
     * @description UI labels, to be replaced by Custom Labels and their translations
     */
    labels = {
        showMore: 'Show More',
        minQty: 'Min Qty',
        maxQty: 'Max Qty',
        incrementStep: 'Increment step',
        sku: 'SKU',
        item: 'item',
        decrease: 'Decrease',
        increase: 'Increase',
        delete: 'Delete',
        saved: 'Saved'
    }

    /**
     * @description Custom page size for items to display
     */
    @api pageSize;

    /**
     * @description Show the "Delete" button
     */
    @api showRemoveItemOption;

    /**
     * @description Show Line Item Total
     */
    @api showLineItemTotal;

    /**
     * @description Show the "Show More" button
     */
    @api showMoreItemsOption;

    /**
     * @description Show Original Price
     */
    @api showOriginalPrice;

    /**
     * @description Show Product SKU
     */
    @api showSKU;

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
     * @description Cart Items provided by the Cart Data Expression
     */
    @api cartItems;
    
    /**
     * @description Total Count of Items in the cart (provided by the Cart Data Expression)
     */
    @api uniqueProductCount;
    
    /**
     * @description Cart Items data to show in UI, handles pagination against pageSize property
     */
    @track cartItemsToShow = [];

    @wire(NavigationContext)
    navContext;

    /**
     * @description Preview mode if component is rendered in the Builder
     */
    isPreview;

    /**
     * @description Number of current pages displayed (custom pagination)
     */
    pages = 0;

    /**
     * @description Shows mock data if component is displayed in the Builder
     * or real data from the Cart Data Expressions (with custom pagination handling)
     * @async
     */
    async connectedCallback() {
        const sessionContext = await getSessionContext();
        this.isPreview = sessionContext.isPreview;
        if (this.isPreview) {
            this.cartItemsToShow = previewData;
            return;
        } else if (this.cartItems.length !== 0) {
            this.requestMoreCartItems();
        }
    }

    /**
     * @description Triggers a 'Load More Cart Items' action at the CartItemsAdapter
     * @async
     */
    async requestMoreCartItems() {
        // increase current pages count
        this.pages++;
        // while current items are less than what should be displayed && less than the total items in the cart
        // ==> request more items from the API
        while (this.cartItems.length < (this.pages*this.pageSize) 
                && this.cartItems.length < this.uniqueProductCount) {
            await dispatchActionAsync(this, createCartItemsLoadAction());
        }
        // show only the necessary items (from 1st item in 1st page to latest in last page)
        this.cartItemsToShow = this.cartItems.slice(0, this.pages*this.pageSize);
    }

    /**
     * @description Show or hide "Show More" button, based on configuration or pagination state
     * @returns {boolean}
     */
    get needsToShowMore() {
        return this.showMoreItemsOption 
            && (this.isPreview || this.cartItemsToShow.length < this.uniqueProductCount);
    }

    /**
     * @description Requests more cart items either from the cache or CartItemsAdapter
     */
    handleShowMoreButton() {
        if (!this.isPreview) {
            this.requestMoreCartItems();
        }
    }

    /**
     * @description Removes the deleted item from the current list
     * @param {CustomEvent} e
     */
    handleDeleteCartItem(e) {
        e.stopPropagation();
        const cartItemId = e.detail;
        this.cartItemsToShow = this.cartItemsToShow.filter(item => item.id !== cartItemId);
    }

    /**
     * @description Handles navigation to selected cart item's product
     * @param {CustomEvent} e
     */
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
}