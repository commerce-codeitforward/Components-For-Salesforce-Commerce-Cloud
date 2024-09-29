@IsTest
public class HTTPServiceTest {
    private static final String ENDPOINT = 'https://api.example.com/data';
    private static final String HTTP_METHOD = 'POST';
    private static final String SERVICE_MODE_LIVE = 'LIVE';
    private static final String SERVICE_MODE_MOCK = 'MOCK';
    private static final String SERVICE_REQUEST_BODY = '{"key":"value"}';
    private static final String MOCKED_RESPONSE_BODY = '{"status":"success"}';
    
    private static Map<String, String> generateRequestDetails(String mode, String endpoint, String method, String timeout, String body) {
        Map<String, String> requestDetails = new Map<String, String>();
        requestDetails.put(Constants.END_POINT, endpoint);
        requestDetails.put(Constants.HTTP_METHOD, method);
        requestDetails.put(Constants.SERVICE_TIMEOUT, timeout);
        requestDetails.put(Constants.SERVICE_MODE, mode);
        requestDetails.put(Constants.SERVICE_REQUEST_BODY, body);
        requestDetails.put(Constants.MOCKED_RESPONSE, MOCKED_RESPONSE_BODY);
        return requestDetails;
    }
  
    
    @IsTest
    static void testSetRequestHeaders() {
        HTTPService service = new HTTPService();
        HttpRequest req = new HttpRequest();
        Map<String, String> headers = new Map<String, String>();
        headers.put('Custom-Header', 'HeaderValue');
        
        service.setRequestHeaders(req, headers);
        
        System.assertEquals('HeaderValue', req.getHeader('Custom-Header'));
        System.assertEquals(Constants.HTTP_HEADER_CONTENT_TYPE_JSON, req.getHeader(Constants.HTTP_HEADER_CONTENT_TYPE));
    }
    
    @IsTest
    static void testMakeExternalCalloutLive() {
        Test.startTest();
        // Set up the HTTP Mock
        HttpMockResponseFactory mockFactory = new HttpMockResponseFactory();
        mockFactory.setStatusCode(200);
        mockFactory.setResponseBody('{"status":"success"}');
        // Register the mock response
        Test.setMock(HttpCalloutMock.class, mockFactory);
        
        HTTPService service = new HTTPService();
        Map<String, String> requestDetails = generateRequestDetails(SERVICE_MODE_LIVE, ENDPOINT, HTTP_METHOD, '3000', SERVICE_REQUEST_BODY);
        Map<String, String> headers = new Map<String, String>();
        
        Map<String, String> response = service.makeExternalCallout(requestDetails, headers);
        
        Test.stopTest();
        
        System.assertEquals(Constants.HTTP_RESPONSE_STATUS_SUCCESS, response.get(Constants.HTTP_RESPONSE_STATUS));
        System.assertEquals('200', response.get(Constants.RESPONSE_REASON_CODE));
    }
    
    @IsTest
    static void testMakeExternalCalloutMock() {
        Test.startTest();
        
        HTTPService service = new HTTPService();
        Map<String, String> calloutRequestDetails = new Map<String, String>{
            Constants.SERVICE_MODE => Constants.SERVICE_MODE_LIVE,
                Constants.SERVICE_REQUEST_BODY => '{"key": "value"}'
                };
                    Map<String, String> headers = new Map<String, String>();
        
        Map<String, String> response = service.makeExternalCallout(calloutRequestDetails, headers);
        
        Test.stopTest();
        
    }
       
    
    // Mock Response Factory
    private class HttpMockResponseFactory implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        public void setStatusCode(Integer code) {
            this.statusCode = code;
        }
        
        public void setResponseBody(String body) {
            this.responseBody = body;
        }
        
        public HTTPResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
}