public with sharing class SingleRelatedListCPEController {
    
    @AuraEnabled
    public static List<ObjectWrapper>  getObjectList(){
        List<ObjectWrapper> items = new List<ObjectWrapper>();
        try {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            List<String> objectList = new List<String>(gd.keySet());
            objectList.sort();
            
            for (String key : objectList) {
                Schema.SObjectType item = gd.get(key);
                Schema.DescribeSObjectResult detail = item.getDescribe();
                if(detail.isAccessible() && detail.isQueryable()){
                    items.add( new ObjectWrapper(detail.getLabel(), detail.getName()));
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return items;
    }

    @AuraEnabled
    public static List<ObjectWrapper>  getRelatedObjects(String objectName){
        List<ObjectWrapper> items = new List<ObjectWrapper>();
        try {
            Schema.SObjectType systemObjectType = Schema.getGlobalDescribe().get(objectName);
            List<Schema.ChildRelationship> childRelationships = systemObjectType.getDescribe().getChildRelationships();
            Map<String, Schema.SObjectType> systemChildObjectTypeMap = new Map<String, Schema.SObjectType>();
            for (Schema.ChildRelationship childRow : childRelationships) {
                systemChildObjectTypeMap.put(childRow.getRelationshipName(), childRow.getChildSObject());
            }
            List<String> childRelList = new List<String>(systemChildObjectTypeMap.keySet());
            childRelList.sort();
            for (String childRow : childRelList) {
                Schema.SObjectType childItem = systemChildObjectTypeMap.get(childRow);
                Schema.DescribeSObjectResult detail = childItem.getDescribe();
                if(detail.isAccessible() && detail.isQueryable()){
                        items.add( new ObjectWrapper(detail.getLabel(), detail.getName()));
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        return items;
    } 

    @AuraEnabled
    public static List<ObjectWrapper> getFieldSets(String objectName){
        List<ObjectWrapper> items = new List<ObjectWrapper>();
        try {
            Schema.SObjectType systemObjectType = Schema.getGlobalDescribe().get(objectName);

            Map<String, Schema.FieldSet> fieldSetMap = systemObjectType.getDescribe().fieldSets.getMap();

            for (String key : fieldSetMap.keySet()) {
                Schema.FieldSet fieldSetObj = fieldSetMap.get(key);
                items.add( new ObjectWrapper(fieldSetObj.getLabel(), fieldSetObj.getName()));

            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return items;
    }

    @AuraEnabled
    public static List<ObjectWrapper> getObjectFields(String objectName){
        List<ObjectWrapper> items = new List<ObjectWrapper>();
        try {
            Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

            for (Schema.SObjectField field : fieldsMap.values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                if(fieldDescribe.isAccessible()){
                    items.add( new ObjectWrapper(fieldDescribe.getLabel(), fieldDescribe.getName()));
                }   
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return items;
    }

    public class ObjectWrapper {
        @AuraEnabled
        public string label;
      
        @AuraEnabled
        public string value;
      
        public ObjectWrapper(string label, string value)
        {
            this.label = label;
            this.value = value;
        }
    } 
}