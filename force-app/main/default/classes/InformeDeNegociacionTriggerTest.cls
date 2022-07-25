@isTest
public class InformeDeNegociacionTriggerTest {
    @TestSetup
    public static void crearOportunidad(){
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

        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Chasis__c = 'TESTCHASIS_89789798';
        oppli.OpportunityId = opp.Id;
        oppli.PricebookEntryId = pbEntry.Id;
        oppli.Product2Id = p.Id;
        oppli.Quantity = 1;
        oppli.TotalPrice = 1 * pbEntry.UnitPrice;
        insert oppli;

        Accesorios__c accesorio = new Accesorios__c();
        accesorio.Descripcion__c = 'Test';
        accesorio.CodigoParte__c = '10BBLD616DYXX';
        accesorio.CodParteEquivalente__c = '70D1985077010';
        accesorio.CantidadMinima__c = 1;
        accesorio.DescripcionAmplia__c = 'Test';
        accesorio.Compa_a_UDC__c = companiasTest.ID;
        insert accesorio;
    }

    @IsTest
    public static void modificarInformeFacturadoTest(){
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Imp_Aduanas__c = 0;
        inf.factura__c = '123';
        insert inf;

        inf.Imp_Aduanas__c = 5;

        Test.startTest();
        Database.SaveResult sr = Database.update(inf, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'La actualizacion de un informe facturado no falla aunque deberia');
        System.assertEquals('No se puede modificar un informe ya facturado', 
                            sr.getErrors()[0].getMessage(), 
                            'El mensaje de la actualizacion de un informe facturado no es el esperado');
    }

    @IsTest
    public static void modificarInformeDeUnaOportunidadFacturada(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Account acc = [
            SELECT ID
            FROM Account
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT ID, Fecha_de_Entrega__c, StageName
            FROM Opportunity
            LIMIT 1
        ];

        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
		infNeg.Cuenta__c = acc.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = acc.Id;
        infNeg.total_negociado__c  = 4;
        insert infNeg;

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
        
        opp.Fecha_de_Entrega__c = Date.newInstance(Date.today().year(), Date.today().month() , Date.today().day());
        opp.StageName = 'Seleccionando Modelo';
        update opp;

        opp.StageName = 'Negociacion';
        update opp;
            
        infNeg.Estado__c = 'Aprobado';
        update infNeg;

        opp.StageName = 'Formalizacion';
        update opp;

        opp.StageName = 'Listo Para Facturar';
        update opp;

        infNeg.Imp_Aduanas__c = 5;

        Test.startTest();
        Database.SaveResult sr = Database.update(infNeg, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'La actualizacion de un informe de una oportunidad facturada no falla aunque deberia');
        System.assertEquals('Para modificar el informe, su oportunidad debe estar en Formalización o una etapa anterior.', 
                            sr.getErrors()[0].getMessage(), 
                            'El mensaje de la actualizacion de un informe facturado no es el esperado');
    }

    @isTest
    public static void cambiarEstadoTest(){
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Estado__c = 'Aprobado';
        inf.Solicitar_accesorios__c = true;
        insert inf;

        inf.Imp_Aduanas__c = 5;

        Test.startTest();
        Database.SaveResult sr = Database.update(inf, false);
        Test.stopTest();

        Informe_de_Negociaci_n__c infModificado = [
            SELECT Estado__c, Solicitar_accesorios__c
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: inf.ID
            LIMIT 1
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'El cambio de un informe aprobado falla cuando no deberia');
        System.assertEquals('Esperando aprobacion', 
                            infModificado.Estado__c, 
                            'El estado no se ha modificado como deberia');
        System.assertEquals(false, 
                            infModificado.Solicitar_accesorios__c, 
                            'El check de solicitar accesorio no se ha modificado como deberia');
    }

