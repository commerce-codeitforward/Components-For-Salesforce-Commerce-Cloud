@isTest
public class AddressOptionTest {

    @isTest
    static void testAddressOptionConstructor() {
        // Create an instance of AddressOption
        String testLabel = 'United States';
        String testValue = 'US';
        String testId = '0017F00000ABCDEFQW';

        AddressOption addressOption = new AddressOption(testLabel, testValue, testId);

        // Verify that the properties are initialized correctly
        System.assertEquals(testLabel, addressOption.label, 'Label should be initialized correctly.');
        System.assertEquals(testValue, addressOption.value, 'Value should be initialized correctly.');
        System.assertEquals(testId, addressOption.id, 'ID should be initialized correctly.');
    }
}
