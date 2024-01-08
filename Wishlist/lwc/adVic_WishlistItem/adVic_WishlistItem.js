/**
 * Created by dillon.loubser on 10/24/23.
 */

import {api, LightningElement, track, wire} from 'lwc';
import getQuantity from '@salesforce/apex/AdVic_WishlistUtil.getQuantity';
import updateQuantity from '@salesforce/apex/AdVic_WishlistUtil.updateQuantity';


export default class AdVicWishlistItem extends LightningElement {
    @api wishlistItemName;
    @api wishlistItemId;
    @api productInfo;
    @api nameLabel;
    @api removeLabel;

    @track quantity = 1;

    connectedCallback() {
        console.log('Name' + this.wishlistItemName);
        this.wishlistItemName = this.wishlistItemName.replaceAll('&quot;',"\"");

        getQuantity({wishlistItemId:this.wishlistItemId}).then(result=>{
            this.quantity = result;
        });
    }

    handleQuantityChange(event){
        this.quantity = parseInt(event.target.value, 10);
        updateQuantity({wishlistItemId:this.wishlistItemId, quantity:this.quantity});
    }

    decreaseQuantity(){
        if(this.quantity-1  >= 0){
            this.quantity = this.quantity - 1;
        }
        updateQuantity({wishlistItemId:this.wishlistItemId, quantity:this.quantity});
    }
    increaseQuantity(){
        this.quantity++;
        updateQuantity({wishlistItemId:this.wishlistItemId, quantity:this.quantity});
    }

    notifyRemoveItem(){
        this.dispatchEvent(new CustomEvent('removeitem',{detail: { wishlistItemId: this.wishlistItemId}}));
    }

    navigateToProduct(event){
        this.dispatchEvent(new CustomEvent('navigate',{detail: { productId: this.productInfo.productId, productName: this.wishlistItemName}}));
    }
}