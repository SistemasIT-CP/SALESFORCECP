@isTest
public class ProcesaWSGetFactAutoTest {
	@TestSetup
    static void crearUDC(){
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

        ID motosID = Schema.SObjectType.Opportunity
                                .getRecordTypeInfosByDeveloperName()
                                .get('Principal_Motos')
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
        modeloTest.description1__c = 'TestModelo';
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
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

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
        opp.C_digo_de_Oportunidad_Numerico__c = 558843;
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

        Opportunity oppMoto = new Opportunity();
        oppMoto.Name = 'TEST OPP CTE1';
        oppMoto.AccountID = acc.ID;
        oppMoto.StageName = 'Contacto Exitoso';
        oppMoto.CloseDate = date.today();
        oppMoto.C_digo_de_Oportunidad_Numerico__c = 555555;
        oppMoto.Marca__c = 'Kia';
        oppMoto.Forma_de_Pago_Multiple__c = 'Contado';
        oppMoto.Sucursal__c = 'Kia El Retiro'; 
        oppMoto.Pricebook2Id = pricebookId;
        oppMoto.Forma_de_Pago_Multiple__c = 'Contado';
        oppMoto.Prueba_de_manejo__c = 'No';
        oppMoto.Tour_CP__c = 'No';
        oppMoto.Walk_Around__c = 'No';
        oppMoto.Origen_de_los_fondos__c = 'Ahorro';
        oppMoto.Procedencia_de_los_fondos__c = 'Otros';
        oppMoto.Compa_a__c = companiasTest.ID;
        oppMoto.L_neas_de_Negocio__c = lineaNegocioTest.ID;
        oppMoto.Desea_realizar_intercambio__c = 'No';
        oppMoto.ModeloVehiculo__c = modeloTest.ID;
        oppMoto.Marca_UDC__c = marcaTest.ID;
        oppMoto.RecordTypeId = motosID;
        oppMoto.Canal_Contrata__c = 'Sucursales Propias - Detalle';
        oppMoto.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        oppMoto.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        oppMoto.Responsable_del_pago__c = 'Tercero Familiar';
        insert oppMoto;

        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'LBPKE1803J0071056';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;

        OpportunityLineItem oppliMoto = new OpportunityLineItem();
        oppliMoto.Chasis__c = 'LBPKE1803J0071055';
        oppliMoto.OpportunityId = oppMoto.Id;
        oppliMoto.PricebookEntryId = pbEntry.Id;
        oppliMoto.Product2Id = p.Id;
        oppliMoto.Quantity = 1;
        oppliMoto.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppliMoto;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'LBPKE1803J0071056';
		infNeg.Cuenta__c = acc.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        infNeg.Estado__c = 'Aprobado';
        insert infNeg;
        
        Informe_de_Negociaci_n__c infNegMoto = new Informe_de_Negociaci_n__c ();
        infNegMoto.Chasis__c = 'LBPKE1803J0071055';
		infNegMoto.Cuenta__c = acc.Id;
        infNegMoto.Oportunidad__c = oppMoto.Id;
        infNegMoto.Facturar_a_nombre_de__c = acc.Id;
        infNegMoto.total_negociado__c  = 4;
        infNegMoto.Estado__c = 'Aprobado';
        insert infNegMoto;
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;

        opp.StageName = 'Negociacion';
        update opp;
        
        oppMoto.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        oppMoto.StageName = 'Seleccionando Modelo';
        update oppMoto;

        oppMoto.StageName = 'Negociacion';
        update oppMoto;
        
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = acc.ID;
        rec.Saldo__c = 4;
        insert rec;

        AllRecibidos__c rec2 = new AllRecibidos__c();
        rec2.Instrumento_de_pago__c = 'Efectivo';
        rec2.Cuenta__c = acc.ID;
        rec2.Saldo__c = 4;
        insert rec2;

        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;

            recibosNegList.add(recNeg);
        }

        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec2.ID;
            recNeg.Informe_de_Negociaci_n__c = infNegMoto.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;

