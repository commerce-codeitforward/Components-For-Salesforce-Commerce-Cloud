/**
 * Created by dillon.loubser on 10/24/23.
 */

import {LightningElement, track, wire} from 'lwc';
import communityId from '@salesforce/community/Id';
import { getSessionContext } from 'commerce/contextApi';
import getWishlistSummaries from '@salesforce/apex/AdVic_WishlistUtil.getWishListSummaries';
import getWishlistItems from '@salesforce/apex/AdVic_WishlistUtil.getWishListItems';
import removeItem from '@salesforce/apex/AdVic_WishlistUtil.removeWishlistItem';
import convertToCart from '@salesforce/apex/AdVic_WishlistUtil.putWishlistInCart';
import deleteList from '@salesforce/apex/AdVic_WishlistUtil.deleteList';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

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
import RenameLabel from '@salesforce/label/c.AdVic_Rename_Label';
import {navigate, NavigationContext} from "lightning/navigation";

export default class AdVicWishlistDisplay extends LightningElement {

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
        RenameLabel
    }

    sessionContext;
    currentWishlistId;
    firstWishlistId;
    wishlists;
    wishlistItems;
    @track fullLoading = true;
    @track itemsLoading = true;

    @wire(NavigationContext) navContext;

    @track showWishlists = true;

    @track showWishlistItems = false;

    connectedCallback() {
        getSessionContext()
            .then((context) => {
                this.sessionContext = context;
                getWishlistSummaries({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, includeDisplayedList:false})
                    .then((results)=>{
                        console.log('results' + JSON.stringify(results));
                        let temp = results.summaries;
                        let updatedTemp = [];
                        temp.forEach((item)=>{
                            item.name = item.name.replaceAll('&quot;', '\"');
                            item.name = item.name.replaceAll('&#39;', '\'');
                            item.name = item.name.replaceAll('&amp;', '&');
                            updatedTemp.push(item);
                        })
                        this.wishlists = updatedTemp;
                        this.currentWishlistId = results.summaries[0].id;
                        this.firstWishlistId = results.summaries[0].id;
                        this.fullLoading = false;
                        getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
                            .then((itemResults)=>{
                                this.wishlistItems = itemResults.items;
                                this.showWishlistItems = true;
                                this.itemsLoading = false;
                            }).catch(error=>{
                                console.log('Get Wishlists Error: ' + JSON.stringify(error));
                            });
                    })
                    .catch((err)=>{
                        console.log('Get Wishlists Error: ' + JSON.stringify(err));
                        this.showWishlists = false;
                    });
            })
            .catch((error) => {
                console.log(error);
            });

    }

    handleActive(event){
        this.currentWishlistId = event.target.value;
        this.itemsLoading = true;
        getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
            .then((itemResults)=>{
                this.wishlistItems = itemResults.items;
                this.itemsLoading = false;
            }).catch(error=>{
                console.log('Get Wishlists Error: ' + JSON.stringify(error));
            });
    }

    removeItem(event){
        var itemId = event.detail.wishlistItemId;
        this.itemsLoading = true;
        removeItem({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, wishlistItemId: itemId}).then(()=>{
            getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
                .then((itemResults)=>{
                    this.wishlistItems = itemResults.items;
                    this.showWishlistItems = true;
                    this.itemsLoading = false;
                }).catch(error=>{
                console.log('Get Wishlists Error: ' + JSON.stringify(error));
            });
        });
    }

    handleConvert(){
        convertToCart({communityId:communityId, wishlistId: this.currentWishlistId, effectiveAccountId: this.sessionContext.effectiveAccountId}).then(result=>{
            console.log('Added To Cart');
        }).catch(err=>{
            console.log(err.message);
            const evt = new ShowToastEvent({
                title: 'Error',
                message: err.message,
                variant: 'error',
            });
            this.dispatchEvent(evt);
        })
    }

    handleDelete(){
        this.fullLoading = true;
        deleteList({communityId: communityId, wishlistId: this.currentWishlistId}).then(()=>{
            getWishlistSummaries({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, includeDisplayedList:false})
                .then((results)=>{
                    console.log('results' + JSON.stringify(results));
                    let temp = results.summaries;
                    let updatedTemp = [];
                    temp.forEach((item)=>{
                        item.name = item.name.replaceAll('&quot;', '\"');
                        item.name = item.name.replaceAll('&#39;', '\'');
                        updatedTemp.push(item);
                    })
                    this.wishlists = updatedTemp; //results.summaries;
                    this.currentWishlistId = results.summaries[0].id;
                    this.firstWishlistId = results.summaries[0].id;
                    this.fullLoading = false;
                    getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
                        .then((itemResults)=>{
                            this.wishlistItems = itemResults.items;
                            this.showWishlistItems = true;
                            this.itemsLoading = false;
                        }).catch(error=>{
                        console.log('Get Wishlists Error: ' + JSON.stringify(error));
                    });
                })
                .catch((err)=>{
                    console.log('Get Wishlists Error: ' + JSON.stringify(err));
                    this.showWishlists = false;
                });
        }).catch(err=>{
            console.log('Delete Wishlists Error: ' + JSON.stringify(err));
        });
    }

    @track showWishListPopUp = false;

    handleCreateWishlist(){
        this.showWishListPopUp = true;
    }

    @track showNamePopUp = false;

    handleRename(){
        this.showNamePopUp = true;
    }

    onCloseRename(event){
        this.showNamePopUp = false;
        if(event.detail.action === "renamed"){
            this.fullLoading = true;
            getWishlistSummaries({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, includeDisplayedList:false})
                .then((results)=>{
                    console.log('results' + results);
                    this.wishlists = results.summaries;
                    this.currentWishlistId = event.detail.wishlistId;
                    this.firstWishlistId = results.summaries[0].id;
                    this.fullLoading = false;
                    getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
                        .then((itemResults)=>{
                            this.wishlistItems = itemResults.items;
                            this.showWishlistItems = true;
                            this.itemsLoading = false;
                        }).catch(error=>{
                        console.log('Get Wishlists Error: ' + JSON.stringify(error));
                    });
                })
                .catch((err)=>{
                    console.log('Get Wishlists Error: ' + JSON.stringify(err));
                    this.showWishlists = false;
                });
        }
    }

    onCloseListPopUp(event){
        this.showWishListPopUp = false;
        if(event.detail.action === "closeWithNew"){
            this.fullLoading = true;
            getWishlistSummaries({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, includeDisplayedList:false})
                .then((results)=>{
                    console.log('results' + results);
                    this.wishlists = results.summaries;
                    this.currentWishlistId = event.detail.wishlistId;
                    this.firstWishlistId = results.summaries[0].id;
                    this.fullLoading = false;
                    getWishlistItems({communityId:communityId, effectiveAccountId:this.sessionContext.effectiveAccountId, wishlistId:this.currentWishlistId, pageParams:null})
                        .then((itemResults)=>{
                            this.wishlistItems = itemResults.items;
                            this.showWishlistItems = true;
                            this.itemsLoading = false;
                        }).catch(error=>{
                        console.log('Get Wishlists Error: ' + JSON.stringify(error));
                    });
                })
                .catch((err)=>{
                    console.log('Get Wishlists Error: ' + JSON.stringify(err));
                    this.showWishlists = false;
                });
        }
    }

    handleNavigation(event){
        var url = window.location.origin + window.location.pathname.split('/', 2).join('/') + '/product/' + event.detail.productId;
        window.open(url, "_self")//recordName: event.detail.productName.replace(' ', '-'),
    }
}