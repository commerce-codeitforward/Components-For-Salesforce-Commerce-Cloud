public with sharing class Recommender_Configuration {
    private static Map<String, RecommenderMetadata> recommendersCache = new Map<String, RecommenderMetadata>();
    
    private Recommender_Configuration() {
    }
  
    public static RecommenderMetadata getRecommendersConfig() {
      List<Einstein_Recommender__mdt> recommenders;
      RecommenderMetadata metaData;
      String currentLocale = UserInfo.getLocale();
      String networkId = Network.getNetworkId();
      String storeName;
      
      if(String.isNotEmpty(networkId)){
        List<WebStoreNetwork> webStroreNetworkObjList = [
            SELECT WebStoreId, NetworkId
            FROM WebStoreNetwork
            WHERE NetworkId = :networkId
            LIMIT 1
        ];
        String webstoreId;
        if (!webStroreNetworkObjList.isEmpty()) {
            webstoreId = webStroreNetworkObjList.get(0).WebStoreId;
            storeName = [
            SELECT Name
            FROM WebStore
            WHERE Id = :webstoreId
            LIMIT 1
          ].Name;
        }
      }else{
        storeName = [Select Store__c From User Where Id = :UserInfo.getUserId()][0].Store__c;
      }
      String dataKey = storeName+'-'+currentLocale;
      if (recommendersCache.containsKey(dataKey)) {
        metaData = recommendersCache.get(dataKey);
      } else {
        Einstein_Configuration__mdt config = [SELECT Consider_Context__c, Locales__c,
    		   (SELECT Einstein_Id__c, UI_Label__c, Context__c FROM Einstein_Recommenders__r WHERE isActive__c = true),
           (SELECT Name_in_Recommender__c, Name_in_Activity_API__c FROM Einstein_Activities__r WHERE Is_Active__c = true),
            HTTP_Service__r.End_Point__c,
            HTTP_Service__r.HTTP_Method__c,
            HTTP_Service__r.Mocked_Response__c,
            HTTP_Service__r.Service_Mode__c,
            HTTP_Service__r.Service_Timeout__c,
            HTTP_Service__r.Impl_Class__c,
            HTTP_Service__r.Named_Credentials__c
    	    FROM EINSTEIN_Configuration__mdt WHERE IsActive__c = true AND Webstore_Name__c = :storeName
        ];

        metaData = new RecommenderMetadata();
        metaData.locales = (Map<String,String>)JSON.deserialize(config.Locales__c, Map<String,String>.class);
        metaData.considerContext = config.Consider_Context__c;
        metaData.endPoint = config.HTTP_Service__r.End_Point__c;
        metaData.httpMethod = config.HTTP_Service__r.HTTP_Method__c;
        metaData.mockedResponse = config.HTTP_Service__r.Mocked_Response__c;
        metaData.serviceMode = config.HTTP_Service__r.Service_Mode__c;
        metaData.serviceTimeout = config.HTTP_Service__r.Service_Timeout__c;
        metaData.serviceImplClass = config.HTTP_Service__r.Impl_Class__c;
        metaData.namedCredentials = config.HTTP_Service__r.Named_Credentials__c;

        RecommenderDetails recoDetails;
        if (config.Einstein_Recommenders__r != null && config.Einstein_Recommenders__r.size() > 0) {
            for (Einstein_Recommender__mdt recoMeta : config.Einstein_Recommenders__r) {
                recoDetails = new RecommenderDetails();
                recoDetails.recoEinsteinId = recoMeta.Einstein_Id__c;
                recoDetails.uiLabel = recoMeta.UI_LABEL__c;
                recoDetails.context = recoMeta.Context__c;
                metaData.addRecoDetails(recoDetails);
            }
        }

        ActivityDetails activityDetails;
        if (config.Einstein_Recommenders__r != null && config.Einstein_Recommenders__r.size() > 0) {
          for (Einstein_Activity__mdt activityMeta : config.Einstein_Activities__r) {
              activityDetails = new ActivityDetails();
              activityDetails.nameInRecommender = activityMeta.Name_in_Recommender__c;
              activityDetails.nameInActivity = activityMeta.Name_in_Activity_API__c;
              metaData.addActivities(activityDetails);
          }
        }
        recommendersCache.put(dataKey, metaData);
      }
      return metaData;
    }
  }