@isTest
public with sharing class ContactTriggerTest {
    @TestSetup
    static void generateAccount() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

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

        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'email@test.com',
                                  Cedula__c = '123123',
                                  Phone = '88888888');

        acc.RecordTypeID = juridicaAccountID;
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '123123';
        acc.Pa_s__c = paisTest.ID;
        acc.Municipio__c = municipioTest.ID;
        acc.Ciudad_UDC__c = departamentoTest.ID;
        acc.Departamento__c = departamentoTest.ID;
        acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
        insert acc;

        Contact contacto = TestFactory.createContact(acc.ID);
        insert contacto;
    }

    @IsTest
    static void actualizarContactIDTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Account ac = 
            [SELECT ID, Secuencia_contactos__c, CODIGOCLIENTE__c
            FROM Account 
            WHERE Name = 'Test Account' 
            LIMIT 1
            ];

        Decimal secuenciaOriginal = ac.Secuencia_contactos__c;
        
        List<Contact> contactList = new List<Contact>();

        for (Integer j = 0; J < 10; j++) {
            Contact cont = new Contact(LastName = 'Contact ' + (j+10),
                                       FirstName = 'Test',
                                       AccountID = ac.ID,
                                       Numero_de_documento__c = '123000' + j*14,
                                       Email = 'email@'+j*9+'email.com',
                                      Phone = '12345678');

            contactList.add(cont);
        }

        Test.startTest();
        Database.SaveResult[] srList = Database.insert(contactList, true);
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                    System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                }
            }
        }
        Test.stopTest();
        
        Account account = 
            [SELECT Secuencia_contactos__c
            FROM Account
            WHERE Id =: ac.Id
            LIMIT 1
            ];

        List<Contact> contList = 
            [SELECT contactid__c, Email, Name
            FROM Contact 
            WHERE Phone = '12345678'
            ORDER BY Name
            ];
           
        System.assertEquals(secuenciaOriginal + 10,
                account.Secuencia_contactos__c,
                'No se ha actualizado el numero de contactos asociados a la cuenta ');
        
        Integer i = 3;

        for (Contact con : contList) {
            i++;
            System.assertEquals('' + i,
                                con.contactid__c,
                                'El contact id de la cuenta ' 
                                    + con.ID 
                                    + ' no coincide con lo esperado.'
                                );
        }
    }

    @isTest 
    static void pruebaInsertDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = 
            [SELECT ID, Secuencia_contactos__c
            FROM Account
            WHERE Name = 'Test Account'
            LIMIT 1
            ];


        Contact cont = new Contact(LastName = 'Contact',
                                       FirstName = 'Test',
                                       contactid__c = '0',
                                       AccountID = acc.ID,
                                       Numero_de_documento__c = '0001',
                                       Email = 'email@email.com',
                                  Phone = '12345678');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(cont, true);
        Test.stopTest();

        System.assertEquals(0, 
                            srInsert.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srInsert.isSuccess(),
                            'Hubo un error en el insert: ' + srInsert.getErrors()
                            );
    }

    @isTest 
    static void pruebaUpdateDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Contact con = 
            [SELECT ID
            FROM Contact 
            LIMIT 1
            ];

        con.Email = 'new@email.com';

        Test.startTest();
        Database.SaveResult srUpdate = Database.Update(con, true);
        Test.stopTest();

        System.assertEquals(0, 
                            srUpdate.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srUpdate.isSuccess(),
                            'Hubo un error en el insert: ' + srUpdate.getErrors()
                            );
    }

    @isTest 
    static void pruebaDeleteDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Contact con = 
            [SELECT ID
            FROM Contact 
            LIMIT 1
            ];

        Test.startTest();
        Database.DeleteResult srDelete = Database.Delete(con, true);
        Test.stopTest();

        System.assertEquals(0, 
                            srDelete.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srDelete.isSuccess(),
                            'Hubo un error en el insert: ' + srDelete.getErrors()
                            );
    }
}