    @isTest
    public static void eliminarInformeReservado(){
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Reservar__c = true;
        insert inf;

        Test.startTest();
        Database.DeleteResult dr = Database.delete(inf, false);
        Test.stopTest();

        Informe_de_Negociaci_n__c infCreado = [
            SELECT Name
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: inf.ID
        ];

        System.assertEquals(false, dr.isSuccess(), 'La eliminacion de un informe reservado funciono cuando no deberia haberlo hecho');
        System.assertEquals('No puede eliminar el informe de negociación ' + infCreado.Name + ', ya que se encuentra en estado reservado', 
                            dr.getErrors()[0].getMessage(),
                            'El mensaje de la eliminacion de un informe reservado no es el esperado');
    }

    @isTest
    public static void eliminarInformeConRecibos(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Account acc = [
            SELECT ID
            FROM Account
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT ID, Fecha_de_Entrega__c, StageName
            FROM Opportunity
            LIMIT 1
        ];

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

        Test.startTest();
        Database.DeleteResult dr = Database.delete(infNeg, false);
        Test.stopTest();

        Informe_de_Negociaci_n__c infCreado = [
            SELECT Name
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: infNeg.ID
        ];

        System.assertEquals(false, dr.isSuccess(), 'La eliminacion de un informe con recibos funciono cuando no deberia haberlo hecho');
        System.assertEquals('El informe de negociación: ' + infCreado.Name + ' tiene recibos asociados los cuales debe eliminar primero, para poder eliminar el registro.', 
                            dr.getErrors()[0].getMessage(),
                            'El mensaje de la eliminacion de un informe con recibos no es el esperado');
    }

    @isTest
    public static void eliminarInformeConAccesoriosDespachados(){
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf;

        Accesorios__c acc = [
            SELECT ID
            FROM Accesorios__c
            LIMIT 1
        ];

        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = inf.ID;
        accInf.Accesorio__c = acc.ID;
        accInf.Cantidad__c = 1;
        accInf.Solicitar_Accesorio_Equivalente__c = false;
        accInf.Estado__c = 'Despachado';
        insert accInf;

        Test.startTest();
        Database.DeleteResult dr = Database.delete(inf, false);
        Test.stopTest();

        Informe_de_Negociaci_n__c infCreado = [
            SELECT Name 
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: inf.ID
        ];

        System.assertEquals(false, dr.isSuccess(), 'La eliminacion de un informe con recibos funciono cuando no deberia haberlo hecho');
        System.assertEquals('El informe de negociación: ' + infCreado.Name + ' tiene accesorios despachados los cuales debe cambiar de estado, para poder eliminar el registro.', 
                            dr.getErrors()[0].getMessage(),
                            'El mensaje de la eliminacion de un informe con recibos no es el esperado');
    }

    @isTest
    public static void eliminarInformeCorrectamente(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf; 

        Test.startTest();
        Database.DeleteResult dr = Database.delete(inf, false);
        Test.stopTest();

        System.assertEquals(true, dr.isSuccess(), 'La eliminacion del informe falla cuando no deberia');
    }

    @isTest
    public static void eliminarInformeLuegoDeLaAprobacionDelProcesoDeAprobacion(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Account account = [
            SELECT ID
            FROM Account
            LIMIT 1
        ];

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Accesorios__c acc = [
            SELECT Id 
            FROM Accesorios__c
            LIMIT 1
        ];

        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
		infNeg.Cuenta__c = account.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = account.Id;
        infNeg.total_negociado__c  = 4;
        insert infNeg;

        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Instrumento_de_pago__c = 'Efectivo';
        rec.Cuenta__c = account.Id;
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
        
        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = infNeg.ID;
        accInf.Accesorio__c = acc.ID;
        accInf.Cantidad__c = 1;
        accInf.Solicitar_Accesorio_Equivalente__c = false;
        insert accInf;
        
        accInf.Estado__c = 'Despachado';
        update accInf;

        infNeg.Estado_de_aprobaci_n__c = 'Pendiente';
        update infNeg;

        infNeg.Estado_de_aprobaci_n__c = 'Aprobado';

        Test.startTest();
        Database.SaveResult sr = Database.update(infNeg, false);
        Test.stopTest();

        List<Recibos_de_la_negociaci_n__c> recNegListActualizada = [
            SELECT Id 
            FROM Recibos_de_la_negociaci_n__c
            WHERE Informe_de_Negociaci_n__c =: infNeg.Id
        ];

        List<Accesorios_del_informe__c> accNegListActualizada = [
            SELECT Id 
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infNeg.Id
        ];

        List<Informe_de_Negociaci_n__c> infNegEliminado = [
            SELECT Id 
            FROM Informe_de_Negociaci_n__c
            WHERE Id =: infNeg.Id
        ];

        System.debug(sr.getErrors());

        System.assertEquals(true, sr.isSuccess(), 'La actualizacion del informe falla cuando no deberia.');
        System.assertEquals(true, recNegListActualizada.isEmpty(), 'El listado de recibo no se ha eliminado como deberia');
        System.assertEquals(true, accNegListActualizada.isEmpty(), 'El listado de accesorios no se ha eliminado como deberia');
        System.assertEquals(true, infNegEliminado.isEmpty(), 'El informe de negociacion no se ha eliminado como deberia');
    }
    
