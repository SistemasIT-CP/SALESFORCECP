@isTest
public with sharing class DireccionesAlterTriggerTest {
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
        
        Id tipoDireccionUDCID = Schema.SObjectType.Catalogo_UDC__c
                            .getRecordTypeInfosByDeveloperName()
                            .get('Tipo_de_Direccion')
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
            
        Catalogo_UDC__c tipoDireccion = new Catalogo_UDC__c();
        tipoDireccion.Name = 'Tipo de direccion';
        tipoDireccion.productcode__c = 'D';
        tipoDireccion.RecordTypeId = tipoDireccionUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {paisTest,
                                                                  municipioTest,
                                                                  departamentoTest,
                                                                  tipoTelefonoTest,
           											 		      tipoDireccion} ;
	
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

        DireccionesAlter__c dir = new DireccionesAlter__c(Cliente__c = acc.ID,
                                                            Contacto__c = contacto.ID,
                                                            Direccion__c = 'Direccion Test Setup',
                                                            SEQUENCEADDRESS__c = '',
                                                            Tipo_de_direcci_n__c = tipoDireccion.ID);

        insert dir;
    }

    @IsTest
    static void setearIDExterno_SecuenciaEnContactoYSecuenciaEnDireccionTest() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID, Secuencia_direccion__c
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

        Decimal secuenciaDireccionOriginal = contact.Secuencia_direccion__c == null? 0 : contact.Secuencia_direccion__c;

        List<DireccionesAlter__c> direccionesList = new List<DireccionesAlter__c>();

        for (Integer i = 0; i < 10; i++) {
            DireccionesAlter__c dir = new DireccionesAlter__c(
                                            Cliente__c = acc.ID,
                                            Contacto__c = contact.ID,
                                            Direccion__c = 'Direccion Test ' + i,
                                            SEQUENCEADDRESS__c = '');
            direccionesList.add(dir);
        }

        Test.startTest();
        insert direccionesList;
        Test.stopTest();
        
        Contact contactNuevo = 
        [SELECT ID, Secuencia_direccion__c
        FROM Contact 
        WHERE AccountID =: acc.ID
        LIMIT 1
        ];


        List<DireccionesAlter__c> direcciones = 
            [SELECT ID, SEQUENCEADDRESS__c, Id_Externo__c
            FROM DireccionesAlter__c
            WHERE Contacto__c =: contact.ID
            ORDER BY Name
            ];

        System.assertEquals(secuenciaDireccionOriginal + 10,
                            contactNuevo.Secuencia_direccion__c,
                            'No se ha actualizado el numero de direcciones asociadas al contacto');

        System.assertEquals(11, 
                            direcciones.size(),
                            'La cantidad de direcciones ingresadas no corresponde con lo esperado.');

        for (DireccionesAlter__c dir : direcciones) {
                                
            System.assertEquals('' + secuenciaDireccionOriginal, 
                                dir.SEQUENCEADDRESS__c,
                                'La secuencia de direccion no se esta seteando correctamente para la direccion ' + dir.ID
                                );
                                
            System.assertEquals(acr.IdExterno__c + '_' + secuenciaDireccionOriginal, 
            dir.Id_Externo__c,
                                'El id externo no se esta seteando correctamente para la direccion ' + dir.ID
                                ); 

            secuenciaDireccionOriginal++;
        }
    }
    
    @IsTest
    static void cambiarContacto() {
        DireccionesAlter__c dir = 
            [SELECT ID, Contacto__c
            FROM DireccionesAlter__c
            WHERE Direccion__c = 'Direccion Test Setup'
            ];
        
        Account acc =
            [SELECT ID
            FROM Account
            ][0];
        
        Contact con = TestFactory.createContact(acc.ID);
        insert con;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        dir.Contacto__c = con.Id;
        update dir;
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

        DireccionesAlter__c dir = new DireccionesAlter__c(
                                            Cliente__c = acc.ID,
                                            Contacto__c = contact.ID,
                                            Direccion__c = 'Direccion Test',
                                            SEQUENCEADDRESS__c = '');

        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(dir, false);
        Test.stopTest();
        
        List<String> errList = new List<String> {'Debe elegir un contacto relacionado a la cuenta.',
                                                'La cuenta debe enviarse correctamente al WS para asociar una direccion alterna'};

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
            [SELECT ID, Secuencia_contactos__c
            FROM Account
            WHERE Name = 'TEST ACCOUNT'
            LIMIT 1
            ];

        Contact contact = 
            [SELECT ID, Secuencia_direccion__c
            FROM Contact 
            WHERE AccountID =: acc.ID
            LIMIT 1
            ];

        DireccionesAlter__c dir = new DireccionesAlter__c(
                                            Cliente__c = acc.ID,
                                            Contacto__c = contact.ID,
                                            Direccion__c = 'Direccion Test',
                                            SEQUENCEADDRESS__c = '');


        Test.startTest();
        Database.SaveResult srInsert = Database.Insert(dir, true);
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

        DireccionesAlter__c dir = 
            [SELECT ID
            FROM DireccionesAlter__c 
            WHERE Direccion__c = 'Direccion Test Setup'
            ];

        dir.Direccion__c = 'Otra direccion';

        Test.startTest();
        Database.SaveResult srUpdate = Database.Update(dir, true);
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

        DireccionesAlter__c dir = 
            [SELECT ID
            FROM DireccionesAlter__c 
            WHERE direccion__c = 'Direccion Test Setup'
            ];

        Test.startTest();
        Database.DeleteResult srDelete = Database.Delete(dir, true);
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
                            FROM DireccionesAlter__c 
                            WHERE Direccion__c = 'Direccion Test Setup'],
                            'La direccion sigue existiendo cuando no deberia hacerlo'
                            );
    }
}