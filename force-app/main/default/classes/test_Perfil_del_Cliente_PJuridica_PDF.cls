@istest
public class test_Perfil_del_Cliente_PJuridica_PDF {

    
    @istest
    public static void testPDF (){
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();
        
        ID marcas = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Marcas')
                                .getRecordTypeId();
        
        ID modelos = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Modelo')
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
        
        insert listCatalogoToInsert;
       
        Product2 prod = new Product2 (Name = 'Test product',
                                    IsActive = true,
                                    Marca_P__c = 'Kia',
                                    CurrencyIsoCode = 'USD',
                                    ProductCode__c = '316220');

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
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
                                           Sucursal__c = 'Altamira',
                                           Pricebook2Id =pricebook.id );

        insert opp;
        
        test.startTest();       
        String url = Page.Perfil_del_Cliente_PJuridica_PDF.getUrl() + '?id=' + acc.ID + '&idOpp=' + opp.ID;
        Test.setCurrentPage(new PageReference(url));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        PC_PJuridica_PDF_Controller pcc = new PC_PJuridica_PDF_Controller (sc);
        
        Test.setCurrentPage(new PageReference(url));
        test.stopTest();
    }


}