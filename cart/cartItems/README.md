# Cart Items

These components represent a light starter pack for displaying cart items, these components support:
- Mock data for Experience Builder preview mode
- UI similar to OOTB components
- Relying on --dxp Styling Hooks for most of the color attributes
- Configuration via properties panel
- Dynamic page size property (OOTB has a default page size of 25 items per page and can't be changed)
- Basic support of promotions
- Basic support of Quantity rules
- No inital Apex code for quick plug-and-play

## Installation Steps
1. Deploy both components `cartItem` and `cartItems` to your instance
2. Navigate to the Cart Page in Experience Builder
3. Delete the OOTB 'Cart Items' component
4. Drag the new 'Cart Items' (located under the custom component section) inside the itemsBody on the cart page.
5. Publish the Site
6. Test it as logged-in user
7. (Optional) Adapt the component logic to your needs.

## Considerations
This version does not support following features:
- dynamic Custom Labels; hardcoded labels should be replaced with new custom labels
- dynamic sort based on the Sort options from the OOTB Cart component
- product variations