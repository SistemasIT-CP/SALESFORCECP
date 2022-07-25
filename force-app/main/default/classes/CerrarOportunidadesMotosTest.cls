@isTest
public class CerrarOportunidadesMotosTest {
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
        modeloTest.Name = 'Modelo';
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

        Opportunity oppAutos = new Opportunity();
        oppAutos.Name = 'TEST OPP CTE1';
        oppAutos.AccountId = acc.ID;
        oppAutos.StageName = 'Contacto Exitoso';
        oppAutos.CloseDate = date.today();
        oppAutos.C_digo_de_Oportunidad_Numerico__c = 12345566;
        oppAutos.Marca__c = 'Kia';
        oppAutos.Forma_de_Pago_Multiple__c = 'Contado';
        oppAutos.Sucursal__c = 'Kia El Retiro'; 
        oppAutos.Pricebook2Id = pricebookId;
        oppAutos.RecordTypeID = autosOpp;
        oppAutos.Prueba_de_manejo__c = 'No';
        oppAutos.Tour_CP__c = 'No';
        oppAutos.Walk_Around__c = 'No';
        oppAutos.Origen_de_los_fondos__c = 'Ahorro';
        oppAutos.Procedencia_de_los_fondos__c = 'Otros';
        oppAutos.Forma_de_Pago_Multiple__c = 'Contado';
        oppAutos.Compa_a__c = companiasTest.ID;
        oppAutos.L_neas_de_Negocio__c = lineaNegocioTest.ID;
        oppAutos.Desea_realizar_intercambio__c = 'No';
        oppAutos.ModeloVehiculo__c = modeloTest.ID;
        oppAutos.Marca_UDC__c = marcaTest.ID;
        oppAutos.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        oppAutos.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        oppAutos.Responsable_del_pago__c = 'Tercero Familiar';
        oppAutos.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        insert oppAutos;

