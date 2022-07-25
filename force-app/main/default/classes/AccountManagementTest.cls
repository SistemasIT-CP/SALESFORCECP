@isTest
public class AccountManagementTest {
	@TestSetup
    public static void createAccountAndUDC() {
    	Id paisUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Pais')
                                    .getRecordTypeId();
        
        Id generoUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Genero')
                                    .getRecordTypeId();

        Id departamentoUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Departamento')
                                    .getRecordTypeId();

        Id municipioUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Municipio')
                                    .getRecordTypeId();

        Id nacionalidadUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Nacionalidad')
                                    .getRecordTypeId();
        
        Id tipoTelUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Tipo_de_Telefono')
                                    .getRecordTypeId();
        
        Id tipoEmailUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Tipos_de_eMail')
                                    .getRecordTypeId();

        Catalogo_UDC__c paisTest = new Catalogo_UDC__c();
        paisTest.Name = 'Pais';
        paisTest.productcode__c = 'P';
        paisTest.RecordTypeId = paisUDCID;

        Catalogo_UDC__c municipioTest = new Catalogo_UDC__c();
        municipioTest.Name = 'Municipio';
        municipioTest.productcode__c = 'M';
        municipioTest.RecordTypeId = municipioUDCID;

        Catalogo_UDC__c departamentoTest = new Catalogo_UDC__c();
        departamentoTest.Name = 'Departamento';
        departamentoTest.productcode__c = 'D';
        departamentoTest.RecordTypeId = departamentoUDCID;

        Catalogo_UDC__c tipoTelefonoTest = new Catalogo_UDC__c();
        tipoTelefonoTest.Name = 'Telefono';
        tipoTelefonoTest.productcode__c = 'T';
        tipoTelefonoTest.RecordTypeId = tipoTelUDCID;
        
        Catalogo_UDC__c tipoEmailTest = new Catalogo_UDC__c();
        tipoEmailTest.Name = 'Email';
        tipoEmailTest.productcode__c = 'E';
        tipoEmailTest.RecordTypeId = tipoEmailUDCID;
        
        Catalogo_UDC__c generoTest = new Catalogo_UDC__c();
        generoTest.Name = 'Genero';
        generoTest.productcode__c = 'G';
        generoTest.RecordTypeId = generoUDCID;
        
        Catalogo_UDC__c nacionalidadTest = new Catalogo_UDC__c();
        nacionalidadTest.Name = 'Nacionalidad';
        nacionalidadTest.productcode__c = 'N';
        nacionalidadTest.RecordTypeId = nacionalidadUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {
            paisTest, municipioTest, departamentoTest, tipoTelefonoTest, tipoEmailTest, generoTest, nacionalidadTest
		};

        insert catList;

        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());

        ID juridicaAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('Juridicos')
                .getRecordTypeId();
        
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        Account accJ = new Account();
		accJ.Name = 'Cuenta Juridica Test';
        accJ.CodigoCliente__c = '123456';
        accJ.Cedula__c = '1001';
        accJ.Creado_desde_Sitio_Externo__c = true;
        insert accJ;
        
