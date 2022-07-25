@isTest
public class FlujoAnfitrionTest {
    @TestSetup
    public static void crearOportunidades(){
        ID personAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('PersonAccount')
                                .getRecordTypeId();
        
        Id autosOpp = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal_Autos')
                                    .getRecordTypeId();
        
        Id motosOpp = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal_Motos')
                                    .getRecordTypeId();
        
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
        
        Id actividadEconomicaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Actividad_Economica')
                                    .getRecordTypeId();
        
        Id nacionalidadID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Nacionalidad')
                                    .getRecordTypeId();
        
        Id ocupacionUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Ocupacion')
                                    .getRecordTypeId();
        
        Id profesionUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Profesion')
                                    .getRecordTypeId();
        
        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Id linNegocioID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Lineas_de_negocio')
                                    .getRecordTypeId();
        
        Id modeloUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Modelo')
                                    .getRecordTypeId();
        
        Id marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Marcas')
                                    .getRecordTypeId();

        Catalogo_UDC__c paisTest = new Catalogo_UDC__c();
            paisTest.Name = 'Argentina';
            paisTest.productcode__c = 'ARG';
            paisTest.RecordTypeId = paisUDCID;
        
        Catalogo_UDC__c actividadEconomicaTest = new Catalogo_UDC__c();
            actividadEconomicaTest.Name = 'ActividadEconomica';
            actividadEconomicaTest.productcode__c = 'ACT';
            actividadEconomicaTest.RecordTypeId = actividadEconomicaID;
        
        Catalogo_UDC__c nacionalidadTest = new Catalogo_UDC__c();
            nacionalidadTest.Name = 'Nacionalidad';
            nacionalidadTest.productcode__c = 'NAC';
            nacionalidadTest.RecordTypeId = nacionalidadID;

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
        
        Catalogo_UDC__c companiasTest = new Catalogo_UDC__c();
            companiasTest.Name = 'KIPESA';
            companiasTest.productcode__c = 'COMP';
            companiasTest.RecordTypeId = companiaID;
        
        Catalogo_UDC__c lineaNegocioTest = new Catalogo_UDC__c();
            lineaNegocioTest.Name = 'Autos Nuevos';
            lineaNegocioTest.productcode__c = 'LDN';
            lineaNegocioTest.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c modeloTest = new Catalogo_UDC__c();
            modeloTest.Name = 'Picanto';
            modeloTest.productcode__c = 'MOD';
            modeloTest.RecordTypeId = modeloUDCID;
            
		Catalogo_UDC__c marcaTest = new Catalogo_UDC__c();
            marcaTest.Name = 'KIA';
            marcaTest.productcode__c = 'KIA';
            marcaTest.RecordTypeId = marcasUDCID;

        Catalogo_UDC__c ingeniero = new Catalogo_UDC__c();
            ingeniero.Name = 'Ingeniero en Sistemas';
            ingeniero.productcode__c = 'ING';
            ingeniero.RecordTypeId = profesionUDCID;

        Catalogo_UDC__c tecnico = new Catalogo_UDC__c();
            tecnico.Name = 'Técnico en Computación';
            tecnico.productcode__c = 'TEC';
            tecnico.RecordTypeId = ocupacionUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {paisTest,
                                                                  municipioTest,
                                                                  departamentoTest,
                                                                  tipoTelefonoTest,
            													  actividadEconomicaTest,
            													  nacionalidadTest,
            													  companiasTest,
            													  lineaNegocioTest,
            													  modeloTest,
            													  marcaTest,
                                                                  ingeniero,
                                                                  tecnico
                                                                };

        insert catList;
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = new Account();
            acc.FirstName = 'Cuenta';
            acc.LastName = 'Test';
            acc.CurrencyIsoCode = 'USD';
            acc.Secuencia_contactos__c = 0;
            acc.Email__c = 'correo@test.com';
            acc.Cedula__c = '321321';
            acc.Phone = '88888888';
            acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
            acc.CodigoCliente__c = '321321';
            acc.RecordTypeId = personAccountID;
            acc.Tipo_de_Indentificaci_n__c = 'Otros';
            acc.Pa_s__c = paisTest.ID;
            acc.Municipio__c = municipioTest.ID;
            acc.Departamento__c = departamentoTest.ID;
            acc.Tipo_de_t_lefono__c = tipoTelefonoTest.ID;
            acc.Actividad_economica_UDC__c = actividadEconomicaTest.ID;
            acc.Nacionalidad_UDC__c = nacionalidadTest.ID;
            acc.Profesion_UDC__c = ingeniero.ID;
            acc.Ocupacion_UDC__c = tecnico.ID;
            acc.Tipo_de_cliente__c = 'Natural';
            acc.Tipo_Cliente__c = 'Ocasional';
            acc.Nivel_organizacional__c = 'Asalariado';
        insert acc;

        Id pricebookId = Test.getStandardPricebookId();

        List<Opportunity> oppToInsert = new List<Opportunity>();

        for (Integer i = 0; i < 5; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'TEST OPP CTE1';
            opp.AccountId = acc.ID;
            opp.StageName = 'Contacto Exitoso';
            opp.CloseDate = date.today();
            opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
            opp.Marca__c = 'Kia';
            opp.Forma_de_Pago_Multiple__c = 'Contado';
            opp.Sucursal__c = 'Kia El Retiro'; 
            opp.Pricebook2Id = pricebookId;
            opp.RecordTypeID = i > 3? motosOpp : autosOpp;
            opp.Prueba_de_manejo__c = 'No';
            opp.Tour_CP__c = 'No';
            opp.Walk_Around__c = 'No';
            opp.Origen_de_los_fondos__c = 'Ahorro';
            opp.Procedencia_de_los_fondos__c = 'Otros';
            opp.Forma_de_Pago_Multiple__c = 'Contado';
            opp.Compa_a__c = companiasTest.ID;
            opp.L_neas_de_Negocio__c = lineaNegocioTest.ID;
            opp.Desea_realizar_intercambio__c = 'No';
            opp.ModeloVehiculo__c = modeloTest.ID;
            opp.Marca_UDC__c = marcaTest.ID;
            opp.Tipo_de_relaci_n_econ_mica__c = 'Credito';
            opp.Tipo_de_transacci_n__c = 'Anticipo o Prima';
            opp.Responsable_del_pago__c = 'Tercero Familiar';

            oppToInsert.add(opp);
        }

        insert oppToInsert;
    }

