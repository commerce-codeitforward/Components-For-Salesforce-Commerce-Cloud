public with sharing class CommerceCheckout {
    @AuraEnabled(cacheable=true)
    public static string getSessionId() {
        return UserInfo.getSessionId();
    }

    @AuraEnabled(cacheable=true)
    public static string getCommerceCheckout(String communityId) {
        System.debug('##communityId in get: '+communityId);
        //Make sure your Salesforce instance URL is added in remote site settings
        String webStoreId = CommerceUtils.resolveCommunityIdToWebstoreId(communityId);
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL+'/services/data/v54.0/commerce/webstores/'+webStoreId+'/checkouts/active';  
        //String restAPIURL = 'https://sf-mojo--uat.sandbox.my.salesforce.com/services/data/v54.0/commerce/webstores/'+webStoreId+'/checkouts/active';  
        String method = 'GET';
        String payload = '';
        
        String response = CommerceCheckoutCallout.createRequest(restAPIURL, method, getSessionId(), payload);

        return response;
    }

    @AuraEnabled(cacheable=true)
    public static string updateCommerceCheckout(String communityId, String payload) {
        System.debug('##updateCommerceCheckout payload: '+payload);
        CommerceRequest payloadCommerceRequest = (CommerceRequest)JSON.deserialize(payload,CommerceRequest.class);
        System.debug('##payloadCommerceRequest: '+payloadCommerceRequest);
        CommercePayload message;
        String jsonPayload = '';
        if (payloadCommerceRequest.shippingInstructions != null) {
            message = new CommercePayload();
            message.shippingInstructions = payloadCommerceRequest.shippingInstructions;
            jsonPayload = JSON.serialize(message);
        }
        String webStoreId = CommerceUtils.resolveCommunityIdToWebstoreId(communityId);
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL+'/services/data/v54.0/commerce/webstores/'+webStoreId+'/checkouts/active';  
        String method = 'PATCH';

        String response = CommerceCheckoutCallout.createRequest(restAPIURL, method, getSessionId(), jsonPayload);

        return response;
    }

    @AuraEnabled(cacheable=true)
    public static string updateCommerceDeliveryMethodCheckout(String communityId, String payload) {
        System.debug('##updateCommerceDeliveryMethodCheckout payload: '+payload);
        CommerceDeliveryMethodRequest payloadCommerceRequest = (CommerceDeliveryMethodRequest)JSON.deserialize(payload,CommerceDeliveryMethodRequest.class);
        System.debug('##payloadCommerceRequest: '+payloadCommerceRequest);
        CommerceDeliveryMethodPayload message;
        if (payloadCommerceRequest.deliveryMethodId != null) {
            message = new CommerceDeliveryMethodPayload();
            message.deliveryMethodId = payloadCommerceRequest.deliveryMethodId;
        }

        String webStoreId = CommerceUtils.resolveCommunityIdToWebstoreId(communityId);
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL+'/services/data/v54.0/commerce/webstores/'+webStoreId+'/checkouts/active';  
        String method = 'PATCH';

        String response = CommerceCheckoutCallout.createRequest(restAPIURL, method, getSessionId(), payload);

        return response;
    }

    public class CommercePayload {
        @AuraEnabled
        public String desiredDeliveryDate;

        @AuraEnabled
        public String shippingInstructions;
    }

    public class CommerceRequest {
        @AuraEnabled
        public String desiredDeliveryDate;

        @AuraEnabled
        public String shippingInstructions;
    }

    public class CommerceDeliveryMethodPayload {
        @AuraEnabled
        public String deliveryMethodId;
    }

    public class CommerceDeliveryMethodRequest {
        @AuraEnabled
        public String deliveryMethodId;
    }
}