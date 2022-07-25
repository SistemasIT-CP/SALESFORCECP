@Istest
public class ProcesaWSUDCTest {
	@IsTest
    public static void getUDCTest(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_UDC_Mock());
        
        Test.startTest();
        ProcesaWS_UDCs.getUDCs();
        Test.stopTest();

        List<Catalogo_UDC__c> catList = 
           [SELECT RecordType.DeveloperName, productCode__c, description2__c
            FROM Catalogo_UDC__c
            WHERE Name = 'TESTACTECONOMICA'
            ];
        
        System.assertEquals(true, !catList.isEmpty(), 'La lista esta vacia cuando no deberia');
        System.assertEquals('Actividad_Economica', catList[0].RecordType.DeveloperName, 'El record type no es el correcto.');
        System.assertEquals('Mayorista', catList[0].description2__c, 'La descripcion no es la correcta.');
        System.assertEquals('COM', catList[0].productCode__c, 'El codigo de producto no es el correcto.');
    }
    
    @IsTest
    public static void getUDCJSONTest(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_UDC_Mock());
        
        Test.startTest();
        ProcesaWS_UDCsJSON.getUDCJSON();
        Test.stopTest();
        
        List<Catalogo_UDC__c> catList = 
            [SELECT RecordType.DeveloperName, productCode__c, description2__c
            FROM Catalogo_UDC__c
            WHERE Name = 'TESTDESCRIPCION'
            ];
        
        System.assertEquals(true, !catList.isEmpty(), 'La lista esta vacia cuando no deberia');
        System.assertEquals('Marcas', catList[0].RecordType.DeveloperName, 'El record type no es el correcto.');
        System.assertEquals('TESTDESCRIPCION', catList[0].description2__c, 'La descripcion no es la correcta.');
        System.assertEquals('8979878789', catList[0].productCode__c, 'El codigo de producto no es el correcto.');            
    }
}