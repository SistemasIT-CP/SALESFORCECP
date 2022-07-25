@isTest
public class LeadTriggerTest {
    @TestSetup
    public static void makeUDCs(){
        ID paisUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Pais')
            .getRecordTypeId();
        
        ID modeloUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Modelo')
            .getRecordTypeId();
        
        ID marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Marcas')
            .getRecordTypeId();
        
        ID telefonoUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Tipo_de_Telefono')
            .getRecordTypeId();
        
        ID emailUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Tipos_de_eMail')
            .getRecordTypeId();
        
        ID nacionalidadUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Nacionalidad')
            .getRecordTypeId();
        
        ID municipioUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Municipio')
            .getRecordTypeId();
        
        ID departamentoUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Departamento')
            .getRecordTypeId();
        
        Catalogo_UDC__c nicaragua = new Catalogo_UDC__c (
            Name = 'Nicaragua',
            productcode__c = 'NIC',
            description1__c = 'Nicaragua',
            ExternalId__c = 'TEST_NIC',
            RecordTypeId = paisUDCID
        );
        
        Catalogo_UDC__c guatemala = new Catalogo_UDC__c (
            Name = 'Guatemala',
            productcode__c = 'GUA',
            description1__c = 'Guatemala',
            ExternalId__c = 'TEST_GUA',
            RecordTypeId = paisUDCID
        );
        
        Catalogo_UDC__c kia = new Catalogo_UDC__c (
            Name = 'Kia',
            productcode__c = 'KIA',
            description1__c = 'Kia',
            ExternalId__c = 'TEST_KIA',
            RecordTypeId = marcasUDCID
        );
        
        Catalogo_UDC__c suzuki = new Catalogo_UDC__c (
            Name = 'SUZUKI',
            productcode__c = 'SUZ',
            description1__c = 'Suzuki',
            ExternalId__c = 'TEST_SUZ',
            RecordTypeId = marcasUDCID
        );
        
        Catalogo_UDC__c picanto = new Catalogo_UDC__c (
            Name = 'Picanto',
            productcode__c = 'PIC',
            description1__c = 'Picanto',
            ExternalId__c = 'TEST_PIC',
            RecordTypeId = modeloUDCID
        );
        
        Catalogo_UDC__c alto = new Catalogo_UDC__c (
            Name = 'Alto',
            productcode__c = 'ALT',
            description1__c = 'Alto',
            ExternalId__c = 'TEST_ALT',
            RecordTypeId = modeloUDCID
        );
        
        Catalogo_UDC__c telefono = new Catalogo_UDC__c (
            Name = 'Telefono',
            productcode__c = 'T',
            description1__c = 'Telefono',
            RecordTypeId = telefonoUDCID
        );
        
        Catalogo_UDC__c email = new Catalogo_UDC__c (
            Name = 'Email',
            productcode__c = 'E',
            description1__c = 'Email',
            RecordTypeId = emailUDCID
        );
        
        Catalogo_UDC__c nacionalidad = new Catalogo_UDC__c (
            Name = 'Nacionalidad',
            productcode__c = 'N',
            description1__c = 'Nacionalidad',
            RecordTypeId = nacionalidadUDCID
        );
        
        Catalogo_UDC__c capitalFederal = new Catalogo_UDC__c (
            Name = 'Capital Federal',
            productcode__c = 'CP',
            description1__c = 'Capital Federal',
            RecordTypeId = departamentoUDCID
        );
        
        Catalogo_UDC__c buenosAires = new Catalogo_UDC__c (
            Name = 'Buenos Aires',
            productcode__c = 'BSAS',
            description1__c = 'Buenos Aires',
            RecordTypeId = municipioUDCID
        );
        
        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c>{
            nicaragua,
                guatemala,
                kia,
                suzuki,
                picanto,
                alto,
                telefono,
                email,
                nacionalidad,
                capitalFederal,
                buenosAires
                };
                    
                    insert catList;
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID juridicaAccountID = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Juridicos')
            .getRecordTypeId();
        
        Account acc = new Account(Name = 'Test Empresa',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '999999abc',
                                  Phone = '+505588888888');
        
        acc.Direccion__c = 'Direccion';
        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '321321';
        acc.Pa_s__c = nicaragua.ID;
        acc.Municipio__c = buenosAires.ID;
        acc.Ciudad_UDC__c = capitalFederal.ID;
        acc.Departamento__c = capitalFederal.ID;
        acc.Tipo_de_t_lefono__c = telefono.ID; 
        acc.Tipo_de_email__c = email.ID;
        insert acc;
        
        Test.setCreatedDate(acc.Id, Date.today().addDays(-7));  
    }
    
