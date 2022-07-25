@isTest
public class OpportunityProduct_Edit_Controller_Test {   
    @TestSetup
    static void createOppProdAndOppItem(){
        ID personAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('PersonAccount')
                                .getRecordTypeId();
        
        ID marcas = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Marcas')
                                .getRecordTypeId();
        
        ID modelos = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Modelo')
                                .getRecordTypeId();

        Id sucursalID = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Sucursales')
                                .getRecordTypeId();

        Id linNegocioID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Lineas_de_negocio')
                                    .getRecordTypeId();
                                            
        List<Catalogo_UDC__c> listCatalogoToInsert = new List<Catalogo_UDC__c>();

        Catalogo_UDC__c lineaNegocioTest = new Catalogo_UDC__c();
        lineaNegocioTest.Name = 'Autos Nuevos';
        lineaNegocioTest.productcode__c = 'LDN';
        lineaNegocioTest.RecordTypeId = linNegocioID;

        listCatalogoToInsert.add(lineaNegocioTest);
        
        Catalogo_UDC__c marca = new Catalogo_UDC__c();
        marca.RecordTypeId = marcas;
        marca.Name = 'SUZUKI';
        
        listCatalogoToInsert.add(marca);
        
        Catalogo_UDC__c modelo = new Catalogo_UDC__c();
        modelo.RecordTypeId = modelos;
        modelo.Name = 'TestModelo';
        
        listCatalogoToInsert.add(modelo);
        
        insert listCatalogoToInsert;
        
        Catalogo_Sucursales__c sucursalElRetiro = new Catalogo_Sucursales__c();
        sucursalElRetiro.Name = 'Kia El Retiro';
        sucursalElRetiro.Codigo_de_la_sucursal__c = '123';

        insert sucursalElRetiro;
       
        Product2 prod = new Product2 (Name = 'Test product',
                                    IsActive = true,
                                    Marca_P__c = 'Kia',
                                    CurrencyIsoCode = 'USD',
                                    ProductCode__c = '316220');
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = new Account(FirstName = 'Cuenta',
                                  LastName = 'Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = personAccountID;
        acc.CodigoCliente__c = '321321';
        insert acc;  
        insert prod;
        
        Pricebook2 pricebook = new Pricebook2(Name = 'Test pricebook for Test Product',
                                              IsActive = true);
        
        insert pricebook;
        
        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert standardPBE;

        PricebookEntry entry = new PricebookEntry(
            Product2Id = prod.ID,
            Pricebook2Id = pricebook.ID,
            UnitPrice = 123.45,
            IsActive = true
        );

        insert entry;
        
        Opportunity opp = new Opportunity (Name = 'Test opportunity',
                                           StageName = 'Contacto Exitoso',
                                           CloseDate = Date.today().addDays(1),
                                           Marca_UDC__c = marca.Id,
                                           ModeloVehiculo__c = modelo.Id,
                                           C_digo_de_Oportunidad_Numerico__c = 987654,
                                           AccountID = acc.ID,
                                           Sucursal__c = 'Kia El Retiro',
                                           Pricebook2Id = pricebook.id);

        insert opp;

        List<OpportunityLineItem> oppItemLista = new List<OpportunityLineItem>();
        
        for(Integer i = 0; i < 10; i++) {
            OpportunityLineItem oppItem = new  OpportunityLineItem (OpportunityId = opp.ID,
                                                                    Product2Id = prod.ID,
                                                                    PricebookEntryId = entry.Id,
                                                                    UnitPrice = 123.45,
                                                                    Quantity = 996.13,
                                                                    Motor__c = 'Test Motor ' + i,
                                                                    Chasis__c = 'Test Chasis ' + i);
            oppItemLista.add(oppItem);
        }
        
        oppItemLista[0].Motor__c = null;
        oppItemLista[1].Motor__c = 'Test Motor 2';
        oppItemLista[1].Chasis__c = 'Test Chasis 2';

        insert oppItemLista;
    }

    @isTest 
    public static void getProductosTest() {
        Opportunity opp = [SELECT ID 
                           FROM Opportunity 
                           WHERE Name = 'CUENTA TEST/SUZUKI/TestModelo'
                           ];
       
        List<OpportunityLineItem> oppProd = [SELECT ID, Name
                                            FROM OpportunityLineItem 
                                            WHERE OpportunityId = :opp.ID
                                            ];
        
        Test.startTest();
        List<OpportunityLineItem> oppItemLista = OpportunityProduct_Edit_Controller.getProductos(opp.ID);
        Test.stopTest();

        Set<ID> oppIDs = new Set<ID>();
        
        for(OpportunityLineItem oppIt : oppItemLista) {
            oppIDs.add(oppIt.ID);
        }
        
        System.assertEquals(oppProd.size(),
                            oppItemLista.size(),
                            'El getProductos esta trayendo Opportunity Product incorrectos');

        for(OpportunityLineItem oppIt : oppProd) {
            System.assertEquals(true,
                                oppIDs.contains(oppIt.ID),
                                'El opportunity product ' + oppIt.Name + ' no esta siendo traido por el getProductos');
        }
    }

    @IsTest
    public static void asignarMotorChasisTest(){
       Opportunity opp = [SELECT ID, Pricebook2Id 
                           FROM Opportunity 
                           WHERE Name = 'CUENTA TEST/SUZUKI/TestModelo'
                           LIMIT 1
                           ];

        Product2 prod = [SELECT ID
                         FROM Product2
                         WHERE Name = 'Test product'
                         LIMIT 1
                         ];

        PricebookEntry entry = [SELECT ID
                                FROM PricebookEntry
                                WHERE Pricebook2Id =: opp.Pricebook2Id
                                LIMIT 1
                               ];


        OpportunityLineItem oppItem = new  OpportunityLineItem(OpportunityId = opp.ID,
                         Product2Id = prod.ID,
                         PricebookEntryId = entry.Id,
                         UnitPrice = 123.45,
                         Quantity = 1);

        insert oppItem;

        Test.startTest();
        String estado = OpportunityProduct_Edit_Controller.AsignarMotorChasis(oppItem.Id, 'Motor', 'Chasis1', 'Color');
        Test.stopTest();

        OpportunityLineItem oppIt = [SELECT Motor__c, Chasis__c, Color__c
                                       FROM OpportunityLineItem
                                       WHERE ID = :oppItem.ID
                                       LIMIT 1];

        System.assertEquals('ok',
                             estado,
                             'AsignarMotorChasis esta fallando cuando no deberia hacerlo');

        System.assertEquals('Motor', 
                            oppIt.Motor__c,
                            'El motor se ha asignado incorrectamente');

        System.assertEquals('Chasis1', 
                             oppIt.Chasis__c,
                             'El chasis se ha asignado incorrectamente');

        System.assertEquals('Color',
                             oppIt.Color__c,
                             'El color se ha asignado incorrectamente');
    }

    @IsTest
    static void deasignarTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Opportunity opp = [
          	SELECT ID, Pricebook2Id 
           	FROM Opportunity 
           	WHERE Name = 'CUENTA TEST/SUZUKI/TestModelo'
           	];

        Product2 prod = [
            SELECT ID
          	FROM Product2
         	WHERE Name = 'Test product'
         	LIMIT 1
        ];

        PricebookEntry entry = [
            SELECT ID
            FROM PricebookEntry
            WHERE Pricebook2Id =: opp.Pricebook2Id
            LIMIT 1
        ];


        OpportunityLineItem oppItem = new OpportunityLineItem(
            OpportunityId = opp.ID,
         	Product2Id = prod.ID,
         	PricebookEntryId = entry.Id,
         	UnitPrice = 123.45,
         	Quantity = 1,
            Motor__c = 'Motor',
            Chasis__c = 'Chasis'
        );

        insert oppItem;
        
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf;
                
        oppItem.IdInformeNegociacion__c = inf.Id;
        update oppItem;

        Test.startTest();
        delete inf;
        String estado = OpportunityProduct_Edit_Controller.Desasignar(oppItem.Id, '', 'Deasignacion');
        Test.stopTest();

        OpportunityLineItem oppItemDeasignado = [
            SELECT ID, Motor__c, Chasis__c, IdInformeNegociacion__c, Color__c
            FROM OpportunityLineItem
            WHERE ID =: oppItem.ID
            LIMIT 1
		];
        

        System.assertEquals('ok', 
                            estado,
                            'Deasignar esta fallando cuando no deberia hacerlo');

        System.assertEquals(null,
                            oppItemDeasignado.Motor__c,
                            'El motor no fue correctamente reasignado');
        System.assertEquals(null,
                            oppItemDeasignado.Chasis__c,
                            'El chasis no fue correctamente reasignado');
        System.assertEquals(null,
                            oppItemDeasignado.Color__c,
                            'El color no fue correctamente reasignado');

        System.assertEquals(null,
                            oppItemDeasignado.IdInformeNegociacion__c,
                            'El informe no fue correctamente deasignado');
    }

