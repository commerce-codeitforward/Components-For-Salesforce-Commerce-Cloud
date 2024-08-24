public class InternalShippingProvider extends ShippingProvider {
  public InternalShippingProvider() {
  }
  public override Map<String, ShippingProviderResponse> retrieveShippingRates(
    ShippingProviderRequest shippingRequest
  ) {
    List<String> responseList = new List<String>();
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = new Map<String, ShippingProviderResponse>();
    Decimal totalCartWeight = 0;
    try {
      List<Decimal> lstShippingWeight = calculateCartWeight(shippingRequest);
      for (Decimal weight : lstShippingWeight) {
        totalCartWeight += weight;
      }
      shippingRequest.packageWeight = totalCartWeight;
      shippingMethodsWithRate = getShippingOptionsFromResponse(
        responseList,
        shippingRequest
      );
    } catch (Exception expObj) {
      System.debug(
        'Exception due to error ====' +
          expObj.getMessage() +
          'at Line Number ====' +
          expObj.getLineNumber()
      );
      // WK_Exception.log(expObj, applicationName, moduleName, className,
      // methodName, supportData);
    }
    return shippingMethodsWithRate;
  }

  public override Map<String, ShippingProviderResponse> getShippingOptionsFromResponse(
    List<String> responseList,
    ShippingProviderRequest shippingRequest
  ) {
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = new Map<String, ShippingProviderResponse>();
    List<Internal_Shipping_Rate__mdt> shippingRates = [
      SELECT
        Id,
        Name__c,
        Rate__c,
        Cart_Max_Price__c,
        Cart_Max_Weight__c,
        Cart_Min_Price__c,
        Cart_Min_Weight__c,
        Shipping_Provider__c
      FROM Internal_Shipping_Rate__mdt
      WHERE Shipping_Provider__c = :shippingRequest.shippingMetaData.id AND Is_Active__c = true 
    ];
    ShippingProviderResponse shippingResponse;
    if (shippingRates != null && shippingRates.size() > 0) {
      for (Internal_Shipping_Rate__mdt rate : shippingRates) {
        shippingResponse = new ShippingProviderResponse();
        shippingResponse.serviceCode = rate.Name__c;
        shippingResponse.cost = rate.Rate__c;
        shippingResponse.carrier = shippingRequest.shippingMetaData.carrier;
        shippingResponse.displayOrder = shippingRequest.shippingMetaData.displayOrder;
        shippingMethodsWithRate.put(
          shippingResponse.serviceCode,
          shippingResponse
        );
      }
    }
    return shippingMethodsWithRate;
  }
  public override void prepareRequestBody(
    ShippingProviderRequest shippingRequest,
    Map<String, String> callOutRequest
  ) {
  }
}