public with sharing class StoreCountryStateCodes {

    @AuraEnabled(cacheable=true)
    public static Map<String, List<AddressOption>> getValidStateCodesByCode(Id storeId) {
        try {
            List<StoreStateCode__c> codeRecs = [SELECT Id, State__c, State_Code__c, Store_Country_Code__r.Country_Code__c FROM StoreStateCode__c  WHERE Store__c = :storeId WITH SECURITY_ENFORCED];

            // A map to hold country codes and their list of regions
            Map<String, List<AddressOption>> countryStatesMap = new Map<String, List<AddressOption>>();


            for (StoreStateCode__c record : codeRecs) {

                // Retrieve the country code from the relationship field
                String countryCode = record.Store_Country_Code__r.Country_Code__c;

                // Create a new State object for the current record
                AddressOption currentRegion = new AddressOption(record.State__c, record.State_Code__c, record.Id);

                // Check if the map already contains the country code key
                if (!countryStatesMap.containsKey(countryCode)) {
                    // If not, create a new list for this country code
                    countryStatesMap.put(countryCode, new List<AddressOption>());
                }
                // Add the state to the corresponding country's list
                countryStatesMap.get(countryCode).add(currentRegion);
            }

            return countryStatesMap;


        } catch ( Exception error) {
            System.debug('Error retrieving state codes for store: ' +error.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AddressOption> getValidCountryCodes(Id storeId) {
        try {
            List<StoreCountryCode__c> codeRecs = [SELECT Country__c, Country_Code__c, Id FROM StoreCountryCode__c  WHERE Store__c = :storeId WITH SECURITY_ENFORCED];

            List<AddressOption> codes = new List<AddressOption>();

            for (StoreCountryCode__c codeRec : codeRecs) {
                System.debug('codeRec.Country__c: '+codeRec.Country__c+', codeRec.Country_Code__c: '+codeRec.Country_Code__c+', codeRec.Id: '+CodeRec.Id);
                AddressOption cc = new AddressOption(codeRec.Country__c, codeRec.Country_Code__c, codeRec.Id);
                System.debug('cc.label: '+cc.label+', : cc.value'+cc.value+', cc.id: '+cc.id);
                codes.add(cc);
            }
            System.debug('codes: '+codes.toString());
            System.debug('number of CountryCodes returned: '+codes.size());

            return codes;
        } catch ( Exception error) {
            System.debug('Error retrieving country codes for store: ' +error.getMessage());
            return null;
        }
    }
}