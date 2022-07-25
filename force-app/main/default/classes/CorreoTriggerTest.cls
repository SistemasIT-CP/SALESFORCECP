@isTest
public with sharing class CorreoTriggerTest {
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
                                    .get('Tipos_de_eMail')
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
        secAcc.Pa_s__c = paisTest.ID;
        secAcc.Municipio__c = municipioTest.ID;
        secAcc.Ciudad_UDC__c = departamentoTest.ID;
        secAcc.Departamento__c = departamentoTest.ID;
        secAcc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID;
        secAcc.CodigoCliente__c = '123456';
        insert secAcc;

        Contact contacto = TestFactory.createContact(acc.ID);
        insert contacto;

        Correo__c correo = new Correo__c(Cliente__c = acc.ID,
                                        Contacto__c = contacto.ID,
                                        EMAILADDRESS__c = 'unemaildeprueba@mail.com');

        insert correo;
    }

    @IsTest
    static void setearIDExterno_SecuenciaEnContactoYSecuenciaEnEmailTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Account acc = 
            [SELECT ID, Secuencia_contactos__c
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID, Secuencia_correo__c
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

        Decimal secuenciaCorreoOriginal = contact.Secuencia_correo__c == null? 1 : contact.Secuencia_correo__c;

        List<Correo__c> correosList = new List<Correo__c>();

        for (Integer i = 0; i < 5; i++) {
            Correo__c correo = new Correo__c(Cliente__c = acc.ID,
                                             Contacto__c = contact.ID,
                                             EMAILADDRESS__c = 'test@mail' + i + '.com');
            correosList.add(correo);
        }

        Test.startTest();
        insert correosList;
        Test.stopTest();
        
        Contact contactNuevo = 
        [SELECT ID, Secuencia_correo__c
        FROM Contact 
        WHERE AccountID =: acc.ID
        LIMIT 1
        ];


        List<Correo__c> correos = 
            [SELECT ID, EMAILADDRESS__c, IdExterno_c__c, electronicaddresslinenumber__c
            FROM Correo__c
            WHERE Contacto__c =: contact.ID and EMAILADDRESS__c != 'unemaildeprueba@mail.com'
            ORDER BY electronicaddresslinenumber__c
            ];

        System.assertEquals(secuenciaCorreoOriginal + 5,
                            contactNuevo.Secuencia_correo__c,
                            'No se ha actualizado el numero de correos asociados al contacto');
        
        System.assertEquals(secuenciaCorreoOriginal + 3, 
                            correos.size(),
                            'La cantidad de correos ingresados no corresponde con lo esperado.');

        for (Correo__c corr : correos) {
            System.assertEquals(acr.IdExterno__c + '_' + (secuenciaCorreoOriginal + 1), 
                                corr.IdExterno_c__c,
                                'El id externo no se esta seteando correctamente para el correo ' + corr.ID
                                );
                                
            System.assertEquals('' + (secuenciaCorreoOriginal + 1), 
                                corr.electronicaddresslinenumber__c,
                                'La secuencia de mail no se esta seteando correctamente para el correo ' + corr.ID
                                );      

            secuenciaCorreoOriginal++;                
        }
    }

    @IsTest
    static void cambiarContacto() {
        Correo__c corr = 
            [SELECT ID, Contacto__c
            FROM Correo__c
            WHERE EMAILADDRESS__c = 'unemaildeprueba@mail.com'
            ];
        
        Account acc =
            [SELECT ID
            FROM Account
            ][0];
        
        Contact con = TestFactory.createContact(acc.ID);
        insert con;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        corr.Contacto__c = con.Id;
        update corr;
        Test.stopTest();
        
        
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

        Correo__c correo = new Correo__c(Cliente__c = acc.ID,
                                        Contacto__c = contact.ID,
                                        EMAILADDRESS__c = 'test@mail.com',
                                        electronicaddresslinenumber__c = '');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(correo, false);
        Test.stopTest();
        
        List<String> errList = new List<String> {'Debe elegir un contacto relacionado a la cuenta.',
                                                'La cuenta debe enviarse correctamente al WS para asociar un correo'};

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

        Account acc = 
            [SELECT ID, Secuencia_contactos__c, codigoCliente__c
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];
        
        System.debug(acc);

        Contact contact = 
            [SELECT ID, Secuencia_correo__c
            FROM Contact 
            WHERE AccountID =: acc.ID
            LIMIT 1
            ];

        Correo__c correo = new Correo__c(Cliente__c = acc.ID,
                                        Contacto__c = contact.ID,
                                        EMAILADDRESS__c = 'test@mail.com',
                                        electronicaddresslinenumber__c = '');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(correo, true);
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

        Correo__c correo = 
            [SELECT ID
            FROM Correo__c 
            WHERE EMAILADDRESS__c = 'unemaildeprueba@mail.com'
            ];

        correo.EMAILADDRESS__c = 'new@email.com';

        Test.startTest();
        Database.SaveResult srUpdate = Database.Update(correo, true);
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

        Correo__c correo = 
            [SELECT ID
            FROM Correo__c 
            WHERE EMAILADDRESS__c = 'unemaildeprueba@mail.com'
            ];

        Test.startTest();
        Database.DeleteResult srDelete = Database.Delete(correo, true);
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
                            FROM Correo__c 
                            WHERE EMAILADDRESS__c = 'test@mail.com'],
                            'El correo sigue existiendo cuando no deberia hacerlo'
                            );
    }
}