    @IsTest
    public static void insertLeadsAutolote() {
        ID autoloteID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Autolote')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'TestLead';
        ld.RecordTypeId = autoloteID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(ld, false);
        Test.stopTest();
        
        System.debug(sr);
        
        Lead lead = 
            [SELECT Marca_UDC__r.Name, Modelo_UDC__r.Name, Pais_UDC__r.Name 
             FROM Lead 
             WHERE LastName = 'TestLead'
            ];
        
        System.assertEquals(true, sr.isSuccess(), 'Algo ha salido mal en la insercion');
        System.assertEquals('Kia', lead.Marca_UDC__r.Name, 'La marca no coincide con lo esperado');
        System.assertEquals('Picanto', lead.Modelo_UDC__r.Name, 'El modelo no coincide con lo esperado');
        System.assertEquals('Nicaragua', lead.Pais_UDC__r.Name, 'El pais no coincide con lo esperado');
    }
    
    @IsTest
    public static void insertLeadsVentas() {
        ID ventasID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Ventas')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'TestLead';
        ld.RecordTypeId = ventasID;
        ld.Modelo_a_cotizar__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar__c = 'Kia';
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(ld, false);
          
        Test.stopTest();
        
        Lead lead = 
            [SELECT Marca_UDC__r.Name, Modelo_UDC__r.Name, Pais_UDC__r.Name 
             FROM Lead 
             WHERE LastName = 'TestLead'
            ];
        
        System.assertEquals(true, sr.isSuccess(), 'Algo ha salido mal en la insercion');
        System.assertEquals('Kia', lead.Marca_UDC__r.Name, 'La marca no coincide con lo esperado');
        System.assertEquals('Picanto', lead.Modelo_UDC__r.Name, 'El modelo no coincide con lo esperado');
        System.assertEquals('Nicaragua', lead.Pais_UDC__r.Name, 'El pais no coincide con lo esperado');
    }
    
    @IsTest
    public static void updateLeadsAutolote() {
        ID autoloteID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Autolote')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'TestLead';
        ld.RecordTypeId = autoloteID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        insert ld;
        
        
        ld.Modelo_a_cotizar_autolote__c = 'Alto';
        ld.Pais_de_origen__c = 'Guatemala';
        ld.Marca_a_cotizar_autolote__c = 'Suzuki';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(ld, false);
        Test.stopTest();
        
        
        Lead lead = 
            [SELECT Marca_UDC__r.Name, Modelo_UDC__r.Name, Pais_UDC__r.Name 
             FROM Lead 
             WHERE LastName = 'TestLead'
            ];
        
        System.assertEquals(true, sr.isSuccess(), 'Algo ha salido mal en la insercion');
        System.assertEquals('SUZUKI', lead.Marca_UDC__r.Name, 'La marca no coincide con lo esperado');
        System.assertEquals('Alto', lead.Modelo_UDC__r.Name, 'El modelo no coincide con lo esperado');
        System.assertEquals('Guatemala', lead.Pais_UDC__r.Name, 'El pais no coincide con lo esperado');
    }
    
