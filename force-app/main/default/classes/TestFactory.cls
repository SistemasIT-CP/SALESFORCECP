@isTest
public class TestFactory {
    public static OpportunityLineItem createOppLineItem(Id opportunityId, Id productId) {
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opportunityId;
        oppLineItem.Product2Id = productId;
        oppLineItem.UnitPrice = 1;
        oppLineItem.Quantity = 1;

        return oppLineItem;
    }

    public static Opportunity createOpportunity(Id accountId, Id pricebookId) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'TEST OPP CTE1';
        opportunity.AccountId = accountId;
        opportunity.StageName = 'Contacto Exitoso';
        opportunity.CloseDate = date.today();
        opportunity.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opportunity.Marca__c = 'Toyota';
        opportunity.Forma_de_Pago_Multiple__c = 'Contado';
        opportunity.Sucursal__c = 'Kia El Retiro'; 
        opportunity.Pricebook2Id = pricebookId;
        opportunity.Prueba_de_manejo__c = 'No';
        opportunity.Tour_CP__c = 'No';
        opportunity.Walk_Around__c = 'No';
        opportunity.Origen_de_los_fondos__c = 'Ahorro';
        opportunity.Procedencia_de_los_fondos__c = 'Otros';
        opportunity.Forma_de_Pago_Multiple__c = 'Contado';
        opportunity.Desea_realizar_intercambio__c = 'No';
        opportunity.Tipo_de_relaci_n_econ_mica__c = 'Credito';
        opportunity.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        opportunity.Responsable_del_pago__c = 'Tercero Familiar';

        return opportunity;
    }

    public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId) {
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = productId;
        pricebookEntry.UnitPrice = 100.00;
        pricebookEntry.IsActive = true;

        return pricebookEntry;
    }

    public static Product2 createProduct(String marca) {
        Product2 product = new Product2();
        product.Name = 'Test';
        product.Marca_P__c = marca;
        product.ProductCode__c = 'Test_' + marca;

        return product;
    }

    public static Account createPersonAccount() {
        ID personAccountID = Schema.SObjectType.Account
                            .getRecordTypeInfosByDeveloperName()
                            .get('PersonAccount')
                            .getRecordTypeId();

        Account account = new Account();
        account.FirstName = 'Cuenta';
        account.LastName = 'Test';
        account.CurrencyIsoCode = 'USD';
        account.Secuencia_contactos__c = 0;
        account.Email__c = 'correo@test.com';
        account.Cedula__c = '321321';
        account.Phone = '88888888';
        account.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
            'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        account.CodigoCliente__c = '321321';
        account.RecordTypeId = personAccountID;
        account.Tipo_de_Indentificaci_n__c = 'Otros';
        account.Tipo_de_cliente__c = 'Natural';
        account.Tipo_Cliente__c = 'Ocasional';
        account.Nivel_organizacional__c = 'Asalariado';
        
        return account;
    }

    public static Contact createContact(Id accountId) {
        Contact contacto = new Contact();
        contacto.FirstName = 'Test';
        contacto.MiddleName	= 'Contact';
        contacto.LastName = 'Factory';
        contacto.Email = 'testContact@email.com';
        contacto.Id_Externo__c = '999999_0';
        contacto.Numero_de_documento__c = '999999_' + (Math.random() * 10);
        contacto.Phone = '99999999';
        contacto.AccountId = accountId;
        contacto.Creado_desde_un_Lead__c = true;

        return contacto;
    }

    public static AccountContactRelation createRelationAccountContact(Id accountId, Id contactId) {
        AccountContactRelation accConRelation = new AccountContactRelation();
        accConRelation.AccountId = accountId;
        accConRelation.ContactId = contactId;

        return accConRelation;
    }

    public static User createUser(Id profileId) {
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.Phone = '123456789';
        u.MobilePhone = '123456789';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = profileId;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';

        return u;
    }

    public static Vehiculo__c createVehiculo() {
        Vehiculo__c vehiculo = new Vehiculo__c();

        return vehiculo;
    }

    public static Vehiculo_de_la_Oportunidad__c createVehiculoOportunidad(Id opportunityId, Id vehiculoId){
        Vehiculo_de_la_Oportunidad__c vehiculoOportunidad = new Vehiculo_de_la_Oportunidad__c();
        vehiculoOportunidad.Vehiculo__c = vehiculoId;
        vehiculoOportunidad.Oportunidad__c = opportunityId;

        return vehiculoOportunidad;
    }
}