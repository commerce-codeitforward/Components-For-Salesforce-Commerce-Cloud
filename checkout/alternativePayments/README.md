# Alternative Payments

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
