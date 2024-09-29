public class FedExShippingProvider extends ShippingProvider {
  public FedExShippingProvider() {
  }
  public override void prepareRequestBody(ShippingProviderRequest shippingRequest,Map<String, String> callOutRequest) {
    FedExShippingRateRequest requestObject = FedExShippingRateRequest.parse(
      shippingRequest.shippingMetaData.requestJSON
    );
    if (requestObject != null) {
      requestObject.requestedShipment.recipient.address = setShipToAddress(
        shippingRequest
      );
      FedExShippingRateRequest.RequestedPackageLineItems packageLItem = requestObject.requestedShipment.requestedPackageLineItems.get(
        0
      );
      FedExShippingRateRequest.Weight weight = new FedExShippingRateRequest.Weight();
      packageLItem.weight.value = shippingRequest.packageWeight;

      String strRatingRequestBody = JSON.serialize(requestObject, true);
      callOutRequest.put(Constants.SERVICE_REQUEST_BODY, strRatingRequestBody);
    }
  }

  public virtual FedExShippingRateRequest.Address setShipToAddress(
    ShippingProviderRequest shippingRequest
  ) {
    FedExShippingRateRequest.Address address = new FedExShippingRateRequest.Address();
    address.postalCode = shippingRequest.postalCode;
    address.countryCode = shippingRequest.country;
    return address;
  }

  public override Map<String, ShippingProviderResponse> getShippingOptionsFromResponse(
    List<String> responseList,
    ShippingProviderRequest shippingRequest
  ) {
    Map<String, Object> shippingMethods = new Map<String, Object>();
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = parseFedExShippingResponse(
      responseList,
      shippingRequest
    );
    return shippingMethodsWithRate;
  }

  public virtual Map<String, ShippingProviderResponse> parseFedExShippingResponse(
    List<String> lstFedExResponseBody,
    ShippingProviderRequest shippingRequest
  ) {
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = new Map<String, ShippingProviderResponse>();
    ShippingProviderResponse shippingResponse;
    if (lstFedExResponseBody != null && lstFedExResponseBody.size() > 0) {
      for (String strFedExResponseBody : lstFedExResponseBody) {
        FedExShippingRateResponse fedexShippingRateResponseObj = FedExShippingRateResponse.parse(
          strFedExResponseBody
        );
        FedExShippingRateResponse.Output fedexShippingRateResponse = fedexShippingRateResponseObj.output;
        for (
          FedExShippingRateResponse.RateReplyDetails shipmentObj : fedexShippingRateResponse.rateReplyDetails
        ) {
          Decimal shippingAmount = shipmentObj.ratedShipmentDetails[0]
              .totalNetCharge != null
            ? Decimal.valueOf(
                shipmentObj.ratedShipmentDetails[0].totalNetCharge
              )
            : 0;
          if (
            shippingMethodsWithRate.containsKey(
              shipmentObj.operationalDetail.serviceCode
            )
          ) {
            shippingResponse = shippingMethodsWithRate.get(
              shipmentObj.operationalDetail.serviceCode
            );
            shippingResponse.cost = shippingResponse.cost + shippingAmount;
          } else {
            shippingResponse = new ShippingProviderResponse();
            shippingResponse.serviceCode = shipmentObj.operationalDetail.serviceCode;
            shippingResponse.cost = shippingAmount;
            shippingResponse.carrier = shippingRequest.shippingMetaData.carrier;
            shippingResponse.displayOrder = shippingRequest.shippingMetaData.displayOrder;
            shippingMethodsWithRate.put(
              shipmentObj.operationalDetail.serviceCode,
              shippingResponse
            );
          }
        }
      }
    }
    return shippingMethodsWithRate;
  }
}