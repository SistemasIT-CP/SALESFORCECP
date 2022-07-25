@isTest
public with sharing class TelefonoTriggerTest {
    @TestSetup
    static void generateAccountAndContact() {
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

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '123123';
        acc.Pa_s__c = paisTest.ID;
        acc.Municipio__c = municipioTest.ID;
        acc.Ciudad_UDC__c = departamentoTest.ID;
        acc.Departamento__c = departamentoTest.ID;
        acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
        insert acc;

        Account secAcc = new Account(Name = 'Second Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Email__c = 'secondemail@test.com',
                                  Cedula__c = '123123second',
                                  Phone = '88888888');

        secAcc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        secAcc.RecordTypeID = juridicaAccountID;
        secAcc.CodigoCliente__c = '123123second';
        secAcc.Pa_s__c = paisTest.ID;
        secAcc.Municipio__c = municipioTest.ID;
        secAcc.Ciudad_UDC__c = departamentoTest.ID;
        secAcc.Departamento__c = departamentoTest.ID;
        secAcc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
        insert secAcc;

        Contact contacto = TestFactory.createContact(acc.ID);
        insert contacto;

        Telefono__c tel = new Telefono__c(Cliente__c = acc.ID,
                                        Contacto__c = contacto.ID,
                                        areacode__c = '505',
                                        phonelinenumber__c = '',
                                        phonenumber__c = '123123');

        insert tel;
    }
    
    @IsTest
    static void cambiarContacto() {
        Telefono__c tel = 
            [SELECT ID, Contacto__c
            FROM Telefono__c
            WHERE phonenumber__c = '123123'
            ];
        
        Account acc =
            [SELECT ID
            FROM Account
            ][0];
        
        Contact con = TestFactory.createContact(acc.ID);
        insert con;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        tel.Contacto__c = con.Id;
        update tel;
        Test.stopTest();
        
        
    }

    @IsTest
    static void setearIDExterno_SecuenciaEnContactoYSecuenciaEnTelefonoTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Account acc = 
            [SELECT ID, CodigoCliente__c
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID, Secuencia_telefono__c
            FROM Contact 
            WHERE AccountID =: acc.ID
            LIMIT 1
            ];

        AccountContactRelation acr =
            [SELECT IdExterno__c
            FROM AccountContactRelation 
            WHERE AccountID =: acc.ID 
                AND ContactID =: contact.ID 
            LIMIT 1
            ];

        Decimal secuenciaTelefonoOriginal = contact.Secuencia_telefono__c == null? 0 : contact.Secuencia_telefono__c;

        List<Telefono__c> telefonosList = new List<Telefono__c>();

        for (Integer i = 0; i < 10; i++) {
            Telefono__c tel = new Telefono__c(Cliente__c = acc.ID,
                                        Contacto__c = contact.ID,
                                        areacode__c = '50' + i,
                                        phonelinenumber__c = '',
                                        phonenumber__c = '123123' + i);
            telefonosList.add(tel);
        }

        Test.startTest();
        insert telefonosList;
        Test.stopTest();
        
        Contact contactNuevo = 
        [SELECT ID, Secuencia_telefono__c
        FROM Contact 
        WHERE AccountID =: acc.ID
        LIMIT 1
        ];


        List<Telefono__c> telefonos = 
            [SELECT ID, phonelinenumber__c, IdExterno__c
            FROM Telefono__c
            WHERE Contacto__c =: contact.ID
            ORDER BY Name
            ];

        System.assertEquals(secuenciaTelefonoOriginal + 10,
                            contactNuevo.Secuencia_telefono__c,
                            'No se ha actualizado el numero de telefonos asociados al contacto');

        System.assertEquals(11, 
                            telefonos.size(),
                            'La cantidad de telefonos ingresadas no corresponde con lo esperado.');

        for (Telefono__c tel : telefonos) {
                                
            System.assertEquals('' + secuenciaTelefonoOriginal, 
                                tel.phonelinenumber__c,
                                'La secuencia de telefono no se esta seteando correctamente para el telefono ' + tel.ID
                                );
                                
            System.assertEquals(acr.IdExterno__c + '_' + secuenciaTelefonoOriginal, 
                                tel.IdExterno__c,
                                'El id externo no se esta seteando correctamente para el telefono ' + tel.ID
                                ); 

            secuenciaTelefonoOriginal++;
        }
    }

    @IsTest
    static void setearValidacionRelaciones(){
        Account acc = 
            [SELECT ID, CodigoCliente__c
            FROM Account
            WHERE Name = 'SECOND TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID, Secuencia_telefono__c
            FROM Contact 
            WHERE Name LIKE '%TEST%'
            LIMIT 1
            ];

        Telefono__c tel = new Telefono__c(Cliente__c = acc.ID,
                                        Contacto__c = contact.ID,
                                        areacode__c = '11',
                                        phonelinenumber__c = '',
                                        phonenumber__c = '999999999');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(tel, false);
        Test.stopTest();
        
        List<String> errList = new List<String> {'Debe elegir un contacto relacionado a la cuenta.',
                                                'La cuenta debe enviarse correctamente al WS para asociar un telefono'};

        System.assertEquals(2, 
                            srInsert.getErrors().size(),
                            'Algo esta fallando y la lista de errores no tiene elementos cuando deberia.'
                            );

        for (Database.Error err : srInsert.getErrors()) {
                    System.assertEquals(true, 
                                        errList.contains(err.getMessage()),
                                        'El error no esta seteandose correctamente'
                                        );

        }
    }

    @isTest 
    static void pruebaInsertDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = 
            [SELECT ID
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID
            FROM Contact 
            WHERE AccountID =: acc.ID
            LIMIT 1
            ];

        Telefono__c tel = new Telefono__c(Cliente__c = acc.ID,
                                        Contacto__c = contact.ID,
                                        areacode__c = '11',
                                        phonelinenumber__c = '',
                                        phonenumber__c = '999999999');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(tel, true);
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

        Telefono__c tel = 
            [SELECT ID
            FROM Telefono__c 
            WHERE phonenumber__c = '123123'
            ];

        tel.phonenumber__c = '999999';

        Test.startTest();
        Database.SaveResult srUpdate = Database.Update(tel, true);
        Test.stopTest();

        Telefono__c telChanged = 
            [SELECT ID, phonenumber__c
            FROM Telefono__c 
            WHERE ID =: tel.ID
            ];

        System.assertEquals(0, 
                            srUpdate.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srUpdate.isSuccess(),
                            'Hubo un error en el insert: ' + srUpdate.getErrors()
                            );

        System.assertEquals('999999', 
                            telChanged.phonenumber__c,
                            'El cambio del numero telefonico no se esta plasmando correctamente'
                            );
    }

    @isTest 
    static void pruebaDeleteDelWS() {

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Telefono__c tel = 
            [SELECT ID
            FROM Telefono__c 
            WHERE phonenumber__c = '123123'
            ];

        Test.startTest();
        Database.DeleteResult srDelete = Database.Delete(tel, true);
        Test.stopTest();

        System.assertEquals(0, 
                            srDelete.getErrors().size(),
                            'Algo esta fallando y la lista de errores tiene elementos.'
                            );

        System.assertEquals(true, 
                            srDelete.isSuccess(),
                            'Hubo un error en el insert: ' + srDelete.getErrors()
                            );

        System.assertEquals(0,
                            [SELECT count() 
                            FROM Telefono__c 
                            WHERE phonenumber__c = '123123'],
                            'El telefono sigue existiendo cuando no deberia hacerlo'
                            );
    }
}