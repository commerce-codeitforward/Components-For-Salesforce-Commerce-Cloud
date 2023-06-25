public with sharing class CommerceCheckoutCallout {
    public static String createRequest(String restAPIURL, String method, String sessionId, String payload) {
        System.debug('##payload in createRequest: ' + payload );   
        HttpResponse response = sendRequest(restAPIURL, method, sessionId, payload);
        String responseString = '';

        if (response.getStatusCode() == 200 || response.getStatusCode() == 202 || response.getStatusCode() == 201) {  
            responseString = JSON.serialize( JSON.deserializeUntyped(response.getBody()) ); 
            responseString = response.getBody(); 
            System.debug('##response: ' + responseString );   
        } else {  
            throw new CommerceException(
                'Failed to update checkout: ' +
                response.getStatusCode() +
                ' ' +
                response.getStatus() +
                ' - ' +
                response.getBody()
            );
        } 

        return responseString;
    }
    
    public static HttpResponse sendRequest(String restAPIURL, String method, String sessionId, String payload) {
        String response = '';
        try {  
            HttpRequest httpRequest = new HttpRequest();  
            httpRequest.setMethod(method);   
            httpRequest.setHeader('Authorization', 'OAuth ' + sessionId);        
            httpRequest.setHeader('Authorization', 'Bearer ' + sessionId); 
            httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
            httpRequest.setEndpoint(restAPIURL);  
            if(method != 'GET'){
                httpRequest.setBody(payload);
            }

            return new Http().send(httpRequest);
        } catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            throw e;  
        }  
    }

    public class CommerceException extends Exception {
    }
}