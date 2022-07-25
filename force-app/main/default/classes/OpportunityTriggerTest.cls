@IsTest
public with sharing class OpportunityTriggerTest {
    @TestSetup
    static void createAccount(){
        ID personAccountID = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();
        
        Id autosOpp = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Principal_Autos')
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
        
        Catalogo_UDC__c companiasTest2 = new Catalogo_UDC__c();
        companiasTest2.Name = 'CASA PELLAS, S.A';
        companiasTest2.productcode__c = 'COMP';
        companiasTest2.RecordTypeId = companiaID;
        
        Catalogo_UDC__c companiasTest3 = new Catalogo_UDC__c();
        companiasTest3.Name = 'V E L O S A';
        companiasTest3.productcode__c = 'COMP';
        companiasTest3.RecordTypeId = companiaID;
        
        Catalogo_UDC__c lineaNegocioTest = new Catalogo_UDC__c();
        lineaNegocioTest.Name = 'Autos Nuevos';
        lineaNegocioTest.productcode__c = 'LDN';
        lineaNegocioTest.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest2 = new Catalogo_UDC__c();
        lineaNegocioTest2.Name = 'Autos Usados';
        lineaNegocioTest2.productcode__c = 'LDN';
        lineaNegocioTest2.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest3 = new Catalogo_UDC__c();
        lineaNegocioTest3.Name = 'Camiones Hino';
        lineaNegocioTest3.productcode__c = 'LDN';
        lineaNegocioTest3.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest4 = new Catalogo_UDC__c();
        lineaNegocioTest4.Name = 'Autos Toyota';
        lineaNegocioTest4.productcode__c = 'LDN';
        lineaNegocioTest4.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest5 = new Catalogo_UDC__c();
        lineaNegocioTest5.Name = 'Autos Suzuki';
        lineaNegocioTest5.productcode__c = 'LDN';
        lineaNegocioTest5.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest6 = new Catalogo_UDC__c();
        lineaNegocioTest6.Name = 'Yamaha';
        lineaNegocioTest6.productcode__c = 'LDN';
        lineaNegocioTest6.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest7 = new Catalogo_UDC__c();
        lineaNegocioTest7.Name = 'Motos Nuevas';
        lineaNegocioTest7.productcode__c = 'LDN';
        lineaNegocioTest7.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c lineaNegocioTest8 = new Catalogo_UDC__c();
        lineaNegocioTest8.Name = 'Motores Marinos';
        lineaNegocioTest8.productcode__c = 'LDN';
        lineaNegocioTest8.RecordTypeId = linNegocioID;
        
        Catalogo_UDC__c modeloTest = new Catalogo_UDC__c();
        modeloTest.Name = 'Modelo';
        modeloTest.productcode__c = 'MOD';
        modeloTest.RecordTypeId = modeloUDCID;
        
        Catalogo_UDC__c marcaTest = new Catalogo_UDC__c();
        marcaTest.Name = 'KIA';
        marcaTest.productcode__c = 'KIA';
        marcaTest.RecordTypeId = marcasUDCID;
        
        Catalogo_UDC__c marcaTest2 = new Catalogo_UDC__c();
        marcaTest2.Name = 'MOTORES MARINO';
        marcaTest2.productcode__c = 'MOTORES MARINO';
        marcaTest2.description1__c = 'MOTORES MARINO';
        marcaTest2.RecordTypeId = marcasUDCID;
        
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
            companiasTest2,
            companiasTest3,
            lineaNegocioTest,
            lineaNegocioTest2,
            lineaNegocioTest3,
            lineaNegocioTest4,
            lineaNegocioTest5,
            lineaNegocioTest6,
            lineaNegocioTest7,
            lineaNegocioTest8,
            modeloTest,
            marcaTest,
            marcaTest2,
            ingeniero,
            tecnico
            };
                
                insert catList;
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Account acc = new Account(FirstName = 'Cuenta',
                                  LastName = 'Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');
        
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
        
        Product2 p = new Product2();
        p.Name = 'test';
        p.Marca_P__c = 'Kia';
        p.ProductCode__c = 'TESTPCode';
        insert p;
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        insert pbEntry;
        
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
        opp.RecordTypeID = autosOpp;
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
        insert opp;
    }
    
    @IsTest
    public static void verifyFields(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Id autosOpp = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Principal_Autos')
            .getRecordTypeId();
        
        List<Account> cuenta = [
            SELECT Id
            FROM account
            WHERE Email__c = 'correo@test.com'
        ];
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 p = new Product2();
        p.Name = 'test';
        p.Marca_P__c = 'Kia';
        p.ProductCode__c = 'TESTPCode';
        insert p;
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        insert pbEntry;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = cuenta.get(0).ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opp.Marca__c = 'Kia';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.Pricebook2Id = pricebookId;
        opp.RecordTypeID = autosOpp;
        opp.Prueba_de_manejo__c = 'No';
        opp.Tour_CP__c = 'No';
        opp.Walk_Around__c = 'No';
        opp.Origen_de_los_fondos__c = 'Ahorro';
        opp.Procedencia_de_los_fondos__c = 'Otros';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Compa_a__c = [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Companias' AND Name = 'KIPESA'].Id;
        opp.L_neas_de_Negocio__c = [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Lineas_de_negocio' AND Name = 'Autos Usados'].Id;
        opp.Desea_realizar_intercambio__c = 'No';
        opp.ModeloVehiculo__c = [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Modelo' AND Name = 'Modelo'].Id;
        opp.Marca_UDC__c =  [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Marcas' AND Name = 'KIA'].Id;
        opp.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        opp.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        opp.Responsable_del_pago__c = 'Tercero Familiar';
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        insert opp;
        
        opp.StageName = 'Seleccionando Modelo';
        update opp; 
        
         opp.StageName = 'Negociacion';
        update opp; 
        
        opp.StageName = 'Formalizacion';
        update opp; 
        
        Test.startTest();
        
         Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = cuenta.get(0).Id;
        infNeg.Error_sincronizacion_WS__c = 'test';
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = cuenta.get(0).Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = cuenta.get(0).ID;
        rec.Saldo__c = 4;
        
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        opp.StageName = 'Listo Para Facturar';
        update opp; 
        Test.stopTest();
    }
    
    @IsTest
    public static void eliminarFacturas() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT Id, Pricebook2Id
            FROM Opportunity
            LIMIT 1
        ];
        
        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];
        
        Product2 p = [
            SELECT Id
            FROM Product2
            WHERE ProductCode__c = 'TESTPCode'
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;
        
        opp.StageName = 'Negociacion';
        update opp;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        opp.StageName = 'Formalizacion';
        update opp;
        
        opp.StageName = 'Listo Para Facturar';
        update opp;
        
        infNeg.factura__c = 'facturaTest';
        infNeg.fechafactura__c = Date.today();
        infNeg.Sincronizacion_WS__c = true;
        update infNeg;
        
        Test.startTest();
        opp.StageName = 'Formalizacion';
        Database.saveResult sr = Database.Update(opp, false);
        Test.stopTest();
        
        Informe_de_Negociaci_n__c infNegActualizado = [
            SELECT factura__c, fechafactura__c, Sincronizacion_WS__c
            FROM Informe_de_Negociaci_n__c
            WHERE Id =: infNeg.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        System.assertEquals(true, String.isBlank(infNegActualizado.factura__c), 'La factura no se nulea como deberia');
        System.assertEquals(null, infNegActualizado.fechafactura__c, 'La fecha de factura no se nulea como deberia');
        System.assertEquals(false, infNegActualizado.Sincronizacion_WS__c, 'La sincronizacion no pasa a false como deberia');
    }
    
    @IsTest
    public static void controlDuplicados() {
        List<Account> accL  =
            [SELECT ID
             FROM Account 
             WHERE Name = 'CUENTA TEST'
            ];
        
        List<Catalogo_UDC__c> marcaList = 
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Marcas'
            ];
        
        Opportunity oppCopia = new Opportunity();
        oppCopia.Name = 'TEST OPP CTE1';
        oppCopia.AccountId = accL[0].ID;
        oppCopia.StageName = 'Contacto Exitoso';
        oppCopia.CloseDate = date.today();
        oppCopia.Marca_UDC__c = marcaList[0].ID;
        
        Profile pVendedor = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator'];
        
        User admin = new User();
        admin.Alias = 'TestAdm';
        admin.Email = 'admin@email.com';
        admin.EmailEncodingKey = 'UTF-8';
        admin.LastName = 'Administrador'; 
        admin.LanguageLocaleKey = 'es';
        admin.LocaleSidKey = 'es_MX'; 
        admin.ProfileId = pAdmin.Id;
        admin.TimeZoneSidKey = 'America/Mexico_City';
        admin.UserName = 'admin@email.com.casapellas';
        
        insert admin;
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'es';
        u.LocaleSidKey = 'es_MX'; 
        u.Marca__c = 'KIA';
        u.ProfileId = pVendedor.Id;
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.UserName = 'test@email.com.casapellas';
        u.Aprobador_KIA__c = admin.ID;
        
        System.runAs(u) {
            Test.startTest();
            Database.SaveResult sr = Database.insert(oppCopia, false);
            Test.stopTest();
            
            Opportunity oppActualizada = [
                SELECT Oportunidad_duplicada__c
                FROM Opportunity 
                WHERE Id =: oppCopia.Id
            ];
            
            System.assertEquals(true, sr.isSuccess(), 'La insecion de la opp falla cuando no deberia');
            System.assertEquals(true, oppActualizada.Oportunidad_duplicada__c, 'La oportunidad no se marca como duplicada cuando deberia');
        }
    }
    
    @IsTest
    public static void testDuplicadosMismoVendedor() {
        List<Account> accL  =
            [SELECT ID
             FROM Account 
             WHERE Name = 'CUENTA TEST'
            ];
        
        List<Catalogo_UDC__c> marcaList = 
            [SELECT ID
             FROM Catalogo_UDC__c
             WHERE RecordType.DeveloperName = 'Marcas'
            ];
        
        Opportunity oppCopia = new Opportunity();
        oppCopia.Name = 'TEST OPP CTE1';
        oppCopia.AccountId = accL[0].ID;
        oppCopia.StageName = 'Contacto Exitoso';
        oppCopia.CloseDate = date.today();
        oppCopia.Marca_UDC__c = marcaList[0].ID;
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(oppCopia, false);
        Test.stopTest();
        
        Opportunity oppActualizada = [
            SELECT Oportunidad_duplicada__c
            FROM Opportunity 
            WHERE Id =: oppCopia.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La insecion de la opp falla cuando no deberia');
        System.assertEquals(false, oppActualizada.Oportunidad_duplicada__c, 'La oportunidad no es duplicada pero se marca como tal');
    }
    
    @isTest
    public static void cambiarFormaPago(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT ID, Forma_de_Pago_Multiple__c
            FROM Opportunity 
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Error_sincronizacion_WS__c = 'test';
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Forma_de_Pago_Multiple__c = 'Ciclo Casa Pellas';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(opp, false);
        Test.stopTest();
        
        Informe_de_Negociaci_n__c infNegActualizado = [
            SELECT Forma_de_Pago_Informe__c
            FROM Informe_de_Negociaci_n__c
            WHERE Id =: infNeg.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        System.assertEquals('Ciclo Casa Pellas', infNegActualizado.Forma_de_Pago_Informe__c, 'La forma de pago no se ha actualizado como se deberia');
    }
    
    @isTest
    public static void cerrarOportunidad(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT Id, Pricebook2Id
            FROM Opportunity
            LIMIT 1
        ];
        
        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];
        
        Product2 p = [
            SELECT Id
            FROM Product2
            WHERE ProductCode__c = 'TESTPCode'
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Error_sincronizacion_WS__c = 'test';
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;
        
        opp.StageName = 'Negociacion';
        update opp;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        Accesorios__c accesorio = new Accesorios__c();
        insert accesorio;
        
        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = infNeg.Id;
        accInf.Accesorio__c = accesorio.Id;
        insert accInf;
        
        opp.StageName = 'Cerrada perdida';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(opp, false);
        Test.stopTest();

        List<Recibos_de_la_negociaci_n__c> recibosList = [
            SELECT Id 
            FROM Recibos_de_la_negociaci_n__c
            WHERE Informe_de_Negociaci_n__c =: infNeg.Id
        ];
        
        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infNeg.Id
        ];
        
        List<Informe_de_Negociaci_n__c> infList = [
            SELECT ID, fechafactura__c, factura__c
            FROM Informe_de_Negociaci_n__c 
            WHERE Oportunidad__c =: opp.Id
        ];
        
        List<OpportunityLineItem> oliList = [
            SELECT Name, Motor__c, Chasis__c, Color__c, IdInformeNegociacion__c
            FROM OpportunityLineItem 
            WHERE OpportunityId =: opp.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        System.assertEquals(true, recibosList.isEmpty(), 'No se estan eliminando los recibos de la negociacion');
        System.assertEquals(true, accInfList.isEmpty(), 'No se estan eliminando los accesorios de la negociacion');
        System.assertEquals(true, infList.isEmpty(), 'No se estan eliminando los informes');
        
        for (OpportunityLineItem oli : oliList) {
            System.assertEquals(true, String.isBlank(oli.Motor__c), 'El motor no se nulea para el prod ' + oli.Name);
            System.assertEquals(true, String.isBlank(oli.Chasis__c), 'El chasis no se nulea para el prod ' + oli.Name);
            System.assertEquals(true, String.isBlank(oli.Color__c), 'El color no se nulea para el prod ' + oli.Name);
            System.assertEquals(true, String.isBlank(oli.IdInformeNegociacion__c), 'El informe no se nulea para el prod ' + oli.Name);
        }
    }
    
    @IsTest
    public static void setearRiesgoTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT Id, Pricebook2Id
            FROM Opportunity
            LIMIT 1
        ];
        
        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];
        
        Product2 p = [
            SELECT Id
            FROM Product2
            WHERE ProductCode__c = 'TESTPCode'
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;
        
        opp.StageName = 'Negociacion';
        update opp;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        opp.StageName = 'Formalizacion';
        update opp;
        
        opp.StageName = 'Listo Para Facturar';
        update opp;
        
        Test.startTest();
        Database.saveResult sr = Database.Update(opp, false);
        Test.stopTest();
        
        Opportunity oppRiesgo = [
            SELECT ID, Riesgo__c
            FROM Opportunity
            WHERE ID =: opp.ID
        ];
        
        System.assertEquals('Medio', oppRiesgo.Riesgo__c, 'El riesgo no se ha actualizado como deberia');
    }
    
    @IsTest
    public static void setearRiesgoCuentaPEPTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT Id, Pricebook2Id, AccountId
            FROM Opportunity
            LIMIT 1
        ];
        
        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];
        
        Product2 p = [
            SELECT Id
            FROM Product2
            WHERE ProductCode__c = 'TESTPCode'
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;
        
        opp.StageName = 'Negociacion';
        update opp;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        opp.StageName = 'Formalizacion';
        update opp;
        
        opp.StageName = 'Listo Para Facturar';
        
        Account cuenta = [
            SELECT Id, PEP__c, Cargo_PEP__c, Fecha_inicio_PEP__c
            FROM Account
            WHERE Id =: opp.AccountId
            LIMIT 1
        ];
        
        cuenta.PEP__c = true;
        cuenta.Cargo_PEP__c = 'Cargo PEP';
        cuenta.Fecha_inicio_PEP__c = Date.today();
        
        update cuenta;
        
        Test.startTest();
        Database.saveResult sr = Database.Update(opp, false);
        Test.stopTest();

        Opportunity oppRiesgo = [
            SELECT ID, Riesgo__c
            FROM Opportunity
            WHERE ID =: opp.ID
        ];
        
        System.assertEquals('Alto', oppRiesgo.Riesgo__c, 'El riesgo no se ha actualizado como deberia');
    }
    
    @isTest
    public static void pasarAvaluoAFormalizacion(){
        Id avaluoOpp = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Avaluo')
            .getRecordTypeId();
        
        Id gravamenId = Schema.SObjectType.AllRecibidos__c
            .getRecordTypeInfosByDeveloperName()
            .get('Gravamen')
            .getRecordTypeId();
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Opportunity oppAvaluo = new Opportunity();
        oppAvaluo.RecordTypeId = avaluoOpp;
        oppAvaluo.CloseDate = Date.today().addDays(7);
        oppAvaluo.AccountId = acc.Id;
        oppAvaluo.StageName = 'Cliente en espera de avaluo';
        oppAvaluo.Name = 'AVALUO/CUENTA TEST';
        insert oppAvaluo;
        
        Vehiculo__c vehConAU = new Vehiculo__c();
        vehConAU.Placa__c = '654321';
        vehConAU.Kilometraje__c = '1000';
        vehConAU.AU__c = 'AU-222-21';
        vehConAU.Precio_de_compra_aprobado_S_Autolote__c = 1500;
        vehConAU.Chasis__c = 'CHASIS12345678912';
        insert vehConAU;
        
        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '1000';
        veh.Precio_de_compra_aprobado_S_Autolote__c = 1500;
        veh.Chasis__c = 'CHASIS21345678912';
        veh.Motor__c = 'Motor';
        veh.Precio_de_compra_aprobado_S_Autolote__c = 1800;
        insert veh;
        
        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Oportunidad__c = oppAvaluo.Id;
        vehOpp.Vehiculo__c = veh.Id;
        insert vehOpp;
        
        oppAvaluo.StageName = 'Aprobacion Autolote';
        update oppAvaluo;
        
        oppAvaluo.StageName = 'Negociacion';
        update oppAvaluo;
        
        AllRecibidos__c recGravamen = new AllRecibidos__c();
        recGravamen.RecordTypeId = gravamenId;
        recGravamen.Saldo__c = 1800;
        recGravamen.Banco__c = 'Lafise';
        recGravamen.Vehiculo__c = veh.Id;
        recGravamen.Cuenta__c = acc.Id;
        insert recGravamen;
        
        oppAvaluo.StageName = 'Formalizacion';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(oppAvaluo, false);
        Test.stopTest();
        
        System.debug(sr);
        
        Vehiculo__c vehActualizado = [
            SELECT AU__c 
            FROM Vehiculo__c
            WHERE Placa__c = '123456'
        ];
        
        OpportunityHelper.setearFechaVenta(new List<Opportunity>{oppAvaluo});
        OpportunityHelper.setearFechaCompra(new List<Opportunity>{oppAvaluo});
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        System.assertEquals('AU-223-' + String.valueOf(Date.today().year()).substring(2), vehActualizado.AU__c, 'El AU no se ha actualizado como deberia');
    }
    
    @isTest
    public static void intentarDeshacerIntercambioConOppHijosExistente() {
        ID avaluoId = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Avaluo')
            .getRecordTypeId();
        
        Opportunity opp = [
            SELECT Id, Desea_realizar_intercambio__c, CloseDate, AccountId, Name 
            FROM Opportunity
            LIMIT 1
        ];
        
        opp.Desea_realizar_intercambio__c = 'Si';
        update opp;
        
        Opportunity oppHijo = new Opportunity();
        oppHijo.CloseDate = opp.CloseDate;
        oppHijo.RecordTypeId = avaluoId;
        oppHijo.StageName = 'Cliente interesado en intercambio';
        oppHijo.AccountId = opp.AccountId;
        oppHijo.Name = 'AVALUO/' + opp.Name.split('/')[0];
        oppHijo.Oportunidad_original__c = opp.Id;
        insert oppHijo;
        
        opp.Desea_realizar_intercambio__c = 'No';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(opp, false);
        Test.stopTest();
        
        System.assertEquals(false, sr.isSuccess(), 'La actualizacion no esta fallando cuando deberia hacerlo');
        System.assertEquals('Primero debe cerrar los avaluos abiertos', sr.getErrors()[0].getMessage(), 'El mensaje de error no es el esperado');
    }
    
    @isTest
    public static void testSeteoCompaniaLineaNegocio() {
        Id principalAutoloteId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autolote')
                            .getRecordTypeId();
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'TEST OPP CTE1';
        opportunity.StageName = 'Contacto Exitoso';
        opportunity.CloseDate = date.today();
        opportunity.RecordTypeId = principalAutoloteId;

        Test.startTest();
        Database.SaveResult srInsert = Database.insert(opportunity, false);
        Test.stopTest();

        System.debug(srInsert);

        System.assertEquals(true, srInsert.isSuccess(), 'La oportunidad no se esta insertando correctamente');

        List<Opportunity> opportunityResult = [
            SELECT Id, L_neas_de_Negocio__c, Compa_a__c, L_neas_de_Negocio__r.Name, Compa_a__r.Name 
            FROM Opportunity 
            WHERE Id =: opportunity.Id 
        ];

        System.assertEquals('Autos Usados', opportunityResult.get(0).L_neas_de_Negocio__r.Name, 'El nombre de la linea de negocio no es el esperado');
        System.assertEquals('CASA PELLAS, S.A', opportunityResult.get(0).Compa_a__r.Name, 'El nombre de la compañia no es el esperado');
    }

    @isTest
    public static void intentarFacturarConOppHijosExistente() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        ID avaluoId = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Avaluo')
            .getRecordTypeId();
        
        Opportunity opp = [
            SELECT Id, Desea_realizar_intercambio__c, StageName, CloseDate, AccountId, Name, Pricebook2Id 
            FROM Opportunity
            LIMIT 1
        ];
        
        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];
        
        Product2 p = [
            SELECT Id
            FROM Product2
            WHERE ProductCode__c = 'TESTPCode'
            LIMIT 1
        ];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Cuenta__c = acc.Id;
        infNeg.Error_sincronizacion_WS__c = 'test';
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        opp.Desea_realizar_intercambio__c = 'Si';
        update opp;
        
        opp.StageName = 'Negociacion';
        update opp;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();
        
        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        
        insert rec;
        
        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;
            
            recibosNegList.add(recNeg);
        }
        
        insert recibosNegList;
        
        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        opp.StageName = 'Formalizacion';
        update opp;
        
        opp.StageName = 'Listo Para Facturar';
        
        Opportunity oppHijo = new Opportunity();
        oppHijo.CloseDate = opp.CloseDate;
        oppHijo.RecordTypeId = avaluoId;
        oppHijo.StageName = 'Cliente interesado en intercambio';
        oppHijo.AccountId = opp.AccountId;
        oppHijo.Name = 'AVALUO/' + opp.Name.split('/')[0];
        oppHijo.Oportunidad_original__c = opp.Id;
        insert oppHijo;
        
        opp.Desea_realizar_intercambio__c = 'No';
        
        Test.startTest();
        Database.SaveResult sr = Database.update(opp, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'La actualizacion no esta fallando cuando deberia hacerlo');
        System.assertEquals('Primero debe cerrar los avaluos abiertos', sr.getErrors()[0].getMessage(), 'El mensaje de error no es el esperado');
    }

    @isTest
    public static void testLiberarVehiculos() {
        Id avaluoOpp = Schema.SObjectType.Opportunity
                .getRecordTypeInfosByDeveloperName()
                .get('Avaluo')
                .getRecordTypeId();

        Account account = [
            SELECT Id 
            FROM Account 
            LIMIT 1
        ];

        Opportunity opportunity = TestFactory.createOpportunity(account.Id, Test.getStandardPricebookId());
        opportunity.RecordTypeId = avaluoOpp;
        insert opportunity;

        Vehiculo__c vehiculo = TestFactory.createVehiculo();
        insert vehiculo;

        Vehiculo_de_la_Oportunidad__c vehOpp = TestFactory.createVehiculoOportunidad(opportunity.Id, vehiculo.Id);
        insert vehOpp;

        Test.startTest();
        opportunity.Permite_Ganar_Oportunidad__c = true;
        opportunity.StageName = 'Cerrada ganada';
        Database.SaveResult srUpdate = Database.update(opportunity, false);
        Test.stopTest();
        
        System.assertEquals(true, srUpdate.isSuccess(), 'La actualizacion esta fallando cuando no deberia');

        Opportunity opportunidadActualizada = [
            SELECT Id, Owner.Name
            FROM Opportunity
            WHERE Id =: opportunity.Id
        ];

        Vehiculo__c vehiculoActualizado = [
            SELECT Id, Estado__c, Vendedor__c, Evaluador__c
            FROM Vehiculo__c
            WHERE Id =: vehiculo.Id 
        ];

        System.assertEquals('Libre', vehiculoActualizado.Estado__c, 'El estado del vehiculo no es el esperado');
        System.assertEquals(opportunidadActualizada.Owner.Name, vehiculoActualizado.Evaluador__c, 'El evaluador del vehiculo no es el esperado');
        System.assertEquals(opportunidadActualizada.Owner.Name, vehiculoActualizado.Vendedor__c, 'El vendedor del vehiculo no es el esperado');
    }

    @isTest
    public static void testCambiarParentOpp() {
        Id avaluoOpp = Schema.SObjectType.Opportunity
                .getRecordTypeInfosByDeveloperName()
                .get('Avaluo')
                .getRecordTypeId();

        Account account = [
            SELECT Id 
            FROM Account 
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT Id, Desea_realizar_intercambio__c 
            FROM Opportunity
            LIMIT 1
        ];

        opp.Desea_realizar_intercambio__c = 'SI';
        update opp;

        Opportunity opportunity = TestFactory.createOpportunity(account.Id, Test.getStandardPricebookId());
        opportunity.RecordTypeId = avaluoOpp;
        opportunity.Oportunidad_original__c = opp.Id;
        insert opportunity;

        Test.startTest();
        opportunity.Oportunidad_original__c = null;
        Database.SaveResult srUpdate = Database.update(opportunity, false);
        Test.stopTest();

        System.assertEquals(true, srUpdate.isSuccess(), 'La actualizacion esta fallando cuando no deberia');

        Opportunity oppActualizada = [
            SELECT Id, Desea_realizar_intercambio__c 
            FROM Opportunity
            WHERE Id =: opp.Id
            LIMIT 1
        ];

        System.assertEquals('NO', oppActualizada.Desea_realizar_intercambio__c, 'El padre no ha cambiado de estado de intercambio como deberia.');
    }
}