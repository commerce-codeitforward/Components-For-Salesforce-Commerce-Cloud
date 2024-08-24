public class UPSShippingProvider extends ShippingProvider {
  public UPSShippingProvider() {
  }
  public virtual override void prepareRequestBody(
    ShippingProviderRequest shippingRequest,
    Map<String, String> callOutRequest
  ) {
    UPSShippingRateRequest requestObject = UPSShippingRateRequest.parse(
      shippingRequest.shippingMetaData.requestJSON
    );
    if (requestObject != null) {
      requestObject.RateRequest.Shipment.Shipper.ShipperNumber = shippingRequest.shippingMetaData.accountNumber;
      requestObject.RateRequest.Shipment.ShipTo = setShipToAddress(
        shippingRequest
      );
      requestObject.RateRequest.Shipment.Package_Z[0]
        .PackageWeight.Weight = String.valueOf(shippingRequest.packageWeight);
      String strRatingRequestBody = JSON.serialize(requestObject, true);
      strRatingRequestBody = strRatingRequestBody.replaceAll(
          'Package_Z',
          'Package'
        )
        .replaceAll('Date_Z', 'Date')
        .replaceAll('Time_Z', 'Time');

      callOutRequest.put(Constants.SERVICE_REQUEST_BODY, strRatingRequestBody);
    }
  }

  public virtual UPSShippingRateRequest.ShipTo setShipToAddress(
    ShippingProviderRequest shippingRequest
  ) {
    UPSShippingRateRequest.Address address = new UPSShippingRateRequest.Address();
    address.AddressLine = new List<String>();
    address.AddressLine.add(shippingRequest.street);
    address.City = shippingRequest.city;
    address.StateProvinceCode = shippingRequest.state;
    address.PostalCode = shippingRequest.postalCode;
    address.CountryCode = shippingRequest.country;
    UPSShippingRateRequest.ShipTo shipTo = new UPSShippingRateRequest.ShipTo();
    shipTo.Address = address;
    return shipTo;
  }

  public virtual override Map<String, ShippingProviderResponse> getShippingOptionsFromResponse(
    List<String> responseList,
    ShippingProviderRequest shippingRequest
  ) {
    Map<String, Object> shippingMethods = new Map<String, Object>();
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = parseUPSShippingResponse(
      responseList,
      shippingRequest
    );
    return shippingMethodsWithRate;
  }

  public virtual Map<String, ShippingProviderResponse> parseUPSShippingResponse(
    List<String> lstUPSResponseBody,
    ShippingProviderRequest shippingRequest
  ) {
    Map<String, ShippingProviderResponse> shippingMethodsWithRate = new Map<String, ShippingProviderResponse>();
    ShippingProviderResponse shippingResponse;
    if (lstUPSResponseBody != null && lstUPSResponseBody.size() > 0) {
      for (String strUPSResponseBody : lstUPSResponseBody) {
        UPSShippingRateResponse upsShippingRateResponseObj = UPSShippingRateResponse.parse(
          strUPSResponseBody
        );
        UPSShippingRateResponse.RateResponse upsShippingRateResponse = upsShippingRateResponseObj.RateResponse;
        for (
          UPSShippingRateResponse.RatedShipment shipmentObj : upsShippingRateResponse.RatedShipment
        ) {
          Decimal shippingAmount = shipmentObj.TotalCharges.MonetaryValue !=
            null
            ? Decimal.valueOf(shipmentObj.TotalCharges.MonetaryValue)
            : 0;
          if (shippingMethodsWithRate.containsKey(shipmentObj.Service.Code)) {
            shippingResponse = shippingMethodsWithRate.get(
              shipmentObj.Service.Code
            );
            shippingResponse.cost = shippingResponse.cost + shippingAmount;
          } else {
            shippingResponse = new ShippingProviderResponse();
            shippingResponse.serviceCode = shipmentObj.Service.Code;
            shippingResponse.cost = shippingAmount;
            shippingResponse.carrier = shippingRequest.shippingMetaData.carrier;
            shippingResponse.displayOrder = shippingRequest.shippingMetaData.displayOrder;
            shippingMethodsWithRate.put(
              shipmentObj.Service.Code,
              shippingResponse
            );
          }
        }
      }
    }
    return shippingMethodsWithRate;
  }
}