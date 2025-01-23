import {LightningElement, api, wire, track} from 'lwc';
import communityId from '@salesforce/community/Id';
import getWishListSummaries from '@salesforce/apex/AdVic_WishlistUtil.getWishListSummaries';
import addItemToWishlist from '@salesforce/apex/AdVic_WishlistUtil.addItemToWishlist';
import createWishList from '@salesforce/apex/AdVic_WishlistUtil.createWishList';
import renameWishlist from '@salesforce/apex/AdVic_WishlistUtil.updateWishlistName';
import { getSessionContext } from 'commerce/contextApi';

import NoWishListLabel from '@salesforce/label/c.AdVic_No_Wishlists';
import AddToWishlist from '@salesforce/label/c.AdVic_Add_To_Wishlist_Title';
import Cancel from '@salesforce/label/c.AdVic_Cancel';
import ConvertLabel from '@salesforce/label/c.AdVic_Convert_Wishlist';
import CreateWishListLabel from '@salesforce/label/c.AdVic_Create_Wishlist_Title';
import LoadingLabel from '@salesforce/label/c.AdVic_Loading_Text';
import DeleteWishlist from '@salesforce/label/c.AdVic_Delete_Wishlist';
import NameLabel from '@salesforce/label/c.AdVic_Name_Label';
import SelectLabel from '@salesforce/label/c.AdVic_Select_Wishlist_Title';
import RemoveLabel from '@salesforce/label/c.AdVic_Remove_Label';
import Add from '@salesforce/label/c.AdVic_Add';
import WishlistName from '@salesforce/label/c.AdVic_Wishlist_Name';
import RenameLabel from '@salesforce/label/c.AdVic_Rename_Label';

export default class AdVic_WishlistPopUp extends LightningElement {

    labels = {
        NoWishListLabel,
        AddToWishlist,
        Cancel,
        ConvertLabel,
        CreateWishListLabel,
        LoadingLabel,
        DeleteWishlist,
        NameLabel,
        SelectLabel,
        RemoveLabel,
        Add,
        WishlistName,
        RenameLabel
    }

    effectiveAccountId;
    @api productId;
    @api justNew = false;
    @api justName = false;
    @api nameId;
    @api firstName;
    @api quantity = 1;

    selectedWishListId;
    wishListCount = 0;
    wishListSummaries;
    @track
    wishListName;
    @track
    isLoading = true;

    @track
    showSelect = false;

    listNameChange(evt){
        this.wishListName = evt.target.value;
    }
    
    connectedCallback() {
        console.log('ProductId: ' + this.productId);
        this.isLoading = true;
        console.log('connected callback called');
        getSessionContext().then((context) => {
            this.effectiveAccountId = context.effectiveAccountId;
            if(!this.justNew && !this.justName) {
                getWishListSummaries({
                    communityId: communityId,
                    effectiveAccountId: this.effectiveAccountId,
                    includeDisplayedList: true
                }).then(result => {
                    console.log(JSON.stringify(result));
                    this.wishListCount = result.wishlistCount;
                    this.wiredWishListSummaries = result.summaries;
                    if (this.wishListCount && this.wishListCount > 0) {
                        let temp = result.summaries;
                        let updatedTemp = [];
                        temp.forEach((item)=>{
                            item.name = item.name.replaceAll('&quot;', '\"');
                            item.name = item.name.replaceAll('&#39;', '\'');
                            item.name = item.name.replaceAll('&amp;', '&');
                            updatedTemp.push(item);
                        })
                        this.wiredWishListSummaries = updatedTemp;
                        this.showSelect = true;
                    }
                    this.isLoading = false;
                })
            }
            else{
                this.isLoading = false;
            }
        });
    }

    get wishListOptions(){
        if(!this.wiredWishListSummaries){
            return;
        }

        return this.wiredWishListSummaries.map((wishList) => {
            return {
                label: wishList.name,
                value: wishList.id
            }
        });
    }

    get hasWishLists(){
        return (this.wishListCount && this.wishListCount > 0);
    }

    handleClose(event){
        this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'close'}}))
    }

    handleAdd(event){
        if(this.selectedWishListId){
            this.addToSelectedWishlist();
        }
        else{
            this.addToNewList();
        }
    }

    addToSelectedWishlist(){
        addItemToWishlist({communityId:communityId, wishlistId:this.selectedWishListId, productId:this.productId, quantity: this.quantity}).then(result=>{
            this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithNew', wishlistItemId: result.Id}}));
        }).catch(err=>{
            console.log('Add Item To Selected Error: ' + JSON.stringify(err));
            this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithError', error: err}}));
        });
    }

    addToNewList(){
        var wishlistInput = {
            name: this.wishListName
        };
        createWishList({communityId:communityId, wishlistInput: wishlistInput}).then(result=>{
            var wishlistId = result.summary.id;
            addItemToWishlist({communityId:communityId, wishlistId:wishlistId, productId:this.productId, quantity: this.quantity}).then(resultItem=>{
                this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithNew', wishlistItemId: resultItem.Id}}));
            }).catch(error=>{
                console.log('Add Item to New Error: ' + JSON.stringify(error));
                this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithError', error: error}}));
            });
        }).catch(err=>{
            console.log('Create List Error: ' + JSON.stringify(err));
            this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithError', error: err}}));
        });
    }

    handleCreate(){
        var wishlistInput = {
            name: this.wishListName
        };
        createWishList({communityId:communityId, wishlistInput: wishlistInput}).then(result=>{
            var wishlistId = result.summary.id;
            this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithNew', wishlistId: wishlistId}}));
        }).catch(err=>{
            console.log('Create List Error: ' + JSON.stringify(err));
            this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'closeWithError', error: err}}));
        });
    }

    handleWishList(event){
        console.log('handleWishList',event.detail.value);
        this.selectedWishListId = event.detail.value;
    }

    handleSelectAList(){
        this.isLoading = true;
        this.showSelect = true;
        this.isLoading = false;
    }

    handleCreateNewList(){
        this.isLoading = true;
        this.showSelect = false;
        this.isLoading = false;
    }

    handleQuantityChange(event){
        this.quantity = parseInt(event.target.value, 10);
    }

    decreaseQuantity(){
        if(this.quantity-1 >= 0){
            this.quantity = this.quantity - 1;
        }
    }
    increaseQuantity(){
        this.quantity++;
    }

    handleRename(){
        renameWishlist({wishlistId: this.nameId, newName: this.wishListName}).then(result=>{
            if(result){
                this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'renamed', wishlistId: this.nameId}}));
            }
            else{
                this.dispatchEvent(new CustomEvent('modalmessage',{detail: { action: 'renameFailed', wishlistId: this.nameId}}));
            }
        })
    }
}
