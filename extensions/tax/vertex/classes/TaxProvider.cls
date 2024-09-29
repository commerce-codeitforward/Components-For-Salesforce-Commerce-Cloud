public abstract class TaxProvider {
  public TaxProvider() {
  }

  public virtual Map<String, String> prepareNamedCredentials(
    TaxProviderRequest taxRequest
  ) {
    Map<String, String> callOutRequest = new Map<String, String>();
    String endPoint =
      Constants.CALLOUT +
      taxRequest.taxMetaData.namedCredentials +
      taxRequest.taxMetaData.endPoint;
    callOutRequest.put(Constants.END_POINT, endPoint);
    // callOutRequest.put(Constants.USERNAME , Constants.CREDENNTIALS_USERNAME);
    // callOutRequest.put(Constants.PASSWORD , Constants.CREDENNTIALS_PASSWORD);
    return callOutRequest;
  }
  public virtual Map<String, String> setServiceDetails(
    TaxProviderRequest taxRequest
  ) {
    Map<String, String> serviceDetails = new Map<String, String>();
    serviceDetails.put(
      Constants.HTTP_METHOD,
      taxRequest.taxMetaData.httpMethod
    );
    serviceDetails.put(
      Constants.SERVICE_TIMEOUT,
      taxRequest.taxMetaData.serviceTimeout
    );
    serviceDetails.put(
      Constants.SERVICE_MODE,
      taxRequest.taxMetaData.serviceMode
    );
    serviceDetails.put(
      Constants.MOCKED_RESPONSE,
      taxRequest.taxMetaData.mockedResponse
    );
    return serviceDetails;
  }

  public virtual Map<String, String> setRequestHeaders(
    TaxProviderRequest taxRequest
  ) {
    Map<String, String> htttpRequestDetails = new Map<String, String>();
    return htttpRequestDetails;
  }

  public virtual TaxProviderResponse calculateTax(
    TaxProviderRequest taxRequest
  ) {
    TaxProviderResponse taxes;
    Map<String, String> responseMap;
    Boolean calloutSuccess = true;
    try {
      Map<String, String> callOutRequest = new Map<String, String>();
      callOutRequest.putAll(prepareNamedCredentials(taxRequest));
      callOutRequest.putAll(setServiceDetails(taxRequest));
      prepareCreateTransaction(taxRequest, callOutRequest);

      responseMap = ServiceFactory.getService(
          taxRequest.taxMetaData.serviceImplClass
        )
        .makeExternalCallout(callOutRequest, setRequestHeaders(taxRequest));
      if (
        Constants.HTTP_RESPONSE_STATUS_ERROR.equals(responseMap.get(Constants.HTTP_RESPONSE_STATUS)) ||
        responseMap.isEmpty()
      ) {
        calloutSuccess = false;
      }
      String response = responseMap.get(Constants.SERVICE_RESPONSE_BODY);
      if (calloutSuccess) {
        taxes = getTaxFromResponse(response, taxRequest);
      }
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
    return taxes;
  }

  public abstract TaxProviderResponse getTaxFromResponse(
    String response,
    TaxProviderRequest taxRequest
  );
  public abstract void prepareCreateTransaction(
    TaxProviderRequest taxRequest,
    Map<String, String> callOutRequest
  );

  public void commitTransaction(TaxProviderRequest taxRequest){
    System.debug(
      '========================= Inside TaxProvider#calculateTax starts'
    );

    TaxProviderResponse taxes;
    Map<String, String> responseMap;
    Boolean calloutSuccess = true;
    try {
      Map<String, String> callOutRequest = new Map<String, String>();
      callOutRequest.putAll(prepareNamedCredentials(taxRequest));
      callOutRequest.putAll(setServiceDetails(taxRequest));
      prepareCommitTransaction(taxRequest, callOutRequest);

      responseMap = ServiceFactory.getService(
          taxRequest.taxMetaData.serviceImplClass
        )
        .makeExternalCallout(callOutRequest, setRequestHeaders(taxRequest));
      if (
        !'201'.equals(responseMap.get(Constants.RESPONSE_REASON_CODE)) ||
        responseMap.isEmpty()
      ) {
        calloutSuccess = false;
      }
      String response = responseMap.get(Constants.SERVICE_RESPONSE_BODY);
      if (calloutSuccess) {
        taxes = getTaxFromResponse(response, taxRequest);
      }
    } catch (Exception expObj) {
      System.debug(
        'Exception due to error ====' +
          expObj.getMessage() +
          'at Line Number ====' +
          expObj.getLineNumber()
      );
    }
  }
  public abstract void prepareCommitTransaction(TaxProviderRequest taxRequest, Map<String, String> callOutRequest);
}