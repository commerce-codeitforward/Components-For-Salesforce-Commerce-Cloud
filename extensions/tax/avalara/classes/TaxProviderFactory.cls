public with sharing class TaxProviderFactory {
  private static TaxProvider taxProvider;
  private static Map<String, TaxProvider> taxProviders = new Map<String, TaxProvider>();
 @testVisible
  private TaxProviderFactory() {
  }
  public static TaxProvider getTaxProvider(TaxMetaData taxMetaData) {
    if (taxProviders.containsKey(taxMetaData.providerImplClass)) {
      TaxProvider = taxProviders.get(taxMetaData.providerImplClass);
    } else {
      if (taxMetaData.providerImplClass != null) {
        Type t = Type.forName(taxMetaData.providerImplClass);
        TaxProvider = (TaxProvider) t.newInstance();
        TaxProviders.put(taxMetaData.providerImplClass, taxProvider);
      }
    }
    return taxProvider;
  }
}