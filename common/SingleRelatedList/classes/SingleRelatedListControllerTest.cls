@isTest
private class SingleRelatedListControllerTest {

    // @isTest
    // static void myUnitTest() {
    //     // TO DO: implement unit test
    // }

    @IsTest
    static void testGetFieldSetFields() {
        
        SingleRelatedListController.FieldSetWrapper result;
        Test.startTest();
        try {
            result = SingleRelatedListController.getFieldSetFields('Account', 'Invalid_Field_Set');
        } catch (Exception e) {
            System.assertEquals('Could not find field set Invalid_Field_Set on the object Account', e.getMessage());
        }
        Test.stopTest();
        // Assert.

    }

    @IsTest
    static void testGetRecordValues() {
        // Create test data
        Account parentAccount = new Account(Name='Parent Account');
        insert parentAccount;
        Account childAccount = new Account(Name='Child Account', ParentId=parentAccount.Id);
        insert childAccount;
        List<Account> childAccounts = new List<Account>();
        childAccounts.add(childAccount);

        // Call the method to test
        Test.startTest();
        List<SObject> result = SingleRelatedListController.getRecordValues('Account', 'Test_Field_Set', 'ParentId', parentAccount.Id, 'Id', 'Name', 'Child Account');
        Test.stopTest();

        // Verify the results
        Assert.isTrue(result.size() == childAccounts.size());
        Assert.areEqual(result[0].Id, childAccount.Id);
    }

    @IsTest
    static void testFieldWrapperIFieldMember() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.BOOLEAN;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('boolean', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldSetWrapperEmpty() {
        SingleRelatedListController.FieldSetWrapper wrapper;
        Test.startTest(); 
        wrapper = new SingleRelatedListController.FieldSetWrapper();
        Test.stopTest();

        Assert.areEqual('', wrapper.fieldSetLabel);
        Assert.areEqual(0, wrapper.fieldList.size());
    }

    @IsTest
    static void testFieldSetWrapper() {
        SingleRelatedListController.FieldSetWrapper wrapper;
        Test.startTest(); 
        wrapper = new SingleRelatedListController.FieldSetWrapper();
        wrapper.fieldSetLabel = 'Field Set Label'; 
        
        SingleRelatedListController.FieldWrapper fieldWrapper = new SingleRelatedListController.FieldWrapper();
        fieldWrapper.fieldName = 'Name';
        fieldWrapper.label = 'Label';
        fieldWrapper.type = 'boolean';
        fieldWrapper.isRequired = true;
        List<SingleRelatedListController.FieldWrapper> fieldWrapperList = new List<SingleRelatedListController.FieldWrapper>();
        fieldWrapperList.add(fieldWrapper);
        wrapper.fieldList = fieldWrapperList;
        Test.stopTest();

        Assert.areEqual('Field Set Label', wrapper.fieldSetLabel);
        Assert.areEqual(1, wrapper.fieldList.size());
    }

    @IsTest
    static void testFieldSetWrapperWList() {
        SingleRelatedListController.FieldSetWrapper wrapper;
        SingleRelatedListController.FieldWrapper fieldWrapper = new SingleRelatedListController.FieldWrapper();
        fieldWrapper.fieldName = 'Name';
        fieldWrapper.label = 'Label';
        fieldWrapper.type = 'boolean';
        fieldWrapper.isRequired = true;

        List<SingleRelatedListController.FieldWrapper> fieldWrapperList = new List<SingleRelatedListController.FieldWrapper>();
        fieldWrapperList.add(fieldWrapper);

        Test.startTest(); 
        wrapper = new SingleRelatedListController.FieldSetWrapper('Field Set Label', fieldWrapperList);
        Test.stopTest();

        Assert.areEqual('Field Set Label', wrapper.fieldSetLabel);
        Assert.areEqual(1, wrapper.fieldList.size());
    }

    @IsTest
    static void testFieldWrapperBoolean() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.BOOLEAN;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('boolean', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperCurrency() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.CURRENCY;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('currency', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperDate() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.DATE;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('date', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperDateTime() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.DATETIME;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('date', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperDouble() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.DOUBLE;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('number', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperInteger() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.INTEGER;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('number', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperLong() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.LONG;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('number', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperEmail() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.EMAIL;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('email', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }
    @IsTest
    static void testFieldWrapperPercent() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.PERCENT;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('percent', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }
    @IsTest
    static void testFieldWrapperPhone() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.PHONE;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('phone', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }
    @IsTest
    static void testFieldWrapperURL() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.URL;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('url', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }
    @IsTest
    static void testFieldWrapperAddress() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.ADDRESS;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('text', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);

    }

    @IsTest
    static void testFieldWrapperCellAttributes() {

        SingleRelatedListController.iFieldSetMember iWrapper = new SingleRelatedListController.iFieldSetMember();
        iWrapper.fieldPath = 'Name';
        iWrapper.label = 'Label';
        iWrapper.type = Schema.DisplayType.BOOLEAN;
        iWrapper.required = true;

        SingleRelatedListController.FieldWrapper wrapper;
        Test.startTest();
        wrapper = new SingleRelatedListController.FieldWrapper(iWrapper);
        wrapper.cellAttributes = new Map<String, String> {
            'alignment' => 'left',
            'iconName' => 'custom:custom5',
            'imageUrl' => 'url',
            'initials' => 'Initials',
            'backgroundColor' => 'green',
            'fontColor' => 'white'
        };
        Test.stopTest();

        Assert.areEqual('Name', wrapper.fieldName);
        Assert.areEqual('Label', wrapper.label);
        Assert.areEqual('boolean', wrapper.type);
        Assert.areEqual(true, wrapper.isRequired);
        Assert.areEqual('left', wrapper.cellAttributes.get('alignment'));
        Assert.areEqual(6, wrapper.cellAttributes.size());

    }


}