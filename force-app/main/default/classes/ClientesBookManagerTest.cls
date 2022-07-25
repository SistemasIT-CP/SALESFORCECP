@isTest
public class ClientesBookManagerTest {
    @TestSetup
    public static void makeData (){
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

        List<Account> accList = new List<Account>();

        for (Integer i = 0; i < 3; i++) {
            Account acc = new Account();
            acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit' + i;
            acc.Pa_s__c = paisTest.ID;
            acc.Municipio__c = municipioTest.ID;
            acc.Ciudad_UDC__c = departamentoTest.ID;
            acc.Departamento__c = departamentoTest.ID;
            acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID; 
            acc.Name = 'Test Account ' + i;
            acc.Categoria_12__c = '1';
            acc.Categoria_19__c = '1';
            acc.Categoria_20__c = '1';
            acc.Categoria_21__c = '1';
            acc.Categoria_22__c = '1';
            acc.Categoria_25__c = '1';
            acc.Categoria_26__c = '1';
            acc.Categoria_27__c = '1';
            acc.Categoria_30__c = '1';
            acc.Categoria_8__c = '1';
            acc.Categorycode001__c = '1';
            acc.Categorycode002__c = '1';
            acc.Categorycode003__c = '1';
            acc.Categorycode004__c = '1';
            acc.Categorycode005__c = '1';
            acc.Categorycode006__c = '1';
            acc.Categorycode007__c = '1';
            acc.Categorycode009__c = '1';
            acc.Categorycode010__c = '1';
            acc.Categorycode011__c = '1';
            acc.Categorycode013__c = '1';
            acc.Categorycode014__c = '1';
            acc.Categorycode015__c = '1';
            acc.Categorycode016__c = '1';
            acc.Categorycode017__c = '1';
            acc.Categorycode018__c = '1';
            acc.CurrencyIsoCode = 'USD';
            acc.Secuencia_contactos__c = 0;
            acc.Email__c = 'email@'+ i + 'test.com';
            acc.Cedula__c = '123123' + i;
            acc.NIT__c = '123456';
            acc.RecordTypeID = juridicaAccountID;
            acc.CodigoCliente__c = '123123' + i;
            acc.Phone = '1231234' + i;

            accList.add(acc);
        }

        insert accList;
        
        Contact contacto = new Contact();
        contacto.FirstName = 'Test';
        contacto.MiddleName	= 'Contact';
        contacto.LastName = 'Xappia';
        contacto.Email = 'test@email.com';
        contacto.Id_Externo__c = '1231230_0';
        contacto.Phone = '12345678';
        contacto.AccountID = accList[0].ID;
        contacto.Numero_de_documento__c = '999999_0';
        contacto.Email = 'test@email.com';

        insert contacto;

        List<AccountContactRelation> acrList = new List<AccountContactRelation>();

        for (Account acc : accList) {
            if(acc.Cedula__c != '1231230') {
                AccountContactRelation acr = new AccountContactRelation();
                acr.ContactId = contacto.ID;
                acr.AccountId = acc.ID;
    
                acrList.add(acr);
            }
        }

        insert acrList;

    }

