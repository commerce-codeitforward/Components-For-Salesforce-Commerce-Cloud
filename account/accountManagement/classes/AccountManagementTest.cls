@IsTest
public class AccountManagementTest {
    static final String TEST_ACCOUNT_NAME = 'TestAccount';
    static final String TEST_WEBSTORE_NAME = 'Test WebStore 0';
    static final String TEST_SITE_USER_EMAIL = 'test@communityuser.com';

    @TestSetup static void setupTestData() {
        // create 5 test webStores
        List<WebStore> testWebStores = new List<WebStore>();
        for (Integer i = 0; i < 5; i++) {
            testWebStores.add(new WebStore(Name = 'Test WebStore ' + i));
        }
        insert testWebStores;

        Account acct = new Account(Name = TEST_ACCOUNT_NAME);
        insert acct;

        Contact con = new Contact(
                FirstName = 'TestFirstName',
                LastName = 'TestLastName',
                Email = 'testuser@example.com',
                AccountId = acct.Id,
                Title = 'TestTitle'
        );
        insert con;

        User communityUser;
        User userWithRole;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            // create test user role
            UserRole testRole = new UserRole(Name = 'CEO');
            insert testRole;

            // create test user with role
            userWithRole = new User(
                    Alias = 'hasrole',
                    Email = 'userwithrole@roletest.com',
                    UserRoleId = testRole.Id,
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'Testing',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    ProfileId = UserInfo.getProfileId(),
                    TimeZoneSidKey = 'America/Los_Angeles',
                    Username = 'userwithrole_' + Datetime.now().getTime() + '@test.com'
            );
            insert userWithRole;
        }

        System.runAs(userWithRole) {
            // Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User' LIMIT 1];
            Profile p = [SELECT Id FROM Profile WHERE UserType = 'PowerCustomerSuccess' LIMIT 1];
            communityUser = new User(
                    FirstName = 'TestFirstName',
                    LastName = 'TestLastName',
                    Email = TEST_SITE_USER_EMAIL,
                    Username = 'communityuser_' + Datetime.now().getTime() + '@test.com',
                    Alias = 'CCPUser',
                    TimeZoneSidKey = 'GMT',
                    LocaleSidKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    ProfileId = p.Id,
                    LanguageLocaleKey = 'en_US',
                    ContactId = con.Id);
            insert communityUser;
        }

        // Create various WebCarts related to the Account and webStoreId, and some unrelated
        for (Integer i = 0; i < 2; i++) {
            WebCart testWebCart = new WebCart(
                    Name = 'Test WebCart ' + i,
                    AccountId = acct.Id,
                    OwnerId = communityUser.Id,
                    Status = i == 0 ? 'Active' : 'Closed',
                    WebStoreId = testWebStores[0].Id
            );
            insert testWebCart;
        }

        WebCart testWebCart2 = new WebCart(
                Name = 'Test WebCart',
                AccountId = acct.Id,
                OwnerId = userWithRole.Id,
                Status = 'Active',
                WebStoreId = testWebStores[0].Id
        );
        insert testWebCart2;


        // create an unrelated account
        Account unrelatedAcct = new Account(Name = 'Unrelated Account');
        insert unrelatedAcct;
        for (Integer i = 0; i < 2; i++) {
            WebCart testWebCart = new WebCart(
                    Name = 'Test WebCart ' + i,
                    AccountId = unrelatedAcct.Id,
                    Status = i == 0 ? 'Active' : 'Closed',
                    WebStoreId = testWebStores[1].Id
            );
            insert testWebCart;
        }
    }

    @IsTest static void testGetConstants() {
        ConstantClass CONSTANTS = AccountManagement.getConstants();
        System.assertEquals('acct-mngt-carts', CONSTANTS.ACCT_MNGT_CARTS_TAB);
        System.assertEquals('acct-mngt-users', CONSTANTS.ACCT_MNGT_USERS_TAB);
    }

    @IsTest static void testGetUsersByAccountId() {
        Account acct = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNT_NAME LIMIT 1];
        List<User> result = AccountManagement.getUsersByAccountId(acct.Id);
        System.assertEquals(1, result.size());
        System.assertEquals(TEST_SITE_USER_EMAIL, result[0].get('Email'));
    }

    @IsTest static void testGetUsersByAccountIdWithBlankAcctId() {
        List<User> result = AccountManagement.getUsersByAccountId('');
        System.assertEquals(new List<User>(), result);
    }

    @IsTest static void testGetWebCartsByAccountId() {
        Account acct = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNT_NAME LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        List<WebCart> result = AccountManagement.getWebCartsByAccountId(acct.Id, webStore.Id);
        System.assertEquals(2, result.size());
    }

    @IsTest static void testGetWebCartsWithBlankAcctId() {
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        List<WebCart> result = AccountManagement.getWebCartsByAccountId('', webStore.Id);
        System.assertEquals(new List<WebCart>(), result);
    }

    @IsTest static void testGetWebCartsWithBlankWebStoreId() {
        Account acct = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNT_NAME LIMIT 1];
        List<WebCart> result = AccountManagement.getWebCartsByAccountId(acct.Id, '');
        System.assertEquals(new List<WebCart>(), result);
    }

    @IsTest static void testGetAccountDataUsersTab() {
        ConstantClass CONSTANTS = AccountManagement.getConstants();
        Account acct = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNT_NAME LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        List<SObject> result = AccountManagement.getAccountData(acct.Id, webStore.Id, CONSTANTS.ACCT_MNGT_USERS_TAB);
        System.assertEquals(1, result.size());
        System.assertEquals(User.SObjectType, result[0].getSObjectType());
        System.assertEquals(TEST_SITE_USER_EMAIL, result[0].get('Email'));
    }

    @IsTest static void testGetAccountDataCartsTab() {
        ConstantClass CONSTANTS = AccountManagement.getConstants();
        Account acct = [SELECT Id FROM Account WHERE Name = :TEST_ACCOUNT_NAME LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        List<SObject> result = AccountManagement.getAccountData(acct.Id, webStore.Id, CONSTANTS.ACCT_MNGT_CARTS_TAB);
        System.assertEquals(2, result.size());
        System.assertEquals(WebCart.SObjectType, result[0].getSObjectType());
    }

    @IsTest static void testGetAccountDataWithBlankAcctId() {
        ConstantClass CONSTANTS = AccountManagement.getConstants();
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        List<SObject> result = AccountManagement.getAccountData('', webStore.Id, CONSTANTS.ACCT_MNGT_CARTS_TAB);
        System.assertEquals(new List<SObject>(), result);
    }

    @IsTest static void testGetAccountDataThrowException() {
        ConstantClass CONSTANTS = AccountManagement.getConstants();
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name = :TEST_WEBSTORE_NAME LIMIT 1];
        AccountManagement.forceException = true;
        try {
            AccountManagement.getAccountData('invalidAccountId', webStore.Id, CONSTANTS.ACCT_MNGT_USERS_TAB);
        } catch (AuraHandledException e) {
            // Assert.isNotNull(e);
            Boolean containsExceptionMessage = e.getMessage().contains(CONSTANTS.TEST_EXCEPTION_MESSAGE);
            Assert.isTrue(containsExceptionMessage, 'contains exception message');
        }
    }
}