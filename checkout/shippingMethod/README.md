# Shipping Method

This component shows the delivery methods that are available to the user during checkout. 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Cart Page in Experience Builder
3. Drag 'Shipping Method' under the custom component section to the top right of the right column on cart page.
4. You'll need Order Delivery Methods for this component to work, if you do not already have these configure you'll need to setup at least one record with the appropriate product and ensure the site is indexed
5. Publish Site
6. Login as user and check components values for accuracy


### Updates
The following updates have been made as of 1/14/25
- Updated design to be closer to what is out of the box
- Updated the data to utilize the storefront api's (these weren't available when this component was first built)
- Updated the mock data framework to be cleaner
- Added dispatching errors & clearing those errors
- Added comments about a way to use expressions if you'd prefer that over storefront apis
- Added summary & edit mode to align with the accordion layout