    @IsTest
    public static void obtenerListadoOportunidades(){
        Account acc = [
            SELECT Id, CodigoCliente__c
            FROM Account
            LIMIT 1
        ];

        List<Opportunity> oppList = [
            SELECT Id, Name, Account.CodigoCliente__c,
                Owner.Name, CreatedDate, Marca_UDC__c, Marca_UDC__r.Name
            FROM Opportunity
            WHERE AccountId =: acc.Id
                AND RecordType.DeveloperName = 'Principal_Autos'
        ];

        Opportunity oppMoto = [
            SELECT Id
            FROM Opportunity
            WHERE AccountId =: acc.Id
                AND RecordType.DeveloperName != 'Principal_Autos'
            LIMIT 1
        ];

        Test.startTest();
        List<Opportunity> oppResultado = FlujoAnfitrionController.getOpportunities(acc.CodigoCliente__c);
        Test.stopTest();
     
        System.assertEquals(oppList, oppResultado, 'La lista obtenida no corresponde con el resultado deseado');

        for (Opportunity opp : oppResultado) {
            System.assertNotEquals(oppMoto.Id, opp.Id, 'Se trae una oportunidad del recordtype incorrecto');
        }
    }

    @IsTest
    public static void obtenerMapaDeModelosPorMarca(){
        Map<String, List<String>> modelosByMarcaEsperado = OportunidadCerradaController.getDependentPicklistValues(Lead.Modelo_a_cotizar__c);

        Test.startTest();
        Map<String, List<String>> modelosByMarcaResultante = FlujoAnfitrionController.getModelosByMarca();
        Test.stopTest();

        System.assertEquals(modelosByMarcaEsperado, modelosByMarcaResultante, 'El mapa de modelos por marca no corresponde con lo esperado.');
    }

    @IsTest
    public static void obtenerMapaDeUsuariosPorSucursal(){
        List<String> listaSucursales = new List<String> {
            'Altamira', 'Juigalpa', 'Kia El Retiro'
        };

        List<User> userToInsert = new List<User>();

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];

        for (Integer i = 0; i < 9; i++) {
            User u = new User();
            u.Sucursal__c = listaSucursales[Math.mod(i, listaSucursales.size())];
            u.Alias = 'Test' + i;
            u.Email = 'test@email.com';
            u.EmailEncodingKey = 'UTF-8';
            u.LastName = 'Testing ' + i; 
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US'; 
            u.ProfileId = p.Id;
            u.IsActive = true;
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.UserName = 'test' + i + '@email.com.casapellas';

            userToInsert.add(u);
        }

        insert userToInsert;

        Test.startTest();
        Map<String, List<User>> usuariosPorSucursal = FlujoAnfitrionController.getUserBySucursal();
        Test.stopTest();

