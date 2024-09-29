public with sharing class TaxConfiguration {
  private static Map<String, TaxMetaData> taxProviders = new Map<String, TaxMetaData>();
  private static Tax_Provider__mdt taxProviderMDT;
  private TaxConfiguration() {
  }

  public static TaxMetaData getMetaDataDTO(String contextId, String transactionType,String docType) {
    TaxMetaData taxMetaDataDTO;
    String currentLocale = UserInfo.getLocale();
    String dataKey = contextId + '-' + currentLocale;
    if (taxProviders.containsKey(dataKey)) {
      taxMetaDataDTO = taxProviders.get(dataKey);
    } else {
      WebStore webStore = [
        SELECT Name,Tax_Document_Type__c,Tax_Transaction_Type__c
        FROM WebStore
        WHERE Id = :contextId
        LIMIT 1
      ];
      if(String.isBlank(transactionType)){
        transactionType = webStore.Tax_Transaction_Type__c;
      }
      if(String.isBlank(docType)){
        docType = webStore.Tax_Document_Type__c;
      }
      taxProviderMDT = [
        SELECT
          Id,
          QualifiedApiName,
          Taxation_Policy__c,
          Customer_Code__c,
          Company_Code__c,
          Shipping_Items_Taxable__c,
          Default_Shipping_Tax_Code__c,
          Default_Product_Tax_Code__c,
          Consider_product_tax_codes__c,
          Product_Tax_Exemption__c,
          Customer_Tax_Exemption__c,
          Document_Type__c,
          Transaction_Type__c,
          Commit__c,
          Address_Line1__c,
          Address_Line2__c,
          City__c,
          State__c,
          Zip_Code__c,
          Country_Code__c,
          Impl_Class__c,
          Request_Template__c,
          Service__r.End_Point__c,
          Service__r.HTTP_Method__c,
          Service__r.Mocked_Response__c,
          Service__r.Service_Mode__c,
          Service__r.Service_Timeout__c,
          Service__r.Impl_Class__c,
          Service__r.Named_Credentials__c
        FROM Tax_Provider__mdt
        WHERE
          Context_Name__c = :webStore.Name
          AND Context_Locale__c = :currentLocale
          AND Transaction_Type__c = :transactionType
          AND Document_Type__c = :docType
        LIMIT 1
      ];
      if (taxProviderMDT != null) {
        taxMetaDataDTO = new TaxMetaData();
        taxMetaDataDTO.requestJSON = taxProviderMDT.Request_Template__c;
        taxMetaDataDTO.providerImplClass = taxProviderMDT.Impl_Class__c;
        taxMetaDataDTO.companyCode = taxProviderMDT.Company_Code__c;
        taxMetaDataDTO.customerCode = taxProviderMDT.Customer_Code__c;
        taxMetaDataDTO.shipFromLine1 = taxProviderMDT.Address_Line1__c;
        taxMetaDataDTO.shipFromLine2 = taxProviderMDT.Address_Line2__c;
        taxMetaDataDTO.shipFromCity = taxProviderMDT.City__c;
        taxMetaDataDTO.shipFromState = taxProviderMDT.State__c;
        taxMetaDataDTO.shipFromCountry = taxProviderMDT.Country_Code__c;
        taxMetaDataDTO.shipFromZipCode = taxProviderMDT.Zip_Code__c;
        taxMetaDataDTO.defaultShippingTaxCode = taxProviderMDT.Default_Shipping_Tax_Code__c;
        taxMetaDataDTO.taxationPolicy = taxProviderMDT.Taxation_Policy__c;
        taxMetaDataDTO.shippingItemsTaxable = taxProviderMDT.Shipping_Items_Taxable__c;
        taxMetaDataDTO.defaultProductTaxCode = taxProviderMDT.Default_Product_Tax_Code__c;
        taxMetaDataDTO.useProductTaxCodes = taxProviderMDT.Consider_product_tax_codes__c;
        taxMetaDataDTO.productTaxExemption = taxProviderMDT.Product_Tax_Exemption__c;
        taxMetaDataDTO.customerTaxExemption = taxProviderMDT.Customer_Tax_Exemption__c;
        taxMetaDataDTO.transactionType = taxProviderMDT.Transaction_Type__c;
        taxMetaDataDTO.documentType = taxProviderMDT.Document_Type__c;
        taxMetaDataDTO.isCommit = taxProviderMDT.Commit__c;
        taxMetaDataDTO.endPoint = taxProviderMDT.Service__r.End_Point__c;
        taxMetaDataDTO.httpMethod = taxProviderMDT.Service__r.HTTP_Method__c;
        taxMetaDataDTO.mockedResponse = taxProviderMDT.Service__r.Mocked_Response__c;
        taxMetaDataDTO.serviceMode = taxProviderMDT.Service__r.Service_Mode__c;
        taxMetaDataDTO.serviceTimeout = taxProviderMDT.Service__r.Service_Timeout__c;
        taxMetaDataDTO.serviceImplClass = taxProviderMDT.Service__r.Impl_Class__c;
        taxMetaDataDTO.namedCredentials = taxProviderMDT.Service__r.Named_Credentials__c;
        taxProviders.put(dataKey, taxMetaDataDTO);
      }
    }
    return taxMetaDataDTO;
  }

  public static Tax_Provider__mdt getMetaDataObject() {
    return taxProviderMDT;
  }
}