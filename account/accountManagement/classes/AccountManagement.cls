public with sharing class AccountManagement {
    @TestVisible
    private static Boolean forceException = false;

    @TestVisible
    private static Boolean multiCurrencyEnabled = Schema.getGlobalDescribe().containsKey('CurrencyType');

    @TestVisible
    private static Boolean testDelegatedExternalUserAdmin = false;

    @AuraEnabled(cacheable=true)
    public static Boolean getMultiCurrencyEnabled() {
        return multiCurrencyEnabled;
    }

    /**
     * returns constants for the component
     * @return ConstantClass
     */
    @AuraEnabled(cacheable=true)
    public static ConstantClass getConstants() {
        return new ConstantClass();
    }

    /**
     * returns the list of users for the given account ID
     * @param accountId - account ID
     * @return {List<User>} list of users
     */
    public static List<User> getUsersByAccountId(String accountId) {
        if (String.isBlank(accountId)) {
            System.debug('Could not get users for account: ' + accountId);
            return new List<User>();
        }
        return [SELECT Id, Name, Email, Title, IsActive
            FROM User
            WHERE AccountId = :accountId
            WITH USER_MODE];
    }

    private static String buildQuery(String accountId, String webStoreId) {
        String query = 'SELECT Id, Name, OwnerId, Owner.Name, TotalProductAmount';
        if (multiCurrencyEnabled) {
            query += ', CurrencyIsoCode';
        }
        query += ' FROM WebCart WHERE Status = \'Active\' AND AccountId = :accountId AND WebStoreId = :webStoreId WITH USER_MODE';
        return query;
    }

    /**
     * returns the list of web carts for the given account and web store IDs
     * @param accountId - account ID
     * @param webStoreId - web store ID
     * @return {List<WebCart>} list of web carts
     */
    public static List<WebCart> getWebCartsByAccountId(String accountId, String webStoreId) {
        if (String.isBlank(accountId) || String.isBlank(webStoreId)) {
            System.debug('Could not get web carts for account: ' + accountId + ' and web store: ' + webStoreId);
            return new List<WebCart>();
        }

        String query = buildQuery(accountId, webStoreId);
        List<WebCart> webCarts;
        try {
            webCarts = Database.query(query);
        } catch (QueryException e) {
            if (e.getMessage().contains('CurrencyIsoCode')) {
                query = query.replace(', CurrencyIsoCode', '');
                webCarts = Database.query(query);
            }
        }
        return webCarts;
    }

    /**
     * returns List of either web carts or users for the given account ID
     * @param accountId - account ID
     * @param webStoreId - web store ID
     * @param activeTab - active tab
     * @return {List<SObject>} list of web carts or users
     */
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

    /**
     * returns the list of contacts for the given account ID
     * @param accountId - account ID
     * @return {List<Contact>} list of contacts
     */
    @AuraEnabled
    public static List<Contact> getAccountContacts(String accountId) {
        if (String.isBlank(accountId)) {
            return new List<Contact>();
        }

        // return contacts for the account that are not already portal users
        return [SELECT Id, Name, FirstName, LastName, Email, Title
            FROM Contact
            WHERE AccountId = :accountId
            AND Id NOT IN (SELECT ContactId FROM User WHERE AccountId = :accountId AND IsActive = TRUE AND ContactId != null)
            WITH USER_MODE
            ORDER BY LastName, FirstName];
    }

    /**
     * This method is used to determine if the current user is a delegated portal admin
     * @param userId - user ID
     * @return {Boolean} true if the user is a delegated portal admin
     */
    @AuraEnabled(cacheable=true)
    public static Boolean isDelegatedExternalUserAdmin(String userId) {
        Boolean isDelegatedExternalUserAdminTest = (Test.isRunningTest() && AccountManagement.testDelegatedExternalUserAdmin);
        if (String.isBlank(userId)) {
            return false;
        }
        User u = [SELECT Profile.PermissionsDelegatedPortalUserAdmin FROM User WHERE Id = :userId];
        if ((u != null && u.Profile.PermissionsDelegatedPortalUserAdmin) || isDelegatedExternalUserAdminTest) {
            return true;
        }
        List<PermissionSetAssignment> assignments = [
            SELECT PermissionSet.PermissionsDelegatedPortalUserAdmin
            FROM PermissionSetAssignment
            WHERE AssigneeId = :userId
        ];
        for (PermissionSetAssignment assignment : assignments) {
            if (assignment.PermissionSet.PermissionsDelegatedPortalUserAdmin) {
                return true;
            }
        }
        return false;
    }

    /**
     * get the timezone, language, locale, and email encoding options for the user
     * @param objectName
     * @param fieldName
     * @return JSON string of the options
     */
    @AuraEnabled(cacheable=true)
    public static String getDynamicPicklistOptions(String objectName, String fieldName) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        if (targetType != null) {
            Schema.SObjectField field = targetType.getDescribe().fields.getMap().get(fieldName);
            if (field != null) {
                List<Schema.PicklistEntry> entries = field.getDescribe().getPicklistValues();
                for (Schema.PicklistEntry entry : entries) {
                    Map<String, String> option = new Map<String, String>();
                    option.put('label', entry.getLabel());
                    option.put('value', entry.getValue());
                    options.add(option);
                }
            }
        }
        return JSON.serialize(options);
    }

    /**
     * get the list of selected profiles for the given community ID
     * @param communityId - community ID
     * @return JSON string of the list of profiles
     */
    @AuraEnabled(cacheable=true)
    public static List<Profile> getSelectedProfilesForCommunity(String communityId) {
        // Query the NetworkMemberGroup object to get the member IDs
        List<NetworkMemberGroup> members = [
                SELECT ParentId
                FROM NetworkMemberGroup
                WHERE NetworkId = :communityId
        ];

        // Extract the member IDs from the NetworkMemberGroup records
        List<Id> memberIds = new List<Id>();
        for (NetworkMemberGroup member : members) {
            memberIds.add(member.ParentId);
        }

        // Query the Profile object to get the profiles
        List<String> profileNamesToExclude = new List<String>();
        profileNamesToExclude.add('System Administrator');
        List<Profile> profiles = [
            SELECT Id, Name
            FROM Profile
            WHERE Id IN :memberIds
            AND Name NOT IN :profileNamesToExclude
        ];

        return profiles;
    }

    @AuraEnabled
    public static Map<String, Object> createContactUser(Map<String, Object> userMap, String accountId, String userId, List<String> permissionSetNames) {
        // Check if the current user is a delegated external admin
        if (!isDelegatedExternalUserAdmin(userId)) {
            String errorMessage = 'Current user is not a delegated external admin';
            AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
            auraHandledException.setMessage(errorMessage);
            throw auraHandledException;
        }

        User user = new User();
        Contact contact = new Contact();
        Savepoint sp = Database.setSavepoint(); // Set a savepoint before DML operations

        try {
            Id contactId = (String) userMap.get('ContactId');
            if (contactId != null) {
                contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];
            } else {
                contact.FirstName = (String) userMap.get('FirstName');
                contact.LastName = (String) userMap.get('LastName');
                contact.Email = (String) userMap.get('Email');
                contact.AccountId = accountId;
                Database.SaveResult sr1 = Database.insert(contact, false); // Insert contact and check for success

                if (!sr1.isSuccess()) {
                    Database.rollback(sp); // Rollback if insert operation was not successful
                    String errorMessage = 'Failed to create contact';
                    AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
                    auraHandledException.setMessage(errorMessage);
                    throw auraHandledException;
                }
            }

            Map<String, Schema.SObjectField> userFields = Schema.SObjectType.User.fields.getMap();
            user.ContactId = contact.Id;
            user.FirstName = (String) userMap.get('FirstName');
            user.LastName = (String) userMap.get('LastName');
            user.Email = (String) userMap.get('Email');
            user.Username = (String) userMap.get('Username');
            user.Alias = (String) userMap.get('Alias');
            user.CommunityNickname = (String) userMap.get('CommunityNickname');
            user.TimeZoneSidKey = (String) userMap.get('TimeZoneSidKey');
            user.LocaleSidKey = (String) userMap.get('LocaleSidKey');
            user.LanguageLocaleKey = (String) userMap.get('LanguageLocaleKey');
            user.EmailEncodingKey = (String) userMap.get('EmailEncodingKey');
            user.ProfileId = (String) userMap.get('ProfileId');
            user.IsActive = true;

            if (userFields.containsKey('DefaultCurrencyIsoCode')) {
                user.put('DefaultCurrencyIsoCode', (String) userMap.get('DefaultCurrencyIsoCode'));
            }
            Database.SaveResult sr2 = Database.insert(user, false); // Insert user and check for success

            if (!sr2.isSuccess()) {
                Database.rollback(sp); // Rollback if insert operation was not successful
                String errorMessage = 'Failed to create user: ' + sr2.getErrors()[0].getMessage();
                AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
                auraHandledException.setMessage(errorMessage);
                throw auraHandledException;
            }

            // After the User is successfully created, assign the Permission Sets
            if (permissionSetNames != null && permissionSetNames.size() > 0) {
                // ensure permission sets are valid
                List<PermissionSet> validPermissionSets = [
                    SELECT Id
                    FROM PermissionSet
                    WHERE Name IN :permissionSetNames
                ];
                List<Id> permissionSets = new List<Id>();
                for (PermissionSet ps : validPermissionSets) {
                    permissionSets.add(ps.Id);
                }

                System.debug('valid permission sets to assign: ' + permissionSets);
                List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
                for (Id permissionSetId : permissionSets) {
                    PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(
                        PermissionSetId = permissionSetId,
                        AssigneeId = user.Id
                    );
                    permissionSetAssignments.add(permissionSetAssignment);
                }

                // Enqueue a job to perform the DML operations on the setup objects in a separate transaction
                System.debug('Enqueuing job...');
                Id jobId = System.enqueueJob(new AccountManagementJob(permissionSetAssignments));
                System.debug('Job enqueued with Id: ' + jobId);
            }
        } catch (Exception e) {
            Database.rollback(sp); // Rollback if any other exception occurs
            String errorMessage = e.getMessage();
            AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
            auraHandledException.setMessage(errorMessage);
            throw auraHandledException;
        }

        Map<String, Object> result = new Map<String, Object>{
            'success' => true,
            'userId' => user.Id,
            'contactId' => contact.Id
        };
        return result;
    }
}