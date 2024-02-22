# Extensions - Salesforce-Commerce-Cloud-Components

The following components are available for the cart page within Salesforce Commerce Cloud Lightning. 
In-depth documentation and installation steps can be found by navigating to the feature folders. 

### List of Sections
The following are the current sections available in this section of the repository.

| Component  | Description | 
| ------------- | ------------- | 
| Orchestrator  | This section holds all the available orchestrators that can be used by extensions.  | 
| Shipping  | This section holds all the available calculator / services for shipping that can be used by extensions.  | 

### Setup Steps for Extensions
1. Turn on the setting
- As of February 1st, all new stores will be enabled by default https://developer.salesforce.com/docs/commerce/salesforce-commerce/guide/cart-calculate-api.html#enable-and-disable-the-cart-calculate-api-for-a-webstore
2. Create apex class
- Your apex class must extend the right CartExtension, for example CartExtension.ShippingCartCalculator is what you’d use for Shipping
3. Register the class
- Create a RegisteredExternalService record via workbench (field mapping to follow)
4. Connect to the store
- Select the correct provider from Administration


# Extension Calculator - Registered Extenal Service Configuration

| Master Label          | Developer Name   | External Service Provider Type | Extension Point Name             | External Service Provider Id                    |
|-----------------------|------------------|--------------------------------|----------------------------------|-------------------------------------------------|
| Cart Calc Tax         | CartCalcTax      | Extension                      | Commerce_Domain_Tax_CartCalculator      | Id of the Apex Class |
| Cart Calc Shipping    | CartCalcShipping | Extension                      | Commerce_Domain_Shipping_CartCalculator | Id of the Apex Class |
| Cart Calc Inventory   | CartCalcInventory| Extension                      | Commerce_Domain_Inventory_CartCalculator | Id of the Apex Class |
| Cart Calc Pricing     | CartCalcPricing  | Extension                      | Commerce_Domain_Pricing_CartCalculator  | Id of the Apex Class |

# Extension Service - Registered Extenal Service Configuration

| Master Label          | Developer Name    | External Service Provider Type | Extension Point Name               | External Service Provider Id     |
|-----------------------|-------------------|--------------------------------|------------------------------------|-----------------------------------|
| Cart Calc Tax         | CartCalcTax       | Extension                      | Commerce_Domain_Tax_Service        | Id of the Apex Class              |
| Cart Calc Inventory   | CartCalcInventory | Extension                      | Commerce_Domain_Inventory_Service  | Id of the Apex Class              |
| Cart Calc Pricing     | CartCalcPricing   | Extension                      | Commerce_Domain_Pricing_Service    | Id of the Apex Class              |

