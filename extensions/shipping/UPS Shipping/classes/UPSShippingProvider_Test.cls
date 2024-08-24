@isTest
public class UPSShippingProvider_Test {

    @isTest
    static void testprepareRequestBody(){
        ShippingProviderRequest shippingRequest = shipProviderRequest();
        Map<String, String> callOutRequest = new Map<String, String>();
        UPSShippingProvider upsShip = new UPSShippingProvider();
        Test.startTest();
        upsShip.prepareRequestBody(shippingRequest, callOutRequest);
        System.assert(callOutRequest.containsKey(Constants.SERVICE_REQUEST_BODY), 'Request body should be populated');
        Test.stopTest();
    }
   
    @isTest
    static void testgetShippingOptionsFromResponse(){
         List<String> responseList = new List<String>{
            '{"RateResponse":{"RatedShipment":[{"Service":{"Code":"01"},"TotalCharges":{"MonetaryValue":"20.00"}},{"Service":{"Code":"02"},"TotalCharges":{"MonetaryValue":"30.00"}}]}}'
        };
        ShippingProviderRequest shippingRequest = shipProviderRequest();
        UPSShippingProvider upsShip = new UPSShippingProvider();
        Test.startTest();
        Map<String, ShippingProviderResponse> shippingOptions = upsShip.getShippingOptionsFromResponse(responseList,shippingRequest);
        System.assert(shippingOptions.containsKey('01'), 'Service code should be in the response');
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
        shipmeta.requestJSON = '{' +
            '"RateRequest": {' +
                '"Request": {' +
                    '"TransactionReference": {' +
                        '"CustomerContext": "Test Context",' +
                        '"CustomerContext2": "Test Context"' +
                    '},' +
                    '"TransactionReference2": {' +
                        '"CustomerContext": "Test Context",' +
                        '"CustomerContext2": "Test Context"' +
                    '}' +
                '},' +
                '"CustomerClassification": {' +
                    '"Code": "00",' +
                    '"Description": "Regular Customer"' +
                '},' +
                '"CustomerClassification2": {' +
                    '"Code": "00",' +
                    '"Description": "Regular Customer"' +
                '},' +
                '"Shipment": {' +
                    '"Shipper": {' +
                        '"Name": "Test Shipper",' +
                        '"ShipperNumber": "123456",' +
                        '"Address": {' +
                            '"AddressLine": ["123 Test St"],' +
                            '"City": "Test City",' +
                            '"StateProvinceCode": "TS",' +
                            '"PostalCode": "12345",' +
                            '"CountryCode": "US",' +
                            '"AddressLine2": "City Park"' +
                        '},' +
                        '"ShipNumber": "123456"' +
                    '},' +
                    '"ShipTo": {' +
                        '"Name": "Test Receiver",' +
                        '"Address": {' +
                            '"AddressLine": ["456 Test Ave"],' +
                            '"City": "Receiver City",' +
                            '"StateProvinceCode": "RC",' +
                            '"PostalCode": "67890",' +
                            '"CountryCode": "US"' +
                        '},' +
                        '"City": "Test"' +
                    '},' +
                    '"ShipFrom": {' +
                        '"Name": "Test Receiver",' +
                        '"Address": {' +
                            '"AddressLine": ["456 Test Ave"],' +
                            '"City": "Receiver City",' +
                            '"StateProvinceCode": "RC",' +
                            '"PostalCode": "67890",' +
                            '"CountryCode": "US"' +
                        '}' +
                    '},' +
                    '"PaymentDetails": [{' +
                        '"ShipmentCharge": {' +
                            '"Type": "01",'+
                            '"Type2": "02",'+
                            '"BillThirdParty": {' +
                                '"AttentionName": "ThirdPartyName",' +
                                ' "Name": "ThirdParty",' +
                                '"AccountNumber": "789123",' +
                                '"AccNumber": "79123",' +
                                '"Address": {' +
                                    '"AddressLine": "ThirdPartyAddress",'+
                                    '"City": "ThirdPartyCity",'+
                                    '"StateProvinceCode": "FL",'+
                                    '"PostalCode": "33101",'+
                                    '"StateCode": "FL",'+
                                    '"CountryCode": "US" '+
                                '}' +
                           '}' +
                        '},' +
                        '"ShipmentCharge2":"LBS"' +
                   ' }],' +
                   '"ShipmentRatingOptions": {' +
                   '"ShipmentRate2":"LBS",' +
                   '"TPFCNegotiatedRatesIndicator": "testTPFCNegotiatedRatesIndicator",' +
                   '"NegotiatedRatesIndicator": "testNegotiatedRatesIndicator"' +
                    '},' +
                   '"Service": {' +
                   '"Code": "testCode",' +
                   '"Description": "testDescription"' +
                    '},' +
                    '"ShipmentTotalWeight": {' +
                        '"UnitOfMeasurement": {' +
                            '"Code": "LBS",' +
                            '"Description": "Pounds"' +
                        '},' +
                        '"Weight": "10",' +
                        '"Height": "10"' +
                    '},' +
                    '"NumOfPieces": "testNumOfPieces",' +
                    '"NumOfData": "testNumOfData",' +
                    '"Package": [{' +
                        '"SimpleRate": {' +
                            '"Code": "SR",' +
                            '"Description": "Simple Rate"' +
                        '},' +
                        '"PackagingType": {' +
                            '"Code": "02",' +
                            '"Description": "Customer Supplied Package"' +
                        '},' +
                        '"Dimensions": {' +
                            '"UnitOfMeasurement": {' +
                                '"Code": "IN",' +
                                '"Description": "Inches"' +
                            '},' +
                            '"Length": "10",' +
                            '"Width": "10",' +
                            '"Height": "10",' +
                            '"Growth": "10"' +
                        '},' +
                        '"PackageWeight": {' +
                            '"UnitOfMeasurement": {' +
                                '"Code": "LBS",' +
                                '"Description": "Pounds",' +
                                '"Site": "Pounds"' +
                            '},' +
                            '"Weight": "5"' +
                        '},' +
                        '"OversizeIndicator": "Y",' +
                        '"OversizeIndicator2": "Y",' +
                        '"MinimumBillableWeightIndicator": "N"' +
                    '}],' +
                    '"DeliveryTimeInformation": {' +
                        '"PackageBillType": "testPackageBillType",' +
                        '"PackageBill": "testPackageBill",' +
                        '"Pickup": {' +
                            '"Date": "testDate",' +
                            '"Hour": "testHour",' +
                            '"Time": "testTime"' +
                        '}' +
                    '},' +
                    '"ShipmentCharges": {' +
                        '"BillShipper": {' +
                            '"AccountNumber": "987654",' +
                            '"HouseNumber": "987654"' +
                        '},' +
                        '"BillShipper2": {' +
                        '"AccountNumber": "987654"' +
                    '}' +
                    '}' +
                '}' +
            '},' +
            '"RateRequest2": "00"' +
           
        '}';
        
        return shipProvider;
    }
   

}