        Opportunity oppMotos = new Opportunity();
        oppMotos.Name = 'TEST OPP CTE1';
        oppMotos.AccountId = acc.ID;
        oppMotos.StageName = 'Contacto Exitoso';
        oppMotos.CloseDate = date.today();
        oppMotos.C_digo_de_Oportunidad_Numerico__c = 12345566;
        oppMotos.Marca__c = 'Kia';
        oppMotos.Forma_de_Pago_Multiple__c = 'Contado';
        oppMotos.Sucursal__c = 'Kia El Retiro'; 
        oppMotos.Pricebook2Id = pricebookId;
        oppMotos.RecordTypeID = motosOpp;
        oppMotos.Prueba_de_manejo__c = 'No';
        oppMotos.Tour_CP__c = 'No';
        oppMotos.Walk_Around__c = 'No';
        oppMotos.Origen_de_los_fondos__c = 'Ahorro';
        oppMotos.Procedencia_de_los_fondos__c = 'Otros';
        oppMotos.Forma_de_Pago_Multiple__c = 'Contado';
        oppMotos.Compa_a__c = companiasTest.ID;
        oppMotos.L_neas_de_Negocio__c = lineaNegocioTest.ID;
        oppMotos.Desea_realizar_intercambio__c = 'No';
        oppMotos.ModeloVehiculo__c = modeloTest.ID;
        oppMotos.Marca_UDC__c = marcaTest.ID;
        oppMotos.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        oppMotos.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        oppMotos.Responsable_del_pago__c = 'Tercero Familiar';
        oppMotos.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        oppMotos.Canal_Contrata__c = 'Sucursales Propias - Detalle';
        insert oppMotos;
    }

    @isTest
    public static void cerrarOportunidadDeMotosCorrectamenteTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Opportunity oppMoto = [
            SELECT Id, StageName, Pricebook2Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Motos'
        ];

        oppMoto.StageName = 'Seleccionando Modelo';
        update oppMoto;

        oppMoto.StageName = 'Negociacion';
        update oppMoto;

        oppMoto.StageName = 'Formalizacion';
        update oppMoto;

        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppMoto.Pricebook2Id
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
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Chasis__c = '123456';
        oppli1.OpportunityId = oppMoto.Id;
        oppli1.PricebookEntryId = pbEntry.Id;
        oppli1.Product2Id = p.Id;
        oppli1.Quantity = 1;
        oppli1.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli1;

        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Chasis__c = '123457';
        oppli2.OpportunityId = oppMoto.Id;
        oppli2.PricebookEntryId = pbEntry.Id;
        oppli2.Product2Id = p.Id;
        oppli2.Quantity = 1;
        oppli2.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli2;
        
        Informe_de_Negociaci_n__c inf1 = new Informe_de_Negociaci_n__c ();
        inf1.Chasis__c = '123456';
		inf1.Cuenta__c = acc.Id;
        inf1.Oportunidad__c = oppMoto.Id;
        inf1.Facturar_a_nombre_de__c = acc.Id;
        inf1.total_negociado__c = 1;
        inf1.Estado__c = 'Aprobado';
        insert inf1;

        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c ();
        inf2.Chasis__c = '123457';
		inf2.Cuenta__c = acc.Id;
        inf2.Oportunidad__c = oppMoto.Id;
        inf2.Facturar_a_nombre_de__c = acc.Id;
        inf2.total_negociado__c = 1;
        inf2.Estado__c = 'Aprobado';
        insert inf2;

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 2;
        insert rec;

        Recibos_de_la_negociaci_n__c recNeg1 = new Recibos_de_la_negociaci_n__c();
        recNeg1.Recibos__c = rec.ID;
        recNeg1.Informe_de_Negociaci_n__c = inf1.ID;
        recNeg1.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg1;

        Recibos_de_la_negociaci_n__c recNeg2 = new Recibos_de_la_negociaci_n__c();
        recNeg2.Recibos__c = rec.ID;
        recNeg2.Informe_de_Negociaci_n__c = inf2.ID;
        recNeg2.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg2;

        inf1.Estado__c = 'Aprobado';
        inf1.factura__c = '123456';
        inf1.fechafactura__c = Date.today();
        inf1.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf1;

        inf2.Estado__c = 'Aprobado';
        inf2.factura__c = '123457';
        inf2.fechafactura__c = Date.today();
        inf2.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf2;

        oppMoto.StageName = 'Listo para facturar';
        oppMoto.Permite_Ganar_Oportunidad__c = true;
        update oppMoto;

        oppMoto.StageName = 'Facturado';
        update oppMoto;

        Test.startTest();
        SchedulableContext sc = null;
        CallCerrarOportunidadesMotos c = new CallCerrarOportunidadesMotos();
        c.execute(sc);
        Test.stopTest();

        Opportunity oppMotoActualizada = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id =: oppMoto.Id
        ];

        System.assertEquals('Cerrada ganada', oppMotoActualizada.StageName, 'La etapa de la oportunidad no se ha actualizado correctamente');
    }

    @isTest
    public static void noCerrarOportunidadDeMotosCuandoNoTieneInformesFacturados(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Opportunity oppMoto = [
            SELECT Id, StageName, Pricebook2Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Motos'
        ];

        oppMoto.StageName = 'Seleccionando Modelo';
        update oppMoto;

        oppMoto.StageName = 'Negociacion';
        update oppMoto;

        oppMoto.StageName = 'Formalizacion';
        update oppMoto;

        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppMoto.Pricebook2Id
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
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Chasis__c = '123456';
        oppli1.OpportunityId = oppMoto.Id;
        oppli1.PricebookEntryId = pbEntry.Id;
        oppli1.Product2Id = p.Id;
        oppli1.Quantity = 1;
        oppli1.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli1;

        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Chasis__c = '123457';
        oppli2.OpportunityId = oppMoto.Id;
        oppli2.PricebookEntryId = pbEntry.Id;
        oppli2.Product2Id = p.Id;
        oppli2.Quantity = 1;
        oppli2.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli2;
        
        Informe_de_Negociaci_n__c inf1 = new Informe_de_Negociaci_n__c ();
        inf1.Chasis__c = '123456';
		inf1.Cuenta__c = acc.Id;
        inf1.Oportunidad__c = oppMoto.Id;
        inf1.Facturar_a_nombre_de__c = acc.Id;
        inf1.total_negociado__c = 1;
        inf1.Estado__c = 'Aprobado';
        insert inf1;

        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c ();
        inf2.Chasis__c = '123457';
		inf2.Cuenta__c = acc.Id;
        inf2.Oportunidad__c = oppMoto.Id;
        inf2.Facturar_a_nombre_de__c = acc.Id;
        inf2.total_negociado__c = 1;
        inf2.Estado__c = 'Aprobado';
        insert inf2;

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 2;
        insert rec;

        Recibos_de_la_negociaci_n__c recNeg1 = new Recibos_de_la_negociaci_n__c();
        recNeg1.Recibos__c = rec.ID;
        recNeg1.Informe_de_Negociaci_n__c = inf1.ID;
        recNeg1.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg1;

        Recibos_de_la_negociaci_n__c recNeg2 = new Recibos_de_la_negociaci_n__c();
        recNeg2.Recibos__c = rec.ID;
        recNeg2.Informe_de_Negociaci_n__c = inf2.ID;
        recNeg2.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg2;

        inf1.Estado__c = 'Aprobado';
        inf1.fechafactura__c = Date.today();
        inf1.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf1;

        inf2.Estado__c = 'Aprobado';
        inf2.factura__c = '123457';
        inf2.fechafactura__c = Date.today();
        inf2.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf2;

        oppMoto.StageName = 'Listo para facturar';
        oppMoto.Permite_Ganar_Oportunidad__c = true;
        update oppMoto;

        oppMoto.StageName = 'Facturado';
        update oppMoto;

        Test.startTest();
        SchedulableContext sc = null;
        CallCerrarOportunidadesMotos c = new CallCerrarOportunidadesMotos();
        c.execute(sc);
        Test.stopTest();

        Opportunity oppMotoActualizada = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id =: oppMoto.Id
        ];

        System.assertEquals('Facturado', oppMotoActualizada.StageName, 'La etapa de la oportunidad no se ha actualizado correctamente');

    }

    @isTest
    public static void noCerrarOportunidadDeMotosCuandoNoLaEtapaCorrecta(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Opportunity oppMoto = [
            SELECT Id, StageName, Pricebook2Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Motos'
        ];

        oppMoto.StageName = 'Seleccionando Modelo';
        update oppMoto;

        oppMoto.StageName = 'Negociacion';
        update oppMoto;

        oppMoto.StageName = 'Formalizacion';
        update oppMoto;

        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppMoto.Pricebook2Id
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
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Chasis__c = '123456';
        oppli1.OpportunityId = oppMoto.Id;
        oppli1.PricebookEntryId = pbEntry.Id;
        oppli1.Product2Id = p.Id;
        oppli1.Quantity = 1;
        oppli1.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli1;

        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Chasis__c = '123457';
        oppli2.OpportunityId = oppMoto.Id;
        oppli2.PricebookEntryId = pbEntry.Id;
        oppli2.Product2Id = p.Id;
        oppli2.Quantity = 1;
        oppli2.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli2;
        
        Informe_de_Negociaci_n__c inf1 = new Informe_de_Negociaci_n__c ();
        inf1.Chasis__c = '123456';
		inf1.Cuenta__c = acc.Id;
        inf1.Oportunidad__c = oppMoto.Id;
        inf1.Facturar_a_nombre_de__c = acc.Id;
        inf1.total_negociado__c = 1;
        inf1.Estado__c = 'Aprobado';
        insert inf1;

        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c ();
        inf2.Chasis__c = '123457';
		inf2.Cuenta__c = acc.Id;
        inf2.Oportunidad__c = oppMoto.Id;
        inf2.Facturar_a_nombre_de__c = acc.Id;
        inf2.total_negociado__c = 1;
        inf2.Estado__c = 'Aprobado';
        insert inf2;

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 2;
        insert rec;

        Recibos_de_la_negociaci_n__c recNeg1 = new Recibos_de_la_negociaci_n__c();
        recNeg1.Recibos__c = rec.ID;
        recNeg1.Informe_de_Negociaci_n__c = inf1.ID;
        recNeg1.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg1;

        Recibos_de_la_negociaci_n__c recNeg2 = new Recibos_de_la_negociaci_n__c();
        recNeg2.Recibos__c = rec.ID;
        recNeg2.Informe_de_Negociaci_n__c = inf2.ID;
        recNeg2.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg2;

        inf1.Estado__c = 'Aprobado';
        inf1.factura__c = '123456';
        inf1.fechafactura__c = Date.today();
        inf1.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf1;

        inf2.Estado__c = 'Aprobado';
        inf2.factura__c = '123457';
        inf2.fechafactura__c = Date.today();
        inf2.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf2;

        oppMoto.StageName = 'Listo para facturar';
        oppMoto.Permite_Ganar_Oportunidad__c = true;
        update oppMoto;

        oppMoto.StageName = 'Facturado';
        update oppMoto;

        oppMoto.StageName = 'Listo para facturar';
        update oppMoto;

        oppMoto.StageName = 'Formalizacion';
        update oppMoto;

        Test.startTest();
        SchedulableContext sc = null;
        CallCerrarOportunidadesMotos c = new CallCerrarOportunidadesMotos();
        c.execute(sc);
        Test.stopTest();

        Opportunity oppMotoActualizada = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id =: oppMoto.Id
        ];

        System.assertEquals('Formalizacion', oppMotoActualizada.StageName, 'La etapa de la oportunidad no se ha actualizado correctamente');
    }

    @isTest
    public static void noCerrarOportunidadAutos(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Opportunity oppAuto = [
            SELECT Id, StageName, Pricebook2Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Autos'
        ];

        oppAuto.StageName = 'Seleccionando Modelo';
        update oppAuto;

        oppAuto.StageName = 'Negociacion';
        update oppAuto;

        oppAuto.StageName = 'Formalizacion';
        update oppAuto;

        PricebookEntry pbEntry = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppAuto.Pricebook2Id
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
        
        OpportunityLineItem oppli1 = new OpportunityLineItem();
        oppli1.Chasis__c = '123456';
        oppli1.OpportunityId = oppAuto.Id;
        oppli1.PricebookEntryId = pbEntry.Id;
        oppli1.Product2Id = p.Id;
        oppli1.Quantity = 1;
        oppli1.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli1;

        OpportunityLineItem oppli2 = new OpportunityLineItem();
        oppli2.Chasis__c = '123457';
        oppli2.OpportunityId = oppAuto.Id;
        oppli2.PricebookEntryId = pbEntry.Id;
        oppli2.Product2Id = p.Id;
        oppli2.Quantity = 1;
        oppli2.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli2;
        
        Informe_de_Negociaci_n__c inf1 = new Informe_de_Negociaci_n__c ();
        inf1.Chasis__c = '123456';
		inf1.Cuenta__c = acc.Id;
        inf1.Oportunidad__c = oppAuto.Id;
        inf1.Facturar_a_nombre_de__c = acc.Id;
        inf1.total_negociado__c = 1;
        inf1.Estado__c = 'Aprobado';
        insert inf1;

        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c ();
        inf2.Chasis__c = '123457';
		inf2.Cuenta__c = acc.Id;
        inf2.Oportunidad__c = oppAuto.Id;
        inf2.Facturar_a_nombre_de__c = acc.Id;
        inf2.total_negociado__c = 1;
        inf2.Estado__c = 'Aprobado';
        insert inf2;

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 2;
        insert rec;

        Recibos_de_la_negociaci_n__c recNeg1 = new Recibos_de_la_negociaci_n__c();
        recNeg1.Recibos__c = rec.ID;
        recNeg1.Informe_de_Negociaci_n__c = inf1.ID;
        recNeg1.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg1;

        Recibos_de_la_negociaci_n__c recNeg2 = new Recibos_de_la_negociaci_n__c();
        recNeg2.Recibos__c = rec.ID;
        recNeg2.Informe_de_Negociaci_n__c = inf2.ID;
        recNeg2.Monto_aplicado_a_la_negociaci_n__c = 1;
        insert recNeg2;

        inf1.Estado__c = 'Aprobado';
        inf1.factura__c = '123456';
        inf1.fechafactura__c = Date.today();
        inf1.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf1;

        inf2.Estado__c = 'Aprobado';
        inf2.factura__c = '123457';
        inf2.fechafactura__c = Date.today();
        inf2.Fecha_de_ultima_facturacion__c = Date.today().addDays(-5);
        update inf2;

        oppAuto.StageName = 'Listo para facturar';
        oppAuto.Permite_Ganar_Oportunidad__c = true;
        update oppAuto;

        oppAuto.StageName = 'Facturado';
        update oppAuto;

        oppAuto.StageName = 'Listo para facturar';
        update oppAuto;

        oppAuto.StageName = 'Formalizacion';
        update oppAuto;

        Test.startTest();
        SchedulableContext sc = null;
        CallCerrarOportunidadesMotos c = new CallCerrarOportunidadesMotos();
        c.execute(sc);
        Test.stopTest();

        Opportunity oppAutoActualizada = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id =: oppAuto.Id
        ];

        System.assertEquals('Formalizacion', oppAutoActualizada.StageName, 'La etapa de la oportunidad no se ha actualizado correctamente');
    }
}