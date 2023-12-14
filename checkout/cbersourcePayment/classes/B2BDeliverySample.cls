// This must implement the sfdc_checkout.CartShippingCharges interface
// in order to be processed by the checkout flow for the "Shipping" integration
global with sharing class B2BDeliverySample implements sfdc_checkout.CartShippingCharges {
    global sfdc_checkout.IntegrationStatus startCartProcessAsync(sfdc_checkout.IntegrationInfo jobInfo, Id cartId){
        System.debug('B2BDeliverySample.startCartProcessAsync enter');
        sfdc_checkout.IntegrationStatus integStatus = new sfdc_checkout.IntegrationStatus();
        try {
            // We need to get the ID of the cart delivery group in order to create the order delivery groups.
            Id cartDeliveryGroupId = [SELECT CartDeliveryGroupId FROM CartItem WHERE CartId = :cartId WITH SECURITY_ENFORCED][0].CartDeliveryGroupId;

            // On re-entry of the checkout flow delete all previous CartDeliveryGroupMethods for the given cartDeliveryGroupId
            delete [SELECT Id FROM CartDeliveryGroupMethod WHERE CartDeliveryGroupId = :cartDeliveryGroupId WITH SECURITY_ENFORCED];
                        			
            List<OrderDeliveryMethod> orderDeliveryMethods = getOrderDeliveryMethods();
            System.debug('B2BDeliverySample OrderDeliveryMethods: ' + orderDeliveryMethods);
            // Create a CartDeliveryGroupMethod record for every shipping option returned
            List<CartDeliveryGroupMethod> cartDeliveryMethods = new List<CartDeliveryGroupMethod>();
            
            for (OrderDeliveryMethod orderDeliveryMethod: orderDeliveryMethods) {
                CartDeliveryGroupMethod cdgm = populateCartDeliveryGroupMethodWithShippingOptions(orderDeliveryMethod,
                                                                cartDeliveryGroupId,
                                                                cartId);
				cartDeliveryMethods.add(cdgm);
            }   
			insert cartDeliveryMethods;          
            // If everything works well, the charge is added to the cart and our integration has been successfully completed.
            integStatus.status = sfdc_checkout.IntegrationStatus.Status.SUCCESS;
        } catch(Exception e) {
            return integrationStatusFailedWithCartValidationOutputError( integStatus, 'An exception of type ' + e.getTypeName() + ' has occurred: ' + e.getMessage(), jobInfo, cartId);
        }
        System.debug('B2BDeliverySample.startCartProcessAsync exit:' + integStatus);
        return integStatus;
    }

    private CartDeliveryGroupMethod populateCartDeliveryGroupMethodWithShippingOptions(OrderDeliveryMethod odm,
                                                                  Id cartDeliveryGroupId,
                                                                  Id webCartId){
        CartDeliveryGroupMethod cartDeliveryGroupMethod = new CartDeliveryGroupMethod(
            CartDeliveryGroupId = cartDeliveryGroupId,
            DeliveryMethodId = odm.Id,
            ExternalProvider = odm.Carrier,
            Name = odm.Name,
            ShippingFee = 0.00,
            WebCartId = webCartId
        );
        return cartDeliveryGroupMethod;
    }

    private sfdc_checkout.IntegrationStatus integrationStatusFailedWithCartValidationOutputError(
        sfdc_checkout.IntegrationStatus integrationStatus, String errorMessage, sfdc_checkout.IntegrationInfo jobInfo, Id cartId) {
            integrationStatus.status = sfdc_checkout.IntegrationStatus.Status.FAILED;
            // In order for the error to be propagated to the user, we need to add a new CartValidationOutput record.
            CartValidationOutput cartValidationError = new CartValidationOutput(BackgroundOperationId = jobInfo.jobId, CartId = cartId, Level = 'Error', Message = errorMessage.left(255), Name = (String)cartId + ':' + jobInfo.jobId, RelatedEntityId = cartId, Type = 'Shipping');
            insert(cartValidationError);
            return integrationStatus;
    }

    private List<OrderDeliveryMethod> getOrderDeliveryMethods() {
        System.debug('enter getOrderDeliveryMethods');
        List<OrderDeliveryMethod> orderDeliveryMethods = [SELECT Id, Name, Carrier, ClassOfService, Description, ProductId FROM OrderDeliveryMethod WHERE IsActive = TRUE AND ProductId != ''];
		System.debug('exit getOrderDeliveryMethods: orderDeliveryMethods:' + orderDeliveryMethods);
		return orderDeliveryMethods;
	}
}