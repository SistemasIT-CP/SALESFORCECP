@isTest
public class Test_PDFCotizacion {

    @TestSetup
    public static void makeData(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Date closeDt = Date.Today();
        Id pricebookId = Test.getStandardPricebookId();
        
        ID juridicaAccountID = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('Juridicos')
            .getRecordTypeId();
        
        ID motosID = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Principal_Motos')
            .getRecordTypeId();
        
        Id marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
            .getRecordTypeInfosByDeveloperName()
            .get('Marcas')
            .getRecordTypeId();
        
        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c>();
        
        Catalogo_UDC__c kia = new Catalogo_UDC__c();
        kia.Name = 'KIA';
        kia.productcode__c = 'KIA';
        kia.RecordTypeId = marcasUDCID;
        
        Catalogo_UDC__c genesis = new Catalogo_UDC__c();
        genesis.Name = 'GENESIS';
        genesis.productcode__c = 'GENESIS';
        genesis.RecordTypeId = marcasUDCID;
        
        catList.add(kia);
        catList.add(genesis);
        
        insert catList;
        
        List<Account> accList = new List<Account>();
        
        Account a2 = new Account(Name = 'Cuenta Motos',
                                 CurrencyIsoCode = 'USD',
                                 Secuencia_contactos__c = 2,
                                 Email__c = 'correo@test.com',
                                 Cedula__c = '321321',
                                 Phone = '+50558888888');
        
        a2.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        a2.RecordTypeID = juridicaAccountID;
        a2.CodigoCliente__c = '321321';
        accList.add(a2);
        
        Account a = new Account(Name = 'Cuenta Autos',
                                 CurrencyIsoCode = 'USD',
                                 Secuencia_contactos__c = 2,
                                 Email__c = 'correo@test.com',
                                 Cedula__c = '123456',
                                 Phone = '+50558888888');
        
        a.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        a.RecordTypeID = juridicaAccountID;
        a.CodigoCliente__c = '123456';
        accList.add(a);
        
        insert accList;
        
        List<Opportunity> oppList = new List<Opportunity>();
        
        Opportunity opp = new opportunity(
            Name = 'testing DIE 4/6/2015',  
            AccountId = a2.Id,
            StageName = 'Contacto Exitoso', 
            CloseDate = closeDt, 
            Pricebook2Id = pricebookId, 
            Sucursal__c = 'Altamira',
            Marca_UDC__c = kia.Id
        );
        
        oppList.add(opp);
        
        Opportunity oppMotos = new opportunity(
            Name = 'testing DIE 4/6/2015',  
            AccountId = a.Id,
            StageName = 'Contacto Exitoso', 
            CloseDate = closeDt, 
            Pricebook2Id = pricebookId,
            RecordTypeId = motosID,
            Sucursal__c = 'Altamira',
            Marca_UDC__c = genesis.Id
        );
        
        oppList.add(oppMotos);
        
        insert oppList;
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Codigovehiculo__c = 'Pro-X',
            Marca_P__c = 'Kia',
            ProductCode__c = 'sku_producto',
            Especificaci_n_1__c = 'Especificacion 1',
            Especificaci_n_2__c = 'Especificacion 2',
            Especificaci_n_3__c = 'Especificacion 3',
            Especificaci_n_4__c = 'Especificacion 4',
            isActive = true,
            CurrencyIsoCode = 'USD'
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 1,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 1 * pbEntry.UnitPrice           
        );
        insert oli;
    }   
    
    @IsTest
    public static void cotizacionAutosTest(){
        List<Opportunity> oppList = 
            [SELECT Id
            FROM Opportunity 
            WHERE Name LIKE '%AUTOS%'
            ];

        List<Product2> prodList = 
            [SELECT Id
            FROM Product2 
            LIMIT 1
            ];

        List<PricebookEntry> pbEntry = 
            [SELECT Id
            FROM PricebookEntry
            WHERE Product2Id =: prodList[0].Id 
            ];

        Quote q = new Quote();
        q.OpportunityId = oppList[0].Id;
        q.Name = 'AUTOS QUOTE';
        q.ExpirationDate = Date.today();
        insert q;

        QuoteLineItem qli = new QuoteLineItem();
        qli.Product2Id = prodList[0].Id;
        qli.Quantity = 1;
        qli.QuoteId = q.Id;
        qli.PricebookEntryId = pbEntry[0].Id;
        qli.UnitPrice = 12339;
        qli.Descuento__c = 0;
        qli.IVA__c = 0;
        qli.Total_precio_especial__c = 200000;
        qli.Precio_de_lista_unitario__c = 10000;
        insert qli;

        Test.startTest();
        PageReference pageRef = Page.PDF_Cotizacion;
        pageRef.getParameters().put('id', '' + q.Id);
        Test.setCurrentPage(pageRef); 

        CtrlPDF_Cotizacion pdf = new CtrlPDF_Cotizacion();
        Test.stopTest();
    }
    
    @IsTest
    public static void cotizacionMotosTest(){
        List<Opportunity> oppList = 
            [SELECT Id
            FROM Opportunity 
            WHERE Name LIKE '%MOTOS%'
            ];

        List<Product2> prodList = 
            [SELECT Id
            FROM Product2 
            LIMIT 1
            ];

        List<PricebookEntry> pbEntry = 
            [SELECT Id
            FROM PricebookEntry
            WHERE Product2Id =: prodList[0].Id 
            ];

        Quote qMotos = new Quote();
        qMotos.OpportunityId = oppList[0].Id;
        qMotos.Name = 'MOTOS QUOTE';
        qMotos.ExpirationDate = Date.today();
        insert qMotos;
                
        QuoteLineItem qliMotos = new QuoteLineItem();
        qliMotos.Product2Id = prodList[0].Id;
        qliMotos.Quantity = 1;
        qliMotos.QuoteId = qMotos.Id;
        qliMotos.PricebookEntryId = pbEntry[0].Id;
        qliMotos.UnitPrice = 2000;
        qliMotos.Descuento__c = 0;
        qliMotos.IVA__c = 0;
        qliMotos.Total_precio_especial__c = 200000;
        qliMotos.Precio_de_lista_unitario__c = 10000;
        insert qliMotos;
        
        Test.startTest();
        PageReference pageRef = Page.PDF_Cotizacion;
        pageRef.getParameters().put('id', '' + qMotos.Id);
        Test.setCurrentPage(pageRef); 
        
        CtrlPDF_Cotizacion pdf = new CtrlPDF_Cotizacion();
        Test.stopTest();
    }
    
    @IsTest
    public static void agregarComaTest(){
        List<Opportunity> oppList = 
            [SELECT Id
            FROM Opportunity 
            WHERE Name LIKE '%MOTOS%'
            ];

        List<Product2> prodList = 
            [SELECT Id
            FROM Product2 
            LIMIT 1
            ];

        List<PricebookEntry> pbEntry = 
            [SELECT Id
            FROM PricebookEntry
            WHERE Product2Id =: prodList[0].Id 
            ];

        Quote qMotos = new Quote();
        qMotos.OpportunityId = oppList[0].Id;
        qMotos.Name = 'MOTOS QUOTE';
        qMotos.ExpirationDate = Date.today();
        insert qMotos;
                
        QuoteLineItem qliMotos = new QuoteLineItem();
        qliMotos.Product2Id = prodList[0].Id;
        qliMotos.Quantity = 1;
        qliMotos.QuoteId = qMotos.Id;
        qliMotos.PricebookEntryId = pbEntry[0].Id;
        qliMotos.UnitPrice = 2000;
        qliMotos.Descuento__c = 0;
        qliMotos.IVA__c = 0;
        qliMotos.Total_precio_especial__c = 200000;
        qliMotos.Precio_de_lista_unitario__c = 10000;
        insert qliMotos;

        Test.startTest();
        PageReference pageRef = Page.PDF_Cotizacion;
        pageRef.getParameters().put('id', '' + qMotos.Id);

        Test.setCurrentPage(pageRef); 
        CtrlPDF_Cotizacion pdf = new CtrlPDF_Cotizacion();
        String valor = pdf.agregarComa('123456.20');
        Test.stopTest();
        
        System.assertEquals('123,456.20', valor);
    }
}