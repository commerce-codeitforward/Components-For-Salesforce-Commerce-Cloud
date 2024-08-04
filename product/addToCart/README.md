# Add To Cart

This component is a light weight reference to how to properly add and item to a cart from the product detail page.

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Product Page in Experience Builder
3. Drag 'Add To Cart' under the custom component section to the top right of the right column on cart page.
4. Publish Site
5. Login as user and check components values for accuracy
  
-   This version does not utilize apex to add items to the cart, but rather the imperative apis that can be found on the salesforce documentation -- https://developer.salesforce.com/docs/commerce/salesforce-commerce/guide/b2b-b2c-comm-display-lwc-apis.html#storefront-actions
-   This component is a light weight reference component, so the value of 1 has been hardcoded to the component. This can be extended to leverage a quantity incrementer if desired. 