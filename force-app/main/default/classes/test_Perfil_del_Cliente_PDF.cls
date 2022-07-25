@istest
public class test_Perfil_del_Cliente_PDF {
    
    @istest
    public static void testPDF (){
        
        ID marcas = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Marcas')
                                .getRecordTypeId();
        
        ID modelos = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Modelo')
                                .getRecordTypeId();
        
        ID generos = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Genero')
                                .getRecordTypeId();
        
        List<Catalogo_UDC__c> listCatalogoToInsert = new List<Catalogo_UDC__c>();
        
        Catalogo_UDC__c marca = new Catalogo_UDC__c();
        marca.RecordTypeId = marcas;
        marca.Name = 'KIA';
        
        listCatalogoToInsert.add(marca);
        
        Catalogo_UDC__c modelo = new Catalogo_UDC__c();
        modelo.RecordTypeId = modelos;
        modelo.Name = 'TestModelo';
        
        listCatalogoToInsert.add(modelo);
        
        Catalogo_UDC__c genero = new Catalogo_UDC__c();
        genero.RecordTypeId = generos;
        genero.Name = 'Indefinido';
        
        listCatalogoToInsert.add(genero);
        
        insert listCatalogoToInsert;
       
        Product2 prod = new Product2 (Name = 'Test product',
                                    IsActive = true,
                                    Marca_P__c = 'Kia',
                                    CurrencyIsoCode = 'USD',
                                    ProductCode__c = '316220');

        ID RTIdAcc = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();
        
        Account acc = new Account ();
        acc.RecordTypeId = 	RTIdAcc;											
        acc.LastName = 'De la Vega';
        acc.Genero_UDC__pc = genero.ID;
        acc.FirstName = 'Enrique';
		acc.Cedula__c = '123QWERT';
        acc.Email__c = 'acme@industrias.com';
        acc.Phone = '23437678';
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
                                           Sucursal__c = 'Altamira',
                                           Pricebook2Id =pricebook.id );

        insert opp;
        
        
        test.startTest();
       
        String url = Page.Perfil_del_Cliente_PDF.getUrl() + '?id=' + acc.ID + '&idOpp=' + opp.ID;
        Test.setCurrentPage(new PageReference(url));
        
        System.debug(url);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        Perfil_del_Cliente_PDF_Controller pcc = new Perfil_del_Cliente_PDF_Controller(sc);
        
        Test.setCurrentPage(new PageReference(url));
        test.stopTest();
    }

}