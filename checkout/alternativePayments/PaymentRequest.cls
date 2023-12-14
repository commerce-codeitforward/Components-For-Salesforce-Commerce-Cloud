/**
 * @description       : Wrapper class for payment invocable methods
 * @author            : Code It Forward
 * @last modified on  : 09-29-2023
 */

public class PaymentRequest {
    @InvocableVariable
    public OrderSummary orderSummary;

    @InvocableVariable
    public Id orderSummaryId;

    @InvocableVariable
    public Decimal grandTotalAmount;

    @InvocableVariable
    public Id accountId;
  
    @InvocableVariable
    public OrderPaymentSummary orderPaymentSummary;
  
    @InvocableVariable
    public PaymentGateway paymentGateway;
  
    @InvocableVariable
    public Payment payment;
  
    @InvocableVariable
    public Decimal amount;
  
    @InvocableVariable
    public String paymentMethod;
  
    /**
     * @description empty constructor
     */
    public PaymentRequest() {
    }
  }