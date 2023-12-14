    global with sharing class B2BCreditCardAdapter implements commercepayments.PaymentGatewayAdapter {
    // commercepayments.ClientSidePaymentAdapter
    
    private static final commercepayments.SalesforceResultCodeInfo RC_SUCCESS = toCodeInfo(commercepayments.SalesforceResultCode.Success);
    private static final commercepayments.SalesforceResultCodeInfo RC_DECLINE = toCodeInfo(commercepayments.SalesforceResultCode.Decline);
    private static final List<String> DECLINE_CODES = new List<String>{'AVS_FAILED','CONTACT_PROCESSOR','EXPIRED_CARD','PROCESSOR_DECLINED',
        'INSUFFICIENT_FUND','STOLEN_LOST_CARD','ISSUER_UNAVAILABLE','UNAUTHORIZED_CARD','CVN_NOT_MATCH','EXCEEDS_CREDIT_LIMIT','INVALID_CVN',
        'DECLINED_CHECK','BLACKLISTED_CUSTOMER','SUSPENDED_ACCOUNT','PAYMENT_REFUSED','CV_FAILED','INVALID_ACCOUNT','GENERAL_DECLINE',
        'INVALID_MERCHANT_CONFIGURATION','DECISION_PROFILE_REJECT','SCORE_EXCEEDS_THRESHOLD','PENDING_AUTHENTICATION','ACH_VERIFICATION_FAILED',
        'DECISION_PROFILE_REVIEW','CONSUMER_AUTHENTICATION_REQUIRED','CONSUMER_AUTHENTICATION_FAILED','MISSING_FIELD','INVALID_DATA',
        'DUPLICATE_REQUEST','INVALID_CARD','CARD_TYPE_NOT_ACCEPTED','INVALID_MERCHANT_CONFIGURATION','PROCESSOR_UNAVAILABLE','INVALID_AMOUNT',
        'INVALID_CARD_TYPE','INVALID_PAYMENT_ID','DEBIT_CARD_USEAGE_EXCEEDD_LIMIT'};
            
    private static final Map<String, String> cardTypesMap = new Map<String, String>{
        '001' => 'VISA',
        '002' => 'Mastercard',
        '003' => 'American Express',
        '004' => 'Discover',
        '005' => 'Diners Club'
        };
        
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

    private static String AUTHORIZE_ENDPOINT = '/pts/v2/payments/';
    private static String TRANSACTION_ENDPOINT = '/tss/v2/transactions/';
    private static String NAMEDCREDENTIAL = 'Cybersource_Legacy';
    
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

    public static String captureRequest = '';
    public static String captureResponse = '';
    public static Integer captureResponseStatusCode = 0;
    

    global B2BCreditCardAdapter() {

    }

    global String getClientComponentName() {
        return 'c/cybersourceCreditCard';
    }

    global Map<String,String> getClientConfiguration() {
        return new Map<String,String>();
    }

    
    // Method called by the commercePayment process to direct the correct action
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        System.debug('B2BPaymentAdapter.processRequest entry');  	
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        System.debug('requestType: ' + requestType);
        commercepayments.PaymentGatewayRequest paymentRequest = gatewayContext.getPaymentRequest();
        commercepayments.GatewayResponse response;
        
        try {
            if (requestType == commercepayments.RequestType.PostAuth) {
                system.debug('PostAuth PaymentGatewayRequest:' + paymentRequest);
                response = createPostAuthResponse((commercepayments.PostAuthorizationRequest)paymentRequest);
            }
            return response;
        } catch (B2BCyberSourceValidationException e) {
             return new commercepayments.GatewayErrorResponse('400', e.getMessage());
        }
    }

    // postAuth is used to process an authorization that was created on the Cliend Side.
    // to create the necessary Payment records and associate them with the Order we need to retrieve
    // the Authorization info from Cybersource using the Request Transaction Id then populate and return
    // a commercepayments.PostAuthorizationResponse object. The platform will do the rest of the heavy lifting. 
    public commercepayments.GatewayResponse createPostAuthResponse(commercepayments.PostAuthorizationRequest postAuthRequest) {
        System.debug('createPostAuthResponse entry');

        commercepayments.PostAuthApiPaymentMethodRequest apiPaymentMethod =(commercepayments.PostAuthApiPaymentMethodRequest) postAuthRequest.paymentMethod;
        commercepayments.AlternativePaymentMethodRequest altPaymentMethod= (commercepayments.AlternativePaymentMethodRequest) apiPaymentMethod.alternativePaymentMethod;
        String gatewayToken = (String)altPaymentMethod.gatewayToken;
        System.debug('gatewayToken:' + gatewayToken);
                        
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
            
            postAuthResponse.setGatewayAuthCode(gatewayToken);
            postAuthResponse.setGatewayResultCode('success');
            postAuthResponse.setSalesforceResultCodeInfo(RC_SUCCESS);
            postAuthResponse.setAmount(postAuthRequest.amount);
            postAuthResponse.setGatewayDate(system.now());

        } catch(CalloutException ce) {
            return new commercepayments.GatewayErrorResponse('500', ce.getMessage());
        }
        System.debug('postAuthResponse exit: ' + postAuthResponse);
        return postAuthResponse;
    }
    
    private static commercepayments.SalesforceResultCodeInfo toCodeInfo(commercepayments.SalesforceResultCode code) {
        return new commercepayments.SalesforceResultCodeInfo(code);
    }
    
    /**
	* Function to set authorization headers in a request
	* Use this to add authorization parameters required for the request
	*/
	private static void setAuthorizationHeaders(HttpRequest req, String target) {
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('User-Agent', 'Mozilla/5.0');
		req.setHeader('Host', apiUrl);
		DateTime dt = DateTime.now();
		String dateString = dt.format('E, dd MMM yyyy HH:mm:ss z', 'GMT');
		req.setHeader('Date', dateString);
		String digest = generateAuthorizationDigest(req);
		req.setHeader('Digest', digest);
		req.setHeader('v-c-merchant-id', merchantId);
		req.setHeader('Signature', 'keyid="'+apiKey+'", algorithm="HmacSHA256", headers="host date (request-target) digest v-c-merchant-id", signature="'+generateAuthorizationSignature(req, digest, dateString, target)+'"');
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
		headerFields += '(request-target): post '+target+'\n';
		headerFields += 'digest: '+digest+'\n';
		headerFields += 'v-c-merchant-id: '+merchantId;
		Blob sigBytes = Blob.valueOf(headerFields);
		Blob keyBytes = EncodingUtil.base64Decode(apiSecretKey);
		Blob hmac = Crypto.generateMac('hmacSHA256', sigBytes, keyBytes);
		return EncodingUtil.base64Encode(hmac);
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
    
	private static String buildAuthRequestBody(commercepayments.AuthorizationRequest authRequest, Boolean createToken) {
        String currencyIsoCode = authRequest.currencyIsoCode;
        String[] cardholderName = authRequest.additionalData.get('cardholderName').split('\\|\\|');
		JSONGenerator jsonGeneratorInstance = JSON.createGenerator(true);
		// Write data to the JSON string
		jsonGeneratorInstance.writeStartObject();
        jsonGeneratorInstance.writeFieldName('clientReferenceInformation');
            jsonGeneratorInstance.writeStartObject();
            jsonGeneratorInstance.writeStringField('code', generateGuid());
            jsonGeneratorInstance.writeEndObject();
        if(createToken) {
            jsonGeneratorInstance.writeFieldName('processingInformation');
            jsonGeneratorInstance.writeStartObject();
            jsonGeneratorInstance.writeFieldName('actionList');
            jsonGeneratorInstance.writeStartArray();
            jsonGeneratorInstance.writeString('TOKEN_CREATE');
            jsonGeneratorInstance.writeEndArray();
            jsonGeneratorInstance.writeFieldName('actionTokenTypes');
            jsonGeneratorInstance.writeStartArray();
            jsonGeneratorInstance.writeString('instrumentIdentifier');
            jsonGeneratorInstance.writeEndArray();
            jsonGeneratorInstance.writeStringField('commerceIndicator', 'internet');
            jsonGeneratorInstance.writeEndObject();
        }
		if(authRequest.additionalData != null) {
			if(authRequest.additionalData.get('token1') != null) {
				//process token auth
                jsonGeneratorInstance.writeFieldName('tokenInformation');
                jsonGeneratorInstance.writeStartObject();
                jsonGeneratorInstance.writeStringField('transientTokenJwt', authRequest.additionalData.get('token1')+authRequest.additionalData.get('token2'));
                jsonGeneratorInstance.writeEndObject();
			} else {
				throw new B2BCyberSourceValidationException('Required Field Missing : transientTokenJwt');
			}
        } else {
            throw new B2BCyberSourceValidationException('Required Field Missing : additionalInfo');
        }
        
        //orderInformation section
        jsonGeneratorInstance.writeFieldName('orderInformation');
        jsonGeneratorInstance.writeStartObject();
        jsonGeneratorInstance.writeFieldName('amountDetails');
        jsonGeneratorInstance.writeStartObject();
        if(authRequest.amount != null) {
            jsonGeneratorInstance.writeStringField('totalAmount', String.ValueOf(authRequest.amount));
        }
        jsonGeneratorInstance.writeStringField('currency', currencyIsoCode);
        jsonGeneratorInstance.writeEndObject();
        
        //billTo section
        if (authRequest.paymentMethod != null) {
            if (authRequest.paymentMethod.address != null) {
                jsonGeneratorInstance.writeFieldName('billTo');
                jsonGeneratorInstance.writeStartObject();
                jsonGeneratorInstance.writeStringField('firstName', cardholderName[0]);
                jsonGeneratorInstance.writeStringField('lastName', cardholderName[1]);
                jsonGeneratorInstance.writeStringField('address1', authRequest.paymentMethod.address.street);
                jsonGeneratorInstance.writeStringField('locality', authRequest.paymentMethod.address.city); 
                jsonGeneratorInstance.writeStringField('administrativeArea', authRequest.paymentMethod.address.state); 
                jsonGeneratorInstance.writeStringField('postalCode', authRequest.paymentMethod.address.postalCode);
                jsonGeneratorInstance.writeStringField('country', authRequest.paymentMethod.address.country);
                jsonGeneratorInstance.writeStringField('email', userEmail);
                jsonGeneratorInstance.writeEndObject();
            } else {
                throw new B2BCyberSourceValidationException('Required Field Missing : address');
            }
                jsonGeneratorInstance.writeEndObject();
		} else {
			throw new B2BCyberSourceValidationException('Required Field Missing : paymentMethod');
		}
		jsonGeneratorInstance.writeEndObject();
		return jsonGeneratorInstance.getAsString();
	}
    
    private static String generateGuid() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

        return guid;
    }
    
    public class B2BCyberSourceValidationException extends Exception {

    }
}