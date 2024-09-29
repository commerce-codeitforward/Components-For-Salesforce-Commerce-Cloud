@isTest
public class FedExShippingProviderTest {

    @isTest
    public static void testPrepareRequestBody() {
        ShippingProviderRequest shippingRequest = shipProviderRequest();
        Map<String, String> callOutRequest = new Map<String, String>();
        FedExShippingProvider fedex = new FedExShippingProvider();
        Test.startTest();
        fedex.prepareRequestBody(shippingRequest, callOutRequest);
        Test.stopTest();

        System.assert(callOutRequest.containsKey(Constants.SERVICE_REQUEST_BODY), 'SERVICE_REQUEST_BODY should be present in callOutRequest');
        String requestBody = callOutRequest.get(Constants.SERVICE_REQUEST_BODY);
       
    }

    @isTest
    public static void testGetShippingOptionsFromResponse() {
        List<String> responseList = new List<String>();   
        responseList.add(jsonRequest());
        ShippingProviderRequest shippingRequest = shipProviderRequest();
        FedExShippingProvider fedex = new FedExShippingProvider();
        Test.startTest();
        Map<String, ShippingProviderResponse> shippingOptions = fedex.getShippingOptionsFromResponse(responseList, shippingRequest);
        System.assert(shippingOptions != null);
        Test.stopTest();
     
    }
   
