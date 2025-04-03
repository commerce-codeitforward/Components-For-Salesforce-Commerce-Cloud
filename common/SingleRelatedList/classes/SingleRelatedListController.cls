public with sharing class SingleRelatedListController {
    
    @AuraEnabled(cacheable=true)
    public static FieldSetWrapper getFieldSetFields(String objectName, String fieldSetName){
        FieldSetWrapper fsw;
        
        try {
            fsw = getFieldSetWrapper(objectName, fieldSetName);            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return fsw;
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecordValues(
        String objectName, 
        String fieldSetName, 
        String parentField, 
        String recordId, 
        String keyField,
        String filterField, 
        String filterValue
        ){
        
        System.debug('getRecordValues: objectName: '+objectName+', fieldSetName: '+fieldSetName+', parentField: '+parentField+', recordId: '+recordId+', keyField: '+keyField+', filterField: '+filterField+', filterValue: '+filterValue);
        List<SObject> records = new List<SObject>();
        try {

            FieldSetWrapper fsw = getFieldSetWrapper(objectName, fieldSetName);
            List<String> fields = new List<String>();
            fields.add(keyField);
            for (FieldWrapper item : fsw.fieldList) {
                fields.add(item.fieldName);
            }           
            String queryString = 'SELECT '+String.join(fields,',')+' FROM '+objectName+' WHERE '+parentField+' = \'' + recordId +'\'';
            if (filterField != null && filterField != '') {
                queryString += ' AND '+filterField+' = \''+filterValue+'\'';
            }
            System.debug('queryString: '+queryString);
            
            records = Database.query(queryString);
        } catch (Exception e) {
            System.debug('getRecordValues: '+e.getMessage());
            // throw new AuraHandledException(e.getMessage());
        }
        return records;
    }

    private static FieldSetWrapper getFieldSetWrapper(String objectName, String fieldSetName){
        System.debug('getFieldSetWrapper: objectName: '+objectName+', fieldSetName: '+fieldSetName);
        List<FieldWrapper> fwList = new List<FieldWrapper>();
        FieldSetWrapper fsw = new FieldSetWrapper();
        try {
            SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
            Schema.FieldSet fs = objectType.getDescribe().fieldSets.getMap().get(fieldSetName);
            for (Schema.FieldSetMember item : fs.getFields()) {
                iFieldSetMember fsm = new iFieldSetMember(item);
                fwList.add(new FieldWrapper(fsm));
            }          
            fsw = new FieldSetWrapper(fs.getLabel(), fwList);
        }
        catch(Exception e){
            System.debug('getFieldSetWrapper: '+e.getMessage());
        }
        
        System.debug('fsw: '+fsw+', size: '+fwList.size());
        return fsw;
    }

    
    public class FieldSetWrapper {
        @AuraEnabled
        public String fieldSetLabel {get; set;}

        @AuraEnabled
        public List<FieldWrapper> fieldList {get; set;}
        
        public FieldSetWrapper() {
            this.fieldList = new List<FieldWrapper>();
            this.fieldSetLabel = '';
        }

        public FieldSetWrapper(String label, List<FieldWrapper> fieldList) {
            this.fieldSetLabel = label;
            this.fieldList = fieldList;
        }
    }

    @TestVisible
    private class iFieldSetMember {
        public String label {get; set;}
        public String fieldPath {get; set;}
        public Schema.DisplayType type {get; set;}
        public Boolean required {get; set;}

        public iFieldSetMember(){}

        public iFieldSetMember(FieldSetMember fsm) {
            this.label = fsm.getLabel();
            this.fieldPath = fsm.getFieldPath();
            this.type = fsm.getType();
            this.required = fsm.getRequired();
        }
    }

    public class FieldWrapper {
        @AuraEnabled
        public String label {get; set;}

        @AuraEnabled
        public String fieldName {get; set;}

        @AuraEnabled
        public String type {get; set;}

        @AuraEnabled
        public Boolean isRequired {get; set;}

        @AuraEnabled
        public Map<String, String> cellAttributes {get; set;}
        // : { alignment: 'right' }

        public FieldWrapper(){}

        public FieldWrapper(iFieldSetMember fieldMember) {
            this.label = fieldMember.label;
            this.fieldName = fieldMember.fieldPath;
            this.isRequired = fieldMember.required;

            if(fieldMember.type == Schema.DisplayType.BOOLEAN) {
                    this.type = 'boolean';
            }	
            else if(fieldMember.type == Schema.DisplayType.CURRENCY) {
                    this.type = 'currency';
                }
            else if(fieldMember.type == Schema.DisplayType.DATE) {
                this.type = 'date';
            }
            else if(fieldMember.type == Schema.DisplayType.DATETIME) {
                this.type = 'date';
            }
            else if(fieldMember.type == Schema.DisplayType.DOUBLE) {		
                this.type = 'number';
            }
            else if(fieldMember.type == Schema.DisplayType.INTEGER) {		
                this.type = 'number';
            }
            else if(fieldMember.type == Schema.DisplayType.LONG) {		
                this.type = 'number';
            }
            else if(fieldMember.type == Schema.DisplayType.EMAIL) {		
                this.type = 'email';
            }
            else if(fieldMember.type == Schema.DisplayType.PERCENT) {		
                this.type = 'percent';
            }
            else if(fieldMember.type == Schema.DisplayType.PHONE) {		
                this.type = 'phone';
            }
            else if(fieldMember.type == Schema.DisplayType.URL) {		
                this.type = 'url';
            }
            else {
                this.type = 'text';
            }
        }
    }
}