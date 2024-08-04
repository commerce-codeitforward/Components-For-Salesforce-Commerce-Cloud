import { LightningElement, track, api } from 'lwc';
import { addItemToCart } from 'commerce/cartApi';
import { trackAddProductToCart } from 'commerce/activitiesApi';


export default class AddToCart extends LightningElement {
    @track quantity = 1;
    @api productId;

    async addToCart() {
        await this.addItemToCart();

        this.template.querySelector('c-custom-toast').showToast('success', 'Item has been added to your Cart!');
    }

    addItemToCart() {
        // this will add the product to the cart.
        addItemToCart(this.productId, this.quantity)
        .then((data) => {
            if (data) {
                // this will update the cart and Cart icon.
                trackAddProductToCart(
                    this.productId
                );
            }
        })
        .catch((error) => {
            this.error = error;
            console.log("error:", error);
        })
        .finally(() => {
            this.dispatchEvent(
                new CustomEvent("cartchanged", {
                bubbles: true,
                composed: true
                })
            );
        });
    }
    
}