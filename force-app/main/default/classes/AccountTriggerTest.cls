@isTest
public with sharing class AccountTriggerTest {
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
        
        Id generoUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Genero')
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
        
        Catalogo_UDC__c generoTest = new Catalogo_UDC__c();
        generoTest.Name = 'Genero';
        generoTest.productcode__c = 'G';
        generoTest.RecordTypeId = generoUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {paisTest,
                                                                  municipioTest,
                                                                  departamentoTest,
                                                                  tipoTelefonoTest,
            													  generoTest} ;

        insert catList;

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '321321';
        acc.Pa_s__c = paisTest.ID;
        acc.Municipio__c = municipioTest.ID;
        acc.Ciudad_UDC__c = departamentoTest.ID;
        acc.Departamento__c = departamentoTest.ID;
        acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
        insert acc;
    }

    @isTest
    public static void validarLargoNombreJuridicas() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Account acc = new Account();
        acc.Name = 'UnNombreDePruebaPeroQueTieneMasDeCuarentaCaracteres';
        
        Database.SaveResult sr = Database.insert(acc, false);
        
        System.assertEquals(false, sr.isSuccess(), 'La validacion de nombre no esta fallando para cuentas juridicas');
    }
    
    @isTest
    public static void validarCedulaDeIdentidad() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();   
        
        Account acc = new Account();
        acc.RecordTypeId = personAccountID;
        acc.FirstName = 'Nombre';
        acc.Phone = '88888888';
        acc.LastName = 'Apellido';
        acc.Tipo_de_Indentificaci_n__c = 'Cedula de Identidad';
        acc.Cedula__c = '123-010190-1234A';
        
        insert acc;
    }
    
    @isTest
    public static void validarCedulaDeIdentidadErronea() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();   
        
        Account acc = new Account();
        acc.RecordTypeId = personAccountID;
        acc.FirstName = 'Nombre';
        acc.LastName = 'Apellido';
        acc.Tipo_de_Indentificaci_n__c = 'Cedula de Identidad';
        acc.Cedula__c = '1-992030-124A';
        acc.Phone = '88888888';
        
        Database.SaveResult sr = Database.insert(acc, false);
        System.assertEquals(false, sr.isSuccess(), 'La validacion de cedula de identidad no funciona como deberia.');
        
    }
    
    @isTest
    public static void validarLargoNombrePersonales() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();   
        
        Account acc = new Account();
        acc.RecordTypeId = personAccountID;
        acc.FirstName = 'UnNombreDePrueba';
        acc.MiddleName = 'PeroQueTieneMas';
        acc.LastName = 'DeCuarentaCaracteres';
        acc.Phone = '88888888';
        
        Database.SaveResult sr = Database.insert(acc, false);
        
        System.assertEquals(false, sr.isSuccess(), 'La validacion de nombre no esta fallando para cuentas juridicas');
    }
    
    @IsTest
    public static void setearMessagingKeyTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWS());
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'email@test.com',
                                  Cedula__c = '123123',
                                  Phone = '8888888');
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.C_rdobas__c = false;
        acc.CodigoCliente__c = '123123';
        acc.Phone = '+5411123456';

        Test.startTest();
        Database.SaveResult sr = Database.insert(acc, false);
        Test.stopTest();
        
        Account accActualizado = [
            SELECT MessagingPlatformKey__c
            FROM Account
            WHERE Id =: acc.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La insersion esta fallando cuando no deberia hacerlo');
        System.assertEquals('whatsapp:+5411123456', accActualizado.MessagingPlatformKey__c, 'El MessagingPlatformKey no se esta seteando como deberia');
    }
    
    @IsTest
    public static void actualizarMessagingKeyTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWS());
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'email@test.com',
                                  Cedula__c = '123123',
                                  Phone = '8888888');
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.C_rdobas__c = false;
        acc.CodigoCliente__c = '123123';
        acc.Phone = '+5411123456';
		insert acc;
        
        Test.startTest();
        acc.Phone = '+5411456789';
        Database.SaveResult sr = Database.update(acc, false);
        Test.stopTest();
        
        Account accActualizado = [
            SELECT MessagingPlatformKey__c
            FROM Account
            WHERE Id =: acc.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia hacerlo');
        System.assertEquals('whatsapp:+5411456789', accActualizado.MessagingPlatformKey__c, 'El MessagingPlatformKey no se esta seteando como deberia cuando se actualiza');
    }
    
    @IsTest
    public static void actualizarCordobas() {
        Map<String, ID> catIDByName = new Map<String, ID>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWS());
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        List<Account> accList = new List<Account>();

        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test Account' + i,
                                      CurrencyIsoCode = 'USD',
                                      Secuencia_contactos__c = 0,
                                      Email__c = 'email@test.com' + i,
                                      Cedula__c = '123123' + i,
                                      Phone = '8888888' + i);
            acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit' + i;
            acc.RecordTypeID = juridicaAccountID;
            acc.C_rdobas__c = false;
            acc.CodigoCliente__c = '123123' + i;
            acc.Pa_s__c = catIDByName.get('PAIS_TEST');
            acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
            acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 

            accList.add(acc);
        }

        insert accList;

        for (Account ac : accList) {
            ac.C_rdobas__c = true;
        }
        
        List<String> errList = new List<String>();

        Test.startTest();
        Database.SaveResult[] srList = Database.update(accList, true);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                    System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    errList.add(err.getMessage());
                }
            }
        }
        Test.stopTest();
        
        List<Account> accountList = 
            [SELECT C_rdobas__c
            FROM Account
            WHERE Name LIKE 'Test Account%'
            ];

        System.assertEquals(0,
                errList.size(),
                'La lista de errores deberia estar vacia y no lo está.');

        for (Account account : accList) {
            System.assertEquals(true,
                                account.C_rdobas__c,
                                'No se actualizó correctamente la moneda'
                                );
        }
    }

    @IsTest
    static void inactivarCliente() {
        Map<String, ID> catIDByName = new Map<String, ID>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWS());
		 
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        List<Account> accList = new List<Account>();

        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test Account' + i,
                                      CurrencyIsoCode = 'USD',
                                      Secuencia_contactos__c = 0,
                                      Email__c = 'email@test.com' + i,
                                      Cedula__c = '123123' + i);
            acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit' + i;
            acc.RecordTypeID = juridicaAccountID;
            acc.C_rdobas__c = false;
            acc.Phone = '88888888';
            acc.CodigoCliente__c = '123123' + i;
            acc.Pa_s__c = catIDByName.get('PAIS_TEST');
            acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
            acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 

            accList.add(acc);
        }

        insert accList;

        for (Account ac : accList) {
            ac.Inactividad__c = true;
        }
        
        List<String> errList = new List<String>();

        Test.startTest();
        Database.SaveResult[] srList = Database.update(accList, true);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                    System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    errList.add(err.getMessage());
                }
            }
        }
        Test.stopTest();
        
        List<Account> accountList = 
            [SELECT Inactividad__c
            FROM Account
            WHERE Name LIKE 'TEST ACCOUNT%'
            ];

        System.assertEquals(0,
                errList.size(),
                'La lista de errores deberia estar vacia y no lo está.');

        for (Account account : accList) {
            System.assertEquals(true,
                                account.Inactividad__c,
                                'No se actualizó correctamente la inactividad'
                                );
        }
    }

    @isTest 
    static void pruebaInsertDelWS() {
        Map<String, ID> catIDByName = new Map<String, ID>();
        List<String> IDList = new List<String>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWS());

        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();
        
        List<Account> accList = new List<Account>();

        for (Integer i = 0; i < 10; i++) {
            Account acc = new Account(Name = 'Test Account' + i,
                                      CurrencyIsoCode = 'USD',
                                      Secuencia_contactos__c = 0,
                                      Email__c = 'email@test.com',
                                      Cedula__c = '123123abc' + i);
                                      
            acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
            acc.RecordTypeID = juridicaAccountID;
            acc.C_rdobas__c = true;
            acc.Inactividad__c = true;
            acc.Phone = '88888888';
            acc.CodigoCliente__c = '123123' + i;
            acc.Pa_s__c = catIDByName.get('PAIS_TEST');
            acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
            acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
            acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 

            accList.add(acc);
        }

        Test.startTest();
        Database.SaveResult[] srInsert = Database.Insert(accList, true);
        Test.stopTest();

        List<Account> ac =
            [SELECT Name, Cedula__c, Envio_correcto_a_WS__c
            FROM Account 
            WHERE Direccion__c LIKE '%Lorem%'
                AND Phone = '123123'
            ];
        
        for (Account acc : ac) {
            IDList.add('' + acc.ID);
        }

        List<Debug_log__c> debugList = 
            [SELECT ID
            FROM Debug_log__c 
            WHERE ID_Objeto__c IN :IDList
            ];

        for(Database.SaveResult sr : srInsert) {
            System.assertEquals(0, 
                                sr.getErrors().size(),
                                'Algo esta fallando y la lista de errores tiene elementos.'
                                );
    
            System.assertEquals(true, 
                                sr.isSuccess(),
                                'Hubo un error en el insert: ' + sr.getErrors()
                                );
        }

        System.assertEquals(0, 
                            debugList.size(),
                            'Se estan creando debugs debido a errores, cuando no deberia');

        for (Account cuenta : ac) {
            System.assertEquals(true, 
                                cuenta.Name.contains('TEST ACCOUNT'),
                                'El nombre no se esta poniendo en mayusculas como deberia.');                       
    
            
            System.assertEquals(true, 
                                cuenta.Cedula__c.contains('ABC'),
                                'La cedula no se esta poniendo en mayusculas como deberia.');

            System.assertEquals(true, 
                                cuenta.Envio_correcto_a_WS__c,
                                'La envio al WS no se esta realizando correctamente.');
        }
    }

    @isTest 
    static void pruebaUpdateDelWS() {
        Map<String, ID> catIDByName = new Map<String, ID>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'email@test.com',
                                  Cedula__c = '123123');
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.C_rdobas__c = false;
        acc.CodigoCliente__c = '123123';
        acc.Phone = '88888888';
        acc.Pa_s__c = catIDByName.get('PAIS_TEST');
        acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
        acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 

        insert acc;

        acc.Phone = '12345678';

        Test.startTest();
        Database.SaveResult srUpdate = Database.Update(acc, true);
        Test.stopTest();

        Account ac = 
            [SELECT ID, Phone
            FROM Account
            WHERE ID =: acc.ID
            ];

        System.assertEquals(0, 
                            srUpdate.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srUpdate.isSuccess(),
                            'Hubo un error en el update: ' + srUpdate.getErrors()
                            );

        System.assertEquals('12345678',
                            ac.Phone,
                            'Los cambios no se realizaron como corresponde');
    }

    @isTest 
    static void pruebaValidacionRepLegal() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Account acc = 
            [SELECT ID, Representante_Legal__c
            FROM Account
            WHERE Name = 'CUENTA TEST'
            LIMIT 1
            ];
        
        Contact contacto = new Contact();
        contacto.FirstName = 'Prueba';
        contacto.MiddleName	= 'Contact9';
        contacto.LastName = 'Xappia9';
        contacto.Email = 'test@email9.com';
        contacto.Id_Externo__c = '999999_0';
        contacto.Numero_de_documento__c = '999999_0';
        contacto.Phone = '12345678';

        insert contacto;
        
        acc.Representante_Legal__c = contacto.ID;

        Test.startTest();
        Database.SaveResult srValidacion = Database.Update(acc, false);
        Test.stopTest();

        System.assertEquals(false, 
                            srValidacion.getErrors().isEmpty(),
                            'La lista de errores esta vacia cuando deberia tener un error'
                            );

        System.assertEquals(false, 
                            srValidacion.isSuccess(),
                            'La validacion no esta funcionando y el update no falla.'
                            );
    }
    
    @isTest 
    static void pruebaDeleteDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
		Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%tem%'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE Name = 'Cuenta Test'
            LIMIT 1
            ];

        Database.DeleteResult srDelete;
        
        System.runAs(u) {
        	Test.startTest();
        	srDelete = Database.Delete(acc, true);
        	Test.stopTest();
        }

        System.assertNotEquals(null, srDelete, 'La eliminacion ni si quiera ha corrido.');
        
        System.assertEquals(0, 
                            srDelete.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srDelete.isSuccess(),
                            'Hubo un error en el delete: ' + srDelete.getErrors()
                            );
    }
    
    @isTest
    static void pruebaValidacionEliminar() {
    	Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Vendedor'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE Name = 'Cuenta Test'
            LIMIT 1
            ];

        Database.DeleteResult srDelete;
        
        System.runAs(u) {
        	Test.startTest();
        	srDelete = Database.Delete(acc, false);
        	Test.stopTest();
        }

        System.assertEquals(false, 
                            srDelete.getErrors().isEmpty(),
                            'No hay errores cuando deberia.'
                            );

        System.assertEquals(false, 
                            srDelete.isSuccess(),
                            'La validacion no fallo, cuando deberia haberlo hecho'
                            );    
    }

    @IsTest
    static void personAccountTest(){
        Map<String, ID> catIDByName = new Map<String, ID>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        Account acc = new Account(FirstName = 'Cuenta',
                                  LastName = 'Personal',
                                  CurrencyIsoCode = 'USD',
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '40999123abc',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        
        acc.RecordTypeID = personAccountID;
        acc.C_rdobas__c = true;
        acc.Tipo_de_Indentificaci_n__c = 'Otros';
        acc.Inactividad__c = true;
        acc.Pa_s__c = catIDByName.get('PAIS_TEST');
        acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
        acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardaMonedaCliente());
        Test.setMock(WebServiceMock.class, new Test_MockWS());
        insert acc;
        Test.stopTest();

        Account perAcc = 
            [SELECT Secuencia_contactos__c, contactid__pc, Numero_de_documento__pc,
                    Cedula__c, Email__c, PersonEmail, Tipo_de_Identificaci_n__pc, 
                    Tipo_de_Indentificaci_n__c, Name, CodigoCliente__c, Phone
            FROM Account 
            WHERE ID =: acc.ID
            LIMIT 1
            ];

        Contact perCont = 
            [SELECT Numero_de_documento__c, contactid__c, Email, Tipo_de_Identificaci_n__c,
                    Envio_correcto_a_WS__c, Phone
            FROM Contact
            WHERE AccountID =: acc.ID 
            LIMIT 1
            ];

        String originalName = 'Cuenta Personal';

        System.assertEquals(true, perAcc.Name.equals(originalName.toUpperCase()), 'El nombre no se encuentra en UpperCase');
        System.assertEquals(0, perAcc.Secuencia_contactos__c, 'La secuencia de contactos no coincide con lo esperado');
        System.assertEquals('0', perAcc.contactid__pc, 'El contactID no coincide con lo esperado');
        System.assertEquals(perAcc.Cedula__c.toUpperCase(), perAcc.Numero_de_documento__pc, 'El numero de documento no coincide con lo esperado');
        System.assertEquals(perAcc.Email__c, perAcc.PersonEmail, 'La secuencia de contactos no coincide con lo esperado');
        System.assertEquals(perAcc.Tipo_de_Identificaci_n__pc, perAcc.Tipo_de_Indentificaci_n__c, 'El tipo de identificacion no coincide con lo esperado');

        System.assertEquals('0', perCont.contactid__c, 'El contactID no coincide con lo esperado');
        System.assertEquals(perAcc.Cedula__c, perCont.Numero_de_documento__c, 'El numero de documento no coincide con lo esperado');
        System.assertEquals(perAcc.Phone, perCont.Phone, 'El telefono no coincide con lo esperado');
        System.assertEquals(perAcc.Email__c, perCont.Email, 'La secuencia de contactos no coincide con lo esperado');
        System.assertEquals(perAcc.Tipo_de_Identificaci_n__pc, perCont.Tipo_de_Identificaci_n__c, 'El tipo de identificacion no coincide con lo esperado');
    }
    
    @IsTest
    static void cambiarNombreCedulaTest(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        Account acc = new Account(FirstName = 'Cuenta',
                                  LastName = 'Personal',
                                  Cedula__c = '40999123abc');

        acc.RecordTypeID = personAccountID;
        acc.Phone = '88888888';
        acc.Tipo_de_Indentificaci_n__c = 'Pasaporte';
        acc.Campo_auxiliar_para_cambios__c = 'Otro-Nombre-Nuevo;Otros;40999123cba;';
        insert acc;

        Profile p = [SELECT Id FROM Profile WHERE Name='Vendedor'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'es';
        u.LocaleSidKey = 'es_MX'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.UserName = 'test@email.com.casapellas';
        
        insert u;

        Test.startTest();
        acc.Campo_auxiliar_para_cambios__c = acc.Campo_auxiliar_para_cambios__c + 'true';
        acc.Requiere_aprobacion__c = u.ID;
        update acc;
        Test.stopTest();

        List<Account> perAcc = 
            [SELECT FirstName, MiddleName, LastName, Tipo_de_Indentificaci_n__c, Cedula__c
            FROM Account 
            WHERE ID =: acc.ID
            ];

        System.assertEquals('OTRO', perAcc[0].FirstName.toUpperCase(), 'El primer nombre no coincide con lo esperado.');
        System.assertEquals('NOMBRE', perAcc[0].MiddleName.toUpperCase(), 'El primer nombre no coincide con lo esperado.');
        System.assertEquals('NUEVO', perAcc[0].LastName.toUpperCase(), 'El primer nombre no coincide con lo esperado.');
        System.assertEquals('Otros', perAcc[0].Tipo_de_Indentificaci_n__c, 'El tipo de identificación no coincide con lo esperado.');
        System.assertEquals('40999123CBA', perAcc[0].Cedula__c.toUpperCase(), 'La cédula no coincide con lo esperado.');
    }
    
    @IsTest
    static void cambiarGeneroYNacionalidad(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        List<Catalogo_UDC__c> generoList = 
            [SELECT ID
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Genero'
            ];
        
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        Account acc = new Account(FirstName = 'Cuenta',
                                  LastName = 'Personal',
                                  Cedula__c = '40999123abc');

        acc.RecordTypeID = personAccountID;
        acc.Phone = '88888888';
        acc.Tipo_de_Indentificaci_n__c = 'Pasaporte';
        insert acc;

        Test.startTest();
        acc.Genero_UDC__pc = generoList[0].ID;
        acc.Lugar_de_nacimiento__pc = 'Un lugar';
        update acc;
        Test.stopTest();

        List<Account> perAcc = 
            [SELECT Lugar_de_nacimiento__c, Lugar_de_nacimiento__pc, Genero_UDC__c, Genero_UDC__pc
            FROM Account 
            WHERE ID =: acc.ID
            ];

        System.assertEquals(perAcc[0].Lugar_de_nacimiento__c, perAcc[0].Lugar_de_nacimiento__pc, 'El lugar de nacimiento no coincide con lo esperado.');
        System.assertEquals(perAcc[0].Genero_UDC__c, perAcc[0].Genero_UDC__pc, 'El lugar de nacimiento no coincide con lo esperado.');
    }
}