            recibosNegList.add(recNeg);
        }

        insert recibosNegList;
        
        opp.StageName = 'Formalizacion';
        update opp;

        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        oppMoto.StageName = 'Formalizacion';
        update oppMoto;

        infNegMoto.Estado__c = 'Aprobado';
        update infNegMoto;
    }
    
    @isTest
    public static void procesaFacturasAutomaticasTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios('Autos', ''));
        
        List<Opportunity> oppList = 
            [SELECT ID, StageName
            FROM Opportunity
            ];
        
        oppList[0].StageName = 'Listo Para Facturar';
        update oppList;
        
        Test.startTest();
        ProcesaWSGetFacturasAutomaticas.procesaFacturasAutomaticas();
        Test.stopTest();
        
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT fechafactura__c, N_mero_de_la_oportunidad__c, fechacreacion__c, factura__c
            FROM Informe_de_Negociaci_n__c
            WHERE Oportunidad__c =: oppList[0].ID
            ];
        
        List<Opportunity> oppListAct = 
            [SELECT Permite_Ganar_Oportunidad__c, StageName
            FROM Opportunity
            WHERE ID =: oppList[0].ID
            ];
            
        List<OpportunityLineItem> oliList = 
            [SELECT ID, Chasis_facturado__c
            FROM OpportunityLineItem
            WHERE OpportunityId =: oppList[0].ID
            ];
        
        System.assertEquals(Date.valueOf('2020-11-07'), infList[0].fechafactura__c, 'La fecha de la factura no se ha seteado correctamente.');
        System.assertEquals(Date.valueOf('2020-01-01'), infList[0].fechacreacion__c, 'La fecha de creacion no se ha seteado correctamente.');
        System.assertEquals('565678', infList[0].factura__c, 'La factura no se ha seteado correctamente.');
        
        System.assertEquals(true , oppListAct[0].Permite_Ganar_Oportunidad__c, 'La oportunidad no puede ganarse.');
        System.assertEquals('Facturado' , oppListAct[0].StageName, 'La etapa de la oportunidad no se ha seteado correctamente.');
    }

    @isTest
    public static void procesaDevolucionesTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios('Autos', ''));
        
        List<Opportunity> oppList = 
            [SELECT ID, StageName
            FROM Opportunity
            ];

        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID, fechafactura__c, factura__c, Sincronizacion_WS__c
            FROM Informe_de_negociaci_n__c
            WHERE Oportunidad__c =: oppList[0].ID
            ];
        
        oppList[0].StageName = 'Listo Para Facturar';
        update oppList;

        ProcesaWSGetFacturasAutomaticas.procesaFacturasAutomaticas();
        
        infList[0].Sincronizacion_WS__c = false;
        update infList;

        Test.startTest();
        ProcesaWSGetDevoluciones.procesaDevoluciones();
        Test.stopTest();
        
        List<Informe_de_Negociaci_n__c> infListAct = 
            [SELECT fechafactura__c, Devolucion__c, Fecha_de_devolucion__c, factura__c, Sincronizacion_WS__c
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: infList[0].ID
            ];
        
        List<Opportunity> oppListAct = 
            [SELECT Permite_Ganar_Oportunidad__c, StageName
            FROM Opportunity
            WHERE ID =: oppList[0].ID
            ];
        
        System.assertEquals(null, infListAct[0].fechafactura__c, 'La fecha de la factura no se ha nuleado como deberia.');
        System.assertEquals(null, infListAct[0].factura__c, 'La factura no se ha nuleado como deberia.');
        System.assertEquals(Date.valueOf('2021-09-13'), infListAct[0].Fecha_de_devolucion__c, 'La fecha de devolucion no se ha seteado correctamente.');
        System.assertEquals('777777', infListAct[0].Devolucion__c, 'La devolucion no se ha seteado correctamente.');
        System.assertEquals(true, infListAct[0].Sincronizacion_WS__c, 'Luego de la devolucion no se ha vuelto a enviar a la tabla.');
        
        System.assertEquals(false , oppListAct[0].Permite_Ganar_Oportunidad__c, 'La oportunidad puede ganarse cuando no deberia.');
        System.assertEquals('Listo Para Facturar' , oppListAct[0].StageName, 'La etapa de la oportunidad no se ha seteado correctamente.');
    }

    @isTest
    public static void procesaFacturasAutomaticasMotos() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios('Motos', ''));
        
        List<Opportunity> oppList = 
            [SELECT ID, StageName, C_digo_de_Oportunidad_Numerico__c
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Motos'
            ];

        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID, fechafactura__c, factura__c
            FROM Informe_de_negociaci_n__c
            WHERE Oportunidad__c =: oppList[0].ID
            ];

        oppList[0].StageName = 'Listo Para Facturar';
        update oppList;
        
        Test.startTest();
        ProcesaWSGetFacturasAutomaticas.procesaFacturasAutomaticas();
        Test.stopTest();
        
        List<Opportunity> oppListAct = 
            [SELECT Permite_Ganar_Oportunidad__c, StageName
            FROM Opportunity
            WHERE ID =: oppList[0].ID
            ];
        
        List<Informe_de_Negociaci_n__c> infListAct = 
            [SELECT fechafactura__c, Devolucion__c, Fecha_de_devolucion__c, factura__c, fechacreacion__c
            FROM Informe_de_Negociaci_n__c
            WHERE Oportunidad__c =: oppListAct[0].ID
            ];
        
        System.assertEquals(Date.valueOf('2020-11-07'), infListAct[0].fechafactura__c, 'La fecha de la factura no se ha seteado correctamente.');
        System.assertEquals(Date.valueOf('2020-01-01'), infListAct[0].fechacreacion__c, 'La fecha de creacion no se ha seteado correctamente.');
        System.assertEquals('565678', infListAct[0].factura__c, 'La factura no se ha seteado correctamente.');
        
        System.assertEquals(true, oppListAct[0].Permite_Ganar_Oportunidad__c, 'La oportunidad puede ganarse cuando no deberia.');
        System.assertEquals('Facturado' , oppListAct[0].StageName, 'La etapa de la oportunidad no se ha seteado correctamente.');
    }

    @isTest
    public static void procesaDevolucionesMotosTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios('Motos', ''));

        Opportunity oppMoto = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Motos'
        ];

        oppMoto.StageName = 'Listo Para Facturar';
        update oppMoto;

        ProcesaWSGetFacturasAutomaticas.actualizarData(ProcesaWSGetFacturasAutomaticas.simulaRespuesta('Motos'));

        Opportunity oppMotoFacturada = [
            SELECT StageName
            FROM Opportunity
            WHERE Id =: oppMoto.Id
        ];
    
        System.debug('etapa de moto: ' + oppMotoFacturada);

        oppMotoFacturada.StageName = 'Cerrada ganada';
        update oppMotoFacturada;
        
        Test.startTest();
        ProcesaWSGetDevoluciones.procesaDevoluciones();
        Test.stopTest();
        
        List<Informe_de_Negociaci_n__c> infListAct = [
            SELECT fechafactura__c, Devolucion__c, Fecha_de_devolucion__c, factura__c
            FROM Informe_de_Negociaci_n__c
            WHERE Oportunidad__c =: oppMotoFacturada.ID
            ];
        
        List<Opportunity> oppListAct = 
            [SELECT Permite_Ganar_Oportunidad__c, StageName
            FROM Opportunity
            WHERE ID =: oppMotoFacturada.ID
            ];
        
        System.assertEquals(null, infListAct[0].fechafactura__c, 'La fecha de la factura no se ha nuleado como deberia.');
        System.assertEquals(null, infListAct[0].factura__c, 'La factura no se ha nuleado como deberia.');
        System.assertEquals(Date.valueOf('2021-09-13'), infListAct[0].Fecha_de_devolucion__c, 'La fecha de devolucion no se ha seteado correctamente.');
        System.assertEquals('777777', infListAct[0].Devolucion__c, 'La devolucion no se ha seteado correctamente.');
        
        System.assertEquals(false , oppListAct[0].Permite_Ganar_Oportunidad__c, 'La oportunidad puede ganarse cuando no deberia.');
        System.assertEquals('Listo Para Facturar' , oppListAct[0].StageName, 'La etapa de la oportunidad no se ha seteado correctamente.');
    }
}