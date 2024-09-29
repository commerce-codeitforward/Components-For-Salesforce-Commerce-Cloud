@isTest
public class VertexTaxProviderTest {
    
     @testSetup
    static void setup(){
        Account account = new Account(Name='Training');
        insert account;
        WebStore webStore = new WebStore(
            Name = 'Training',
            Tax_Document_Type__c ='INVOICE',
            Tax_Transaction_Type__c ='SALE'
        );
        insert webStore;
        WebCart cart = new WebCart(Name='Cart', WebStoreId=webStore.Id, AccountId=account.Id);
        insert cart;
         CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup(CartId=cart.Id, Name='Default Delivery');
        insert cartDeliveryGroup;
        CartItem cartItemWithNoSku = new CartItem(
            CartId=cart.Id,
            Quantity=1.0,
            Type='Product',
            Name='TestProductNoSku',
            CartDeliveryGroupId=cartDeliveryGroup.Id
        );
        insert cartItemWithNoSku;
    }
    @isTest
    public static void prepareCreateTransactionTest(){
       TaxProviderRequest taxRequest = taxProviderRequest();
       Map<String, String> callOutRequest = new Map<String, String>();
       Test.startTest();
       VertexTaxProvider vtax = new VertexTaxProvider();
       vtax.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
       Test.stopTest();
    }
     @isTest
    static void testprepareCreateTransactionIf(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        taxRequest.hasMultipleShipments = false;
        Map<String, String> callOutRequest = new Map<String, String>();
        VertexTaxProvider provider = new VertexTaxProvider();
        provider.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
        
    }
    @isTest
    static void testprepareCreateTransactionElse(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        taxRequest.taxableCartItems = null;
        Map<String, String> callOutRequest = new Map<String, String>();
        VertexTaxProvider provider = new VertexTaxProvider();
        provider.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
        
    }
     @isTest
    static void testgetTaxFromResponse(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        String strVertexResponseBody = jsonString();
        VertexTaxProvider avalaraTax = new VertexTaxProvider();
        Test.startTest();
        avalaraTax.getTaxFromResponse(strVertexResponseBody,taxRequest);
        Test.stopTest();
    }
    @isTest
    static void testprepareCommitTransaction(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        Map<String, String> callOutRequest = new Map<String, String>();
        VertexTaxProvider avalaraTax = new VertexTaxProvider();
        Test.startTest();
        avalaraTax.prepareCommitTransaction(taxRequest, callOutRequest);
        Test.stopTest();
    }
     private static TaxProviderRequest taxProviderRequest(){
        WebStore store =[SELECT Id FROM WebStore WHERE Name = 'Training' LIMIT 1];
        WebCart webCart = [SELECT Id FROM WebCart WHERE Name = 'Cart' LIMIT 1];
        CartItem webCartItem = [SELECT Id FROM CartItem WHERE CartId=:webCart.Id LIMIT 1];
        TaxProviderRequest taxRequest = new TaxProviderRequest();
        taxRequest.taxTransacionType = 'SalesInvoice';
        taxRequest.currencyCode = 'USD';
        taxRequest.cartId = webCart.id;
        taxRequest.hasMultipleShipments = true;
        taxRequest.street = '123 Main St';
        taxRequest.city = 'Anytown';
        taxRequest.state = 'CA';
        taxRequest.postalCode = '12345';
        taxRequest.country = 'US';
        taxRequest.taxMetaData = new TaxMetaData();
        taxRequest.taxMetaData.companyCode = 'ABC';
        taxRequest.taxMetaData.isCommit = false;
        taxRequest.taxMetaData.customerCode = '123';
        taxRequest.taxMetaData.useProductTaxCodes = true;
        taxRequest.taxMetaData.taxationPolicy = 'Abdg';
        taxRequest.taxMetaData.requestJSON = 'Abdg';
        taxRequest.taxMetaData.productTaxExemption = true;
        taxRequest.taxMetaData.customerTaxExemption = true;
        taxRequest.taxMetaData.shippingItemsTaxable =false;
        taxRequest.customerTaxId = '987';
        taxRequest.customerExemptionCode = 'EXEMPT';
        taxRequest.entityUseCode = 'USE';
        taxRequest.taxableCartItems = new Map<String, TaxableCartItem>();
        TaxableCartItem tcItem = new TaxableCartItem();
        tcItem.lineItemTexas = new List<LineItemTaxDetails>();
        tcItem.amount = 100.0;
        tcItem.sku = 'SKU123';
        tcItem.quantity = 10.0;
        tcItem.lineItemType = 'Product';
        tcItem.taxClassId = 'Taxable';
        tcItem.productExemptionCode = 'None';
        tcItem.entityUseCode = 'None';
        tcItem.street = '123 Main St';
        tcItem.city = 'Anytown';
        tcItem.state = 'CA';
        tcItem.postalCode = '12345';
        tcItem.country = 'US';
        taxRequest.taxableCartItems.put(tcItem.id, tcItem);
        
        return taxRequest;
    }
    private static String jsonString(){
        String json = '{' +
            '"data": {' +
            '    "currency_z": {' +
            '        "isoCurrencyCodeAlpha": "USD",' +
            '        "isoCurrencyCodeNum": 840,' +
            '        "isoCurrencyName": "US Dollar"' +
            '    },' +
            '    "customer": {' +
            '        "administrativeDestination": {' +
            '            "city": "New York",' +
            '            "country": "USA",' +
            '            "mainDivision": "NY",' +
            '            "postalCode": "10001",' +
            '            "streetAddress1": "123 5th Ave",' +
            '            "taxAreaId": "12345"' +
            '        },' +
            '        "customerCode": {' +
            '            "classCode": "A",' +
            '            "isBusinessIndicator": true,' +
            '            "value": "CUST123"' +
            '        },' +
            '        "destination": {' +
            '            "city": "New York",' +
            '            "country": "USA",' +
            '            "mainDivision": "NY",' +
            '            "postalCode": "10001",' +
            '            "streetAddress1": "123 5th Ave",' +
            '            "taxAreaId": "12345"' +
            '        },' +
            '        "isTaxExempt": false,' +
            '        "taxRegistrations": []' +
            '    },' +
            '    "documentDate": "2024-05-30",' +
            '    "documentNumber": "DOC123",' +
            '    "lineItems": [],' +
            '    "postingDate": "2024-05-30",' +
            '    "returnAssistedParametersIndicator": false,' +
            '    "roundAtLineLevel": true,' +
            '    "saleMessageType": "SALE",' +
            '    "seller": {' +
            '        "administrativeOrigin": {' +
            '            "city": "Los Angeles",' +
            '            "country": "USA",' +
            '            "mainDivision": "CA",' +
            '            "postalCode": "90001",' +
            '            "streetAddress1": "456 Main St",' +
            '            "taxAreaId": "54321"' +
            '        },' +
            '        "company": "Seller Co",' +
            '        "physicalOrigin": {' +
            '            "city": "Los Angeles",' +
            '            "country": "USA",' +
            '            "mainDivision": "CA",' +
            '            "postalCode": "90001",' +
            '            "streetAddress1": "456 Main St",' +
            '            "taxAreaId": "54321"' +
            '        },' +
            '        "taxRegistrations": []' +
            '    },' +
            '    "subTotal": 100.0,' +
            '    "taxPointDate": "2024-05-30",' +
            '    "total": 108.0,' +
            '    "totalTax": 8.0,' +
            '    "transactionId": "TRANS123",' +
            '    "transactionType": "SALE"' +
            '},' +
            '"meta": {' +
            '    "app": "VertexApp",' +
            '    "timeElapsed": 123,' +
            '    "timeReceived": "2024-05-30T12:34:56Z"' +
            '}' +
            '}';
        
        return json;
    }
   
   
    
}