# Salesforce-Commerce-Cloud-Reference-Components

Welcome to Salesforce Commerce Cloud Reference Components! 
This repository is an open source, community driven, source of reference components for Commerce Cloud on Core. (That is to say B2B and D2C Commerce)

These components are reference components intended to get you started quicker on any customization that is needed within Commerce Cloud. While each developer strives to build the most 'production' ready component as possible to contribute, you should make your own assessment of the components prod-readiness before using them. 
In most cases, you'll be able to hit the ground running with these components and make your own modifications as needed. 

NOTE: These components are designed only for the LWR version of checkout, not the previous Aura version (flow based checkout).

This repository is not intended to replace the great content that Salesforce already provides us, but as LWR is still new this space can be used to bring together community created content quicker in some areas. 
https://github.com/forcedotcom/commerce-on-lightning-components/tree/release

### List of Components
The following components are the current components available in this repository.

| Component  | Page | Status |
| ------------- | ------------- | ------------- |
| Cart Summary  | Cart, Checkout  | Ready |
| Shipping Method  | Checkout  | Ready |
| Shipping Instructions  | Checkout  | Ready |

## Component Docs

<details>
<summary>Cart Summary</summary>
This component utilizes a combination of slots & expressions to be a light weight version of cart summary. 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Cart Page in Experience Builder
3. Drag 'Cart Summary' under the custom component section to the top right of the right column on cart page.
  You'll notice that the component comes over with place holder values for the $$, this is so you can see what the formatting looks like in Experience Builder. You'll also notice that there are slots available for you to place your text into the component and style as you wish. 
4. Drag a 'Text Block' component into each of the slots and style as needed
5. Publish Site
6. Login as user and check components values for accuracy
  
### Limitation
-   This version does not utilize apex to bring cart summary details to the screen, so it's relying on expressions to show the information
-   This version is not as 'smart' as the native component, meaning it won't hide and show promotions automatically or give you striked out original prices. If you want that functionality you'll have to add that afterwards. 
</details>

<details>
<summary>Shipping Method</summary>
This component shows the delivery methods that are available to the user during checkout. 
This component utilize the commerce cloud API to make updates to the checkout session (which can be found here -- https://developer.salesforce.com/docs/atlas.en-us.242.0.chatterapi.meta/chatterapi/connect_resources_commerce_webstore_checkouts.htm) In order to make this work you will need to ensure you have a remote site setup for your community url. 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Cart Page in Experience Builder
3. Drag 'Shipping Method' under the custom component section to the top right of the right column on cart page.
4. Navigate to Remote Site Settings (Setup > Search "Remote Site Settings")
5. Add a new setting with the name "Checkout Services" and the url of your community (example: https://XXX--uat.sandbox.my.site.com)
6. You'll need Order Delivery Methods for this component to work, if you do not already have these configure you'll need to setup at least one record with the appropriate product and ensure the site is indexed
7. Publish Site
8. Login as user and check components values for accuracy

### Limitation
</details>

<details>
<summary>Shipping Instructions</summary>
This component shows the delivery methods that are available to the user during checkout. 
This component utilize the commerce cloud API to make updates to the checkout session (which can be found here -- https://developer.salesforce.com/docs/atlas.en-us.242.0.chatterapi.meta/chatterapi/connect_resources_commerce_webstore_checkouts.htm) In order to make this work you will need to ensure you have a remote site setup for your community url. 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Cart Page in Experience Builder
3. Drag 'Shipping Instructions' under the custom component section to the top right of the right column on cart page
  You'll notice that the component comes over with place holder values for the Title and Placeholder values. Fill those in as desired.
4. Navigate to Remote Site Settings (Setup > Search "Remote Site Settings")
5. Add a new setting with the name "Checkout Services" and the url of your community (example: https://XXX--uat.sandbox.my.site.com)
6. Publish Site
7. Login as user and check components values for accuracy

### Limitation
</details>

If you're interested in contributing, create a branch / pull request and get started! The more we contribute the better this repository is!
