# Cart Summary

This component utilizes a combination of slots & expressions to be a light weight version of cart summary. 

### Installation Steps
1. Deploy Code to your instance
2. Navigate to the Cart Page in Experience Builder
3. Drag 'Cart Summary' under the custom component section to the top right of the right column on cart page.
  You'll notice that the component comes over with place holder values for the $$, this is so you can see what the formatting looks like in Experience Builder. You'll also notice that there are slots available for you to place your text into the component and style as you wish. 
4. Drag a 'Text Block' component into each of the slots and style as needed
5. Publish Site
6. Login as user and check components values for accuracy
  
-   This version does not utilize apex to bring cart summary details to the screen, so it's relying on expressions to show the information
-   This version is not as 'smart' as the native component, meaning it won't hide and show promotions automatically or give you striked out original prices. If you want that functionality you'll have to add that afterwards. 