/**
 * @description       : Wrapper class for payment invocable response mehtod
 * @author            : Code It Forward
 * @last modified on  : 09-29-2023
 */

public class PaymentResponse {
    @InvocableVariable
    public OrderPaymentSummary orderPaymentSummary;
    public PaymentResponse() {
    }
  
    public PaymentResponse(OrderPaymentSummary ops) {
      orderPaymentSummary = ops;
    }
  }