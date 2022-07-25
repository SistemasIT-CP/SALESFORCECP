@IsTest
public class InsertarPersonaListaNegraTest {
	@IsTest
    public static void probarInsert() {
        Test.startTest();
        InsertarPersonasListaNegra.insertRecords();
        Test.stopTest();
    }
    
    @IsTest
    public static void crearMetadata() {
        Test.startTest();
        Metadata.CustomMetadata r = InsertarPersonasListaNegra.createRecord('Test Alias', 33);
        Test.stopTest();
        
        System.assertEquals('33', r.label);
        
        for (Metadata.CustomMetadataValue v : r.values) {
            if (v.field == 'Alias__c') {
                System.assertEquals('Test Alias', v.value, 'El alias no se setea correctamente');
            } else if (v.field == 'Identificador__c') {
                System.assertEquals('33', v.value, 'El identificador no se setea correctamente');
            }
        }
    }
}