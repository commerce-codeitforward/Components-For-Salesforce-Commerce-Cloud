# Shipping Address

This component shows shipping addresses in the checkout screen and utilizes the latest and greatest of the checkout standards of commerce cloud. 
This component provides an exmaple of checkout api usage for adding and selecting shipping addresses. Additionally, 
this component provides an example implementation for limiting country and state/province picklist values for address editing and creation. 

### Installation Steps
1. Enable State and Country/Territory Picklists in the target org.
2. Deploy Code to your instance (shippingAddress package.xml is provided)
3. Grant access StoreCountryStateCode classes on the user profiles for the store.
4. Grant Read access to Store Country Codes and Store State Codes custom objects on the user profiles for the store.
5. Populate relevant Store Country Code and Store State Code values according to the use case.
6. Navigate to the Checkout Page in Experience Builder.
7. Drag 'Shipping Address' under the custom component section to the top right of the right column on cart page.
8. Set Apply Country Filter or Apply State Filter according to the use case and supporting data.
9. Publish Site
10. Login as user (NOTE: currently only supports authenticated users)