    @isTest
    public static void makeCorrectCallTest() {

        String contXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">'+
                        +'<soapenv:Header>'+ 
                        +'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                            +'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                            +'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" '+
                            +'soapenv:mustUnderstand="1">'+
                            +'<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                            +'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
                            +'<wsse:Username>salesforce</wsse:Username>'+   
                            +'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">Y@32Jf9!bF</wsse:Password>'+  
                            +'</wsse:UsernameToken>'+
                        +'</wsse:Security>'+
                        +'</soapenv:Header>'+
                        +'<soapenv:Body>'+
                        '<orac:processContact>'+
                            +'</orac:processContact>'+
                        +'</soapenv:Body>'+
                    +'</soapenv:Envelope>';

        String accXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">'+
                                +'<soapenv:Header>'+ 
                                +'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                                +'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                                +'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" '+
                                +'soapenv:mustUnderstand="1">'+
                                +'<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" '+
                                    +'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
                                    +'<wsse:Username>salesforce</wsse:Username>'+   
                                    +'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">Y@32Jf9!bF</wsse:Password>'+  
                                +'</wsse:UsernameToken>'+
                                +'</wsse:Security>'+
                            +'</soapenv:Header>'+
                                +'<soapenv:Body>'+
                                +'<orac:processAddressBook>'+
                                +'</orac:processAddressBook>'+
                                +'</soapenv:Body>'+
                        +'</soapenv:Envelope>';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        HTTPResponse resContact = CallWS_ClientesBookManager.makeCall(contXML);
        HTTPResponse resClient = CallWS_ClientesBookManager.makeCall(accXML);
        Test.stopTest();

        System.assertEquals(200, resContact.getStatusCode(), 'El status code no es el correcto para contacto.');
        System.assertEquals(200, resClient.getStatusCode(), 'El status code no es el correcto para cuenta.');

        System.assertEquals('application/json', resContact.getHeader('Content-Type'), 'El header no es el correcto para contacto.');
        System.assertEquals('application/json', resClient.getHeader('Content-Type'), 'El header no es el correcto para cuenta.');

        System.assertNotEquals(null, resContact.getBody(), 'El body es null cuando no deberia serlo en contacto.');
        System.assertNotEquals(null, resClient.getBody(), 'El body es null cuando no deberia serlo en cuenta.');
    }

    @IsTest
    static void makeWrongCallTest(){
        
        String s = 'This is not an XML';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        HTTPResponse resWrong = CallWS_ClientesBookManager.makeCall(s);
        Test.stopTest();

        System.assertEquals(505, resWrong.getStatusCode(), 'El status code no es el correcto.');

        System.assertEquals('Oh, something is wrong', resWrong.getBody(), 'El body no es el correcto.');
    }

    @IsTest
    static void xmlGeneratorClientTest(){
        Account acc =
            [SELECT ID, Pa_s__r.productCode__c, Direccion__c,
                    CodigoCliente__c, Cedula__c
            FROM Account 
            WHERE Name LIKE 'Test Account%' 
            LIMIT 1
            ];

        List<String> direcciones = new List<String>();
        Integer inicio = 0;
        Integer fin = 40;
        while(inicio < fin) {
            direcciones.add(acc.Direccion__c.substring(inicio, fin));
            inicio = inicio + 40;
            fin = inicio + 40 < acc.Direccion__c.length()? inicio + 40 : acc.Direccion__c.length(); 
        }

        List<String> direccionesParseadas = new List<String>();
        inicio = 1;

        for(String dir : direcciones) {
            direccionesParseadas.add('<addressLine'+inicio+'>'+dir+'</addressLine'+inicio+'>');
            inicio++;
        }

        Test.startTest();
        String xml = CallWS_ClientesBookManager.generaXMLRequest(acc.ID, '2');
        Test.stopTest();

        System.assertEquals(true, xml.contains(acc.Pa_s__r.productCode__c), 'El codigo del pais no se setea correctamente en el XML');

        for (String dirPar : direccionesParseadas) {
            System.assertEquals(true, xml.contains(dirPar), 'La direccion exacta no se setea correctamente en el XML');
        }
        
        System.debug(xml);

        System.assertEquals(true, xml.contains(acc.CodigoCliente__c), 'El codigo de cliente no se setea correctamente en el XML');

        System.assertEquals(true, xml.contains(acc.Cedula__c), 'La cedula no se setea correctamente en el XML');

        System.assertEquals(true, xml.contains('2414'), 'El businessUnit no se setea correctamente en el XML');
    }

    @IsTest
    static void xmlGeneratorContactTest(){
        Contact con = 
            [SELECT ID, AccountID 
            FROM Contact 
            WHERE FirstName = 'TEST'
            ];
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE ID =: con.AccountID
            ];

        List<AccountContactRelation> acrList =
            [SELECT IdExterno__c
            FROM AccountContactRelation 
            WHERE ContactId =: con.ID
            ];
        
        Telefono__c tel = new Telefono__c();
        tel.Cliente__c = acc.ID;
        tel.Contacto__c = con.ID;
        
        insert tel;
        
