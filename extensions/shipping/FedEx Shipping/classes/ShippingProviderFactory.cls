public with sharing class ShippingProviderFactory {
  private static ShippingProvider shippingProvider;
  private static Map<String, ShippingProvider> shippingProviders = new Map<String, ShippingProvider>();
  private ShippingProviderFactory() {
  }
  public static ShippingProvider getShippingProvider(
    ShippingMetaData shippingMetaData
  ) {
    if (shippingProviders.containsKey(shippingMetaData.providerImplClass)) {
      shippingProvider = shippingProviders.get(shippingMetaData.providerImplClass);
    } else {
      if (shippingMetaData.providerImplClass != null) {
        Type t = Type.forName(shippingMetaData.providerImplClass);
        shippingProvider = (ShippingProvider) t.newInstance();
        shippingProviders.put(shippingMetaData.providerImplClass,shippingProvider);
      }
    }
    return shippingProvider;
  }
}