    @IsTest
    public static void updateLeadsVentas() {
        ID ventasID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Ventas')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'TestLead';
        ld.RecordTypeId = ventasID;
        ld.Modelo_a_cotizar__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar__c = 'Kia';
        insert ld;
        
        ld.Modelo_a_cotizar__c = 'Alto';
        ld.Pais_de_origen__c = 'Guatemala';
        ld.Marca_a_cotizar__c = 'Suzuki';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(ld, false);
        Test.stopTest();
        
        Lead lead = 
            [SELECT Marca_UDC__r.Name, Modelo_UDC__r.Name, Pais_UDC__r.Name 
             FROM Lead 
             WHERE LastName = 'TestLead'
            ];
        
        System.assertEquals(true, sr.isSuccess(), 'Algo ha salido mal en la insercion');
        System.assertEquals('SUZUKI', lead.Marca_UDC__r.Name, 'La marca no coincide con lo esperado');
        System.assertEquals('Alto', lead.Modelo_UDC__r.Name, 'El modelo no coincide con lo esperado');
        System.assertEquals('Guatemala', lead.Pais_UDC__r.Name, 'El pais no coincide con lo esperado');
    }
    
    @IsTest
    public static void eliminarContactoLuegoDeConvertir() {
        List<Catalogo_UDC__c> tipoTelefono =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipo_de_Telefono'
            ];
        
