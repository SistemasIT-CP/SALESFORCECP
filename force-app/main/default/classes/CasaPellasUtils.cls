public without sharing class CasaPellasUtils {
    public static Set<Id> getFieldId(List<sObject> records, String field) {
        Set<Id> ids = new Set<Id>();
        
        for (sObject record : records) {
            ids.add((Id) record.get(field));
        }

        return ids;
    }
}