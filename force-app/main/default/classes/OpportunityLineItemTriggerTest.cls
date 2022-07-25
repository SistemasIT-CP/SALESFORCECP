@isTest
public class OpportunityLineItemTriggerTest {
	@TestSetup
    public static void crearOportunidades(){
		Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        insert acc;

        Product2 p = new Product2();
        p.Name = 'Test';
        p.Marca_P__c = 'Kia';
        p.ProductCode__c = 'TESTPCode';
        insert p;
        
        Id pricebookId = Test.getStandardPricebookId();

        Opportunity opp = new Opportunity();
        opp.Name = 'TEST';
        opp.AccountId = acc.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opp.Marca__c = 'Kia';
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.Pricebook2Id = pricebookId;
        insert opp;
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        insert pbEntry;
    }
    
    @isTest
    public static void generaCotizacionesTest(){
        List<Product2> pList = 
            [SELECT ID
            FROM Product2
            WHERE Name = 'Test'
            ];
        
        List<Opportunity> oppList =
            [SELECT ID, Name
			FROM Opportunity
            ];
        
        List<PricebookEntry> pbList =
            [SELECT ID, UnitPrice
            FROM PricebookEntry
           	WHERE Product2Id =: pList[0].ID
            ];
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppList[0].ID;
        oli.Product2Id = pList[0].ID;
        oli.UnitPrice = 1.0;
        oli.Quantity = 1;
        
        Test.startTest();
        insert oli;
        Test.stopTest();
        
        List<Quote> qList = 
            [SELECT OpportunityId, Name, ExpirationDate, Producto_Referencia__c, ID
             FROM Quote
            ];
        
        List<QuoteLineItem> qliList = 
            [SELECT Product2Id, Quantity, QuoteId, PricebookEntryId, 
             		UnitPrice
            FROM QuoteLineItem
            WHERE QuoteId =: qList[0].ID
            ];
        
        System.assertEquals(oppList[0].ID, qList[0].OpportunityId, 'La oportunidad de la cotizacion no se genera correctamente');
        System.assertEquals(oppList[0].Name, qList[0].Name, 'El nombre de la cotizacion no se genera correctamente');
        System.assertEquals(Date.today().addDays(7), qList[0].ExpirationDate, 'La fecha de expiracion de la cotizacion no se genera correctamente');
        System.assertEquals(pList[0].ID, qList[0].Producto_Referencia__c, 'El producto de la cotizacion no se genera correctamente');
        
        System.assertEquals(pList[0].ID, qliList[0].Product2Id, 'El producto del producto de cotizacion no se genera correctamente');
        System.assertEquals(1, qliList[0].Quantity, 'La cantidad del producto de cotizacion no se genera correctamente');
        System.assertEquals(qList[0].ID, qliList[0].QuoteId, 'La cotizacion del producto de cotizacion no se genera correctamente');
        System.assertEquals(pbList[0].ID, qliList[0].PricebookEntryId, 'El precio de lista del producto de cotizacion no se genera correctamente');
    }
    
    @isTest
    public static void actualizarPrecioUnitarioTest(){
        List<Product2> pList = 
            [SELECT ID
            FROM Product2
            WHERE Name = 'Test'
            ];
        
        List<Opportunity> oppList =
            [SELECT ID, Name
			FROM Opportunity
            ];

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppList[0].ID;
        oli.Product2Id = pList[0].ID;
        oli.UnitPrice = 1.0;
        oli.Quantity = 1;
        
        insert oli;
        
        oli.UnitPrice = 250.10;
        
        Test.startTest();
		update oli;
        Test.stopTest();
	}
    
    @isTest
    public static void eliminarCotizacionesTest() {
    	List<Product2> pList = 
            [SELECT ID
            FROM Product2
            WHERE Name = 'Test'
            ];
        
        List<Opportunity> oppList =
            [SELECT ID, Name
			FROM Opportunity
            ];
        
        List<PricebookEntry> pbList =
            [SELECT ID, UnitPrice
            FROM PricebookEntry
           	WHERE Product2Id =: pList[0].ID
            ];
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppList[0].ID;
        oli.Product2Id = pList[0].ID;
        oli.UnitPrice = 1.0;
        oli.Quantity = 1;
        insert oli;
        
        List<Quote> qList = 
            [SELECT ID
            FROM Quote
            ];
        
        Test.startTest();
        delete oli;
        Test.stopTest();    
        
        System.assertEquals(1, qList.size(), 'Las cotizaciones no se crearon bien de ppio.');
        System.assertEquals(0, [SELECT ID FROM Quote].size(), 'Las cotizaciones no se eliminaron como debian hacerlo.');
    }

    @isTest
    public static void eliminarOportunidadConInforme() {
        List<Product2> pList = 
            [SELECT ID
            FROM Product2
            WHERE Name = 'Test'
            ];
        
        List<Opportunity> oppList =
            [SELECT ID, Name
			FROM Opportunity
            ];
        
        List<PricebookEntry> pbList =
            [SELECT ID, UnitPrice
            FROM PricebookEntry
           	WHERE Product2Id =: pList[0].ID
            ];
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppList[0].ID;
        oli.Product2Id = pList[0].ID;
        oli.UnitPrice = 1.0;
        oli.Quantity = 1;
        insert oli;

        Informe_de_negociaci_n__c inf = new Informe_de_negociaci_n__c();
        insert inf;

        oli.IdInformeNegociacion__c = inf.ID;
        update oli;

        Test.startTest();
        Database.delete(oli, false);
        Test.stopTest();  
    }

    @isTest
    public static void actualizarChasisTest() {
        List<Product2> pList = 
            [SELECT ID
            FROM Product2
            WHERE Name = 'Test'
            ];
        
        List<Opportunity> oppList =
            [SELECT ID, Name
			FROM Opportunity
            ];
        
        List<PricebookEntry> pbList =
            [SELECT ID, UnitPrice
            FROM PricebookEntry
           	WHERE Product2Id =: pList[0].ID
            ];
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = oppList[0].ID;
        oli.Product2Id = pList[0].ID;
        oli.UnitPrice = 1.0;
        oli.Quantity = 1;
        insert oli;

        oli.Chasis__c = 'ChasisTest';

        Test.startTest();
        Database.SaveResult sr = Database.update(oli, false);
        Test.stopTest();

        System.assertEquals(true, sr.isSuccess());
    }
}