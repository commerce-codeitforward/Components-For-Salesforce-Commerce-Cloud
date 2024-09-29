public with sharing class GenericFieldInputController {
    private final static String CART = 'WebCart';

    @AuraEnabled
    public static void updateGenericRecordByCartId(String cartId, String objectApiNamesJson, String fieldName, String value){
        System.debug('updateGenericRecordByCartId enter');
        System.debug('cartId:' + cartId);
        System.debug('objectApiNamesJson:'+ objectApiNamesJson);
        System.debug('fieldName:' + fieldName);
        System.debug('value:' + value);
        List<SObject> sObjectsToUpdate = new List<SObject>();
        List<Object> objectApiNames = (List<Object>)JSON.deserializeUntyped(objectApiNamesJson);
        for (Object objectData : objectApiNames) {
            Map<String, Object> data = (Map<String, Object>) objectData;
            String objectApiName = (String)data.get('objectApiName');
            String query = '';
            if (objectApiName == CART) {
                query = 'SELECT Id, ' + fieldName + ' FROM ' + objectApiName + ' WHERE Id = :cartId';
            }
            else {
                query = 'SELECT Id, CartId, ' + fieldName + ' FROM ' + objectApiName + ' WHERE CartId = :cartId';
            }
            List<SObject> records = Database.query(query);
            for (sObject record : records) {
                String regex = '[0-9]{4}-[0-9]{0,2}-[0-9]{0,2}';
                Pattern datePattern = Pattern.compile(regex);
                Matcher matchDate = datePattern.matcher(value);
                if (matchDate.matches()) {
                    Date dateValue = Date.valueOf(value);
                    record.put(fieldName, dateValue);
                }
                else {
                    record.put(fieldName, value);
                }
                sObjectsToUpdate.add(record);
            }
        }
        Database.update(sObjectsToUpdate, false);
    }
}