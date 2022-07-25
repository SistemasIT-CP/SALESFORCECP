@isTest
public without sharing class mostrarOportunidadHijoTest {
    @TestSetup
    public static void crearOportunidad(){
        Id principalAutos = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autos')
                            .getRecordTypeId();

        Id marcaId = Schema.SObjectType.Catalogo_UDC__c
                            .getRecordTypeInfosByDeveloperName()
                            .get('Marcas')
                            .getRecordTypeId();

        Id modeloId = Schema.SObjectType.Catalogo_UDC__c
                            .getRecordTypeInfosByDeveloperName()
                            .get('Modelo')
                            .getRecordTypeId();

        Id submodeloId = Schema.SObjectType.Catalogo_UDC__c
                            .getRecordTypeInfosByDeveloperName()
                            .get('Submodelo')
                            .getRecordTypeId();

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Catalogo_UDC__c marca = new Catalogo_UDC__c();
        marca.Name = 'KIA';
        marca.productcode__c = 'KIA';
        marca.RecordTypeId = marcaId;
        marca.Permitido_para_autolote__c = true;
        insert marca;

        Catalogo_UDC__c modelo = new Catalogo_UDC__c();
        modelo.Name = 'PICANTO';
        modelo.productcode__c = 'PICANTO';
        modelo.RecordTypeId = modeloId;
        modelo.Permitido_para_autolote__c = true;
        modelo.udc_padre__c = marca.Id;
        insert modelo;

        Catalogo_UDC__c submodelo = new Catalogo_UDC__c();
        submodelo.Name = 'PICANTO MECANICO';
        submodelo.productcode__c = 'PICANTO MECANICO';
        submodelo.RecordTypeId = submodeloId;
        submodelo.Permitido_para_autolote__c = true;
        submodelo.udc_padre__c = modelo.Id;
        insert submodelo;

        Account acc = new Account();
        acc.Name = 'Cuenta empresa';
        acc.CurrencyIsoCode = 'USD';
        acc.Email__c = 'correo@test.com';
        acc.Cedula__c = '321321';
        acc.Phone = '88888888';
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        acc.Tipo_de_Indentificaci_n__c = 'Otros';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = Date.today();
        opp.Name = 'Oportunidad Autos';
        opp.RecordTypeId = principalAutos;
        opp.AccountId = acc.Id;
        insert opp;
    }

    @isTest
    public static void obtenerAniosTest(){
        List<String> anios = new List<String>();

        Schema.DescribeFieldResult f = Vehiculo__c.Anio_opcion__c.getDescribe();
		List<Schema.PicklistEntry> pickL = f.getPicklistValues();
        
		for (Schema.PicklistEntry pickV : pickL) {
            anios.add(pickV.getLabel());
		}     

        Test.startTest();
        List<String> respuesta = mostrarOportunidadHijo.obtenerListaAnios();
        Test.stopTest();

        for (String anio : anios) {
            System.assertEquals(true, 
                                respuesta.contains(anio),
                                'El anio ' + anio + ' no esta en el resultado cuando deberia');
        }
    }

    @isTest
    public static void obtenerMapaUdcTest(){
        Test.startTest();
        List<Map<String, List<String>>> listadoMapaUdc = mostrarOportunidadHijo.obtenerUdcs();
        Test.stopTest();

        System.assertEquals(2, 
                            listadoMapaUdc.size(), 
                            'El mapa de udc no trae uno por modelo y otro por submodelo como deberia');

        Map<String, List<String>> mapaModeloPorMarca = listadoMapaUdc[0];
        Map<String, List<String>> mapaSubmodeloPorMarca = listadoMapaUdc[1];

        System.assertEquals(true, 
                            mapaModeloPorMarca.containsKey('KIA'),
                            'La marca KIA no aparece en el mapa cuando deberia');
        System.assertEquals(true, 
                            mapaModeloPorMarca.get('KIA').contains('PICANTO'),
                            'El modelo PICANTO no aparece en el mapa relacionado a KIA cuando deberia');

        System.assertEquals(true, 
                            mapaSubmodeloPorMarca.containsKey('PICANTO'),
                            'La modelo PICANTO no aparece en el mapa cuando deberia');
        System.assertEquals(true, 
                            mapaSubmodeloPorMarca.get('PICANTO').contains('PICANTO MECANICO'),
                            'El modelo PICANTO MECANICO no aparece en el mapa relacionado a PICANTO cuando deberia');
    }

    @isTest
    public static void obtenerMapaEtapasTest(){
        Test.startTest();
        Map<String, String> colorPorEtapa = mostrarOportunidadHijo.obtenerMapaEtapas();
        Test.stopTest();

        List<Orden_de_etapas_por_recordType__mdt> ordenList = [
            SELECT Label, Codigo_de_color__c 
            FROM Orden_de_etapas_por_recordType__mdt
            WHERE RecordType__c = 'Avaluo'
        ];

        for (Orden_de_etapas_por_recordType__mdt orden : ordenList) {
            System.assertEquals(true, 
                                colorPorEtapa.containsKey(orden.Label), 
                                'La etapa ' + orden.Label + ' no esta siendo incluida en el mapa de etapas');
            System.assertEquals(orden.Codigo_de_color__c, 
                                colorPorEtapa.get(orden.Label),
                                'El color de la etapa ' + orden.Label + ' no esta coincide con lo esperado');
        }
    }

    @isTest
    public static void obtenerAvaluoTest() {
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        mostrarOportunidadHijo.crearAvaluo(
            opp.Id,
            'PLACA123',
            'KIA',
            'PICANTO',
            'PICANTO MECANICO',
            '2021',
            '12000'
        );

        Test.startTest();
        List<Vehiculo_de_la_Oportunidad__c> vehList = mostrarOportunidadHijo.obtenerHijoAvaluo(opp.Id);
        Test.stopTest();

        Opportunity avaluo = [
            SELECT Id 
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Avaluo'
                AND Oportunidad_original__c =: opp.Id
        ];

        Vehiculo_de_la_Oportunidad__c vehOpp = [
            SELECT Id 
            FROM Vehiculo_de_la_Oportunidad__c
            WHERE Oportunidad__c =: avaluo.Id 
        ];

        System.assertEquals(false, vehList.isEmpty(), 'No se esta retornando ningun vehiculo cuando deberia');
        System.assertEquals(vehOpp.Id, vehList[0].Id, 'El vehiculo que se esta retornando no es el correcto');
    }

    @isTest
    public static void asociarVehiculoInexistenteTest(){
        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '200';
        veh.Estado__c = 'Pendiente';
        insert veh;

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Test.startTest();
        String respuesta = mostrarOportunidadHijo.asociarVehiculoExistente(opp.Id, 'placaInexistente');
        Test.stopTest();

        System.assertEquals('No existe vehiculo disponible con la placa indicada', respuesta, 'La respuesta de error no coincide con lo esperado');
    }

    @isTest
    public static void asociarVehiculoNoDisponibleTest(){
        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '200';
        veh.Estado__c = 'Libre';
        insert veh;

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Test.startTest();
        String respuesta = mostrarOportunidadHijo.asociarVehiculoExistente(opp.Id, '123456');
        Test.stopTest();

        System.assertEquals('No existe vehiculo disponible con la placa indicada', respuesta, 'La respuesta de error no coincide con lo esperado');
    }

    @isTest
    public static void asociarVehiculoExistenteTest(){
        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '200';
        veh.Estado__c = 'Pendiente';
        insert veh;

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Test.startTest();
        String respuesta = mostrarOportunidadHijo.asociarVehiculoExistente(opp.Id, '123456');
        Test.stopTest();

        List<Opportunity> oppPreAvaluo = [
            SELECT Id 
            FROM Opportunity
            WHERE Oportunidad_original__c =: opp.Id
        ];

        List<Vehiculo_de_la_Oportunidad__c> vehOpp = [
            SELECT Id
            FROM Vehiculo_de_la_Oportunidad__c
            WHERE Vehiculo__c =: veh.Id AND Oportunidad__r.Oportunidad_original__c =: opp.Id
        ];

        System.assertEquals('Ok', respuesta, 'La respuesta no coincide con lo esperado');
        System.assertEquals(false, oppPreAvaluo.isEmpty(), 'No se esta creando correctamente el pre avaluo asociado al vehiculo.');
        System.assertEquals(false, vehOpp.isEmpty(), 'No se esta asociando correctamente el vehiculo a la oportunidad.');
    }

    @isTest
    public static void asociarVehiculoQueTodaviaEstaEnAvaluo(){
        ID avaluoId = Schema.SObjectType.Opportunity
                    .getRecordTypeInfosByDeveloperName()
                    .get('Avaluo')
                    .getRecordTypeId();

        Account acc = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];
        
        Opportunity oppPrincipal = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];

        Opportunity opp = new Opportunity();
        opp.StageName = 'Avaluo Realizado';
        opp.CloseDate = Date.today();
        opp.Name = 'Oportunidad Autos';
        opp.RecordTypeId = avaluoId;
        opp.AccountId = acc.Id;
        insert opp;

        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '200';
        veh.Estado__c = 'Pendiente';
        insert veh;

        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Oportunidad__c = opp.Id;
        vehOpp.Vehiculo__c = veh.Id;    
        insert vehOpp;


        Test.startTest();
        String respuesta = mostrarOportunidadHijo.asociarVehiculoExistente(oppPrincipal.Id, '123456');
        Test.stopTest();

        System.assertEquals(true, respuesta.contains('Este vehiculo es parte de un proceso llevado por'));
        System.assertEquals(true, respuesta.contains(', con lo cual no puede ser asociado.'));
    }
}