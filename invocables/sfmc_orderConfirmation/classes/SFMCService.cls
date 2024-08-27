public class SFMCService {
    @future(callout = true)
    public static void postMessages(String messagesJson) {
        System.debug('##postMessages messagesJson: '+messagesJson);
        HttpResponse response = sendRequest(messagesJson);

        if (response.getStatusCode() != 201) {
            throw new SFMCException(
                'Failed to post messages to SFMC: HTTP' +
                response.getStatusCode() +
                ' ' +
                response.getStatus() +
                ' - ' +
                response.getBody()
            );
        }
    }

    /**
     * @description gets the access token from the /v2/token endpoint
     * @return Returns the full authentication payload from response
     */
    private static String getToken(){

        // IN PRODUCTION THIS AREAS SHOULD BE PULLED OUT INTO NAMED CREDENTIALS AND MORE SECURE METHODS
        authBody body;
        body = new authBody();
        body.grant_type = 'client_credentials';
        body.client_id = 'XXX';
        body.client_secret = 'XXX';
        body.account_id = '534000355';

        String bodyJSON = JSON.serialize(body);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Marketing_Cloud/v2/token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(bodyJSON);

        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();

        return responseBody;
    }

    /**
     * @description make the actual api call to the /interaction/v1/events endpoint
     * @param body The json body that will be send with the request
     * @return Returns the response from the request
     */
    private static HttpResponse sendRequest(String body) {
        // call the getToken method to get the access token
        String authBody = getToken();

        // pull out the access token from the response
        Map<String, String> m = (Map<String, String>) JSON.deserialize(authBody, Map<String, String>.class);
        String token = m.get('access_token');
        System.debug('##sendRequest token: '+token);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://XXXX.rest.marketingcloudapis.com/interaction/v1/events');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer '+token);
        request.setBody(body);

        return new Http().send(request);
    }

    public class SFMCException extends Exception {
    }

    public class authBody{
        public String grant_type;
        public String client_id;
        public String client_secret;
        public String account_id;
    }
}