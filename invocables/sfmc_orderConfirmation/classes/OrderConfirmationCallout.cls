/**
 * @description         : Invocable action built to fire an event to a Marketing Cloud Journey
 * @author              : Shane Smyth
 * @last modified on    : 3-21-2022
 */
global with sharing class OrderConfirmationCallout {
    @InvocableMethod(label='Add Contact to SFMC Journey' description='Add a contact to a Marketing Cloud Journey')
    global static void sendMessages(List<JourneyRequest> requests) {
        for (JourneyRequest request : requests) {
            createJourneyEntry(request);
        }
    }

    /**
     * @description sends a journey entry event from flow
     * @param request Pass a collection variable of contacts
     * @return Returns a status
     */
    public static void createJourneyEntry(JourneyRequest request){
        List<JourneyEntryPayload> payload = new List<JourneyEntryPayload>();
        JourneyEntryPayload message = createMessage(request);
        if (message != null) {
            payload.add(message);
        }
        
        if (payload.size() > 0) {
            SFMCService.postMessages(JSON.serialize(message));
        }
    }

    /**
     * @description gathers all the order items in the order 
     * @param OrderSummaryId The order summary that is being processed
     * @return Returns serialized order items json
     */
    private static string orderSummaryPayload(Id OrderSummaryId){
        List<JourneyOrderItemPayload> allOrderItems = new List<JourneyOrderItemPayload>();
        JourneyOrderItemsWrapper OrderItemsWrapper;

        // Gather up all order items and put them into a item payload for the json body, excluding the shipping charge product
        for(OrderItemSummary orderItems : [SELECT Id,Product2Id,Product2.Image__c,Product2.Name,Quantity,UnitPrice FROM OrderItemSummary WHERE OrderSummaryId =: OrderSummaryId  AND Product2.Name != 'Shipping Charge for this delivery method']){
            JourneyOrderItemPayload orderItemsPayload;
            orderItemsPayload = new JourneyOrderItemPayload();
            orderItemsPayload.OrderItemId = orderItems.Id;
            orderItemsPayload.OrderItemName = orderItems.Product2.Name;
            orderItemsPayload.OrderItemQuantity = orderItems.Quantity;
            orderItemsPayload.OrderItemAmount = orderItems.UnitPrice;
            orderItemsPayload.ProductUrl = orderItems.Product2.Image__c;

            allOrderItems.add(orderItemsPayload);
        }

        // wrap the order items in a array of objects 
        OrderItemsWrapper = new JourneyOrderItemsWrapper();
        OrderItemsWrapper.OrderItems = allOrderItems;

        System.debug('##orderSummaryPayload allOrderItems: '+allOrderItems);
        System.debug('##orderSummaryPayload OrderItems: '+OrderItemsWrapper);
        return JSON.serialize(OrderItemsWrapper);
    }

    /**
     * @description create the message body that will be used for the API call
     * @param request the request parameters from the flow invocation
     * @return Returns the full payload for the callout 
     */
    private static JourneyEntryPayload createMessage(JourneyRequest request) {
        JourneyEntryPayload payload;
        if (request.JourneyAPIEventKey != null) {
            JourneyDataPayload dataPayload;
            dataPayload = new JourneyDataPayload();
            dataPayload.Email = request.Email;
            dataPayload.OrderSummaryId = request.OrderSummaryId;
            dataPayload.SubscriberKey = request.SubscriberKey;
            dataPayload.First_Name = request.First_Name;
            dataPayload.Last_Name = request.Last_Name;
            dataPayload.OrderPayload = orderSummaryPayload(request.OrderSummaryId);

            payload = new JourneyEntryPayload();
            payload.ContactKey = request.SubscriberKey;
            payload.EventDefinitionKey = request.JourneyAPIEventKey;
            payload.Data = dataPayload;
        }
        System.debug('##OrderConfirmationCallout orderSummaryPayload: '+payload);
        return payload;
    }

    global class JourneyRequest{

        @InvocableVariable(required=true)
        public String JourneyAPIEventKey;

        @InvocableVariable(required=true)
        public String OrderSummaryId;

        @InvocableVariable(required=true)
        public String Email;

        @InvocableVariable(required=true)
        public String SubscriberKey;

        @InvocableVariable(required=true)
        public String First_Name;

        @InvocableVariable(required=true)
        public String Last_Name;

    }

    global class JourneyOrderItemsWrapper {
        public List<JourneyOrderItemPayload> OrderItems;
    }

    global class JourneyOrderItemPayload {
        public Id OrderItemId;
        public String OrderItemName;
        public Decimal OrderItemQuantity;
        public Decimal OrderItemAmount;
        public String ProductUrl;
    }

    global class JourneyEntryPayload {
        public Id ContactKey;
        public String EventDefinitionKey;
        public JourneyDataPayload Data;
    }

    global class JourneyDataPayload {
        public String Email;
        public Id OrderSummaryId;
        public String SubscriberKey;
        public String First_Name;
        public String Last_Name;
        public String OrderPayload;
    }
}