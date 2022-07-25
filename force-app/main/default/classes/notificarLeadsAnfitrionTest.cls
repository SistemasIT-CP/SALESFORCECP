@IsTest
public class notificarLeadsAnfitrionTest {
    @IsTest
    public static void ejecutaWSProductosDia(){
        ID anfitrionId = Schema.SObjectType.Lead
                            .getRecordTypeInfosByDeveloperName()
                            .get('Anfitrion')
                            .getRecordTypeId();

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';
        
        insert u;
        
        Lead ld = new Lead();
        ld.FirstName = 'FirstName';
        ld.MiddleName = 'MiddleName';
        ld.LastName = 'LastName';
        ld.Email = 'email@email.com';
        ld.Phone = '+505512345678';
        ld.Cedula_Nro__c = 'cedula123';
        ld.LeadSource = 'Presencial';
        ld.Status = 'Contacto exitoso';
        ld.Marca_a_cotizar__c = 'Toyota';
        ld.Modelo_a_cotizar__c = 'Corolla';
        ld.RecordTypeId = anfitrionId;
        ld.OwnerId = u.Id;
        insert ld;
        
        Test.setCreatedDate(ld.Id, Date.today().addDays(-1));

        SchedulableContext sc = null;
        notificarLeadsAnfitrion x = new notificarLeadsAnfitrion();

        Test.startTest();
        x.execute(sc);
        Test.stopTest();
    }
}