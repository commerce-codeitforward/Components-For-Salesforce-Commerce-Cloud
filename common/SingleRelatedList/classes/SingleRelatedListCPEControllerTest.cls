@isTest
private class SingleRelatedListCPEControllerTest {

    @isTest
    static void testGetObjectList() {
        
        List<SingleRelatedListCPEController.ObjectWrapper> result = new List<SingleRelatedListCPEController.ObjectWrapper>();
        Test.startTest();
        result = SingleRelatedListCPEController.getObjectList();
        Test.stopTest();

        Assert.isTrue(result.size() > 0);

    }

    @IsTest
    static void testGetRelatedObjects() {
        Test.startTest();   
        List<SingleRelatedListCPEController.ObjectWrapper> result = SingleRelatedListCPEController.getRelatedObjects('Account');
        Boolean hasContact = false;
        for(Integer i = 0; i < result.size(); i++) {
            if(result[i].value == 'Contact'){
                hasContact = true;
            } 
        }
        Test.stopTest();
        Assert.isTrue(result.size() > 0);
        Assert.areEqual(true, hasContact);
    }


    @IsTest
    static void testGetObjectFields() {
        Test.startTest();
        List<SingleRelatedListCPEController.ObjectWrapper> result = SingleRelatedListCPEController.getObjectFields('Account');
        Boolean hasField = false;
        for(Integer i = 0; i < result.size(); i++) {
            if(result[i].value == 'AccountNumber'){
                hasField = true;
            } 
        }
        
        Test.stopTest();
        Assert.isTrue(result.size() > 0);
        Assert.areEqual(true, hasField);
    }

    @IsTest
    static void testGetFieldSets() {
        Test.startTest();
        List<SingleRelatedListCPEController.ObjectWrapper> result = SingleRelatedListCPEController.getFieldSets('Account');
        Test.stopTest();
        Assert.areEqual(0, result.size());
    }
        
}