@isTest
public class ProcesaWSGetFactAutoPorFechaTest {
	@TestSetup
    static void crearData(){
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

        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'LBPKE1803J0071056';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;
    }

    @isTest
    public static void procesaFacturasAutomaticasTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        Opportunity opp = [
            SELECT ID, StageName
            FROM Opportunity
            LIMIT 1
		];
        
        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'LBPKE1803J0071056';
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
        rec.MontoAplicado__c = 4;
        insert rec;

        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = rec.ID;
            recNeg.Informe_de_Negociaci_n__c = infNeg.ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;

            recibosNegList.add(recNeg);
        }

        insert recibosNegList;
        
        opp.StageName = 'Formalizacion';
        update opp;

        infNeg.Estado__c = 'Aprobado';
        update infNeg;
        
        opp.StageName = 'Listo Para Facturar';
        update opp;
        
        Test.startTest();
        ProcesaWSGetFacturasAutomaticasPorFecha.procesaFacturasAutomaticasPorFecha(Date.today());
        Test.stopTest();
        
        Informe_de_Negociaci_n__c informeFacturado = 
            [SELECT fechafactura__c, N_mero_de_la_oportunidad__c, fechacreacion__c, factura__c
            FROM Informe_de_Negociaci_n__c
            WHERE Oportunidad__c =: opp.Id
            ];
        
        Opportunity oppFacturada = 
            [SELECT Permite_Ganar_Oportunidad__c, StageName
            FROM Opportunity
            WHERE ID =: opp.Id
            ];
            
        OpportunityLineItem oliFacturado = 
            [SELECT ID, Chasis_facturado__c
            FROM OpportunityLineItem
            WHERE OpportunityId =: opp.Id
            ];
        
        System.assertEquals('558843' , informeFacturado.N_mero_de_la_oportunidad__c, 'El numero de la oportunidad no se ha seteado correctamente.');
        System.assertEquals(Date.valueOf('2020-11-07'), informeFacturado.fechafactura__c, 'La fecha de la factura no se ha seteado correctamente.');
        System.assertEquals(Date.valueOf('2020-01-01'), informeFacturado.fechacreacion__c, 'La fecha de creacion no se ha seteado correctamente.');
        System.assertEquals('565678', informeFacturado.factura__c, 'La factura no se ha seteado correctamente.');
        
        System.assertEquals(true , oliFacturado.Chasis_facturado__c, 'El chasis no se ha marcado como facturado.');
        
        System.assertEquals(true , oppFacturada.Permite_Ganar_Oportunidad__c, 'La oportunidad no puede ganarse.');
        System.assertEquals('Facturado' , oppFacturada.StageName, 'La etapa de la oportunidad no se ha seteado correctamente.');
    }
}