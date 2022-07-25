@isTest
public class ButtonRecallControllerTest {
	@TestSetup
    static void generateAccount() {
        Id paisUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Pais')
                                    .getRecordTypeId();

        Id departamentoUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Departamento')
                                    .getRecordTypeId();

        Id municipioUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Municipio')
                                    .getRecordTypeId();

        Id tipoTelUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Tipo_de_Telefono')
                                    .getRecordTypeId();

        Catalogo_UDC__c paisTest = new Catalogo_UDC__c();
        paisTest.Name = 'PAIS_TEST';
        paisTest.productcode__c = 'PTE';
        paisTest.RecordTypeId = paisUDCID;

        Catalogo_UDC__c municipioTest = new Catalogo_UDC__c();
        municipioTest.Name = 'MUNICIPIO_TEST';
        municipioTest.productcode__c = 'MTE';
        municipioTest.RecordTypeId = municipioUDCID;

        Catalogo_UDC__c departamentoTest = new Catalogo_UDC__c();
        departamentoTest.Name = 'DEPARTAMENTO_TEST';
        departamentoTest.productcode__c = 'DTE';
        departamentoTest.RecordTypeId = departamentoUDCID;

        Catalogo_UDC__c tipoTelefonoTest = new Catalogo_UDC__c();
        tipoTelefonoTest.Name = 'TIPO_TELEFONO_TEST';
        tipoTelefonoTest.productcode__c = 'TTT';
        tipoTelefonoTest.RecordTypeId = tipoTelUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {paisTest,
                                                                  municipioTest,
                                                                  departamentoTest,
                                                                  tipoTelefonoTest} ;

        insert catList;

        Test.setMock(HttpCalloutMock.class, new HTTPErrorMock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '123123';
        acc.RecordTypeID = juridicaAccountID;
        acc.Pa_s__c = paisTest.ID;
        acc.Municipio__c = municipioTest.ID;
        acc.Ciudad_UDC__c = departamentoTest.ID;
        acc.Departamento__c = departamentoTest.ID;
        acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
        insert acc;
        
        Contact contacto = new Contact();
        contacto.FirstName = 'Prueba';
        contacto.MiddleName	= 'Contact';
        contacto.LastName = 'Xappia';
        contacto.Email = 'test@email.com';
        contacto.AccountID = acc.ID;
        contacto.Numero_de_documento__c = '999999';
        contacto.Phone = '12345678';

        insert contacto;
    }
    
    @IsTest
    static void recallAccTest() {
        Account acc =
            [SELECT ID
             FROM Account
             WHERE Name = 'CUENTA TEST'
            ];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        ButtonRecallController.recall(acc.ID, 'Account');
        Test.stopTest();
            
        Account ac =
            [SELECT ID, Envio_correcto_a_WS__c, CodigoCliente__c
             FROM Account
             WHERE Name = 'CUENTA TEST'
            ];
        
        System.assertNotEquals(null, ac.CodigoCliente__c, 'El codigo de cliente no se ha seteado como corresponde.');
        System.assertEquals(true, ac.Envio_correcto_a_WS__c, 'La cuenta no se envia correctamente al WS.');
    }
    
    @IsTest
    static void recallConTest() {
        Contact con =
            [SELECT ID
             FROM Contact
         	 WHERE Email = 'test@email.com'
            ];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        ButtonRecallController.recall(con.ID, 'Contact');
        Test.stopTest();
        
        Contact c =
            [SELECT ID, Envio_correcto_a_WS__c
             FROM Contact
         	 WHERE Email = 'test@email.com'
            ];
        
        System.assertEquals(true, c.Envio_correcto_a_WS__c, 'El contacto no se envia correctamente al WS.');
    }
    
    @IsTest
    static void erroresNotificadosTest() {
        Account acc =
            [SELECT ID
             FROM Account
             WHERE Name = 'CUENTA TEST'
            ];
        
        Contact con =
            [SELECT ID
             FROM Contact
             WHERE AccountID =: acc.Id
             LIMIT 1
            ];
        
        Test.startTest();
        String errorAcc = ButtonRecallController.erroresNotificados(acc.ID);
		String errorCon = ButtonRecallController.erroresNotificados(con.ID);
        Boolean enviadoAcc = ButtonRecallController.yaHaSidoEnviado(acc.ID, 'Account');
        Boolean enviadoCon = ButtonRecallController.yaHaSidoEnviado(con.ID, 'Contact');
        Test.stopTest();
        
        System.assertEquals(true, String.isNotBlank(errorAcc), 'No se regresa un error aunque lo hay en cuenta');
        System.assertEquals(true, String.isNotBlank(errorCon), 'No se regresa un error aunque lo hay en contacto');
        System.assertEquals(true, enviadoAcc, 'YaHaSidoEnviado no funciona con una cuenta que se envió previamente');
        System.assertEquals(true, enviadoCon, 'YaHaSidoEnviado no funciona con un contacto que se envió previamente');
    }
}