        List<User> usuariosList = [
            SELECT Id, Name, Sucursal__c
            FROM User
            WHERE Sucursal__c != null
            	AND Profile.Name LIKE 'Vendedor%'
                AND IsActive = true
        ];

        for (User u : usuariosList) {
            System.assertEquals(true, usuariosPorSucursal.containsKey(u.Sucursal__c), 'La sucursal ' + u.Sucursal__c + ' no está contemplada en el mapa resultante');
            System.assertEquals(true, usuariosPorSucursal.get(u.Sucursal__c).contains(u), 'El usuario ' + u.Name + ' no viene en el mapa.');
        }
    }

    @isTest
    public static void actualizarDatosOportunidadTest(){
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Date hoy = Date.today();
        Id userId = UserInfo.getUserId();


        Test.startTest();
        String resultado = FlujoAnfitrionController.crearTareaDeAnfitrion(
            userId,
            opp.Id
        );
        Test.stopTest();

        List<Task> tkList = [
            SELECT Status, Subject, ActivityDate, WhatId
            FROM Task 
            WHERE WhatId =: opp.Id
        ];

        System.assertEquals('Ok', resultado, 'El metodo esta fallando cuando no deberia hacerlo');

        System.assertEquals(1, tkList.size(), 'La cantidad de tareas creadas no es la esperada');
        System.assertEquals('Completada', tkList[0].Status, 'La tarea no se ha completado exitosamente');
        System.assertEquals('Visita', tkList[0].Subject, 'El motivo de la tarea no es el correcto');
        System.assertEquals(hoy, tkList[0].ActivityDate, 'La fecha de vencimiento de la tarea no es la correcta');
    }

    @IsTest
    public static void crearLeadAnfitrion(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];

        User u = new User();
            u.Alias = 'TestUser';
            u.Email = 'test@email.com';
            u.EmailEncodingKey = 'UTF-8';
            u.LastName = 'Testing'; 
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US'; 
            u.ProfileId = p.Id;
            u.IsActive = true;
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.UserName = 'test@email.com.casapellas';

        insert u;

        User uInsert = [
            SELECT Name 
            FROM User
            WHERE Id =: u.Id
        ];

        Test.startTest();
        Id leadInsertadoId = FlujoAnfitrionController.createLeadAnfitrion(
            'NombreTest',
            '',
            'ApellidoTest',
            'email@test.com',
            '123456789',
            '987654321',
            'Kia',
            'Picanto',
            uInsert.Name
            );
        Test.stopTest();
        
        Lead ldInsertado = [
            SELECT FirstName, MiddleName, LastName, Email, Phone, Cedula_Nro__c, 
                LeadSource, Status, Marca_a_cotizar__c, Modelo_a_cotizar__c,
                RecordType.DeveloperName, Owner.Name
            FROM Lead 
            WHERE Id =: leadInsertadoId
        ];

        System.assertNotEquals(null, leadInsertadoId, 'El lead se ha insertado correctamente.');
        System.assertEquals('NOMBRETEST', ldInsertado.FirstName, 'El nombre del lead no corresponde con lo esperado.');
        System.assertEquals(null, ldInsertado.MiddleName, 'El segundo nombre del lead no corresponde con lo esperado.');
        System.assertEquals('APELLIDOTEST', ldInsertado.LastName, 'El apellido del lead no corresponde con lo esperado.');
        System.assertEquals('email@test.com', ldInsertado.Email, 'El mail del lead no corresponde con lo esperado.');
        System.assertEquals('123456789', ldInsertado.Phone, 'El telefono del lead no corresponde con lo esperado.');
        System.assertEquals('987654321', ldInsertado.Cedula_Nro__c, 'La cedula del lead no corresponde con lo esperado.');
        System.assertEquals('Presencial', ldInsertado.LeadSource, 'El origen del lead no corresponde con lo esperado.');
        System.assertEquals('Contacto exitoso', ldInsertado.Status, 'El estado del lead no corresponde con lo esperado.');
        System.assertEquals('Kia', ldInsertado.Marca_a_cotizar__c, 'La marca del lead no corresponde con lo esperado.');
        System.assertEquals('Picanto', ldInsertado.Modelo_a_cotizar__c, 'El modelo del lead no corresponde con lo esperado.');
        System.assertEquals('Anfitrion', ldInsertado.RecordType.DeveloperName, 'El recordtype del lead no corresponde con lo esperado.');
        System.assertEquals('Testing', ldInsertado.Owner.Name, 'El propietario del lead no corresponde con lo esperado.');
    }
}