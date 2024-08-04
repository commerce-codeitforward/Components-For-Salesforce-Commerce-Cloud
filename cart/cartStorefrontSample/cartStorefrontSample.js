import { LightningElement, wire } from 'lwc';
import { CartItemsAdapter } from "commerce/cartApi";
import { dispatchActionAsync, createCartClearAction, createCartItemUpdateAction } from 'commerce/actionApi';

export default class CartStorefrontSample extends LightningElement {

    /**
     * @description Preview mode if component is rendered in the Builder
     */
    isPreview;

    @wire(CartItemsAdapter)
    setCartItems({ data, error }) {
        this.isPreview = this.isInSitePreview();
        if (!this.isPreview) {
            if (data) {

                console.log('##cartItemsAdapter data', data);
                
            } else if (error) {
                this.isCartEmpty = true;
                console.error('Error fetching cart items', error);
            }
        }
    }

    handleAddMoreButton() {
        this.requestMoreCartItems();
    }

    async requestMoreCartItems(){
        //await dispatchActionAsync(this, createCartClearAction());
        await dispatchActionAsync(this, createCartItemUpdateAction('0a9DI0000000Si0YAE', 2));
    }

    /**
     * 
     * helper class that checks if we are in site preview mode
     * 
     */
    isInSitePreview() {
        let url = document.URL;
        
        return (url.indexOf('sitepreview') > 0 
            || url.indexOf('livepreview') > 0
            || url.indexOf('live-preview') > 0 
            || url.indexOf('live.') > 0
            || url.indexOf('.builder.') > 0);
    }
}