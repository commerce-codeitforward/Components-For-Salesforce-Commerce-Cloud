/**
 * @description       : Creates Order Payment Summary and Payment Authorization after a Order Summary is created
 * @author            : Code It Forward
 * @last modified on  : 09-29-2023
 */

public without sharing class AuthorizeAlternativePayment {
    /**
     * @description execution method for invocable
     * @param requests - Payment Request (Order Summary and Payment Gateway are required)
     * @return Payment Response - Order Payment Summary Record.
     */
    @InvocableMethod
    public static List<PaymentResponse> execute(List<PaymentRequest> requests) {
        osWrapper os = new osWrapper();
        PaymentGateway pg;
        Decimal authorizationAmount;
        for (PaymentRequest r : requests) {
            System.debug('##'+r.orderSummaryId);
            os.orderSummaryId = r.orderSummaryId;
            os.grandTotalAmount = r.grandTotalAmount;
            os.accountId = r.accountId;
            os.paymentMethod = r.paymentMethod;
            pg = r.paymentGateway;
            if (r.amount != null && r.amount <> 0) {
                authorizationAmount = r.amount;
            } else {
                authorizationAmount = r.grandTotalAmount;
            }
        }
        OrderPaymentSummary ops = createOrderPaymentSummary(os);
        createPaymentAuthorization(os.accountId, pg, ops, authorizationAmount);
  
        PaymentResponse response = new PaymentResponse(ops);
  
        return new List<PaymentResponse>{ response };
    }
    
    /**
     * @description creates order payment summary
     * @param os - Order Summary
     * @return the new OrderPaymentSummary
     */
    public static OrderPaymentSummary createOrderPaymentSummary(osWrapper os) {
        OrderPaymentSummary ops = new OrderPaymentSummary(
            OrderSummaryId = os.orderSummaryId,
            Type = os.paymentMethod,
            Method = os.paymentMethod + '-' + Integer.valueOf(Math.floor(1000 + Math.random() * 9000))
        );
  
        insert ops;
        return ops;
    }

    /**
     * @description creates payment authorization
     * @param os - Order Summary
     * @param pg - Payment Gateway
     * @param ops - Order Payment Summary
     * @param authorizationAmount - Authorization Amount.
     */
    public static void createPaymentAuthorization(Id accountId, PaymentGateway pg,
            OrderPaymentSummary ops, Decimal authorizationAmount) {
      PaymentAuthorization pa = new PaymentAuthorization(
        AccountId = accountId,
        Amount = authorizationAmount,
        EffectiveDate = System.now(),
        GatewayDate = System.now(),
        PaymentGatewayId = pg.Id,
        ProcessingMode = 'External',
        SfResultCode = 'Success',
        Status = 'Processed',
        OrderPaymentSummaryId = ops.Id
      );
  
      insert pa;
    }

    public class osWrapper {
        public Id orderSummaryId;
        public Id accountId;
        public Decimal grandTotalAmount;
        public String paymentMethod;
    }
  }