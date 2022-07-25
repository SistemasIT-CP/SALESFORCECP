@isTest
public with sharing class AccountContactRelationTriggerTest {
    @TestSetup
    static void generateUDC(){
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
    }

    @IsTest
    static void insertRelationAndCheckIdExterno(){
        Map<String, ID> catIDByName = new Map<String, ID>();

        for(Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE Name LIKE '%TEST%']) {
            catIDByName.put(cat.Name, cat.ID);
        }

        System.debug(catIDByName);

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
                                  Phone = '12345678',
                                  Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                                            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit');


        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '321321';
        acc.Pa_s__c = catIDByName.get('PAIS_TEST');
        acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
        acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 
        insert acc;

        Contact cont = new Contact(LastName = 'Contact ',
                                       FirstName = 'Test',
                                   	   Phone = '12345678',
                                       AccountID = acc.ID,
                                       Numero_de_documento__c = '0008',
                                       Email = 'email@email.com');

        Test.startTest();
        insert cont;
        Test.stopTest();

        AccountContactRelation acr =
            [SELECT ID, IdExterno__c, AccountID, ContactID, CreatedBy.Name 
            FROM AccountContactRelation 
            WHERE AccountID =: acc.ID 
            LIMIT 1
            ];
        
        System.debug(acr);
            
        System.assertEquals(acc.ID,
                            acr.AccountID,
                            'La cuenta no es la correcta');

        System.assertEquals(cont.ID,
                            acr.ContactID,
                            'El contacto no es la correcto');

        System.assertEquals('321321_3', 
                            acr.IdExterno__c,
                            'El idExterno no se ha seteado correctamente');
    }

    @IsTest
    static void deleteACR(){
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

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '12345678',
                                  Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                                            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit');

        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '321321';
        acc.Pa_s__c = catIDByName.get('PAIS_TEST');
        acc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
        acc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
        acc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 
        insert acc;

        Account secAcc = new Account(Name = 'Second Test Account',
                                  CurrencyIsoCode = 'USD',
                                  Email__c = 'secondemail@test.com',
                                  Cedula__c = '123123second',
                                  Phone = '12345678');

        secAcc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        secAcc.RecordTypeID = juridicaAccountID;
        secAcc.CodigoCliente__c = '123123second';
        secAcc.Pa_s__c = catIDByName.get('PAIS_TEST');
        secAcc.Municipio__c = catIDByName.get('MUNICIPIO_TEST');
        secAcc.Ciudad_UDC__c = catIDByName.get('DEPARTAMENTO_TEST');
        secAcc.Departamento__c = catIDByName.get('DEPARTAMENTO_TEST');
        secAcc.Tipo_de_t_lefono__c = catIDByName.get('TIPO_TELEFONO_TEST'); 
        insert secAcc;

        Contact cont = new Contact(LastName = 'Contact ',
                                       FirstName = 'Test',
                                       AccountID = secAcc.ID,
                                       Numero_de_documento__c = '0008',
                                   	   Phone = '12345678',
                                       Email = 'email@email.com');

        insert cont;


        AccountContactRelation acr = new AccountContactRelation(AccountID = acc.ID, 
                                                                ContactID = cont.ID);
        
        insert acr;

        Test.startTest();
        delete acr;
        Test.stopTest();

        System.assertEquals(0, 
                            [SELECT count()
                            FROM AccountContactRelation 
                            WHERE AccountID =: acc.ID 
                                AND ContactID =: cont.ID],
                            'La relacion sigue existiendo aunque deberia haberse eliminado');
    }

}