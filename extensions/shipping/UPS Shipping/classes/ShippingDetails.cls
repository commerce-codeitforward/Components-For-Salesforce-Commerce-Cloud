public with sharing class ShippingDetails {
  private static Map<String, List<ShippingMetaData>> shippingProviders = new Map<String, List<ShippingMetaData>>();
  private static List<Shipping_Provider__mdt> shippingProviderMDTs;
  private ShippingDetails() {
  }

  public static List<ShippingMetaData> getMetaDataDTO(String contextId) {
    List<ShippingMetaData> shippingMetaDataDTOs = new List<ShippingMetaData>();
    String currentLocale = UserInfo.getLocale();
    String dataKey = contextId + '-' + currentLocale;
    if (shippingProviders.containsKey(dataKey)) {
      shippingMetaDataDTOs = shippingProviders.get(dataKey);
    } else {
      String webStoreName = [
        SELECT Name
        FROM WebStore
        WHERE Id = :contextId
        LIMIT 1
      ]
      .Name;
      shippingProviderMDTs = [
        SELECT
          Id,
          Impl_Class__c,
          Max_Weight_Threshold__c,
          Min_Weight_Threshold__c,
          QualifiedApiName,
          Request__c,
          Account_Number__c,
          Display_Order__c,
          Service__c,
          Shipping_Options__c,
          Carrier__c,
          Service__r.End_Point__c,
          Service__r.HTTP_Method__c,
          Service__r.Mocked_Response__c,
          Service__r.Service_Mode__c,
          Service__r.Service_Timeout__c,
          Service__r.Impl_Class__c,
          Service__r.Named_Credentials__c
        FROM Shipping_Provider__mdt
        WHERE
          Context_Name__c = :webStoreName
          AND Context_Locale__c = :currentLocale AND Is_Active__c = true 
        ORDER BY Display_Order__c ASC NULLS LAST
      ];
      if (shippingProviderMDTs != null && shippingProviderMDTs.size() > 0) {
        ShippingMetaData shippingMetaDataDTO;
        for (
          Shipping_Provider__mdt shippingProviderMDT : shippingProviderMDTs
        ) {
          shippingMetaDataDTO = new ShippingMetaData();
          shippingMetaDataDTO.id = shippingProviderMDT.id;
          shippingMetaDataDTO.requestJSON = shippingProviderMDT.Request__c;
          shippingMetaDataDTO.providerImplClass = shippingProviderMDT.Impl_Class__c;
          shippingMetaDataDTO.maxPackageWeight = shippingProviderMDT.Max_Weight_Threshold__c;
          shippingMetaDataDTO.minPackageWeight = shippingProviderMDT.Min_Weight_Threshold__c;
          shippingMetaDataDTO.shippinggMethodNames = shippingProviderMDT.Shipping_Options__c;
          shippingMetaDataDTO.accountNumber = shippingProviderMDT.Account_Number__c;
          shippingMetaDataDTO.displayOrder = Integer.valueOf(
            shippingProviderMDT.Display_Order__c
          );
          shippingMetaDataDTO.carrier = shippingProviderMDT.Carrier__c;
          shippingMetaDataDTO.endPoint = shippingProviderMDT.Service__r.End_Point__c;
          shippingMetaDataDTO.httpMethod = shippingProviderMDT.Service__r.HTTP_Method__c;
          shippingMetaDataDTO.mockedResponse = shippingProviderMDT.Service__r.Mocked_Response__c;
          shippingMetaDataDTO.serviceMode = shippingProviderMDT.Service__r.Service_Mode__c;
          shippingMetaDataDTO.serviceTimeout = shippingProviderMDT.Service__r.Service_Timeout__c;
          shippingMetaDataDTO.serviceImplClass = shippingProviderMDT.Service__r.Impl_Class__c;
          shippingMetaDataDTO.namedCredentials = shippingProviderMDT.Service__r.Named_Credentials__c;
          shippingMetaDataDTOs.add(shippingMetaDataDTO);
        }
        shippingProviders.put(dataKey, shippingMetaDataDTOs);
      }
    }
    return shippingMetaDataDTOs;
  }

  public static List<Shipping_Provider__mdt> getMetaDataObject() {
    return shippingProviderMDTs;
  }
}