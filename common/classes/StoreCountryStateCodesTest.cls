@isTest
public class StoreCountryStateCodesTest {

    @testSetup
    static void setup() {
        // Create test data

        // Create a test Store
        WebStore store = new WebStore(Name = 'Test Store');
        insert store;

        // Create StoreCountryCode__c records
        List<StoreCountryCode__c> countryCodes = new List<StoreCountryCode__c>{
            new StoreCountryCode__c(Store__c = store.Id, Country__c = 'United States', Country_Code__c = 'US'),
            new StoreCountryCode__c(Store__c = store.Id, Country__c = 'Canada', Country_Code__c = 'CA')
        };
        insert countryCodes;

        // Create StoreStateCode__c records
        List<StoreStateCode__c> stateCodes = new List<StoreStateCode__c>{
            new StoreStateCode__c(Store__c = store.Id, State__c = 'California', State_Code__c = 'CA', Store_Country_Code__c = countryCodes[0].Id),
            new StoreStateCode__c(Store__c = store.Id, State__c = 'Ontario', State_Code__c = 'ON', Store_Country_Code__c = countryCodes[1].Id)
        };
        insert stateCodes;
    }

    @isTest
    static void testGetValidStateCodesByCode() {
        // Retrieve the test Store
        WebStore store = [SELECT Id FROM WebStore WHERE Name = 'Test Store' LIMIT 1];

        // Test the getValidStateCodesByCode method
        Test.startTest();
        Map<String, List<AddressOption>> stateCodes = StoreCountryStateCodes.getValidStateCodesByCode(store.Id);
        Test.stopTest();

        // Verify the results
        Assert.isTrue(!stateCodes.isEmpty(), 'State codes map should not be null');
        System.assertEquals(2, stateCodes.size(), 'There should be two country codes in the map');

        List<AddressOption> usStates = stateCodes.get('US');
        List<AddressOption> caStates = stateCodes.get('CA');

        System.assertEquals(1, usStates.size(), 'There should be one state for US');
        System.assertEquals('California', usStates[0].label, 'State label should be California');
        System.assertEquals('CA', usStates[0].value, 'State code should be CA');

        System.assertEquals(1, caStates.size(), 'There should be one state for CA');
        System.assertEquals('Ontario', caStates[0].label, 'State label should be Ontario');
        System.assertEquals('ON', caStates[0].value, 'State code should be ON');
    }

    @isTest
    static void testGetValidCountryCodes() {
        // Retrieve the test Store
        WebStore store = [SELECT Id FROM WebStore WHERE Name = 'Test Store' LIMIT 1];

        // Test the getValidCountryCodes method
        Test.startTest();
        List<AddressOption> countryCodes = StoreCountryStateCodes.getValidCountryCodes(store.Id);
        Test.stopTest();

        // Verify the results
        Assert.isTrue(countryCodes!=null, 'Country codes list should not be null');
        System.assertEquals(2, countryCodes.size(), 'There should be two country codes');

        AddressOption usCode = countryCodes[0];
        AddressOption caCode = countryCodes[1];

        System.assertEquals('United States', usCode.label, 'Country label should be United States');
        System.assertEquals('US', usCode.value, 'Country code should be US');
        System.assertEquals('Canada', caCode.label, 'Country label should be Canada');
        System.assertEquals('CA', caCode.value, 'Country code should be CA');
    }
}
