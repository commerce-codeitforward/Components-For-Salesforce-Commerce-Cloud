public virtual class HTTPService {
    public HTTPService() {
    }
    public virtual HttpRequest createHttpRequest(
      Map<String, String> requestDetails
    ) {
      HttpRequest req = new HttpRequest();
      req.setEndpoint(requestDetails.get(Constants.END_POINT));
      req.setMethod(
        String.isNotBlank(requestDetails.get(Constants.HTTP_METHOD)) ? requestDetails.get(Constants.HTTP_METHOD) : Constants.HTTP_POST );
      Integer timeout = String.isNotBlank(
          requestDetails.get(Constants.SERVICE_TIMEOUT) ) ? Integer.valueOf(requestDetails.get(Constants.SERVICE_TIMEOUT)) : Constants.HTTP_DEFAULT_TIMEOUT;
      req.setTimeout(timeout);
      return req;
    }
  
    public virtual void setRequestHeaders(
      HttpRequest req,
      Map<String, String> requestHeaders
    ) {
      if (!requestHeaders.isEmpty()) {
        for (String key : requestHeaders.keySet()) {
          req.setHeader(key, requestHeaders.get(key));
          System.debug('============= key : '+key+': '+requestHeaders.get(key));
        }
      }
      if (!requestHeaders.containsKey(Constants.HTTP_HEADER_CONTENT_TYPE)) {
        req.setHeader(
          Constants.HTTP_HEADER_CONTENT_TYPE,
          Constants.HTTP_HEADER_CONTENT_TYPE_JSON
        );
      }
    }
  
    public virtual Map<String, String> makeExternalCallout(
      Map<String, String> calloutRequestDetails,
      Map<String, String> requestHeaders
    ) {
      Map<String, String> responseMap = new Map<String, String>();
      try {
        HttpRequest req = createHttpRequest(calloutRequestDetails);
        setRequestHeaders(req, requestHeaders);
        Http http = new Http();
        HTTPResponse res = null;
       // if (!Test.isRunningTest()) {
          if (
            calloutRequestDetails.get(Constants.SERVICE_MODE)
              .toUpperCase()
              .equals(Constants.SERVICE_MODE_LIVE)
          ) {
            if(String.isNotBlank(calloutRequestDetails.get(Constants.SERVICE_REQUEST_BODY))){
              req.setbody(
              calloutRequestDetails.get(Constants.SERVICE_REQUEST_BODY)
            );
            }
            res = http.send(req);
          } else {
            res = new HTTPResponse();
            res.setStatusCode(Constants.HTTP_200);
            res.setBody(calloutRequestDetails.get(Constants.MOCKED_RESPONSE));
          }
      //  } else {
     //     res = new HTTPResponse();
     //     res.setStatusCode(Constants.HTTP_200);
     //   }
        if (res.getStatusCode() == Constants.HTTP_200) {
          responseMap.put(
            Constants.HTTP_RESPONSE_STATUS,
            Constants.HTTP_RESPONSE_STATUS_SUCCESS
          );
          responseMap.put(
            Constants.RESPONSE_REASON_CODE,
            String.valueOf(res.getstatusCode())
          );
          responseMap.put(Constants.SERVICE_RESPONSE_BODY, res.getBody());
        } else {
          responseMap.put(
            Constants.HTTP_RESPONSE_STATUS,
            Constants.HTTP_RESPONSE_STATUS_ERROR
          );
          responseMap.put(
            Constants.RESPONSE_REASON_CODE,
            String.valueOf(res.getstatusCode())
          );
          responseMap.put(Constants.SERVICE_RESPONSE_BODY, res.getBody());
        }
      } catch (Exception expObj) {
        responseMap.put(
          Constants.HTTP_RESPONSE_STATUS,
          Constants.HTTP_RESPONSE_STATUS_ERROR
        );
        System.debug(
          'Exception due to error ====' +
            expObj.getMessage() +
            'at Line Number ====' +
            expObj.getLineNumber()
        );
        // WK_Exception.log(expObj, applicationName, moduleName, className,
        // methodName, supportData);
      }
      return responseMap;
    }
  }