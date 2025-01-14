@isTest
public class GenericFieldInputControllerTest {

   @testSetup 
   static void setup() {
        Account testAccount = new Account(
            Name = 'TestAccount'
        );
        insert testAccount;
        WebStore testWebStore = new WebStore(
            Name = 'TestWebStore', 
            DefaultLanguage = 'en_US'
        );
        insert testWebStore;
        
        WebCart cart = new WebCart(
            Name = 'Cart', 
            WebStoreId = testWebStore.Id, 
            AccountId = testAccount.Id
        );
        insert cart;
        
        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup(
            CartId = cart.Id, 
            Name = 'Default Delivery'
        );
        insert cartDeliveryGroup;
        
        CartItem cartItem = new CartItem(
            CartId = cart.Id, 
            Sku = 'SKU_Test1', 
            SalesPrice = 10.00, 
            Quantity = 3.0, 
            Type = 'Product', 
            Name = 'TestProduct', 
            CartDeliveryGroupId = cartDeliveryGroup.Id
        );
        insert cartItem;
    }

    @isTest 
    static void testUpdateCartRequestedDeliveryDate() {
        WebCart cart = [
            SELECT Id 
            FROM WebCart 
            LIMIT 1
        ];
        Test.startTest();
        GenericFieldInputController.updateGenericRecordByCartId(cart.Id, '[{"objectApiName":"WebCart"}]', 'Requested_Delivery_Date__c', '2024-08-15');
        Test.stopTest();

        cart = [
            SELECT Id, Requested_Delivery_Date__c
            FROM WebCart 
            LIMIT 1
        ];

        Date updatedRequestedDate = Date.valueOf('2024-08-15');
        System.assertEquals(updatedRequestedDate, cart.Requested_Delivery_Date__c, 'Requested_Delivery_Date__c should be updated to 2024-08-15 value.');
    }

    @isTest 
    static void testUpdateCartDeliveryGroupShippingAddress() {
        WebCart cart = [
            SELECT Id 
            FROM WebCart 
            LIMIT 1
        ];
        Test.startTest();
        GenericFieldInputController.updateGenericRecordByCartId(cart.Id, '[{"objectApiName":"CartDeliveryGroup"}]', 'ShippingInstructions', 'testShippingInstructions');
        Test.stopTest();

        CartDeliveryGroup cartDeliveryGroup = [
            SELECT Id, ShippingInstructions
            FROM CartDeliveryGroup
            LIMIT 1
        ];

        System.assertEquals('testShippingInstructions', cartDeliveryGroup.ShippingInstructions, 'ShippingInstructions should be updated totestShippingInstructions value.');
    }
}