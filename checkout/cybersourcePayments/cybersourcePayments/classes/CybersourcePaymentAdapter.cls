global with sharing class CybersourcePaymentAdapter implements commercepayments.PaymentGatewayAdapter {
    // Salesforce Result Codes
    private static final commercepayments.SalesforceResultCodeInfo RC_SUCCESS = toCodeInfo(commercepayments.SalesforceResultCode.Success);
    private static final commercepayments.SalesforceResultCodeInfo RC_DECLINE = toCodeInfo(commercepayments.SalesforceResultCode.Decline);
    
    // Cybersource Response Codes
    private static final List<String> DECLINE_CODES = new List<String>{'AVS_FAILED','CONTACT_PROCESSOR','EXPIRED_CARD','PROCESSOR_DECLINED',
        'INSUFFICIENT_FUND','STOLEN_LOST_CARD','ISSUER_UNAVAILABLE','UNAUTHORIZED_CARD','CVN_NOT_MATCH','EXCEEDS_CREDIT_LIMIT','INVALID_CVN',
        'DECLINED_CHECK','BLACKLISTED_CUSTOMER','SUSPENDED_ACCOUNT','PAYMENT_REFUSED','CV_FAILED','INVALID_ACCOUNT','GENERAL_DECLINE',
        'INVALID_MERCHANT_CONFIGURATION','DECISION_PROFILE_REJECT','SCORE_EXCEEDS_THRESHOLD','PENDING_AUTHENTICATION','ACH_VERIFICATION_FAILED',
        'DECISION_PROFILE_REVIEW','CONSUMER_AUTHENTICATION_REQUIRED','CONSUMER_AUTHENTICATION_FAILED','MISSING_FIELD','INVALID_DATA',
        'DUPLICATE_REQUEST','INVALID_CARD','CARD_TYPE_NOT_ACCEPTED','INVALID_MERCHANT_CONFIGURATION','PROCESSOR_UNAVAILABLE','INVALID_AMOUNT',
        'INVALID_CARD_TYPE','INVALID_PAYMENT_ID','DEBIT_CARD_USEAGE_EXCEEDD_LIMIT'};
    
    // Cybersource Card Types
    // TODO: Move to Custom Meta Data so new card types can be added easier
    private static final Map<String, String> cardTypesMap = new Map<String, String>{
        '001' => 'VISA',
        '002' => 'Mastercard',
        '003' => 'American Express',
        '004' => 'Discover',
        '005' => 'Diners Club'
        };
    
    // TODO: Move to Custom Meta Data so new card types can be added easier
	private static final Map<String, String> cardCodesMap = new Map<String, String>{
        'VISA' => '001',
        'Mastercard' => '002',
        'American Express' => '003',
        'Discover' => '004',
        'Diners Club' => '005'
        };
        
	private static String apiUrl = '';
    private static String merchantId = '';
    private static String apiKey = '';
    private static String apiSecretKey = '';
    private static String userEmail = '';
    private static String origin = '';
    private static String captureContext = '';
    private static String dateString = '';

    private static String TRANSACTION_ENDPOINT = '/tss/v2/transactions/';
    
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
    
    public CybersourcePaymentAdapter() {

    }

    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        System.debug('CybersourcePaymentAdapter.processRequest entry');  	
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        System.debug('requestType: ' + requestType);
        commercepayments.PaymentGatewayRequest paymentRequest = gatewayContext.getPaymentRequest();
        commercepayments.GatewayResponse response;
        
        try {
            if (requestType == commercepayments.RequestType.PostAuth) {
                system.debug('PostAuth PaymentGatewayRequest:' + paymentRequest);
                response = createPostAuthResponse( (commercepayments.PostAuthorizationRequest) paymentRequest);
            }
            return response;
        } catch (CyberSourceValidationException e) {
             return new commercepayments.GatewayErrorResponse('400', e.getMessage());
        }
    }

    // postAuth is used to process an authorization that was created on the Client Side.
    // to create the necessary Payment records and associate them with the Order we need to retrieve
    // the Authorization info from Cybersource using the Request Transaction Id then populate and return
    // a commercepayments.PostAuthorizationResponse object. The platform will do the rest of the heavy lifting. 
    private commercepayments.GatewayResponse createPostAuthResponse(commercepayments.PostAuthorizationRequest postAuthRequest) {
        System.debug('createPostAuthResponse entry');
        commercepayments.PostAuthApiPaymentMethodRequest apiPaymentMethod =(commercepayments.PostAuthApiPaymentMethodRequest) postAuthRequest.paymentMethod;
        commercepayments.AlternativePaymentMethodRequest altPaymentMethod= (commercepayments.AlternativePaymentMethodRequest) apiPaymentMethod.alternativePaymentMethod;
        // LWC passes in the Cybersource RequestId as the gatewayToken
        String gatewayToken = (String) altPaymentMethod.gatewayToken;
        System.debug('gatewayToken:' + gatewayToken);
        // get the settings needed for the callout
        setApiSettings();
        commercepayments.PostAuthorizationResponse postAuthResponse = new commercepayments.PostAuthorizationResponse();
        
        String target = TRANSACTION_ENDPOINT + gatewayToken;
        HttpRequest req = new HttpRequest();
		req.setMethod('GET');
        setTransactionHeaders(req, target);
        req.setEndpoint( target);
        commercepayments.PaymentsHttp http = new commercepayments.PaymentsHttp();
        HttpResponse response = null;
        try {
            response = http.send(req);
            system.debug('http response: ' + response);
            Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            for (String key : results.keySet()) {
                System.debug(key + ': ' + results.get(key));
            }
            
            // populate the commercepayments.PostAuthorizationResponse
            String intentStatus = (String)results.get('status');
            Integer sc = response.getStatusCode();
            if(sc == 200){
                postAuthResponse.setGatewayAuthCode(gatewayToken);
                postAuthResponse.setGatewayResultCode('success');
                postAuthResponse.setSalesforceResultCodeInfo(RC_SUCCESS);
                postAuthResponse.setAmount(postAuthRequest.amount);
                postAuthResponse.setGatewayDate(system.now());
            } else {
                return new commercepayments.GatewayErrorResponse('500', response.getBody());
            }
        } catch(CalloutException ce) {
            return new commercepayments.GatewayErrorResponse('500', ce.getMessage());
        }

        System.debug('postAuthResponse exit: ' + postAuthResponse);
        return postAuthResponse;
    }
    
    private static commercepayments.SalesforceResultCodeInfo toCodeInfo(commercepayments.SalesforceResultCode code) {
        return new commercepayments.SalesforceResultCodeInfo(code);
    }
    
    private static void setTransactionHeaders(HttpRequest req, String target) {
		req.setHeader('Content-Type', 'application/json');
        req.setHeader('Host', apiUrl);
		req.setHeader('User-Agent', 'Mozilla/5.0');
		req.setHeader('Host', apiUrl);
		DateTime dt = DateTime.now();
		String dateString = dt.format('E, dd MMM yyyy HH:mm:ss z', 'GMT');
		req.setHeader('Date', dateString);
		
		req.setHeader('v-c-merchant-id', merchantId);
		req.setHeader('Signature', 'keyid="'+apiKey+'", algorithm="HmacSHA256", headers="host request-target v-c-merchant-id", signature="'+ generateTransactionSignature(req, target)+'"');
	}

	private static String generateTransactionSignature(HttpRequest req, String target) {
		String headerFields = 'host: '+ apiUrl + '\n';
		headerFields += 'request-target: get ' + target + '\n';
		headerFields += 'v-c-merchant-id: ' + merchantId;
		Blob sigBytes = Blob.valueOf(headerFields);
		Blob keyBytes = EncodingUtil.base64Decode(apiSecretKey);
		Blob hmac = Crypto.generateMac('hmacSHA256', sigBytes, keyBytes);
		return EncodingUtil.base64Encode(hmac);
	}
    
    public class CyberSourceValidationException extends Exception {

    }
}