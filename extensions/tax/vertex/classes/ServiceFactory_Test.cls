@isTest
public class ServiceFactory_Test {
   @IsTest
    static void testGetServiceWithClassName() {
        HTTPService service = ServiceFactory.getService('HTTPService');
        System.assertNotEquals(null, service, 'Service should not be null');
    }

    @IsTest
    static void testGetServiceWithoutClassName() {
        HTTPService service = ServiceFactory.getService(null);
        System.assertNotEquals(null, service, 'Service should not be null');
    }
    
}