        Account accP = new Account();
        accP.FirstName = 'Cuenta Personal';
        accP.LastName = 'Test';
        accP.CodigoCliente__c = '654321';
        accP.Cedula__c = '1000';
        accP.Creado_desde_Sitio_Externo__c = true;
        insert accP;
    }
    
    @isTest
    public static void modificarCuentaPersonal() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        String r = AccountManagement.editRecord(
            						'654321', 'Genero', 'Nueva direccion', 'Municipio', 'Departamento', 
                                    'Departamento','Pais', '88888888', 'Telefono', 'nuevo@email.com', 'Email', 'Nacionalidad', '');
        Test.stopTest();
        
        List<Account> accJ =
            [SELECT ID, Name, Genero_UDC__pr.Name, Direccion__c, Municipio__r.Name, Ciudad_UDC__r.Name, 
                    Departamento__r.Name, Pa_s__r.Name, Tipo_de_t_lefono__r.Name, Phone, 
                    Tipo_de_Indentificaci_n__c, Cedula__c, Email__c, Tipo_de_email__r.Name, Nacionalidad_UDC__r.Name
            FROM Account
            WHERE CodigoCliente__c = '654321'
            ];
        
        System.assertEquals('La modificacion de la cuenta 654321 ha sido un éxito!', r, 'La respuesta no es la que corresponde');
        System.assertEquals('Genero', accJ[0].Genero_UDC__pr.Name, 'El genero seteado no es el que corresponde');
        System.assertEquals('Nueva direccion', accJ[0].Direccion__c, 'La direccion seteada no es la que corresponde');
        System.assertEquals('Municipio', accJ[0].Municipio__r.Name, 'El municipio seteado no es el que corresponde');
        System.assertEquals('Departamento', accJ[0].Ciudad_UDC__r.Name, 'La ciudad seteada no es la que corresponde');
        System.assertEquals('Departamento', accJ[0].Departamento__r.Name, 'El departamento seteado no es el que corresponde');
        System.assertEquals('Pais', accJ[0].Pa_s__r.Name, 'El pais seteado no es el que corresponde');
        System.assertEquals('88888888', accJ[0].Phone, 'El telefono seteado no es el que corresponde');
        System.assertEquals('Telefono', accJ[0].Tipo_de_t_lefono__r.Name, 'El tipo de telefono seteado no es el que corresponde');
        System.assertEquals('nuevo@email.com', accJ[0].Email__c, 'El mail seteado no es el que corresponde');
        System.assertEquals('Email', accJ[0].Tipo_de_email__r.Name, 'El tipo de email seteado no es el que corresponde');
        System.assertEquals('Nacionalidad', accJ[0].Nacionalidad_UDC__r.Name, 'La nacionalidad seteada no es la que corresponde');
    }
    
    @isTest
    public static void modificarCuentaJuridica() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        String r = AccountManagement.editRecord(
            						'123456', 'Genero', 'Nueva direccion', 'Municipio', 'Departamento', 
                                    'Departamento','Pais', '88888888', 'Telefono', 'nuevo@email.com', 'Email', 'Nacionalidad', 'Pesca');
        Test.stopTest();
        
        List<Account> accJ =
            [SELECT ID, Direccion__c, Municipio__r.Name, Ciudad_UDC__r.Name, 
                    Departamento__r.Name, Pa_s__r.Name, Tipo_de_t_lefono__r.Name, Phone, 
                    Segmentaci_n_por_linea__c, Email__c, Tipo_de_email__r.Name
            FROM Account
            WHERE CodigoCliente__c = '123456'
            ];
        
        System.assertEquals('La modificacion de la cuenta 123456 ha sido un éxito!', r, 'La respuesta no es la que corresponde');
        System.assertEquals('Nueva direccion', accJ[0].Direccion__c, 'La direccion seteada no es la que corresponde');
        System.assertEquals('Municipio', accJ[0].Municipio__r.Name, 'El municipio seteado no es el que corresponde');
        System.assertEquals('Departamento', accJ[0].Ciudad_UDC__r.Name, 'La ciudad seteada no es la que corresponde');
        System.assertEquals('Departamento', accJ[0].Departamento__r.Name, 'El departamento seteado no es el que corresponde');
        System.assertEquals('Pais', accJ[0].Pa_s__r.Name, 'El pais seteado no es el que corresponde');
        System.assertEquals('88888888', accJ[0].Phone, 'El telefono seteado no es el que corresponde');
        System.assertEquals('Telefono', accJ[0].Tipo_de_t_lefono__r.Name, 'El tipo de telefono seteado no es el que corresponde');
        System.assertEquals('nuevo@email.com', accJ[0].Email__c, 'El mail seteado no es el que corresponde');
        System.assertEquals('Email', accJ[0].Tipo_de_email__r.Name, 'El tipo de email seteado no es el que corresponde');	    
        System.assertEquals('Pesca', accJ[0].Segmentaci_n_por_linea__c, 'La segmentacion seteada no es la que corresponde');	    
    }
    
    @isTest
    public static void modificarCuentaInexistente() {
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://gcpcrm--dev3.my.salesforce.com/services/apexrest/AccountManagement/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        
        String json = '{"codigoCliente": "0"}';
        
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        String r = AccountManagement.editRecord(
            						'0', '', '', '', '', 
                                    '','', '', '', '', '', '', '');
        Test.stopTest();
        
        System.assertEquals('La cuenta con código de cliente 0 no existe.', r, 'El codigo de error seteado no es el correcto');
    }
    
    @isTest
    public static void modificarCuentaConDatosErroneos() {
    	RestRequest request = new RestRequest();
        request.requestUri =
            'https://gcpcrm--dev3.my.salesforce.com/services/apexrest/AccountManagement/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        
        String json = '{"codigoCliente": "123456", "nombre":"Nuevo nombre", "direccion":"Nueva direccion",'+
            ' "municipio":"M", "ciudad":"Departamento", "departamento":"D", "pais":"P", "tipoDeIdentificacion":"Otros",'+
            ' "identificacion":"99999", "telefono":"99999", "tipoDeTelefono":"T", "email":"nuevo@email.com", "tipoDeEmail":"E"}';
        
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        String r = AccountManagement.editRecord(
            						'123456', '', '', '', '', 
                                    '','', '', '', 'unEmailErroneo', '', '', '');
        Test.stopTest();
        
        List<Account> accJ =
            [SELECT ID, Name, Direccion__c, Municipio__r.Name, Ciudad_UDC__r.Name, 
                    Departamento__r.Name, Pa_s__r.Name, Tipo_de_t_lefono__r.Name, Phone, 
                    Tipo_de_Indentificaci_n__c, Cedula__c, Email__c, Tipo_de_email__r.Name
            FROM Account
            WHERE CodigoCliente__c = '123456'
            ];
        
        System.assertEquals('El email no tiene un formato valido en Salesforce.', r, 'El codigo de error seteado no es el correcto');	        
    }
    
    @isTest
    public static void creacionCuentaJuridica() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        String r = AccountManagement.createNewRecords(
            						'Juridico', '', '', '', 'Nuevo nombre', '', 'Nueva direccion',
                                    'Municipio', 'Departamento', 'Departamento' ,'Pais', 'Otros', '99999', '88888888', 'Pesca', 'Telefono',
                                    'nuevo@email.com', 'Email', '');
        Test.stopTest();
        
        System.debug(r);

        String codigoCliente = r.split(':')[1].trim();
        
        List<Account> accJ =
            [SELECT ID, Name, Genero_UDC__pr.Name, Direccion__c, Municipio__r.Name, Ciudad_UDC__r.Name, 
                    Departamento__r.Name, Pa_s__r.Name, Tipo_de_t_lefono__r.Name, Phone, 
                    Tipo_de_Indentificaci_n__c, Cedula__c, Email__c, Tipo_de_email__r.Name, Nacionalidad_UDC__r.Name,
             		RecordType.DeveloperName
            FROM Account
            WHERE CodigoCliente__c =: codigoCliente
            ];
        
        System.assertEquals(false, accJ.isEmpty(), 'La lista está vacia cuando no deberia estarlo.');
        
        System.assertEquals('Juridicos', accJ[0].RecordType.DeveloperName, 'El tipo de cuenta no se ha seteado correctamente.');
        System.assertEquals('NUEVO NOMBRE', accJ[0].Name, 'El nombre seteado no es el que corresponde');
        System.assertEquals('Nueva direccion', accJ[0].Direccion__c, 'La direccion seteada no es la que corresponde');
        System.assertEquals('Municipio', accJ[0].Municipio__r.Name, 'El municipio seteado no es el que corresponde');
        System.assertEquals('Departamento', accJ[0].Ciudad_UDC__r.Name, 'La ciudad seteada no es la que corresponde');
        System.assertEquals('Departamento', accJ[0].Departamento__r.Name, 'El departamento seteado no es el que corresponde');
        System.assertEquals('Pais', accJ[0].Pa_s__r.Name, 'El pais seteado no es el que corresponde');
        System.assertEquals('Otros', accJ[0].Tipo_de_Indentificaci_n__c, 'El tipo de id seteado no es el que corresponde');
        System.assertEquals('99999', accJ[0].Cedula__c, 'La cedula seteada no es la que corresponde');
        System.assertEquals('88888888', accJ[0].Phone, 'El telefono seteado no es el que corresponde');
        System.assertEquals('Telefono', accJ[0].Tipo_de_t_lefono__r.Name, 'El tipo de telefono seteado no es el que corresponde');
        System.assertEquals('nuevo@email.com', accJ[0].Email__c, 'El mail seteado no es el que corresponde');
        System.assertEquals('Email', accJ[0].Tipo_de_email__r.Name, 'El tipo de email seteado no es el que corresponde');	    
        
    }
    
    @isTest
    public static void creacionCuentaPersonal() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        String r = AccountManagement.createNewRecords(
            						'Natural', 'Otro', 'Nombre', 'Distinto', '', 'Genero', 'Nueva direccion',
                                    'Municipio', 'Departamento', 'Departamento', 'Pais', 'Otros', '99999', '88888888', '', 'Telefono',
                                    'nuevo@email.com', 'Email', 'Nacionalidad');
        Test.stopTest();
        
        String codigoCliente = r.split(':')[1].trim();
        
        List<Account> accJ =
            [SELECT ID, Name, Genero_UDC__pr.Name, Direccion__c, Municipio__r.Name, Ciudad_UDC__r.Name, 
                    Departamento__r.Name, Pa_s__r.Name, Tipo_de_t_lefono__r.Name, Phone, 
                    Tipo_de_Indentificaci_n__c, Cedula__c, Email__c, Tipo_de_email__r.Name, Nacionalidad_UDC__r.Name,
             		RecordType.DeveloperName
            FROM Account
            WHERE CodigoCliente__c =: codigoCliente
            ];
        
        System.assertEquals(false, accJ.isEmpty(), 'La lista está vacia cuando no deberia estarlo.');
        
        System.assertEquals('PersonAccount', accJ[0].RecordType.DeveloperName, 'El tipo de cuenta no se ha seteado correctamente.');
        System.assertEquals('OTRO NOMBRE DISTINTO', accJ[0].Name, 'El nombre seteado no es el que corresponde');
        System.assertEquals('Genero', accJ[0].Genero_UDC__pr.Name, 'El genero seteado no es el que corresponde');
        System.assertEquals('Nueva direccion', accJ[0].Direccion__c, 'La direccion seteada no es la que corresponde');
        System.assertEquals('Municipio', accJ[0].Municipio__r.Name, 'El municipio seteado no es el que corresponde');
        System.assertEquals('Departamento', accJ[0].Ciudad_UDC__r.Name, 'La ciudad seteada no es la que corresponde');
        System.assertEquals('Departamento', accJ[0].Departamento__r.Name, 'El departamento seteado no es el que corresponde');
        System.assertEquals('Pais', accJ[0].Pa_s__r.Name, 'El pais seteado no es el que corresponde');
        System.assertEquals('Otros', accJ[0].Tipo_de_Indentificaci_n__c, 'El tipo de id seteado no es el que corresponde');
        System.assertEquals('99999', accJ[0].Cedula__c, 'La cedula seteada no es la que corresponde');
        System.assertEquals('88888888', accJ[0].Phone, 'El telefono seteado no es el que corresponde');
        System.assertEquals('Telefono', accJ[0].Tipo_de_t_lefono__r.Name, 'El tipo de telefono seteado no es el que corresponde');
        System.assertEquals('nuevo@email.com', accJ[0].Email__c, 'El mail seteado no es el que corresponde');
        System.assertEquals('Email', accJ[0].Tipo_de_email__r.Name, 'El tipo de email seteado no es el que corresponde');
        System.assertEquals('Nacionalidad', accJ[0].Nacionalidad_UDC__r.Name, 'La nacionalidad seteada no es la que corresponde');    
    }
    
    @isTest
    public static void creacionCuentaConPersonalConError() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        
        String r = AccountManagement.createNewRecords(
            						'Natural', '', 'Nombre', '', '', 'Genero', 'Nueva direccion',
                                    'Municipio', 'Departamento', 'Departamento' ,'Pais', 'Otros', '1000', '88888', '', 'Telefono',
                                    'unEmailConFormatoIncorrecto', 'Eemail', 'Nacionalidad');
        Test.stopTest();
        
        System.assertEquals(true, r.contains('Ya existe una cuenta personal con esa identificación.'), 'El error por duplicidad no se ha seteado correctamente');
    }
    
    @isTest
    public static void creacionCuentaConJuridicaConError() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        String r = AccountManagement.createNewRecords(
            						'Juridico', '', '', '', 'Cuenta Juridica Test', '', 'Nueva direccion',
                                    'Municipio', 'Departamento', 'Departamento' ,'Pais', 'Otros', '1001', '88888', 'Pesca', 'Telefono',
                                    'unEmailConFormatoIncorrecto', 'Email', '');
        Test.stopTest();
        
        System.assertEquals(true, r.contains('Esta cuenta jurídica ya existe en Salesforce.'), 'El error por duplicidad no se ha seteado correctamente');
    }
    
    @isTest
    public static void creacionCuentaConJuridicaConNombreIncorrecto() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        String r = AccountManagement.createNewRecords(
            						'Juridico', '', '', '', '', '', 'Nueva direccion',
                                    'M', 'Departamento', 'D' ,'P', 'Otros', '1001', '88888', '', 'T',
                                    'mail@mail.com', 'E', 'N');
        Test.stopTest();
        
        System.assertEquals(false, r.contains('Esa cuenta jurídica ya existe en Salesforce.'), 'El error por duplicidad no se ha seteado correctamente');
        System.assertEquals(true, r.contains('El campo nombre es obligatorio.'), 'El error nombre no se ha seteado correctamente');
    }
    
    @isTest
    public static void creacionCuentaConTipoInvalido() {
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        String r = AccountManagement.createNewRecords(
            						'', '', '', '', 'Cuenta Juridica Test', '', 'Nueva direccion',
                                    'M', 'Departamento', 'D' ,'P', 'Otros', '1001', '88888', '', 'T',
                                    'unEmailConFormatoIncorrecto', 'E', 'N');
        Test.stopTest();
        
        System.assertEquals(true, r.contains('El tipo de cuenta seleccionado no existe.'), 'El error de cuenta invalida no se ha seteado correctamente');
    }
}