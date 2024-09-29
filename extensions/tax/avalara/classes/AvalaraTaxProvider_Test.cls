@isTest
public class AvalaraTaxProvider_Test {
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
    static void testprepareCreateTransaction(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        Map<String, String> callOutRequest = new Map<String, String>();
        AvalaraTaxProvider provider = new AvalaraTaxProvider();
        provider.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
        
    }
     @isTest
    static void testprepareCreateTransactionIf(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        taxRequest.hasMultipleShipments = false;
        Map<String, String> callOutRequest = new Map<String, String>();
        AvalaraTaxProvider provider = new AvalaraTaxProvider();
        provider.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
        
    }
      @isTest
    static void testprepareCreateTransactionElse(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        taxRequest.taxableCartItems = null;
        Map<String, String> callOutRequest = new Map<String, String>();
        AvalaraTaxProvider provider = new AvalaraTaxProvider();
        provider.prepareCreateTransaction(taxRequest, callOutRequest);
        String expectedRequestBody = '{"type":"SalesInvoice","currencyCode":"USD","commit":false,"companyCode":"ABC","customerCode":"123","businessIdentificationNo":"987","exemptionNo":"EXEMPT","entityUseCode":"USE","date":"2023-03-15","lines":[{"number":"1","itemCode":"SKU123","amount":100,"taxIncluded":false}]}';
        System.assertNotEquals(expectedRequestBody, callOutRequest.get(Constants.SERVICE_REQUEST_BODY));
        
    }
     @isTest
    static void testgetTaxFromResponse(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        String strAvalaraResponseBody = jsonString();
        AvalaraTaxProvider avalaraTax = new AvalaraTaxProvider();
        Test.startTest();
        TaxProviderResponse response = avalaraTax.getTaxFromResponse(strAvalaraResponseBody,taxRequest);
        System.assert(response!= null);
        Test.stopTest();
    }
    @isTest
    static void testprepareCommitTransaction(){
        TaxProviderRequest taxRequest = taxProviderRequest();
        Map<String, String> callOutRequest = new Map<String, String>();
        AvalaraTaxProvider avalaraTax = new AvalaraTaxProvider();
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
     String json = '{"id":"123","taxing": "2024-05-29","taxDate": "2024-05-29","modifiedUserId": "User1","modifiedDate": "2024-05-29T12:00:00Z","email": "test@example.com","description": "Transaction Description","exchangeRate": 1.1,"exchangeRateEffectiveDate": "2024-05-28","version": "1.0","locked": false,"adjustmentReason": "None","totalTaxCalculated": 75.00,"totalTaxable": 850.00,"totalDiscount": 50.00,"totalExempt": 100.00,"salespersonCode": "SP1","referenceCode": "REF123","purchaseOrderNo": "PO123","reportingLocationCode": "RLOC1","locationCode": "LOC1","reconciled": true,"exemptNo": "EX123","customerCode": "CUST1","customerVendorCode": "CVC1","entityUseCode": "EUC1","customerUsageType": "UT1","exchangeRateCurrencyCode": "EUR","currencyCode": "USD","batchCode": "BATCH1","code":"ABC","companyId":12345,"date":"2023-03-15","paymentDate": "2024-06-01","status":"Completed","type":"SalesInvoice","totalAmount":100.0,"totalTax":7.5,"lines":[{"id":"123-1","transactionId":"123","customerUsageType": "UT1","entityUseCode": "EUC1","discountAmount": 10.00,"exemptCertId": "EC123","exemptAmount": 5.00,"exemptNo": "EX123","isItemTaxable": true,"quantity": 2.0,"ref1": "Ref1","ref2": "Ref2","taxIncluded": false,"nonPassthroughDetails": [{"Id": "HS1"}],"hsCode": "HS1","costInsuranceFreight": 10.00,"vatCode": "VAT1","vatNumberTypeId": "VN1","originAddressId": "OA1","destinationAddressId": "DA1","destination": "DA1","reportingDate": "2024-05-29","taxCalculated": 37.50,"lineNumber":"abc","itemCode":"ITEM123","description":"Test Item","lineAmount":100.0,"tax":7.5,"taxableAmount":100.0,"taxCode":"PC040000","taxCodeId":"123456","taxDate":"2023-03-15","details":[{"id":"123-1-1","transactionLineId":"123-1","transactionId":"123","addressId":"123","country":"US","region":"WA","stateFIPS":"53","exemptAmount":0.0, "exemptReasonId": "EC123","jurisCode": "EC123","inState": true,"jurisName": "EC123","signatureCode": "signatureCode","signCode": "jurisdictionId","jurisdictionId": "jurisdiction","stateAssignedNo": "stateAssigned","jurisType": "juris","nonTaxableRuleId": "nonTaxableRule","nonTaxableType": "nonTaxableType", "nonTaxableAmount":0.0,"taxableAmount":100.0,"rate":7.5,"tax":7.5,"taxCalculated":7.5,"rateRuleId": "rateRule","rateSourceId": "rateSource","serCode": "sCode","sourcing": "sourcing","taxOverride": "taxOver","taxType":"SalesTax","taxName":"Washington State Tax","taxAuthorityTypeId":1,"taxRegionId":"123456","taxSubTypeId":"S","rateType":"General","taxableUnits":100.0,"nonTaxableUnits":0.0,"exemptUnits":0.0,"reportingTaxableUnits":100.0,"reportingNonTaxableUnits":0.0,"reportingExemptUnits":0.0,"reportingTax":7.5,"reportingTaxCalculated":7.5,"jurisdictionType":"State","taxSubTypeId":"S","rateTypeCode":"G","unitOfBasis":"Each","isNonPassThru":false,"isFee":false,"liabilityType":"Seller","chargedTo":"Customer"}]}],"addresses":[{"id":"123","transactionId":"123","boundaryLevel":"Exact","line1":"123 Main St","line2": "Apt 4", "line3": "2","line": "", "city":"Anytown","region":"WA","postalCode":"12345","country":"US","taxRegionId":"123456","latitude":"47.123456","longitude":"-122.123456"}],"summary":[{"country":"US","region":"WA","jurisType":"State","jurisCode":"53","jurisName":"Washington","taxAuthorityType":"State","stateAssignedNo":"WA","taxType":"SalesTax","taxSubType":"S","taxName":"Washington State Tax","rateType":"General","taxable":100.0,"rate":0.075,"tax":7.5,"taxCalculated":7.5,"nonTaxable":0.0,"exemption":0.0,"exempt":0.0}],"taxDetailsByTaxType":[{"taxType":"SalesTax","tax":"Sales","totalTaxable":100.0,"totalExempt":0.0,"totalNonTaxable":0.0,"totalTax":7.5}]}';
             
        return json;
    }
    
}