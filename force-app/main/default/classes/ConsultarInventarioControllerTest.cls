@isTest
public class ConsultarInventarioControllerTest {
    @TestSetup
    public static void crearUDC(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Id linNegocioID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Lineas_de_negocio')
                                    .getRecordTypeId();

        Id avaluoId = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Avaluo')
                                    .getRecordTypeId();

        Catalogo_UDC__c casaPellas = new Catalogo_UDC__c();
        casaPellas.Name = 'CASA PELLAS, S.A';
        casaPellas.productCode__c = 'E01';
        casaPellas.RecordTypeId = companiaID;
        insert casaPellas;

        Catalogo_UDC__c autolote = new Catalogo_UDC__c();
        autolote.Name = 'Autos Usados';
        autolote.productCode__c = '02';
        autolote.RecordTypeId = linNegocioID;
        insert autolote;

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        acc.Tipo_de_Indentificaci_n__c = 'Otros';
        acc.Tipo_Cliente__c = 'Ocasional';
        acc.Nivel_organizacional__c = 'Asalariado';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = acc.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opp.Marca__c = 'Kia';
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.RecordTypeID = avaluoId;
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
    }

    @isTest
    public static void consultarInventarioConChasisExistente(){
        Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        Opportunity opp = [
            SELECT Id 
            FROM Opportunity
            LIMIT 1
        ];

        Vehiculo__c veh = new Vehiculo__c();
        veh.Chasis__c = 'TestChasis1234567';
        insert veh;

        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Vehiculo__c = veh.Id;
        vehOpp.Oportunidad__c = opp.id;
        insert vehOpp;
        
        Test.startTest();
        String respuesta = ConsultarInventarioController.consultarInventario(opp.Id);
        Test.stopTest();

        Opportunity oppActualizada = [
            SELECT Permite_ganar_oportunidad__c
            FROM Opportunity
            WHERE Id =: opp.Id
        ];

        System.assertEquals(
            'Ok. Todos los vehiculos se encuentran ingresados correctamente en el inventario, puede cerrar la oportunidad.', 
            respuesta,
            'La respuesta del intento exitoso no corresponde con lo esperado'
        );

        System.assertEquals(
            true,
            oppActualizada.Permite_ganar_oportunidad__c,
            'La oportunidad no puede cerrarse cuando deberia'
        );
    }

    @isTest
    public static void consultarInventarioConChasisNoExistentes(){
        Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        Opportunity opp = [
            SELECT Id 
            FROM Opportunity
            LIMIT 1
        ];

        Vehiculo__c veh = new Vehiculo__c();
        veh.Chasis__c = 'ChasisInexistente';
        insert veh;

        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Vehiculo__c = veh.Id;
        vehOpp.Oportunidad__c = opp.id;
        insert vehOpp;

        Test.startTest();
        String respuesta = ConsultarInventarioController.consultarInventario(opp.Id);
        Test.stopTest();

        Opportunity oppActualizada = [
            SELECT Permite_ganar_oportunidad__c
            FROM Opportunity
            WHERE Id =: opp.Id
        ];
        
        Vehiculo__c vehActualizado = [
            SELECT Chasis__c
            FROM Vehiculo__c
            WHERE Id =: veh.Id
        ];

        System.assertEquals(
            'Los siguientes chasis no estan ingresados en el inventario: ' + vehActualizado.Chasis__c, 
            respuesta,
            'La respuesta del intento fallido no corresponde con lo esperado'
        );

        System.assertEquals(
            false,
            oppActualizada.Permite_ganar_oportunidad__c,
            'La oportunidad puede cerrarse cuando deberia'
        );
    }
}