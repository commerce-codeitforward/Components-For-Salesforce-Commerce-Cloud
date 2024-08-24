@isTest
public class ShippingProviderFactory_Test {
    
    
    @isTest
    static void testgetShippingProvider(){
        ShippingMetaData metaData1 = createShippingMetaData('InternalShippingProvider');
        Test.startTest();
        ShippingProvider provider1 = ShippingProviderFactory.getShippingProvider(metaData1);
        Test.stopTest();
    }
    
    private static ShippingMetaData createShippingMetaData(String providerClass) {
        ShippingMetaData shippingMetaData = new ShippingMetaData();
        shippingMetaData.providerImplClass = providerClass;
        return shippingMetaData;
    }
    
}