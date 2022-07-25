@isTest
public class TestWS_InsertaFacturasAutomaticas {
    @TestSetup
    public static void crearCuentaYOpp() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        insert acc;
        
        Id pricebookId = Test.getStandardPricebookId();

        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = acc.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 123456;
        opp.Marca__c = 'Kia';
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.Pricebook2Id = pricebookId;
        insert opp;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS';
		infNeg.Cuenta__c = acc.ID;
        infNeg.Oportunidad__c = opp.ID;
        infNeg.Facturar_a_nombre_de__c = acc.ID;
        insert infNeg;
    }
    
    @isTest
    public static void generarXML() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Informe_de_Negociaci_n__c infNeg = 
            [SELECT ID, C_digo_de_Cliente__c, Chasis__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c, 
                	   Name, Error_sincronizacion_WS__c, Sincronizacion_WS__c, Consecutivo_del_Informe__c, Facturar_a_nombre_de__r.CodigoCliente__c 
            FROM Informe_de_Negociaci_n__c
            ];
        
        Test.startTest();
        String xml = CallWSInsertaFacturaAutomatica.crearXML(infNeg);
        Test.stopTest();
        
        System.assertEquals(true, xml.contains(infNeg.C_digo_de_Cliente__c), 'El codigo de cliente del inf no se setea correctamente.');
        System.assertEquals(true, xml.contains(infNeg.Chasis__c), 'El chasis del inf no se setea correctamente.');
        System.assertEquals(true, xml.contains('' + infNeg.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c), 
                            'El codigo numerico de la oportunidad del inf no se setea correctamente.');
        System.assertEquals(true, xml.contains(infNeg.Consecutivo_del_Informe__c), 'El consecutivo del inf no se setea correctamente.');
    }
    
    @isTest
    public static void getFacturasAutomaticas(){
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Informe_de_Negociaci_n__c infNeg = 
            [SELECT ID, C_digo_de_Cliente__c, Chasis__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c, 
                    Name, Error_sincronizacion_WS__c, Sincronizacion_WS__c, Consecutivo_del_Informe__c,
             		Facturar_a_nombre_de__r.CodigoCliente__c
            FROM Informe_de_Negociaci_n__c
            ];
        
        String xml = CallWSInsertaFacturaAutomatica.crearXML(infNeg);
        ws_Oportunidades.wsOportunidadesPort wsOpp = new ws_Oportunidades.wsOportunidadesPort();
        
        Test.startTest();
        String resp = wsOpp.InsertarFacturacionAutomatica(Label.strKey, Label.strApp, Label.strModulo, xml);
        Test.stopTest();
        
        System.assertEquals('Bien', resp, 'La respuesta recibida del WS es incorrecta');
    }
}