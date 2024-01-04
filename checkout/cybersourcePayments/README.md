# Cybersource - B2B / B2C Commerce for LWR

This component uses Cybersource Microform Integration along with the Commerce LWR Place Order process to validate Credit Card information and create Order Payment Summary records. Initially we use Cybersource Microforms to create a Cybersource temporary token. We then use the temporary token to Authorize a payment in Cybersource. In addition, we leverage the 'commerce/checkoutApi' postAuthorizePayment() API to validate the Cybersource Authorization and populate the commercepayments.PostAuthorizationResponse in the CybersourcePaymentGateway. The commerce platform will manage the creation of all the necessary OrderPaymentSummary and AlternativePaymentMethod records. Keep in mind the platform create an AlternativePaymentMethod record instead of a CardPaymentMethod.

Install instructions:
1. Deploy the code.
2. Assign the Cybersource Payments permission set to users. This will grant them access to the following apex classes
  -  CybersourceController
  -  CybersourcePaymentAdapter
3. Create a Cybersource Merchant Account with Cybersource
4. Create a Cybersource Security Key.
  - If you have a Cybersource Security Key and knkow the Api Key and API Shared Secret values, you can use those. Otherwise you will need to create one.
  - From the Cybersource Dashboard click "+ Generate new key"
  - Select the REST-Shared Secret option
  - Leave all other options unselected
  - Click "Generate Key" button. Copy and store the public and private keys in a secure location.The Private Key cannot be recovered if misplaced. You will need the Shared and Private values in the next step.
5. Create a "Payment API Variable" Custom Setting record in Salesforce with the following values
  - Name: Cybersource
  - Api Key: YOUR_CYBERSOURCE_SECURITY_KEY_API_KEY
  - Api Merchant Id: YOUR_CYBERSOURCE_MERCHANT_ID
  - Api Shared Secret Key: YOUR_CYBERSOURCE_SECURITY_KEY_API_SHARED_KEY
  - Api Target Origin: YOUR STORE SITE URL Make sure there isn't a trailing "/" in the URL
    - CORRECT: http://mysiteurl.com
    - INCORRECT: http://mysiteurl.com/
  - Api Url: apitest.cybersource.com This will need to change for Production
6. Create a Legacy Named Credential with the following settings
  - Label:	Cybersource
  - Name:	Cybersource
  - URL:	https://apitest.cybersource.com
  - Certificate: Leave Blank
  - Identity Type: Named Credential
  - Authentication Protocol: Password Authentication
  - Username:	YOUR_CYBERSOURCE_ACCOUNT_USERNAME
  - Password:	YOUR_CYBERSOURCE_ACCOUNT_PASSWORD
  - Generate Authorization Header: Unchecked
  - Allow Merge Fields in HTTP Header: Checked
  - Allow Merge Fields in HTTP Body: Checked
  - Outbound Network Connection: Leave Blank
7. Register the Payment Gateway Provider. Follow these directions for registering the CybersourcePaymentAdapter class as a Payment Gateway Provider
  - Login to Workbench
  - Select Data then Insert
  - Select PaymentGatewayProvider as the object type
  - Select "Single Record"
  - Click "Next"
  - fill in the following Fields
  - ApexAdapterId = CybersourcePaymentAdapter class Id
  - IdempotencySupported = Yes
  - MasterLabel = Cybersource Payment Provider
  - DeveloperName = CybersourcePaymentProvider
  - Language = 'en_US'
  - Click insert
8. Register your Payment Gateway Provider as a Payment Gateway
  - Log in to Salesforce
  - From the App Launcher type Payment and select "Payment Gateways"
  - Click the "New" button to create a new Payment Gateway record.
  - Fill in the following fields:
  - Payment Gateway Name: Cybersouce Payment Gateway
  - Status: Active
  - Payment Gateway Provider: Search for "Cybersource Payment Gateway" and select
  - Merchant Credential: Search for the Cybersource Named Credential you created earlier
  - Click Save
  - Go to Store Administration
  - Click "Payments"
  - Click "Select Provider"
  - Check "Cybersource Payment Gateway"
  - Click "Next"
  - Click "Confirm"
9.Create Remote Site
  - In Salesforce Setup click "Remote Site Settings"
  - Click "New Remote Site"
  - Complete the following fields:
  - Remote Site Name: Cybersource Test This value will be different for Production
  - Remote Site URL: https://apitest.cybersource.com This value will be different for Production
  - Click "Save"
10. Create Trusted URLs
  - In Salesforce Setup click "Trusted URLs"
  - Click "New Trusted URL"
  - Complete the following fields:
    - API Name: CybersourceTest This value will be different for Production
    - URL: https://testflex.cybersource.com  This value will be different for Production
    - Active: Check
    - CSP Context: All
    - connect-src: Check
    - font-src: Check
    - frame-src: Check
    - img-src: Check
    - style-src: Check
  - Click "Save"
11. Open Experience Builder for your Storefront
  - Click "Settings" in the Left Navigation
  - Click "Security & Privacy"
  - Change the "Security Level" to "Relaxed CSP: Permit Access to Inline Scripts and Allowed Hosts"
  - Click "Add Trusted URL" and complete the following fields:
    - Name: testflex.cybersource.com  This value will be different for Production
    - URL: https://testflex.cybersource.com  This value will be different for Production
    - Active: Checked
  - Click Save
  - Click "Add Trusted URL" and complete the following fields:
    - Name: Cybersource Microform Test  This value will be different for Production
    - URL: https://testflex.cybersource.com/microform/bundle/v2/flex-microform.min.js  This value will be different for Production
    - Active: Checked
  - Click Save
  - Modify the Checkout Page
  - Select the "Checkout" Page from the Page list combo box
  - In the Payment Section remove any existing Payment Components
  - From the Components Menu drag and drop the "Cybersource Payment" Component into the Payments Section.
  - Click the Publish button.


  Custom Metadata for State and Country Values.
  Cybersource requires State and Country ISO codes as part of the Credit Card Address. These are managed with Country_Code__mtd and State_Code__mdt values. This repo contains Country and State values for the United States. Additional values can be added using these Custom Metadata Types.