    private static ShippingProviderRequest  shipProviderRequest(){
        ShippingProviderRequest shipProvider = new ShippingProviderRequest();
         ShippingMetaData shipmeta = new ShippingMetaData();
        shipProvider.street ='1600 Massachusetts Avenue';
        shipProvider.city = 'Washington';
        shipProvider.state = 'Washington DC';
        shipProvider.postalCode = '20011';
        shipProvider.country = 'United States';
        shipProvider.packageWeight = 32.00;
        shipProvider.shippingMetaData = shipmeta;
        shipmeta.accountNumber ='HJ8214';
        shipmeta.carrier = 'UPS';
        shipmeta.displayOrder = 1;
        shipmeta.requestJSON ='{"accountNumber":{"value":"123456"},"requestedShipment":{"shipper":{"address":{"postalCode":"12345","countryCode":"US"}},"recipient":{"address":{"postalCode":"67890","countryCode":"US"}},"pickupType":"PICKUP_AT_FEDEX_LOCATION","rateRequestType":["LIST"],"requestedPackageLineItems":[{"weight":{"units":"LB","value":10.0}}]}}';
        
        return shipProvider;
    }
    private static String jsonRequest(){
         String json = '{' +
      '"transactionId": "123456789",' +
      '"customerTransactionId": "abc123",' +
      '"customerId": "abc123",' +
      '"output": {' +
        '"alerts": [{"alertType": "Info",'+
        '"code": "code",' +
        '"coding": "code",' +
        '"message": "This is an informational alert."}],' +
        '"rateReplyDetails": [{' +
          '"serviceType": "FEDEX_GROUND",' +
          '"serviceName": "FedEx Ground",' +
          '"packagingType": "YOUR_PACKAGING",' +
          '"ratedShipmentDetails": [{' +
            '"rateType": "PAYOR_ACCOUNT_SHIPMENT",' +
            '"ratedWeightMethod": "ACTUAL",' +
            '"totalDiscounts": 0.0,' +
            '"totalBaseCharge": 10.0,' +
            '"totalBase": 10.0,' +
            '"totalNetCharge": 10.0,' +
            '"totalNetFedExCharge": 10.0,' +
            '"shipmentRateDetail": {' +
              '"rateZone": "1",' +
              '"rateScale": "1",' +
              '"rate": "1",' +
              '"dimDivisor": 139,' +
              '"fuelSurchargePercent": 0.0,' +
              '"totalSurcharges": 0.0,' +
              '"totalFreightDiscount": 0.0,' +
              '"surCharges": [{'+
              '"type": "1",' +
              '"description": "description",' +
              '"amount": 13.90' +
             '}],' +
              '"pricingCode": "ACTUAL",' +
              '"totalBillingWeight": {' +
                '"units": "LB",' +
                '"value": 1.0' +
              '},' +
              '"currency": "USD"' +
            '},' +
            '"ratedPackages": [{' +
              '"groupNumber": 1,' +
              '"group": 1,' +
              '"effectiveNetDiscount": 0.0,' +
              '"packageRateDetail": {' +
                '"rateType": "PAYOR_ACCOUNT_PACKAGE",' +
                '"ratedWeightMethod": "ACTUAL",' +
                '"baseCharge": 10.0,' +
                '"netFreight": 10.0,' +
                '"totalSurcharges": 0.0,' +
                '"netFedExCharge": 10.0,' +
                '"totalTaxes": 0.0,' +
                '"netCharge": 10.0,' +
                '"totalRebates": 0.0,' +
                '"billingWeight": {' +
                  '"units": "LB",' +
                  '"unit": "LB",' +
                  '"value": 1.0' +
                '},' +
                '"totalFreightDiscounts": 0.0,' +
                '"totalFreight": 0.0,' +
                '"currency": "USD",' +
                '"surcharges": [{'+
                '"rateZone":"Rate"'+
                '}]' +
              '}' +
            '}],' +
            '"currency": "USD"' +
          '}],' +
          '"ratedShipmentDetails_Z": [{' +
            '"rateType": "PAYOR_ACCOUNT_SHIPMENT",' +
            '"ratedWeightMethod": "ACTUAL",' +
            '"totalDiscounts": 0.0,' +
            '"totalBaseCharge": 10.0,' +
            '"totalBase": 10.0,' +
            '"totalNetCharge": 10.0,' +
            '"totalNetFedExCharge": 10.0,' +
            '"shipmentRateDetail": {' +
              '"rateZone": "1",' +
              '"rateScale": "1",' +
              '"rate": "1",' +
              '"dimDivisor": 139,' +
              '"fuelSurchargePercent": 0.0,' +
              '"totalSurcharges": 0.0,' +
              '"totalFreightDiscount": 0.0,' +
              '"surCharges": [{'+
              '"type": "1",' +
              '"level": "1",' +
              '"description": "description",' +
              '"amount": 13.90' +
             '}],' +
              '"pricingCode": "ACTUAL",' +
              '"totalBillingWeight": {' +
                '"units": "LB",' +
                '"value": 1.0' +
              '},' +
              '"currency": "USD"' +
            '},' +
            '"ratedPackages": [{' +
              '"groupNumber": 1,' +
              '"group": 1,' +
              '"effectiveNetDiscount": 0.0,' +
              '"packageRateDetail": {' +
                '"rateType": "PAYOR_ACCOUNT_PACKAGE",' +
                '"ratedWeightMethod": "ACTUAL",' +
                '"baseCharge": 10.0,' +
                '"netFreight": 10.0,' +
                '"totalSurcharges": 0.0,' +
                '"netFedExCharge": 10.0,' +
                '"totalTaxes": 0.0,' +
                '"netCharge": 10.0,' +
                '"totalRebates": 0.0,' +
                '"billingWeight": {' +
                  '"units": "LB",' +
                  '"unit": "LB",' +
                  '"value": 1.0' +
                '},' +
                '"totalFreightDiscounts": 0.0,' +
                '"totalFreight": 0.0,' +
                '"currency": "USD",' +
                '"surcharges": [{'+
                '"rateZone":"Rate"'+
                '}]' +
              '}' +
            '}],' +
            '"currency": "USD"' +
          '}],' +
          '"operationalDetail": {' +
            '"ineligibleForMoneyBackGuarantee": false,' +
            '"astraDescription": "FedEx Ground",' +
            '"airportId": "MEM",' +
            '"airId": "MEM",' +
            '"serviceCode": "92"' +
          '},' +
          '"serviceDescription": {' +
            '"serviceId": "FedEx Ground",' +
            '"serviceType": "FedEx ",' +
            '"code": "FG",' +
            '"serviceCategory": "FedEx Ground product",' +
            '"description": "FedEx Ground Description",' +
            '"service": "FedEx Ground",' +
            '"names": [{'+
            '"type": "FG",' +
            '"value": "FG value",' +
            '"values": "FG values",' +
            '"encoding": "FGendode"' +
           '}],' +
            '"astraDescription": "FedEx Ground Describe"' +
             '},' +
         
          '"signatureOption": "SERVICE_DEFAULT",' +
          '"signatureOptionType": "SERVICE_DEFAULT"' +
        '}],' +
        '"quoteDate": "2023-03-15T12:34:56-05:00",' +
        '"quote": "2023-03-15T12:34:56-05:00",' +
        '"encoded": false' +
      '}' +
    '}';
        return json;
    }
}