        Correo__c corr = new Correo__c();
        corr.Cliente__c = acc.ID;
        corr.Contacto__c = con.ID;
        
        insert corr;
        
        DireccionesAlter__c dir = new DireccionesAlter__c();
        dir.Cliente__c = acc.ID;
        dir.Contacto__c = con.ID;
        
        insert dir;

        List<String> criterios = new List<String> {'Parent', 'All relation'};

        Test.startTest();
        List<String> xmlList = CallWS_ClientesBookManager.generaXMLRequestContact(con.ID, '2', '0', '0', '0', 'CONTACTO', criterios);
        Test.stopTest();

        System.assertEquals(acrList.size() + 1, xmlList.size(), 'No se estan creando la cantidad de XMLs correctos');
    }
    
    @IsTest
    static void xmlGeneratorCorreoTest(){
        Contact con = 
            [SELECT ID, AccountID 
            FROM Contact 
            WHERE FirstName = 'TEST'
            ];
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE ID =: con.AccountID
            ];

        List<AccountContactRelation> acrList =
            [SELECT IdExterno__c
            FROM AccountContactRelation 
            WHERE ContactId =: con.ID
            ];
        
        
        Correo__c corr = new Correo__c();
        corr.Cliente__c = acc.ID;
        corr.Contacto__c = con.ID;
        corr.EMAILADDRESS__c = 'email@email.com';
        corr.electronicaddresslinenumber__c = '8';
        
        insert corr;

        List<String> criterios = new List<String> { 'Only relation', acrList[0].IdExterno__c };

        Test.startTest();
        List<String> xmlList = CallWS_ClientesBookManager.generaXMLRequestContact(corr.ID, '2', '2', '0', '0', 'CORREO', criterios);
        Test.stopTest();

        System.assertEquals(1, xmlList.size(), 'No se estan creando la cantidad de XMLs correctos');
    }
    
    @IsTest
    static void xmlGeneratorTelefonoTest(){
        Contact con = 
            [SELECT ID, AccountID 
            FROM Contact 
            WHERE FirstName = 'TEST'
            ];
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE ID =: con.AccountID
            ];

        List<AccountContactRelation> acrList =
            [SELECT IdExterno__c
            FROM AccountContactRelation 
            WHERE ContactId =: con.ID
            ];
        
        Telefono__c tel = new Telefono__c();
        tel.Cliente__c = acc.ID;
        tel.Contacto__c = con.ID;
        tel.areacode__c = '505';
        tel.phonenumber__c = '12345678';
        tel.phonelinenumber__c = '1';
        
        insert tel;

        List<String> criterios = new List<String> { 'Only relation', acrList[0].IdExterno__c };

        Test.startTest();
        List<String> xmlList = CallWS_ClientesBookManager.generaXMLRequestContact(tel.ID, '2', '0', '2', '0', 'TELEFONO', criterios);
        Test.stopTest();

        System.assertEquals(1, xmlList.size(), 'No se estan creando la cantidad de XMLs correctos');
    }
    
    @IsTest
    static void xmlGeneratorDireccionTest(){
        Contact con = 
            [SELECT ID, AccountID 
            FROM Contact 
            WHERE FirstName = 'TEST'
            ];
        
        Account acc = 
            [SELECT ID
            FROM Account
            WHERE ID =: con.AccountID
            ];

        List<AccountContactRelation> acrList =
            [SELECT IdExterno__c
            FROM AccountContactRelation 
            WHERE ContactId =: con.ID
            ];
        
        
        DireccionesAlter__c dir = new DireccionesAlter__c();
        dir.Cliente__c = acc.ID;
        dir.Contacto__c = con.ID;
        dir.Direccion__c = 'Una direccion';
        
        insert dir;

        List<String> criterios = new List<String> { 'Only relation', acrList[0].IdExterno__c };

        Test.startTest();
        List<String> xmlList = CallWS_ClientesBookManager.generaXMLRequestContact(dir.ID, '2', '0', '0', '2', 'DIRECCION', criterios);
        Test.stopTest();

        System.assertEquals(1, xmlList.size(), 'No se estan creando la cantidad de XMLs correctos');
    }
    
    @IsTest
    static void xmlGeneratorFromClientTest(){
        Account acc =
            [SELECT Direccion__c, Ciudad_UDC__c, Ciudad_UDC__r.Name, Pa_s__r.Name,
                    Nacionalidad_UDC__c, Nacionalidad_UDC__r.productCode__c,
                    Pa_s__r.productCode__c, Name, Departamento__r.productCode__c, Pa_s__c,
                    Departamento__c, Profesion_UDC__c, Profesion_UDC__r.productCode__c,
                    Ocupacion_UDC__c, Ocupacion_UDC__r.productCode__c,  Tipo_de_t_lefono__c,
                    Tipo_de_t_lefono__r.productCode__c, Phone, Email__c, 
                    Actividad_economica_UDC__c, Actividad_economica_UDC__r.productCode__c, Cedula__c,
                    CodigoCliente__c, INDUSTRYCLASSIFICATIONCODE__c, ID, BUSINESSUNIT__c, Tipo_de_b_squeda__c,
                    Tipo_de_b_squeda__r.productcode__c, RecordTypeID, Numero_de_documento__pc, Extranjero__c,
                    Categorycode001__c, categorycode002__c, Categorycode003__c, Categorycode004__c, Categorycode005__c,
                    Categorycode006__c, Categorycode007__c, Categoria_8_UDC__c, Categoria_8_UDC__r.productCode__c,
                    Categorycode009__c, Categorycode010__c, Categorycode011__c, Categoria_12__c, Categorycode013__c, 
                    Categorycode014__c, Categorycode015__c, Categorycode016__c, Categorycode017__c, Categorycode018__c, 
                    Categoria_20__c, Categoria_21__c, Categoria_22__c, Categorycode023__c, Categorycode024__c, 
                    Categoria_25__c, Categoria_26_UDC__c, Categoria_26_UDC__r.productCode__c, Categoria_27__c, Categorycode028__c, 
                    Categorycode029__c, Categoria_30__c, Categor_a_19_segmento_UDC__c, Categor_a_19_segmento_UDC__r.productcode__c,
                    Tipo_de_email__c, Tipo_de_email__r.productcode__c, NIT__c, Municipio__c, Municipio__r.Name
            FROM Account 
            WHERE Name LIKE 'Test Account%' 
            LIMIT 1
            ];

        
        Test.startTest();
        String xml = CallWS_ClientesBookManager.generaXMLRequestCuenta(acc, '2');
        Test.stopTest();

        System.assertEquals(true, xml.contains(acc.Pa_s__r.productCode__c), 'El codigo del pais no se setea correctamente en el XML');
        
        System.debug(xml);

        System.assertEquals(true, xml.contains(acc.CodigoCliente__c), 'El codigo de cliente no se setea correctamente en el XML');

        System.assertEquals(true, xml.contains(acc.Cedula__c), 'La cedula no se setea correctamente en el XML');

        System.assertEquals(true, xml.contains('2414'), 'El businessUnit no se setea correctamente en el XML');
    }
    
    @IsTest
    static void ingresoDeCuentaNula() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID identificacion = Id.valueOf('0015500001HYf3lAAD');
        
        Test.startTest();
        CallWS_ClientesBookManager.InsertarCliente(identificacion, '1');
        Test.stopTest();
    }
    
    @IsTest
    static void ingresoDeContactoNulo() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID identificacion = Id.valueOf('0015500001HYf3lAAD');
        
        Test.startTest();
        CallWS_ClientesBookManager.InsertarContacto(identificacion, '1', '0', '0', '0', '', new List<String>());
        Test.stopTest();
    }
    
    @IsTest
    static void ingresoDeContactoNuloFuture() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID identificacion = Id.valueOf('0015500001HYf3lAAD');
        
        Test.startTest();
        CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(identificacion, '1', '0', '0', '0', '', new List<String>());
        Test.stopTest();
    }
    
    @IsTest
    static void ingresoDeCuentaHarcodeadaNula() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Test.startTest();
        CallWS_ClientesBookManager.InsertarClienteDesdeCuenta(new Account(), '1');
        Test.stopTest();
    }
}