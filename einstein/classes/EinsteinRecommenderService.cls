public with sharing class EinsteinRecommenderService {
    public EinsteinRecommenderService() {

    }

    public static Map<String, String> setServiceDetails(
      EinsteinRequest request
    ) {
      Map<String, String> serviceDetails = new Map<String, String>();
      serviceDetails.put(
        Constants.HTTP_METHOD,
        request.metaData.httpMethod
      );
      serviceDetails.put(
        Constants.SERVICE_TIMEOUT,
        request.metaData.serviceTimeout
      );
      serviceDetails.put(
        Constants.SERVICE_MODE,
        request.metaData.serviceMode
      );
      serviceDetails.put(
        Constants.MOCKED_RESPONSE,
        request.metaData.mockedResponse
      );
      return serviceDetails;
    }
    public static Map<String, String> setRequestHeaders(
      EinsteinRequest request
      ) {
        Map<String, String> htttpRequestDetails = new Map<String, String>();
        htttpRequestDetails.put('Cookie', request.cookie);
        htttpRequestDetails.put('Authorization', 'OAuth ' + UserInfo.getSessionId());
        return htttpRequestDetails;
      }
    public static void prepareRecommenderRequest (EinsteinRequest request, Map<String, String> callOutRequest){
      String endPoint = Url.getOrgDomainUrl().toExternalForm()+request.metaData.endPoint.replace('{webstoreId}',request.webstoreId);
      endPoint+='?language='+request.metaData.locales.get(UserInfo.getLocale());
      if(UserInfo.getUserType() == 'Guest'){
        endPoint+='&asGuest=true';
      }else{
        endPoint+='&asGuest=false';
      }
      endPoint+='&recommender=' + request.recommender;
      if (String.isNotBlank(request.anchorValues)) {
        RecommenderDetails rd = request.metaData.getRecommender(request.recommender);
        if(rd.context.indexOf('Category') > -1 || rd.context.indexOf('Product') > -1){
          endpoint += '&anchorValues=' + request.anchorValues;
        }
      }
      callOutRequest.put(Constants.END_POINT, endPoint);
    }
    public static String getRecommendations(
        EinsteinRequest request
      ) {
        Map<String, String> responseMap;
        Boolean calloutSuccess = true;
        String response = '';
        try {
          Map<String, String> callOutRequest = new Map<String, String>();
          callOutRequest.putAll(setServiceDetails(request));
          prepareRecommenderRequest(request, callOutRequest);
    
          responseMap = ServiceFactory.getService(
            request.metaData.serviceImplClass
            )
            .makeExternalCallout(callOutRequest, setRequestHeaders(request));
          if (
            Constants.HTTP_RESPONSE_STATUS_ERROR.equals(responseMap.get(Constants.HTTP_RESPONSE_STATUS)) ||
            responseMap.isEmpty()
          ) {
            calloutSuccess = false;
          }
          response = responseMap.get(Constants.SERVICE_RESPONSE_BODY);
        } catch (Exception expObj) {
          System.debug(
            'Exception due to error ====' +
              expObj.getMessage() +
              'at Line Number ====' +
              expObj.getLineNumber()
          );
        }
        return response;
      }

}