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
![Screenshot 2024-01-04 at 11 28 03 AM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/db21a1f4-f6df-46a4-8aae-a197aff6c6f6)

## **PLP/PDP/Global Pop-Up Component**

**Experience Builder Screenshot (AdVic_WishlistPopUp LWC):**


**End User View Screenshot (AdVic_WishlistPopUp LWC):**

**User clicks a button that calls the Pop Up method:**
![Screenshot 2024-01-04 at 11 44 09 AM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/f7c54a97-57da-4eb7-8cb8-4d2c969eba7a)

**User clicks "Create New List:**
![Screenshot 2024-01-04 at 11 46 49 AM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/089879d5-adff-4a78-bbb5-6734efd84b02)

**User clicks into the Wish List Drop Down:**
![Screenshot 2024-01-04 at 11 47 04 AM](https://github.com/Bedwards2400/Components-For-Salesforce-Commerce-Cloud/assets/90705679/504a5750-b70d-4d1d-994e-3560163e89b7)