        List<Catalogo_UDC__c> tipoEmail =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipos_de_eMail'
            ];
        
        List<Catalogo_UDC__c> tipoNacionalidad =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Nacionalidad'
            ];
        
        ID autoloteID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Autolote')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'Lead';
        ld.FirstName = 'Test';
        ld.Direccion__c = 'Test direccion';
        ld.Company = 'TestCompany';
        ld.Tipo_de_email_UDC__c = tipoEmail[0].ID;
        ld.Tipo_de_telefono_UDC__c = tipoTelefono[0].ID;
        ld.Tipo_de_documento__c = 'Otros';
        ld.Phone = '12345678';
        ld.Email = 'email@email.com';
        ld.Nacionalidad__c = tipoNacionalidad[0].ID;
        ld.RecordTypeId = autoloteID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        ld.Cedula_Nro__c = '123456';
        ld.Title = 'Cargo de prueba';
        ld.OwnerId = UserInfo.getUserId();
        
        insert ld;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Database.LeadConvert lc = new database.LeadConvert();  
        lc.setLeadId(ld.ID);  
        lc.setDoNotCreateOpportunity(true);  
        lc.setConvertedStatus('Convertido');  
        lc.setOwnerId(ld.OwnerId);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
        test.stopTest();
        
        System.debug(lcr);
        
        System.assertEquals(true, lcr.isSuccess(), 'La conversion está fallando');
        
        List<Account> accList = 
            [SELECT ID, Envio_correcto_a_WS__c, Name
             FROM Account
             WHERE Name = 'TESTCOMPANY'
            ];
        
        List<Contact> contList = 
            [SELECT ID
             FROM Contact
             WHERE Name = 'TEST LEAD' OR Creado_desde_un_Lead__c = true
            ];
        
        System.assertEquals(true, !accList.isEmpty(), 'La lista de cuentas convertidas esta vacia cuando no deberia');
        
        for (Account acc : accList) {
            System.assertEquals(true, acc.Envio_correcto_a_WS__c, 'La cuenta ' + acc.Name + ' se ingresó correctamente');
        }
        
        System.assertEquals(true, contList.isEmpty(), 'La lista de contactos convertidos no esta vacia cuando deberia');
    }
    
    @IsTest
    public static void convertirCorrectamenteCuentasPersonales() {
        List<Catalogo_UDC__c> tipoTelefono =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipo_de_Telefono'
            ];
        
        List<Catalogo_UDC__c> tipoEmail =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipos_de_eMail'
            ];
        
        List<Catalogo_UDC__c> tipoNacionalidad =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Nacionalidad'
            ];
        
        ID autoloteID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Autolote')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'Lead';
        ld.FirstName = 'Test';
        ld.Direccion__c = 'Test direccion';
        ld.Tipo_de_email_UDC__c = tipoEmail[0].ID;
        ld.Tipo_de_telefono_UDC__c = tipoTelefono[0].ID;
        ld.Tipo_de_documento__c = 'Otros';
        ld.Phone = '12345678';
        ld.Email = 'email@email.com';
        ld.Nacionalidad__c = tipoNacionalidad[0].ID;
        ld.RecordTypeId = autoloteID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        ld.Cedula_Nro__c = '123456';
        ld.OwnerId = UserInfo.getUserId();
        
        insert ld;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Database.LeadConvert lc = new database.LeadConvert();  
        lc.setLeadId(ld.ID);  
        lc.setDoNotCreateOpportunity(true);  
        lc.setConvertedStatus('Convertido');  
        lc.setOwnerId(ld.OwnerId);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
        test.stopTest();
        
        System.assertEquals(true, lcr.isSuccess(), 'La conversion está fallando');
        
        List<Lead> ldList = [
            SELECT ConvertedAccountId
            FROM Lead
            WHERE ID =: ld.Id
        ];
        
        List<Account> accList = 
            [SELECT ID, Envio_correcto_a_WS__c, Name, Email__c
             FROM Account
             WHERE ID =: ldList[0].ConvertedAccountId
            ];
        
        System.assertEquals(true, !accList.isEmpty(), 'La lista de cuentas convertidas esta vacia cuando no deberia');
        
        for (Account acc : accList) {
            System.assertEquals('email@email.com', acc.Email__c, 'El email no se setea correctamente en la cuenta ' + acc.Name);
        }
    } 
    
    @IsTest
    public static void convertirOportunidades() {
        List<Catalogo_UDC__c> tipoTelefono =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipo_de_Telefono'
            ];
        
        List<Catalogo_UDC__c> tipoEmail =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Tipos_de_eMail'
            ];
        
        List<Catalogo_UDC__c> tipoNacionalidad =
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Nacionalidad'
            ];
        
        ID ventasID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Ventas')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'Lead';
        ld.FirstName = 'Test';
        ld.Direccion__c = 'Test direccion';
        ld.Tipo_de_email_UDC__c = tipoEmail[0].ID;
        ld.Tipo_de_telefono_UDC__c = tipoTelefono[0].ID;
        ld.Tipo_de_documento__c = 'Otros';
        ld.Phone = '12345678';
        ld.Email = 'email@email.com';
        ld.Nacionalidad__c = tipoNacionalidad[0].ID;
        ld.RecordTypeId = ventasID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        ld.Cedula_Nro__c = '123456';
        ld.Como_desea_realizar_su_compra__c = 'Contado';
        ld.Desea_realizar_intercambios__c = true;
        ld.OwnerId = UserInfo.getUserId();
        
        insert ld;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Database.LeadConvert lc = new database.LeadConvert();  
        lc.setLeadId(ld.ID);  
        lc.setDoNotCreateOpportunity(false);  
        lc.setConvertedStatus('Convertido');  
        lc.setOwnerId(ld.OwnerId);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
        test.stopTest();
        
        System.debug(lcr.getErrors());
        System.assertEquals(true, lcr.isSuccess(), 'La conversion está fallando');
        
        List<Lead> ldList = 
            [SELECT ConvertedOpportunityId 
             FROM Lead
             WHERE ID =: ld.ID
            ];
        
        List<Opportunity> oppList = 
            [SELECT ID, Forma_de_Pago_Multiple__c, Desea_realizar_intercambio__c
             FROM Opportunity
             WHERE ID =: ldList[0].ConvertedOpportunityId
            ];
        
        System.assertEquals(true, !oppList.isEmpty(), 'La lista de oportunidades convertidas esta vacia cuando no deberia');
        
        System.assertEquals('Contado', oppList[0].Forma_de_Pago_Multiple__c, 'La forma de adquisicion no se ha seteado correctamente');
        System.assertEquals('SI', oppList[0].Desea_realizar_intercambio__c, 'Desea realizar intercambio no se ha seteado correctamente');
    } 
    
    @IsTest
    public static void convertirConError() {
        ID autoloteID = Schema.SObjectType.Lead
            .getRecordTypeInfosByDeveloperName()
            .get('Autolote')
            .getRecordTypeId();
        
        Lead ld = new Lead();
        ld.LastName = 'Lead';
        ld.FirstName = 'Test';
        ld.Company = 'TestCompany';
        ld.RecordTypeId = autoloteID;
        ld.Modelo_a_cotizar_autolote__c = 'Picanto';
        ld.Pais_de_origen__c = 'Nicaragua';
        ld.Marca_a_cotizar_autolote__c = 'Kia';
        ld.OwnerId = UserInfo.getUserId();
        
        insert ld;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new HTTPErrorMock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Database.LeadConvert lc = new database.LeadConvert();  
        lc.setLeadId(ld.ID);  
        lc.setDoNotCreateOpportunity(false);  
        lc.setConvertedStatus('Convertido');  
        lc.setOwnerId(ld.OwnerId);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
        test.stopTest();
        
        List<Debug_log__c> debugList =
            [SELECT ID
             FROM Debug_log__c
            ];
        
        System.assertEquals(false, lcr.isSuccess(), 'La conversión no está fallando cuando deberia hacerlo');
        System.assertEquals(true, debugList.isEmpty(), 'No se estan creando debugs cuando hay un error');
    } 
    
    /*@IsTest
public static void convertirLeadAUnaCuentaExistente(){
ID anfitrionId = Schema.SObjectType.Lead
.getRecordTypeInfosByDeveloperName()
.get('Anfitrion')
.getRecordTypeId();

Account acc = [
SELECT Id 
FROM Account
];

Lead ld = new Lead();
ld.LastName = 'Lead';
ld.FirstName = 'Test';
ld.RecordTypeId = anfitrionId;
ld.Company = 'Test Empresa';
ld.OwnerId = UserInfo.getUserId();

insert ld;
Test.setCreatedDate(ld.Id, System.now().addDays(-1));


Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

Test.startTest();
Database.LeadConvert lc = new database.LeadConvert();  
lc.setLeadId(ld.Id);  
lc.setAccountId(acc.Id);  
lc.setDoNotCreateOpportunity(true);  
lc.setConvertedStatus('Convertido');  
lc.setOwnerId(ld.OwnerId);
Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
Test.stopTest();

System.debug(lcr.getErrors()[0].getMessage());

System.assertEquals(false, lcr.isSuccess(), 'La conversión no está fallando cuando deberia hacerlo');
System.assertEquals(true, 
lcr.getErrors()[0].getMessage().contains(
'La cuenta que ha seleccionado tiene los siguientes campos requeridos vacios:' + 
' Tipo de identificación. Por favor rellenelos en el lead para convertir.'
), 
'El mensaje de error al convertir para una cuenta existente no es el esperado'
);
}*/
    
    /*@IsTest
public static void convertirLeadAUnaCuentaNueva(){
ID anfitrionId = Schema.SObjectType.Lead
.getRecordTypeInfosByDeveloperName()
.get('Anfitrion')
.getRecordTypeId();

Account acc = [
SELECT Id 
FROM Account
];

Lead ld = new Lead();
ld.LastName = 'Lead';
ld.FirstName = 'Test';
ld.RecordTypeId = anfitrionId;
ld.Cedula_Nro__c = '123456';
ld.Tipo_de_documento__c = 'Otros';
ld.Company = 'Test Empresa';
ld.OwnerId = UserInfo.getUserId();

insert ld;

Test.startTest();
Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

Database.LeadConvert lc = new database.LeadConvert();  
lc.setLeadId(ld.Id);  
lc.setDoNotCreateOpportunity(true);  
lc.setConvertedStatus('Convertido');  
lc.setOwnerId(ld.OwnerId);
Database.LeadConvertResult lcr = Database.convertLead(lc, false);  
Test.stopTest();

System.assertEquals(false, lcr.isSuccess(), 'La conversión no está fallando cuando deberia hacerlo');
System.assertEquals(true, 
lcr.getErrors()[0].getMessage().contains('Para convertir debe completar los campos: Dirección,' + 
' País, Tipo de teléfono, Email, Nacionalidad, Teléfono, Tipo de email'
), 
'El mensaje de error al convertir para una cuenta nueva no es el esperado'
);
}*/
}