    @IsTest
    static void crearInformeTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        OpportunityLineItem oppItem = [SELECT ID
                                      FROM OpportunityLineItem
                                      WHERE Chasis__c = 'Test Chasis 3'
                                      LIMIT 1
                                      ];

        Test.startTest();
        String estado = OpportunityProduct_Edit_Controller.CrearInformeNegociacion(oppItem.Id);
        Test.stopTest();

        oppItem = [SELECT ID, Product2Id, OpportunityId, Motor__c, 
                          Chasis__c, Color__c, IdInformeNegociacion__c
                  FROM OpportunityLineItem
                  WHERE Chasis__c = 'Test Chasis 3'
                  ];

        Informe_de_Negociaci_n__c infNeg = [SELECT Producto__c, Oportunidad__c, Motor__c, 
                                                   Chasis__c, Color_Externo__c
                                            FROM Informe_de_Negociaci_n__c
                                            WHERE ID = :oppItem.IdInformeNegociacion__c
                                            ];
        
        System.assertEquals('ok', 
                            estado,
                            'CrearInformeNegociacion no esta funcionando pero deberia hacerlo');

        System.assertEquals(infNeg.ID, 
                            oppItem.IdInformeNegociacion__c, 
                            'El informe no esta bien asociado al opportunity item');

