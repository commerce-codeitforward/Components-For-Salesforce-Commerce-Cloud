@isTest
public class ShippingCartCalculatorExtensionTest {
    @isTest
    public static void calculateTest(){
        CartExtension.Cart cart = arrangeCart();
        CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForAddToCart(cart);
        CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForAddToCart(cart.getCartItems().get(0));
        CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(buyerActionDetails); 
        CartExtension.CartCalculateCalculatorRequest calculatorRequest = new CartExtension.CartCalculateCalculatorRequest(cart, CartExtension.OptionalBuyerActionDetails.empty());
        WebCart testCart = [Select id,Name,WebStoreId from WebCart where Name = 'My Cart' Limit 1];
        WebStore store = [Select id, Name from WebStore where Name = 'Training' Limit 1];
        String currentLocale = UserInfo.getlocale();
        Map<String, ShippingProviderResponse> shippingMethodsWithRate = new Map<String, ShippingProviderResponse>();
        CartExtension.CartDeliveryGroupMethodList cartDeliveryGroupMethods;
        String shippingProduct;
        List<ShippingMetaData> shipproviderList = new List<ShippingMetaData>();
        Shipping_Provider__mdt ship = getCustomMetadataRecord();
        ShippingMetaData metaData1 = createShippingMetaData('InternalShippingProvider');
        ShippingMetaData shipmeta = new ShippingMetaData();
        Shipping_Provider__mdt testShipProvider =[Select id from Shipping_Provider__mdt where Impl_Class__c = 'InternalShippingProvider' LIMIT 1];
        shipmeta.id = testShipProvider.Id;
        shipmeta.maxPackageWeight= 100.90;
        shipmeta.minPackageWeight = 10.89;
        shipmeta.accountNumber ='AB56';
        shipmeta.endPoint ='https://api.test.com/endpoint';
        shipmeta.httpMethod = 'POST';
        shipmeta.shippinggMethodNames ='Standard, Express';
        shipmeta.serviceTimeout ='30';
        shipmeta.requestJSON='{"key": "value"}';
        shipmeta.providerImplClass ='TestProviderClass';
        shipmeta.mockedResponse ='{"response": "mocked"}';
        shipmeta.serviceImplClass ='TestServiceClass';
        shipmeta.addMetaData('key2', 100);
        shipmeta.serviceMode ='Test';
        shipmeta.getMetaData('Test');
        shipmeta.namedCredentials= 'TestCredentials';
        shipproviderList.add(shipmeta);
        Test.startTest();
        ShippingCartCalculatorExtension shipCartExt = new ShippingCartCalculatorExtension();
        shipCartExt.calculate(calculatorRequest);
        shipCartExt.setShippingOptionsInCart(shippingMethodsWithRate, cartDeliveryGroupMethods, shippingProduct, shipmeta);
        Test.stopTest();
    }
    private virtual List<ShippingMetaData> getMetaData(String webStoreId) {
    return ShippingDetails.getMetaDataDTO(webStoreId);
  	}
    private static ShippingMetaData createShippingMetaData(String providerClass) {
        ShippingMetaData shippingMetaData = new ShippingMetaData();
        shippingMetaData.providerImplClass = providerClass;
        return shippingMetaData;
    }
    @isTest
    public static void getMetaDataTest(){
        WebStore testWebStore = new WebStore(Name='Training');
        insert testWebStore;
        Test.startTest();
        ShippingCartCalculatorExtension shipCartExt = new ShippingCartCalculatorExtension();
        shipCartExt.getMetaData(testWebStore.Id);
        Test.stopTest();
        
        
    }
  
    
    
    private static CartExtension.Cart arrangeCart() {
        Account testAccount = new Account(Name='My Account');
        insert testAccount;
        
        WebStore testWebStore = new WebStore(Name='Training');
        insert testWebStore;
        
        WebCart testCart = new WebCart(Name='My Cart', WebStoreId=testWebStore.Id, AccountId=testAccount.Id);
        insert testCart;
        
        CartDeliveryGroup testDeliveryGroup = new CartDeliveryGroup(Name='My Delivery Group', CartId=testCart.Id,DeliverToStreet= '123Street',DeliverToCity='San Francisco',DeliverToCountry='United States',DeliverToPostalCode='11098',DeliverToState='Maryland');
        insert testDeliveryGroup;
        Product2 testProduct2 = new Product2(name='My Product2',Tax_Class_Id__c='Test',Taxable__c=false,family='Shipping');
        insert(testProduct2);
        CartItem testCartItem2 = new CartItem(Name='My Cart Item 2',Product2Id=testProduct2.Id, Type ='Product',CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItem2;
        
        
        
        WebCartAdjustmentBasis testCartAdjustmentBasis = new WebCartAdjustmentBasis(Name='My Coupon', WebCartId=testCart.Id);
        insert testCartAdjustmentBasis;
        CartValidationOutput cartValidate = new CartValidationOutput(Name='cartValidate', Type = 'Shipping',CartId=testCart.Id, Level = 'Info',RelatedEntityId = testCartItem2.Id);
        insert cartValidate;
        
        return CartExtension.CartTestUtil.getCart(testCart.Id);
    }
    private static CartExtension.BuyerActionsMock getBuyerActionsForAddToCart(CartExtension.Cart cart) {
        return getCartItemChangedBuyerActions(cart);
    } 
    private static CartExtension.BuyerActionDetails getBuyerActionDetailsForAddToCart(CartExtension.CartItem addedCartItem) {
        CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
            .withChangedItem(CartExtension.OptionalCartItem.of(addedCartItem))
            .withAdded(True)
            .build();
        List<CartExtension.CartItemChange> changedCartItems = new List<CartExtension.CartItemChange>{cartItemChange};
            CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
            .withCartItemChanges(changedCartItems)
            .build();
        return buyerActionDetails;
    }
    private static CartExtension.BuyerActionsMock getCartItemChangedBuyerActions(CartExtension.Cart cart) {
        CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(cart);
        buyerActions.setCartItemChanged(True);
        return buyerActions;
    }
      public static Shipping_Provider__mdt getCustomMetadataRecord() {
        Shipping_Provider__mdt testShipProvider = new Shipping_Provider__mdt(
            Context_Name__c = 'Training',
            Context_Locale__c = 'en_US',
            Impl_Class__c = 'InternalShippingProvider'
        ); 
        return testShipProvider;
    }
}