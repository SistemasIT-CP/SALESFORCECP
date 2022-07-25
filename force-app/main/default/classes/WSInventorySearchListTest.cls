@isTest
public class WSInventorySearchListTest {
    @TestSetup
    public static void crearUDC(){
        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Id linNegocioID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Lineas_de_negocio')
                                    .getRecordTypeId();
        
        Id marcasId = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Marcas')
                                    .getRecordTypeId();

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c>();

        for (Integer i = 0; i < 200; i++) {
            Catalogo_UDC__c cat = new Catalogo_UDC__c();
            cat.Name = 'Cat ' + i;
            cat.description1__c = 'Desc1 ' + i;
            cat.description2__c = 'Desc2 ' + i;
            cat.Marca_relacionada__c = 'TOYOTA;KIA';
            cat.productCode__c = 'E' + i;
            if (Math.mod(i, 3) == 0) {
                cat.RecordTypeId = companiaID;
            } else if (Math.mod(i, 3) == 1) {
                cat.RecordTypeId = linNegocioID;
            } else {
                cat.RecordTypeId = marcasId;
            }
            catList.add(cat);
        }

        insert catList;

        Id profileId = [
            SELECT Id
            FROM Profile 
            WHERE Name = 'Vendedor'
            LIMIT 1
        ].Id;

        User u = TestFactory.createUser(profileId);
        insert u;
    }

    @isTest
    public static void getInventarioTest() {
        Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> inventarioList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        Test.stopTest();

        System.assertEquals(8, inventarioList.size(), 'La cantidad de elementos del inventario no es la esperada');

        for (WS_InventorySearchList.Inventory inventario : inventarioList) {
            System.assertEquals(true, inventario.chasis.contains('TestChasis123456'), 'El campo chasis no corresponde con lo esperado');
            System.assertEquals(true, inventario.descripcion.contains('Descripcion'), 'El campo descripcion no corresponde con lo esperado');
            System.assertEquals(true, inventario.codigomotor.contains('CodMotor'), 'El campo codigomotor no corresponde con lo esperado');
            System.assertEquals(true, inventario.numerocorto >= 1234560 && inventario.numerocorto <= 1234567, 'El campo numerocorto no corresponde con lo esperado');
        }
    }
    
    @isTest
    public static void getInventarioByChasisTest() {
    	Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> invList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        List<WS_InventorySearchList.Inventory> invSearch = WS_InventorySearchList.getInventarioByString('TestChasis1234567', invList);
        Test.stopTest();

        System.assertEquals(1, invSearch.size(), 'El buscador por chasis no esta trayendo la cantidad correcta de resultados');
        System.assertEquals('TestChasis1234567', invSearch[0].chasis, 'El resultado no tiene el chasis esperado');
    }
    
    @isTest
    public static void getInventarioByDescripcionTest() {
    	Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> invList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        List<WS_InventorySearchList.Inventory> invSearch = WS_InventorySearchList.getInventarioByString('Descripcion1', invList);
        Test.stopTest();

        System.assertEquals(1, invSearch.size(), 'El buscador por descripcion no esta trayendo la cantidad correcta de resultados');
        System.assertEquals('Descripcion1', invSearch[0].descripcion, 'El resultado no tiene la descripcion esperada');
    }
    
    @isTest
    public static void getInventarioByCodigoMotorTest() {
    	Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> invList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        List<WS_InventorySearchList.Inventory> invSearch = WS_InventorySearchList.getInventarioByString('CodMotor5', invList);
        Test.stopTest();

        System.assertEquals(1, invSearch.size(), 'El buscador por codigomotor no esta trayendo la cantidad correcta de resultados');
        System.assertEquals('CodMotor5', invSearch[0].codigomotor, 'El resultado no tiene el codigomotor esperado');
    }
    
    @isTest
    public static void getInventarioByNumberoCortoTest() {
    	Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> invList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        List<WS_InventorySearchList.Inventory> invSearch = WS_InventorySearchList.getInventarioByString('1234567', invList);
        Test.stopTest();

        System.assertEquals(1, invSearch.size(), 'El buscador por numerocorto no esta trayendo la cantidad correcta de resultados');
        System.assertEquals(1234567, invSearch[0].numerocorto, 'El resultado no tiene el numerocorto esperado');
    }
    
    @isTest
    public static void getInventarioByNullTest() {
    	Test.setMock(HttpCalloutMock.class, new InventorySearchListMock());
        
        Test.startTest();
        List<WS_InventorySearchList.Inventory> invList = WS_InventorySearchList.getInventario('Casa Pellas S.A.', 'Autos Suzuki', 'Suzuki', '', 'true');
        List<WS_InventorySearchList.Inventory> invSearch = WS_InventorySearchList.getInventarioByString('', invList);
        Test.stopTest();

        System.assertEquals(invSearch.size(), invList.size(), 'La cantidad de resultados obtenidos no es lo esperado');

        for (WS_InventorySearchList.Inventory inventario : invList) {
            System.assertEquals(true, invSearch.contains(inventario), 'El elemento ' + inventario.chasis + ' no esta incluido en el resultado cuando deberia');
        }
    }
    
    @isTest
    public static void cargaPickListTest() {
        User u = [
            SELECT Id, Marca__c
            FROM User
            WHERE Alias = 'TestUser'
            LIMIT 1
        ];

        List<List<Catalogo_UDC__c>> picklistMap;

        System.runAs(u) {
            Test.startTest();
            picklistMap = WS_InventorySearchList.cargaPickList();
            Test.stopTest();
        }

        System.assertEquals(3, picklistMap.size(), 'El mapa de picklist no trae la cantidad correcta de listas');
    }
}