    @isTest
    public static void testEnviarMotosASegundaAprobacion() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Account account = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Id motosOppId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Motos')
                            .getRecordTypeId();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = account.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 123456789;
        opp.Marca__c = 'Kia';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Sucursal__c = 'Juigalpa'; 
        opp.Pricebook2Id = Test.getStandardPricebookId();
        opp.RecordTypeID = motosOppId;
        opp.Prueba_de_manejo__c = 'No';
        opp.Tour_CP__c = 'No';
        opp.Walk_Around__c = 'No';
        opp.Origen_de_los_fondos__c = 'Ahorro';
        opp.Procedencia_de_los_fondos__c = 'Otros';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Desea_realizar_intercambio__c = 'No';
        opp.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        opp.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        opp.Responsable_del_pago__c = 'Tercero Familiar';
        insert opp;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
		infNeg.Cuenta__c = account.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = account.Id;
        infNeg.total_negociado__c  = 4;
        insert infNeg;
        
        Test.startTest();
        infNeg.Texto_bandera__c = 'Precio Aprobacion';
        Database.SaveResult srUpdate = Database.update(infNeg, false);
        Test.stopTest();
        
        System.assertEquals(true, srUpdate.isSuccess(), 'La actualizacion del campo bandera esta fallando cuando no deberia.');
        System.assertEquals(true, srUpdate.getErrors().isEmpty(), 'Hay mensajes de error cuando no deberia estar fallando.');
    }
    
        @isTest
    	public static void testCerrarProcesosDeAprobacionAdicionales() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Account account = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Id motosOppId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Motos')
                            .getRecordTypeId();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = account.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 123456789;
        opp.Marca__c = 'Kia';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Sucursal__c = 'Juigalpa'; 
        opp.Pricebook2Id = Test.getStandardPricebookId();
        opp.RecordTypeID = motosOppId;
        opp.Prueba_de_manejo__c = 'No';
        opp.Tour_CP__c = 'No';
        opp.Walk_Around__c = 'No';
        opp.Origen_de_los_fondos__c = 'Ahorro';
        opp.Procedencia_de_los_fondos__c = 'Otros';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Desea_realizar_intercambio__c = 'No';
        opp.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        opp.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        opp.Responsable_del_pago__c = 'Tercero Familiar';
        insert opp;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
		infNeg.Cuenta__c = account.Id;
        infNeg.Oportunidad__c = opp.Id;
        infNeg.Facturar_a_nombre_de__c = account.Id;
        infNeg.total_negociado__c  = 4;
        insert infNeg;
        
        Test.startTest();
        infNeg.Horario_de_aprobacion__c = Datetime.now();
        Database.SaveResult srUpdate = Database.update(infNeg, false);
        Test.stopTest();
        
        System.assertEquals(true, srUpdate.isSuccess(), 'La actualizacion del horario de aprobacion esta fallando cuando no deberia.');
        System.assertEquals(true, srUpdate.getErrors().isEmpty(), 'Hay mensajes de error cuando no deberia estar fallando.');
    }
}