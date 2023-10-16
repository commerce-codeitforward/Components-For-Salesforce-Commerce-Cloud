/**
 * @description       : General Pre-authorization Payment Class
 * @author            : Code It Forward
 * @last modified on  : 09-29-2023
**/
public abstract without sharing class PreAuthorizeAlternativePayment {
    public PreAuthorizeAlternativePayment() {
    }

    /**
    * @description Method that create Alternative Payment Method record
    * @param billingContactPointAddressId Buyer Account billing contact point Address Id
    * @param cartId Id of the current cart
    * @param paymentType Payment Method, example: Check,Wire Transfer,etc.
    * @return string Id of the created Alternative Payment Method
    **/
    public static String createAlternativePaymentMethod(string country, string postalCode, string state, string city, string street, string cartId, string paymentType){
        AlternativePaymentMethod oneAlternativePaymentMethod = new AlternativePaymentMethod();

        oneAlternativePaymentMethod.AccountId = CommerceUtils.getUserAccountID();
        oneAlternativePaymentMethod.GatewayToken=paymentType+'-' +Integer.valueOf(Math.floor(1000 + Math.random() * 9000));
        oneAlternativePaymentMethod.PaymentMethodCity=city;
        oneAlternativePaymentMethod.PaymentMethodCountry=country;
        oneAlternativePaymentMethod.PaymentMethodPostalCode=postalCode;
        oneAlternativePaymentMethod.PaymentMethodState=state;
        oneAlternativePaymentMethod.PaymentMethodStreet=street;
        oneAlternativePaymentMethod.ProcessingMode='External';
        oneAlternativePaymentMethod.Status='Active';
        oneAlternativePaymentMethod.PaymentGatewayId=getPaymentMethodGateway(paymentType);
        insert oneAlternativePaymentMethod;
        return oneAlternativePaymentMethod.Id;
    }

    /**
    * @description Update cart record to assign the alternative payment method to paymentMethodId field
    * @param cartId Id of the current cart
    * @param APMId Alternative Payment Method to save as Cart PaymentMethodId
    **/
    public static void updateCartWithAPM (string cartId, string APMId){
        WebCart cartToUpdate = new WebCart(Id=cartId);
        cartToUpdate.PaymentMethodId=APMId;
        update cartToUpdate;
    }

    /**
     * @description Get the Payment Gateway for the Payment Method selected.
     * @param paymentMethod - Payment Method Selected.
     * @return Payment Gateway Id.
     */
    public static String getPaymentMethodGateway(String paymentMethod) {
        String paymentGatewayId;
        List<PaymentGateway> paymentGateways = [
                SELECT Id
                FROM PaymentGateway
                WHERE PaymentGatewayName = :paymentMethod
                LIMIT 1];

        if (!paymentGateways.isEmpty()) {
            paymentGatewayId = paymentGateways[0].Id;
        } else {
            System.debug('No Payment Gateway for Payment Method' + paymentMethod);
        }

        return paymentGatewayId;
    }

    /**
    * @description Get active payment Gateway
    * @param webStoreId Store Id
    * @return String Id of the payment Gateway
    **/
    public static String getPaymentGatewayId(String webStoreId) {
        String paymentGatewayId = null;
        try {
            paymentGatewayId = [SELECT Integration FROM StoreIntegratedService WHERE ServiceProviderType='Payment' AND StoreId=:webStoreId].Integration;
        } catch (Exception e) {
            System.debug('Error querying the payment integration from StoreIntegratedService: ' + e.getMessage());
        }
        return paymentGatewayId;
    }
}