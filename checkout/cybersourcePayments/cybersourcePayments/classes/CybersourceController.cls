public with sharing class CybersourceController {
    
    private static String AUTHORIZE_ENDPOINT = '/pts/v2/payments/';
    
    private static String apiUrl = '';
    private static String merchantId = '';
    private static String apiKey = '';
    private static String apiSecretKey = '';
    private static String userEmail = '';
    private static String origin = '';
    private static String captureContext = '';
    private static String dateString = '';
    private static String cardinalCommerceUrl = '';

    // This is currently pulling the State Names and ISO Codes from the State / Country Picklist
    // A better way to do this may be to use Custom Metadata
    @AuraEnabled
    public static List<State_Code__mdt> getStateOptions(){
        List<State_Code__mdt> stateCodes = [SELECT Id, State_Name__c, Abbreviation__c, Country_Code__r.Alpha2Code__c FROM State_Code__mdt ORDER BY State_Name__c];
        System.debug('statecodes: ' + stateCodes);
		return stateCodes;
    }

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
    }

    @AuraEnabled
    public static String generateKey() {
        System.debug('Generating Key');
        setApiSettings();
        System.debug('API settings set');
        try {
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

    // Currently the postAuth api in the LWC does not allow us to pass a large token or custom data to the Payment Adapter
    // We need to Authorize the card using the transient token from the Microform
    // We are not passing any credit card number or cvv numbers into this method
    @AuraEnabled
    public static Map<String,Object> authorizeCard(Map<String,Object> paymentsData){
        System.debug('CybersourceController.authorizeCard enter');
        System.debug('paymentsData: ' + paymentsData);
        if (paymentsData != null && !paymentsData.isEmpty()) {
            System.debug('*** REQUEST ***');
            for (String key : paymentsData.keySet()) {
                System.debug(key+': ' + paymentsData.get(key));
            }
        }

        setApiSettings();
        String target = AUTHORIZE_ENDPOINT;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://'+apiUrl+target);
        req.setMethod('POST');
        req.setBody(buildAuthRequestBody(paymentsData));
        setAuthorizationHeaders(req, target);
        
        Http http = new Http();
        HttpResponse response = null;
        Map<String,Object> body;
        try {
            System.debug('Request: ' + req.getBody());
            response = http.send(req);
        
            Integer sc = response.getStatusCode();
            if(sc == 201){
                System.debug('response: ' + response.getBody());
                body = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            } else {
                throw new CyberSourceAuthorizeException(response.getBody());
            }
        } catch (CalloutException ce) {
            throw new CyberSourceAuthorizeException(ce.getMessage(), ce);
        }
        return body;
    }

    private static HttpRequest generatePostRequest(String reqTarget, String reqBody) {
        HttpRequest req = generateRequestBase(reqTarget, 'POST');
        
        String digestString = generateDigest(reqBody);
        String signatureString = generateSignature('post', reqTarget, digestString);
        
        req.setHeader('Digest', digestString);
        req.setHeader('Signature', signatureString);
        req.setBody(reqBody);
        
        return req;
    }

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
    
    //Generates the (host date request-target digest v-c-merchant-id) string
    private static String generateSignatureHeaders(String reqType, String reqTarget, String digestString) {
        String headerFields = '';
        
        //Add host
        headerFields += ('host: ' + apiUrl + '\n');
        
        //Add date (for POST requests only)
        if(reqType == 'post') {
            headerFields += 'date: ' + dateString + '\n';
        }
        
        //Add request-target
        headerFields += ('request-target: ' + reqType + ' ' + reqTarget + '\n');
        
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
        
        signatureString += ' request-target';

        //Add in 'digest' for POST requests        
        if(reqType == 'post') {
            signatureString += ' digest';
        }
        
        signatureString += ' v-c-merchant-id", ';
        signatureString += 'signature="' + signatureHash + '"';
        
        return signatureString;
    }    

    private static String buildAuthRequestBody(Map<String,Object> paymentsData) {
        System.debug('buildAuthRequestBody enter');
        System.debug('paymentsData: ' + paymentsData);

        String currencyIsoCode = (String) paymentsData.get('currencyIsoCode');
        String addressString = (String) paymentsData.get('addressString');
        System.debug('addressString: ' + addressString);
        Map<String,Object> address = (Map<String,Object>) JSON.deserializeUntyped(addressString);
		JSONGenerator jsonGeneratorInstance = JSON.createGenerator(true);
		// Write data to the JSON string
		jsonGeneratorInstance.writeStartObject();
        jsonGeneratorInstance.writeFieldName('clientReferenceInformation');
            jsonGeneratorInstance.writeStartObject();
            jsonGeneratorInstance.writeStringField('code', generateGuid());
            jsonGeneratorInstance.writeEndObject();
        // if((Boolean) paymentsData.get('createToken')) {
        //     jsonGeneratorInstance.writeFieldName('processingInformation');
        //     jsonGeneratorInstance.writeStartObject();
        //     jsonGeneratorInstance.writeFieldName('actionList');
        //     jsonGeneratorInstance.writeStartArray();
        //     jsonGeneratorInstance.writeString('TOKEN_CREATE');
        //     jsonGeneratorInstance.writeEndArray();
        //     jsonGeneratorInstance.writeFieldName('actionTokenTypes');
        //     jsonGeneratorInstance.writeStartArray();
        //     jsonGeneratorInstance.writeString('instrumentIdentifier');
        //     jsonGeneratorInstance.writeEndArray();
        //     jsonGeneratorInstance.writeStringField('commerceIndicator', 'internet');
        //     jsonGeneratorInstance.writeEndObject();
        // }
		if(paymentsData.get('token') != null) {
            //process token auth
            jsonGeneratorInstance.writeFieldName('tokenInformation');
            jsonGeneratorInstance.writeStartObject();
            jsonGeneratorInstance.writeStringField('transientTokenJwt', (String) paymentsData.get('token'));
            jsonGeneratorInstance.writeEndObject();
        } else {
            throw new CyberSourceAuthorizeException('Required Field Missing : transientTokenJwt');
        }
        
        //orderInformation section
        jsonGeneratorInstance.writeFieldName('orderInformation');
        jsonGeneratorInstance.writeStartObject();
        jsonGeneratorInstance.writeFieldName('amountDetails');
        jsonGeneratorInstance.writeStartObject();
        // change amount if auth amount needs to reflect cart total
        jsonGeneratorInstance.writeStringField('totalAmount', String.ValueOf(0.0));
        jsonGeneratorInstance.writeStringField('currency', currencyIsoCode != null ? currencyIsoCode : 'USD');
        jsonGeneratorInstance.writeEndObject();
        
        //billTo section
        if (address != null) {
            jsonGeneratorInstance.writeFieldName('billTo');
            jsonGeneratorInstance.writeStartObject();
            jsonGeneratorInstance.writeStringField('firstName', (String) paymentsData.get('firstName'));
            jsonGeneratorInstance.writeStringField('lastName', (String) paymentsData.get('lastName'));
            jsonGeneratorInstance.writeStringField('address1', (String) address.get('street'));
            jsonGeneratorInstance.writeStringField('locality', (String) address.get('city')); 
            jsonGeneratorInstance.writeStringField('administrativeArea', (String) address.get('region')); 
            jsonGeneratorInstance.writeStringField('postalCode', (String) address.get('postalCode'));
            jsonGeneratorInstance.writeStringField('country', (String) address.get('country'));
            jsonGeneratorInstance.writeStringField('email', userEmail);
            jsonGeneratorInstance.writeEndObject();
        } else {
            throw new CyberSourceAuthorizeException('Required Field Missing : address');
        }
        jsonGeneratorInstance.writeEndObject();
		jsonGeneratorInstance.writeEndObject();

        System.debug('buildAuthRequestBody exit');
		return jsonGeneratorInstance.getAsString();
    }

    /**
	* Function to set authorization headers in a request
	* Use this to add authorization parameters required for the request
	*/
	private static void setAuthorizationHeaders(HttpRequest req, String target) {
        System.debug('setAuthorizationHeaders enter');
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('User-Agent', 'Mozilla/5.0');
		//TODO: fill these in
		req.setHeader('Host', apiUrl);
		
		DateTime dt = DateTime.now();
		String dateString = dt.format('E, dd MMM yyyy HH:mm:ss z', 'GMT');
		req.setHeader('Date', dateString);
		String digest = generateAuthorizationDigest(req);
		req.setHeader('Digest', digest);
		req.setHeader('v-c-merchant-id', merchantId);
		req.setHeader('Signature', 'keyid="'+apiKey+'", algorithm="HmacSHA256", headers="host date request-target digest v-c-merchant-id", signature="'+generateAuthorizationSignature(req, digest, dateString, target)+'"');
        System.debug('setAuthorizationHeaders exit');
    }

	private static String generateAuthorizationDigest(HttpRequest req) {
		Blob data = req.getBodyAsBlob();
		Blob hash = Crypto.generateDigest('SHA-256', data);
		String digest = EncodingUtil.base64Encode(hash);
		return 'SHA-256='+digest;
	}

	private static String generateAuthorizationSignature(HttpRequest req, String digest, String dateString, String target) {
		String headerFields = 'host: '+apiUrl+'\n';
		headerFields += 'date: '+dateString+'\n';
		headerFields += 'request-target: post '+target+'\n';
		headerFields += 'digest: '+digest+'\n';
		headerFields += 'v-c-merchant-id: '+merchantId;
		Blob sigBytes = Blob.valueOf(headerFields);
		Blob keyBytes = EncodingUtil.base64Decode(apiSecretKey);
		Blob hmac = Crypto.generateMac('hmacSHA256', sigBytes, keyBytes);
		return EncodingUtil.base64Encode(hmac);
	}

    private static String generateGuid() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

        return guid;
    }
 
    public class CyberSourceAuthorizeException extends Exception {

    }
}
