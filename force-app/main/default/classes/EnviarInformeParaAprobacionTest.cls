@isTest
public class EnviarInformeParaAprobacionTest {
    @TestSetup
    public static void crearInforme() {
        Id motosID = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal_Motos')
                                    .getRecordTypeId();
        
        Id autosID = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal_Autos')
                                    .getRecordTypeId();
        
        Id marcasID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Marcas')
                                    .getRecordTypeId();
                
        Id modeloID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Modelo')
                                    .getRecordTypeId();
        
        Catalogo_UDC__c toyota = new Catalogo_UDC__c();
        toyota.RecordTypeID = marcasID;
        toyota.Name = 'TOYOTA';
        toyota.productCode__c = 'TY';
        insert toyota;
                
        Catalogo_UDC__c xf3r = new Catalogo_UDC__c();
        xf3r.RecordTypeID = modeloID;
        xf3r.Name = 'XF3R';
        xf3r.productCode__c = 'XF3R';
        xf3r.description1__c = 'MOTOCICLETA';
        insert xf3r;
        
        Catalogo_UDC__c hero = new Catalogo_UDC__c();
        hero.RecordTypeID = marcasID;
        hero.Name = 'HERO';
        hero.productCode__c = 'HR';
        insert hero;
        
        Opportunity oppMoto = new Opportunity();
        oppMoto.Name = 'TEST OPP CTE1';
        oppMoto.StageName = 'Contacto Exitoso';
        oppMoto.CloseDate = date.today();
        oppMoto.C_digo_de_Oportunidad_Numerico__c = 1234566;
        oppMoto.Forma_de_Pago_Multiple__c = 'Contado';
        oppMoto.Sucursal__c = 'Kia El Retiro'; 
        oppMoto.Forma_de_Pago_Multiple__c = 'Contado';
        oppMoto.Prueba_de_manejo__c = 'No';
        oppMoto.Tour_CP__c = 'No';
        oppMoto.Walk_Around__c = 'No';
        oppMoto.Origen_de_los_fondos__c = 'Ahorro';
        oppMoto.Procedencia_de_los_fondos__c = 'Otros';
        oppMoto.Desea_realizar_intercambio__c = 'No';
        oppMoto.RecordTypeId = motosID;
        oppMoto.Marca_UDC__c = hero.ID;
        oppMoto.ModeloVehiculo__c = xf3r.ID;
        insert oppMoto;
        
        Opportunity oppAuto = new Opportunity();
        oppAuto.Name = 'TEST OPP CTE1';
        oppAuto.StageName = 'Contacto Exitoso';
        oppAuto.CloseDate = date.today();
        oppAuto.C_digo_de_Oportunidad_Numerico__c = 1234567;
        oppAuto.Forma_de_Pago_Multiple__c = 'Contado';
        oppAuto.Sucursal__c = 'Kia El Retiro'; 
        oppAuto.Forma_de_Pago_Multiple__c = 'Contado';
        oppAuto.Prueba_de_manejo__c = 'No';
        oppAuto.Tour_CP__c = 'No';
        oppAuto.Walk_Around__c = 'No';
        oppAuto.Origen_de_los_fondos__c = 'Ahorro';
        oppAuto.Procedencia_de_los_fondos__c = 'Otros';
        oppAuto.Desea_realizar_intercambio__c = 'No';
        oppAuto.RecordTypeId = autosID;
        oppAuto.Marca_UDC__c = toyota.ID;
        insert oppAuto;
        
       	Informe_de_Negociaci_n__c infMoto = new Informe_de_Negociaci_n__c();
        infMoto.Estado__c = 'Esperando aprobacion';
        infMoto.Oportunidad__c = oppMoto.ID;
        infMoto.total_negociado__c = 0;
    	insert infMoto; 
        
        Informe_de_Negociaci_n__c infAuto = new Informe_de_Negociaci_n__c();
        infAuto.Estado__c = 'Rechazado';
        infAuto.total_negociado__c = 0;
        infAuto.Oportunidad__c = oppAuto.ID;
    	insert infAuto; 
    }
    
	@isTest
    public static void enviarReporteTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            WHERE Estado__c = 'Rechazado'
            ];
        
        Test.startTest();
        String respuesta = EnviarInformeParaAprobacion.enviarReporte(infList[0].ID);
        Test.stopTest();
        
        //System.assertEquals('Ok', respuesta, 'El envio esta fallando cuando no deberia.');
    }
    
    @isTest
    public static void enviarReporteMotosTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            WHERE Estado__c = 'Esperando aprobacion'
            ];
        
        Test.startTest();
        String respuesta = EnviarInformeParaAprobacion.enviarReporte(infList[0].ID);
        Test.stopTest();
        
        System.assertEquals('Ok', respuesta, 'El envio esta fallando cuando no deberia.');
    }
    
    @isTest
    public static void informeConMontoMenor() {
		List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID, total_negociado__c 
            FROM Informe_de_Negociaci_n__c
            WHERE Estado__c = 'Rechazado'
            ];
        
        infList[0].total_negociado__c  = 1;
        update infList;
        
        Test.startTest();
        String respuesta = EnviarInformeParaAprobacion.enviarReporte(infList[0].ID);
        Test.stopTest();
        
        System.assertEquals('Pendiente', respuesta, 'El envio no falla a pesar de tener un monto pendiente.');
    }
    
    @isTest
    public static void informeYaAprobado() {
		List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID, Estado__c
            FROM Informe_de_Negociaci_n__c
            WHERE Estado__c = 'Rechazado'
            ];
        
        infList[0].Estado__c  = 'Aprobado';
        update infList;
        
        Test.startTest();
        String respuesta = EnviarInformeParaAprobacion.enviarReporte(infList[0].ID);
        Test.stopTest();
        
        System.assertEquals('Aprobado', respuesta, 'El envio no falla a pesar de tener ya estar aprobado.');
    }
}