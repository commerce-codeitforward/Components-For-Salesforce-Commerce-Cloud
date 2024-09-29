@isTest
public class VertexTaxRequestTest {

    @isTest
    static void testParse() {
        String json = '{"accumulationCustomerNumber": "12345",' +
            '"accumulationDocumentNumber": "98765",' +
            '"billingType": "Bill To Customer",' +
            '"companyCodeCurrency": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"currency_z": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"customer": {' +
            '"administrativeDestination": {' +
            '"city": "New York",' +
            '"country": "USA",' +
            '"currencyConversion": {' +
            '"currency_z": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"rate": 1.0' +
            '},' +
            '"externalJurisdictionCode": "EXT_JURIS_CODE",' +
            '"latitude": "40.7128",' +
            '"locationCode": "LOC_CODE_123",' +
            '"locationCustomsStatus": "CUSTOMS_STATUS_1",' +
            '"longitude": "-74.0060",' +
            '"mainDivision": "NY",' +
            '"postalCode": "10001",' +
            '"streetAddress1": "123 Main St",' +
            '"taxAreaId": "TAX_AREA_123"' +
            '},' +
            '"customerCode": {' +
            '"classCode": "A123",' +
            '"isBusinessIndicator": true,' +
            '"value": "C123"' +
            '},' +
            '"destination": {' +
            '"city": "Los Angeles",' +
            '"country": "USA",' +
            '"currencyConversion": {' +
            '"currency_z": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"rate": 1.0' +
            '},' +
            '"externalJurisdictionCode": "EXT_JURIS_CODE_2",' +
            '"latitude": "34.0522",' +
            '"locationCode": "LOC_CODE_456",' +
            '"locationCustomsStatus": "CUSTOMS_STATUS_2",' +
            '"longitude": "-118.2437",' +
            '"mainDivision": "CA",' +
            '"postalCode": "90001",' +
            '"streetAddress1": "456 Oak St",' +
            '"taxAreaId": "TAX_AREA_456"' +
            '},' +
            '"exemptionCertificate": {' +
            '"exemptionCertificateNumber": "EXEMPT_CERT_123",' +
            '"value": "CERT_1"' +
            '},' +
            '"exemptionReasonCode": "EXEMPT_REASON_CODE_1",' +
            '"isTaxExempt": false,' +
            '"taxRegistrations": []' +
            '},' +
            '"documentDate": "2024-05-30",' +
            '"documentNumber": "123456",' +
            '"lineItems": [],' +
            '"postingDate": "2024-05-30",' +
            '"saleMessageType": "Retail Sale",' +
            '"seller": {' +
            '"administrativeOrigin": {' +
            '"city": "San Francisco",' +
            '"country": "USA",' +
            '"currencyConversion": {' +
            '"currency_z": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"rate": 1.0' +
            '},' +
            '"externalJurisdictionCode": "EXT_JURIS_CODE_3",' +
            '"latitude": "37.7749",' +
            '"locationCode": "LOC_CODE_789",' +
            '"locationCustomsStatus": "CUSTOMS_STATUS_3",' +
            '"longitude": "-122.4194",' +
            '"mainDivision": "CA",' +
            '"postalCode": "94105",' +
            '"streetAddress1": "789 Pine St",' +
            '"taxAreaId": "TAX_AREA_789"' +
            '},' +
            '"company": "ABC Inc",' +
            '"department": "Finance",' +
            '"dispatcher": {' +
            '"dispatcherCode": {' +
            '"classCode": "D123",' +
            '"value": "DISPATCHER_1"' +
            '},' +
            '"taxRegistrations": []' +
            '},' +
            '"division": "Sales",' +
            '"nexusIndicator": true,' +
            '"nexusReasonCode": "REASON_CODE_1",' +
            '"physicalOrigin": {' +
            '"city": "Seattle",' +
            '"country": "USA",' +
            '"currencyConversion": {' +
            '"currency_z": {' +
            '"isoCurrencyCodeAlpha": "USD",' +
            '"isoCurrencyCodeNum": 840,' +
            '"isoCurrencyName": "United States Dollar"' +
            '},' +
            '"rate": 1.0' +
            '},' +
            '"externalJurisdictionCode": "EXT_JURIS_CODE_4",' +
            '"latitude": "47.6062",' +
            '"locationCode": "LOC_CODE_321",' +
            '"locationCustomsStatus": "CUSTOMS_STATUS_4",' +
            '"longitude": "-122.3321",' +
            '"mainDivision": "WA",' +
            '"postalCode": "98101",' +
            '"streetAddress1": "321 Elm St",' +
            '"taxAreaId": "TAX_AREA_321"' +
            '},' +
            '"taxRegistrations": [],' +
            '"utilityProvider": "XYZ Utility"' +
            '},' +
            '"paymentDate": "2024-06-01",' +
            '"postToJournal": true,' +
            '"proratePercentage": 50,' +
            '"returnAssistedParametersIndicator": true,' +
            '"returnGeneratedLineItemsIndicator": true,' +
            '"returnTimeElapsedDetailsIndicator": true,' +
            '"roundAtLineLevel": false,' +
            '"simplificationCode": "SIMP_CODE_1",' +
            '"situsOverride": {' +
            '"taxingLocation": "SITUS_LOC_1"' +
            '},' +
            '"taxOverride": {' +
            '"overrideReasonCode": "OVERRIDE_REASON_CODE_1",' +
            '"overrideType": "Amount"' +
            '},' +
            '"taxPointDate": "2024-05-30",' +
            '"transactionId": "T123",' +
            '"transactionType": "Sale"' +
            '}';

        VertexTaxRequest request = VertexTaxRequest.parse(json);

    }
}