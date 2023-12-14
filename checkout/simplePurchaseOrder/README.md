# Simple Purchase Order

https://youtu.be/nBPWHMgfOq0
This component is a replacement for the standard purchase order component that can be used on the LWR checkout page.
It utilizes the declarative api as par of LWR checkout - https://developer.salesforce.com/docs/atlas.en-us.b2b_b2c_comm_dev.meta/b2b_b2c_comm_dev/b2b_b2c_comm_display_lwc_apis.htm 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Checkout Page in Experience Builder
3. Drag 'Simple Purchase Order' under the custom component section to the payment section of the checkout page
4. Navigate to Remote Site Settings (Setup > Search "Remote Site Settings")
5. Publish Site
6. Login as user and complete a checkout to validate functionality

This component is dependant on the following items:
[Stencil](/common/lwc/stencil/)