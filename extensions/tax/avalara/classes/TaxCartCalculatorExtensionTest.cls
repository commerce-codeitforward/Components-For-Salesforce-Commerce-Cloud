@IsTest
public class TaxCartCalculatorExtensionTest {
     @testSetup static void setup() {
        Account account = new Account(Name='TestAccount');
        insert account;
        WebStore webStore = new WebStore(Name='Training', SupportedLanguages='en_US', DefaultLanguage='en_US',  Tax_Document_Type__c ='INVOICE',Tax_Transaction_Type__c ='SALE');
        insert webStore;
        WebCart cart = new WebCart(Name='Cart', WebStoreId=webStore.Id, AccountId=account.Id);
        insert cart;
        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup(CartId=cart.Id, Name='Default Delivery');
        insert cartDeliveryGroup;
        CartItem cartItem = new CartItem(
            CartId=cart.Id,
            Sku='SKU_Test1',
            Quantity=3.0,
            Type='Product',
            Name='TestProduct',
            CartDeliveryGroupId=cartDeliveryGroup.Id
        );
        insert cartItem;
    }
    
    @isTest
    static void testCalculate(){
        CartExtension.Cart cart = arrangeCart();
        String name = 'Training';
        Tax_Provider__mdt taxProvider = getCustomMetadataRecord(name);
        CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForDeleteFromCart(cart);
        CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForQuantityIncrease(cart.getCartItems().get(0));
        CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(buyerActionDetails);
        CartExtension.CartCalculateCalculatorRequest Cartrequest = new CartExtension.CartCalculateCalculatorRequest(cart,optionalBuyerActionDetails);
      
        Test.startTest();
        TaxCartCalculatorExtension taxCaluculate = new TaxCartCalculatorExtension();
        
        taxCaluculate.calculate(Cartrequest);
        Test.stopTest();
    }
    @isTest
    static void testcreateTaxRequest(){
        CartExtension.Cart cart = arrangeCart();
        TaxMetaData taxMetaData = getTaxMeta ();
        Test.startTest();
        TaxCartCalculatorExtension taxCaluculate = new TaxCartCalculatorExtension();
        TaxProviderRequest taxprovider = taxCaluculate.createTaxRequest(cart, taxMetaData);
        System.assertnotEquals(taxprovider,null);
        Test.stopTest();
    }
     @isTest
    static void testsetTaxInCart(){
        CartExtension.Cart cart = arrangeCart();
        TaxMetaData taxMetaData = getTaxMeta ();
        TaxProviderResponse tpResponse = getTaxProviderResponse ();
        Test.startTest();
        TaxCartCalculatorExtension taxCaluculate = new TaxCartCalculatorExtension();
        taxCaluculate.setTaxInCart(cart, taxMetaData,tpResponse);
        Test.stopTest();
    }
    
   
    private static CartExtension.Cart arrangeCart() {
        Account testAccount = new Account(Name='My Account');
        insert testAccount;

        WebStore testWebStore = new WebStore(Name='Training',Tax_Document_Type__c ='INVOICE', Tax_Transaction_Type__c ='SALE');
        insert testWebStore;

        WebCart testCart = new WebCart(Name='My Cart', WebStoreId=testWebStore.Id, AccountId=testAccount.Id);
        insert testCart;

        CartDeliveryGroup testDeliveryGroup = new CartDeliveryGroup(Name='My Delivery Group', CartId=testCart.Id,DeliverToStreet='415 Mission St',DeliverToCity='San Francisco',DeliverToCountry='United States',DeliverToPostalCode='11098',DeliverToState='Maryland');
        insert testDeliveryGroup;
         Product2 testProduct2 = new Product2(name='My Product2',Tax_Class_Id__c='Test',Taxable__c=false);
        insert(testProduct2);

         Product2 testProduct = new Product2(name='My Product35',Tax_Class_Id__c='Test',Taxable__c=true);
        insert(testProduct);
        Product2 testProduct3 = new Product2(name='My Products',Taxable__c=true);
        insert(testProduct3);

        CartItem testCartItem = new CartItem(Name='My Cart Item',Product2Id=testProduct.Id,Type ='Charge', CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItem;
        CartItem testCartItemed = new CartItem(Name='My Cart Item',Product2Id=testProduct3.Id,Type ='Charge', CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItemed;
        CartItem testCartItem2 = new CartItem(Name='My Cart Item 2',Product2Id=testProduct2.Id, Type ='Product',CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItem2;
        CartItem testCartItem3 = new CartItem(Name='My Cart Item 2',Product2Id=testProduct.Id, Type ='Product',CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItem3;
         CartItem testCartItem4 = new CartItem(Name='My Cart Item 2',Product2Id=testProduct3.Id, Type ='Product',CartId=testCart.Id, CartDeliveryGroupId=testDeliveryGroup.Id);
        insert testCartItem4;
        CartTax cartTax = new CartTax( CartItemId=testCartItem.Id, Name='CartTax', Amount=20.00,TaxType='Actual',TaxCalculationDate=date.newInstance(2023, 10, 21) );
        insert cartTax;
        CartValidationOutput cartValidate = new CartValidationOutput(Name='cartValidate', Type = 'Taxes',CartId=testCart.Id, Level = 'Info',RelatedEntityId = testCartItem.Id);
        insert cartValidate;
       Promotion promotion = new Promotion(Name ='Promotion', IsActive =true, IsCommercePromotion = true,IsAutomatic= false);
        insert promotion;
        CartItemPriceAdjustment cartItemAdj = new CartItemPriceAdjustment(PriceAdjustmentCauseId=promotion.id,  CartId=testCart.Id,CartItemId=testCartItem.Id,Name ='cartItemAdj',TotalAmount=45.00, AdjustmentSource ='Rule', AdjustmentType ='AdjustmentPercentage', AdjustmentValue =90.00, AdjustmentTargetType='Cart');
        insert cartItemAdj;
        WebCartAdjustmentBasis testCartAdjustmentBasis = new WebCartAdjustmentBasis(Name='My Coupon', WebCartId=testCart.Id);
        insert testCartAdjustmentBasis;

        return CartExtension.CartTestUtil.getCart(testCart.Id);
    }
    private static TaxMetaData getTaxMeta (){
        TaxMetaData taxMetaData = new TaxMetaData();
        taxMetaData.shippingItemsTaxable = false;
        taxMetaData.useProductTaxCodes =true;
        taxMetaData.productTaxExemption = true;
        taxMetaData.defaultProductTaxCode ='Testing';
        taxMetaData.defaultShippingTaxCode='TestShip';
        return taxMetaData;
    }
    private static TaxProviderResponse getTaxProviderResponse (){
        TaxProviderResponse taxProviderResponse = new TaxProviderResponse();
        Map<String, TaxableCartItem> taxableMap = new Map<String, TaxableCartItem>();
        List<LineItemTaxDetails> lineItemTexasList = new List<LineItemTaxDetails>();
        taxProviderResponse.taxableCartItems = taxableMap;
        TaxableCartItem taxableCartItem = new TaxableCartItem();
        taxableMap.put(taxableCartItem.id,taxableCartItem);
        taxableCartItem.amount = 100.00;
        taxableCartItem.quantity = 1;
        taxableCartItem.sku = 'ABC';
        taxableCartItem.lineItemType = 'Product';
        taxableCartItem.taxClassId = 'Taxable';
        taxableCartItem.productExemptionCode = 'None';
        taxableCartItem.entityUseCode = 'None';
        taxableCartItem.street = '123 Main St';
        taxableCartItem.city = 'Anytown';
        taxableCartItem.state = 'CA';
        taxableCartItem.postalCode = '12345';
        taxableCartItem.country = 'US';
        taxableCartItem.lineItemTexas = lineItemTexasList;
        LineItemTaxDetails lineItemTaxDetails = new LineItemTaxDetails();
        lineItemTaxDetails.rate = 0.0825;
        lineItemTaxDetails.tax = 8.25;
        lineItemTaxDetails.taxName = 'California State Tax';
        lineItemTaxDetails.taxType = 'SalesTax';
        lineItemTexasList.add(lineItemTaxDetails);
        return taxProviderResponse;
    }
    private static CartExtension.BuyerActionsMock getBuyerActionsForDeleteFromCart(CartExtension.Cart cart) {
        return getCartItemChangedBuyerActions(cart);
    }
    private static CartExtension.BuyerActionDetails getBuyerActionDetailsForQuantityIncrease(CartExtension.CartItem cartItemWithIncreasedQuantity) {
        CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
                                                            .withChangedItem(CartExtension.OptionalCartItem.of(cartItemWithIncreasedQuantity))
                                                            .withQuantityIncreased(True)
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
    public static Tax_Provider__mdt getCustomMetadataRecord(String myName) {
         Tax_Provider__mdt testTaxProvider = new Tax_Provider__mdt(
            Context_Name__c = myName,
            Context_Locale__c = 'en_GB',
            Taxation_Policy__c = 'Standard',
            Customer_Code__c = 'Cust123',
            Company_Code__c = 'Comp456',
            Shipping_Items_Taxable__c = true,
            Default_Shipping_Tax_Code__c = 'ShippingTax',
            Default_Product_Tax_Code__c = 'ProductTax',
            Consider_product_tax_codes__c = true,
            Product_Tax_Exemption__c = false,
            Customer_Tax_Exemption__c = true,
            Document_Type__c = 'INVOICE',
            Transaction_Type__c = 'SALE',
            Commit__c = true,
            Address_Line1__c = '123 Test St',
            Address_Line2__c = 'Suite 100',
            City__c = 'Test City',
            State__c = 'Test State',
            Zip_Code__c = '12345',
            Country_Code__c = 'USA',
            Impl_Class__c = 'TestImplClass',
            Request_Template__c = '{"request": "template"}'
      			); 
        return testTaxProvider;
    }
    private static TaxProviderRequest  taxProviderRequest(){
        WebCart webCart = [SELECT Id FROM WebCart WHERE Name = 'Cart' LIMIT 1];
        TaxProviderRequest taxProvider = new TaxProviderRequest();
         TaxMetaData taxmeta = new TaxMetaData();
        taxProvider.street ='1600 Massachusetts Avenue';
        taxProvider.city = 'Washington';
        taxProvider.state = 'Washington DC';
        taxProvider.postalCode = '20011';
        taxProvider.country = 'United States';
        taxProvider.cartId = webCart.id;
        taxProvider.hasMultipleShipments = true;
        taxProvider.taxMetaData = taxmeta;
        taxProvider.getData('Test');
        taxProvider.addData('Test', webCart);
        Tax_Provider__mdt testTaxProvider =[Select id from Tax_Provider__mdt where Impl_Class__c = 'TestImplClass' LIMIT 1];
        taxmeta.id = testTaxProvider.Id;
        taxmeta.endPoint ='https://api.test.com/endpoint';
        taxmeta.httpMethod = 'POST';
        taxmeta.serviceTimeout ='30';
        taxmeta.requestJSON='{"key": "value"}';
        taxmeta.providerImplClass ='TestProviderClass';
        taxmeta.mockedResponse ='{"response": "mocked"}';
        taxmeta.serviceImplClass ='TestServiceClass';
        taxmeta.addMetaData('key2', 100);
        taxmeta.serviceMode ='Test';
        taxmeta.getMetaData('Test');
        taxmeta.namedCredentials= 'TestCredentials';
        return taxProvider;
    }
    private static void assertNoCartValidationOutputs(CartExtension.Cart cart) {
        String errorString = '';
        Iterator<CartExtension.CartValidationOutput> cvoIterator = cart.getCartValidationOutputs()
            .iterator();
        while (cvoIterator.hasNext()) {
            errorString += cvoIterator.next().getMessage() + '; ';
        }
    }
     
}