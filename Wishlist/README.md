# AdVic B2B LWR Wishlist Feature

This package was developed to fill in the gaps between the Wishlist functionality in Salesforce B2B LWR and Aura. The main goal was to achieve parity so that Users could create multiple wishlists (Available in Aura, but not LWR) and add products to those wishlists. 

In this package, users can:
- Create Multiple Wish Lists (OOTB Wish List Feature only allows for 1 List)
- Delete Wish Lists (Not available OOTB)
- Rename their Wish Lists
- Convert an entire Wish List into a Cart (OOTB Wish List Feature only allows for adding individual Wish List Items to the Cart)

## Package Components
This Package consists of 3 Lightning Web Components (LWCs) and an Apex Utility Class with a corresponding Test Class.

Lightning Web Components:
- AdVic_WishlistDisplay
- AdVic_WishlistItem
- AdVic_WishlistPopUp

Apex:
- AdVic_WishlistUtil
- AdVic_WishlistUtilTest


## Screenshots 

## **My Profile**

**Experience Builder Screenshot (AdVic_WishlistDisplay and AdVic_Wishlistitem LWCs):**

![Screenshot 2024-01-04 at 10 57 56 AM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/fbfa91a7-94c8-4f9c-880d-906ca1e640d3)

**End User View Screenshot (AdVic_WishlistDisplay and AdVic_Wishlistitem LWC):**

![Screenshot 2024-01-08 at 2 37 45 PM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/2450d33d-bf5e-47d6-bf71-a658d9afb21c)


## **PLP/PDP/Global Pop-Up Component**

The Pop-Up component can be leveraged throughout your org. The most obvious places are the PLP and PDP (Anywhere you typically add products to your cart).

**Note:** The screenshots below show the Pop-Up from the End User perspective when the User clicks "Add to List" as opposed to "Add to Cart" from a Product List Page (PLP). The PLP details are not shown due to client-sensitivity.

**User clicks a button that calls the Pop Up method:**

![Screenshot 2024-01-08 at 2 16 55 PM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/989276c8-0e7e-4093-8ddb-bf01a26ba905)

**User clicks "Create New List:**

![Screenshot 2024-01-08 at 2 16 02 PM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/6d57dfe9-d72e-48c3-a97a-97093ec6f38f)

**User clicks into the Wish List Drop Down:**

![Screenshot 2024-01-08 at 2 17 36 PM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/4e04b5ae-95db-4db4-92a5-b40d0d395ab2)





