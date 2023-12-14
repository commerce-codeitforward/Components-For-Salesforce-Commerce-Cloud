public with sharing class CyberSourceUtils {
    
    private static String apiUrl = '';
    private static String merchantId = '';
    private static String apiKey = '';
    private static String apiSecretKey = '';
    private static String userEmail = '';
    private static String origin = '';
    private static String captureContext = '';
    private static String dateString = '';
    private static String cardinalCommerceUrl = '';

    private static void setApiSettings() {
        Payment_Api_Variables__c pav = Payment_Api_Variables__c.getValues('Cybersource');
        apiUrl = pav.Api_Url__c;
        merchantId = pav.Api_Merchant_Id__c;
        apiKey = pav.Api_Key__c;
        apiSecretKey = pav.Api_Shared_Secret_Key__c;
        userEmail = UserInfo.getUserEmail();
        origin = pav.Api_Target_Origin__c;
		DateTime dt = DateTime.now();
		dateString = dt.format('E, dd MMM yyyy HH:mm:ss z', 'GMT');
        // cardinalCommerceUrl = pav.Cardinal_Commerce_Url__c;
    }

    @AuraEnabled
    public static String generateKey() {
        System.debug('Generating Key');
        setApiSettings();
        System.debug('API settings set');
        try {
            // String reqTarget = '/flex/v1/keys?format=JWT';
            // String reqBody = '{"encryptionType":"RsaOaep256", "targetOrigin":"' + origin + '"}';
            String reqTarget = '/microform/v2/sessions';
            String reqBody = '{"targetOrigins":["' + origin + '"], "allowedCardNetworks": ["VISA", "MASTERCARD"],"clientVersion": "v2.0"}';
            HttpRequest req = generatePostRequest(reqTarget, reqBody);
            Http http = new Http();
            System.debug('Request:'+req);
            HttpResponse res = http.send(req);
            System.debug('Response:'+res);
            // Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            // System.debug('Response Map:'+resMap);
            return res.getBody();
        } catch(Exception e) {
            return e.getMessage();
        }
    }

    
    private static HttpRequest generatePostRequest(String reqTarget, String reqBody) {
        HttpRequest req = generateRequestBase(reqTarget, 'POST');
        
        //POST requests
        String digestString = generateDigest(reqBody);
        String signatureString = generateSignature('post', reqTarget, digestString);
        
        req.setHeader('Digest', digestString);
        req.setHeader('Signature', signatureString);
        req.setBody(reqBody);
        
        return req;
    }

    private static HttpRequest generateRequestBase(String reqTarget, String reqMethod) {
        HttpRequest req = new HttpRequest();
        req.setMethod(reqMethod);
        req.setEndpoint('https://'+apiUrl+ reqTarget);
        
        req.setHeader('Host', apiUrl);
        req.setHeader('v-c-merchant-id', merchantId);
        req.setHeader('Content-Type', 'application/json');
        
        req.setHeader('Date', dateString);
        
        return req;
    }

    // --- HTTP Request Helper Methods ---
    private static String generateDigest(String reqBody) {
        Blob digestHash = Crypto.generateDigest('SHA-256', Blob.valueOf(reqBody)); 
        String digestString = 'SHA-256=' + EncodingUtil.base64Encode(digestHash);
        
        return digestString;
    }

    
    // --- Signature Helper Methods ---
    //
    //Method wrapping helper methods to create and return the string that will be set for the Signature header
    private static String generateSignature(String reqType, String reqTarget, String digestString) {  
        String signatureHeaders = generateSignatureHeaders(reqType, reqTarget, digestString);
        String signatureHash = generateSignatureHash(signatureHeaders);

        return generateSignatureString(reqType, signatureHash);
    }
    
    //Generates the (host date (request-target) digest v-c-merchant-id) string
    private static String generateSignatureHeaders(String reqType, String reqTarget, String digestString) {
        String headerFields = '';
        
        //Add host
        headerFields += ('host: ' + apiUrl + '\n');
        
        //Add date (for POST requests only)
        if(reqType == 'post') {
            headerFields += 'date: ' + dateString + '\n';
        }
        
        //Add (request-target)
        headerFields += ('(request-target): ' + reqType + ' ' + reqTarget + '\n');
        
        //Add digest (for POST requests only)
        if(reqType == 'post') {
            headerFields += ('digest: ' + digestString + '\n');
        } 
        
        //Add v-c-merchant-id
        headerFields += ('v-c-merchant-id: ' + merchantId);
        
        return headerFields;
    }
    
    //Creates a HmacSHA256 hash of the Signature Header/Value String
    private static String generateSignatureHash(String data) {        
        Blob hash = Crypto.generateMac('HmacSHA256', Blob.valueOf(data), EncodingUtil.base64Decode(apiSecretKey));

        return EncodingUtil.base64Encode(hash);
    }
    
    //Creates the value to be attached to the Signature on the POST request
    private static String generateSignatureString(String reqType, String signatureHash) {
        String signatureString = '';
        
        signatureString += 'keyid="' + apiKey + '", ';
        signatureString += 'algorithm="HmacSHA256", ';
        signatureString += 'headers="host';
            
        //Add in 'date' for POST requests (seems to break GET requests)
        if(reqType == 'post') {
            signatureString += ' date';
        }
        
        signatureString += ' (request-target)';

        //Add in 'digest' for POST requests        
        if(reqType == 'post') {
            signatureString += ' digest';
        }
        
        signatureString += ' v-c-merchant-id", ';
        signatureString += 'signature="' + signatureHash + '"';
        
        return signatureString;
    }    
    //
    // --- End of Signature Helper Methods ---

}