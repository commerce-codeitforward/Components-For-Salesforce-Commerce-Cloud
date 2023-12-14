/**
 * @description       : Controller class for checkout payment authorization
 * @author            : Code It Forward
 * @last modified on  : 09-29-2023
**/
public with sharing class AlternativePaymentController extends PreAuthorizeAlternativePayment{
    public AlternativePaymentController() {
        super();
    }
    
    /**
    * @description Method to call creating an alterative payment
    * @param billingContactPointAddressId Buyer Account billing contact point Address Id
    * @param cartId Id of the current cart
    * @param paymentMethod Payment Method, example: Check,Wire Transfer,etc.
    **/
    @AuraEnabled
    public static void preAuthorize(string country, string postalCode, string state, string city, string street, string cartId, string paymentMethod){
        string APMId=createAlternativePaymentMethod(country,postalCode,state,city,street,cartId,paymentMethod);
        updateCartWithAPM(cartId,APMId);
    }
}