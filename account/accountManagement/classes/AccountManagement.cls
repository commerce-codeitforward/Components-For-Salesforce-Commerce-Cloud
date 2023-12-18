public with sharing class AccountManagement {
    @TestVisible
    private static Boolean forceException = false;

    @AuraEnabled(cacheable=true)
    public static ConstantClass getConstants() {
        return new ConstantClass();
    }

    public static List<User> getUsersByAccountId(String accountId) {
        if (String.isBlank(accountId)) {
            System.debug('Could not get users for account: ' + accountId);
            return new List<User>();
        }
        return [SELECT Id, Name, Email, Title, IsActive
            FROM User
            WHERE AccountId = :accountId WITH USER_MODE];
    }

    public static List<WebCart> getWebCartsByAccountId(String accountId, String webStoreId) {
        if (String.isBlank(accountId) || String.isBlank(webStoreId)) {
            System.debug('Could not get web carts for account: ' + accountId + ' and web store: ' + webStoreId);
            return new List<WebCart>();
        }
        return [SELECT Id, Name, OwnerId, Owner.Name, TotalProductAmount
            FROM WebCart
            WHERE Status = 'Active'
            AND AccountId = :accountId
            AND WebStoreId = :webStoreId WITH USER_MODE];
    }

    @AuraEnabled
    public static List<SObject> getAccountData(String accountId, String webStoreId, String activeTab) {
        try {
            ConstantClass CONSTANTS = getConstants();
            if (String.isBlank(accountId)) {
                return new List<SObject>();
            }

            if (Test.isRunningTest() && forceException) {
                String forceExceptionMessage = CONSTANTS.TEST_EXCEPTION_MESSAGE;
                AuraHandledException auraHandledException = new AuraHandledException(forceExceptionMessage);
                auraHandledException.setMessage(forceExceptionMessage);
                throw auraHandledException;
            }

            if (activeTab == CONSTANTS.ACCT_MNGT_CARTS_TAB) {
                return getWebCartsByAccountId(accountId, webStoreId);
            } else {
                return getUsersByAccountId(accountId);
            }
        } catch(Exception e) {
            String errorMessage = 'An exception occurred in AccountManagement: ' + e.getMessage();
            AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
            auraHandledException.setMessage(errorMessage);
            throw auraHandledException;
        }
    }
}