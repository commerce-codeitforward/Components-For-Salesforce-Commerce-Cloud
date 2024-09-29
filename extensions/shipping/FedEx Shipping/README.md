# LWR Extension Framework : FedEx Shipping Integration

This repository contains a reference implementation of integrating B2B/D2C commerce with a FedEx Shipping Provider to retrieve shipping methods and costs/rates.

**Remember** : The integration is built on the Salesforce Commerce Extension framework introduced in the Winter '24 release. 
Moving forward, it is essential to prioritize extensions over integrations as they provide more targeted customizations for B2B/D2C stores.

## Capabilities ##
- Shipping related information can be pre configured like  , 
  - Shipper/Account Number
  - Ship From Address
  - Shipper Address 
  - Weight thresholds
  - Shipping Options(shipping methods code & name mapping)
  - Mocked response
- In case a store supports multiple locales/countries , can configure locale specific shipping providers so a store can have multiple shipping providers configured
- Can combine shipping rates from multiple shipping providers (e.g. internal flat rates & FedEx rates), 
  - On UI,  rates can be displayed grouping by carrier (have to customize LWC component )
  - Also can be sorted using display order (have to customize LWC component )

## Extensibility ##
There are various points where this implementation can be extended to achieve project specific requirement:
  - Meta Data
    - Can add more fields to both the meta data types Shipping Provider & HTTP Service
  - Code 
     - Following classes can be extended , details are available under respective item number 
      - ShippingCartCalculatorExtension 
      - ShippingProvider
      - HTTPService

 ## Limitations  ##
  Currently HTTPS Service supports only JSON (as data format)

 ## Prerequisites  ##
  - Standard object **Product2** should have an attribute **Weight__c** to store a product's weight.
  - There should be a product with **product family** configured as **Shipping (Product2.Family = 'Shipping')** , this product will be used as shipping product 

 ## Upcoming Features  ##
  - Logging enhancements 
  - HTTP Service - Support for XML data format

## Snapshots ##

### FedEx shipping methods with rates  ### 

![image](https://github.com/rajapatnaik/fedex-salesforce-b2b-lightning/assets/37152379/14772687-321d-4979-ac0c-bd172f359afb)


### FedEx shipping methods & rates combined with internal flat rates ### 

![image](https://github.com/rajapatnaik/fedex-salesforce-b2b-lightning/assets/37152379/70b82cb0-6345-4901-ae58-035301d8d141)



## Documentation ##
For details , docs can be found here (Use "Shipping Integration (using OAuth)" as a starting/parent doc): 
  - [Shipping Integration (using OAuth)](https://github.com/rajapatnaik/fedex-salesforce-b2b-lightning/blob/main/SF-LWR%20Extension%20Framework%20_%20Shipping%20Integration%20(using%20OAuth)-010724-224833.pdf)
  - [FedEx Shipping Integration](https://github.com/rajapatnaik/fedex-salesforce-b2b-lightning/blob/main/SF-LWR%20Extension%20Framework%20_%20FedEx%20Shipping%20Integration-010724-230045.pdf)
  - [Flat Shipping Rates](https://github.com/rajapatnaik/fedex-salesforce-b2b-lightning/blob/main/SF-LWR%20Extension%20Framework%20_%20Flat%20Shipping%20Rates-010724-230330.pdf)

**Warning**: The provided sample code is intended for demonstration purposes only. It is important to refrain from using this source code in a production system without first modifying and thoroughly testing it.

