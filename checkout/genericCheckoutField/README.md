# Generic Sheckout Field - B2B / D2C Commerce for LWR
This component was designed to allow a User to add a single field from either the WebCart or CartDeliveryGroup objects to the Commerce LWR Place Order process. 

Install instructions:
1. Deploy the code.
2. Create a custom field on wither the WebCart or CartDeliveryGroup object you wish to display.
3. Using a Permission set, grant Read / Write access to the custom field you created.
4. Open Experience Builder for your Storefront
  - Select the "Checkout" Page from the Page list combo box
  - From the Components Menu drag and drop the "Generic Checkout Field Input Component" Component into the Section of your choice.
  - In the Component Properties display complete the following fields:
    - Object API Name: Select the appropriate object
    - Field API Name: Enter the Api Name of the Custom Field to be displayed
    - Field Label Override: Enter a value for the field label. This can be left blank to use the fields configured label
    - Is Required: Check this to make the field required
    - Field Error Message: Enter the error message you wish to display should an error occur
  - Click the Publish button.
