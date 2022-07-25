@isTest
public class TestOpportunityLineItem {
   
    @istest
    public static void pruebaOLI(){
    
        Date closeDt = Date.Today();
        Id pricebookId = Test.getStandardPricebookId();
        
        Account a2 = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '32132881');

        a2.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        a2.CodigoCliente__c = '321321';
        insert a2;

		opportunity opp = new opportunity(Name='testing DIE 4/6/2015' ,  AccountId= a2.Id,StageName = 'Contacto Exitoso', CloseDate = closeDt, Pricebook2Id =pricebookId, Sucursal__c='Altamira');
		insert opp;
        
    	

        //Create your product
        Product2 prod = new Product2(
             Name = 'Product X',
             ProductCode = 'Pro-X',
             Marca_P__c = 'Kia',
             ProductCode__c = 'sku_producto',
             isActive = true
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
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
             OpportunityId = opp.Id,
             Quantity = 1,
             PricebookEntryId = pbEntry.Id,
             TotalPrice = 1 * pbEntry.UnitPrice
        );
        insert oli;
        
    }
}