        System.assertEquals(oppItem.Product2Id, 
                            infNeg.Producto__c, 
                            'El producto no coincide entre el opportuniny item y el informe');

        System.assertEquals(oppItem.OpportunityId, 
                            infNeg.Oportunidad__c, 
                            'La oportunidad no coincide entre el opportuniny item y el informe');

        System.assertEquals(oppItem.Motor__c, 
                            infNeg.Motor__c, 
                            'El motor no coincide entre el opportuniny item y el informe');

        System.assertEquals(oppItem.Chasis__c, 
                            infNeg.Chasis__c, 
                            'El chasis no coincide entre el opportuniny item y el informe');

        System.assertEquals(oppItem.Color__c, 
                            infNeg.Color_Externo__c, 
                            'El color no coincide entre el opportuniny item y el informe');

    }

    @IsTest
    static void crearInformeErrorInformeTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Opportunity opp = [SELECT ID, Pricebook2Id 
                           FROM Opportunity 
                           WHERE Name = 'CUENTA TEST/SUZUKI/TestModelo'
                           LIMIT 1
                           ];
        
        Product2 prod = [SELECT ID
                         FROM Product2
                         WHERE Name = 'Test product'
                         LIMIT 1
                         ];


        PricebookEntry entry = [SELECT ID
                                FROM PricebookEntry
                                WHERE Pricebook2Id =: opp.Pricebook2Id
                                LIMIT 1
                                ];

        OpportunityLineItem oppItem = new  OpportunityLineItem (OpportunityId = opp.ID,
                         Product2Id = prod.ID,
                         PricebookEntryId = entry.Id,
                         UnitPrice = 123.45,
                         Quantity = 1);

        insert oppItem;
        
        Informe_de_negociaci_n__c inf = new Informe_de_negociaci_n__c();
        insert inf;
        
        oppItem.IdInformeNegociacion__c = inf.Id;
        update oppItem;
        
        Test.startTest();
        String estado = OpportunityProduct_Edit_Controller.CrearInformeNegociacion(oppItem.Id);
        Test.stopTest();
     
        System.assertEquals('InformeYaCreado', estado);
    }

    @IsTest
    static void crearInformeErrorChasisTest(){
        Opportunity opp = [SELECT ID 
                           FROM Opportunity 
                           WHERE Name = 'CUENTA TEST/SUZUKI/TestModelo'
                           ];

        OpportunityLineItem oppItem = [SELECT ID, IdInformeNegociacion__c
                                      FROM OpportunityLineItem
                                      WHERE OpportunityId = :opp.ID
                                       		AND IdInformeNegociacion__c = null
                                            AND Motor__c = null
                                      LIMIT 1];

        Test.startTest();
        String estado = OpportunityProduct_Edit_Controller.CrearInformeNegociacion(oppItem.ID);
        Test.stopTest();
        
        System.assertEquals('MotorChasisNoAsignado', 
                            estado,
                            'El motor no fue asignado pero aun asi CrearInformeNegociacion no falla');
    }
    
    @isTest
    public static void obtenerTipoOportunidadTest() {
		List<Opportunity> oppList = 
            [SELECT ID, RecordType.DeveloperName
            FROM Opportunity
            ];
        
        Test.startTest();
        String estado = OpportunityProduct_Edit_Controller.obtenerRecordTypeOpp('' + oppList[0].ID);
        Test.stopTest();
        
        System.assertEquals(oppList[0].RecordType.DeveloperName, 
                            estado,
                            'El tipo de oportunidad no se obtiene correctamente.');
    }
}