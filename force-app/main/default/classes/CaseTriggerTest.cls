@isTest
public class CaseTriggerTest {
    @TestSetup
    public static void crearGruposYUsuarios(){                
        Group g1 = new Group(Name='Grupo de prueba', type='Queue');
        insert g1;
        
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
        insert q1;
        
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Agente Contact Center'];
        
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
        
        User u2 = new User();
        u2.Alias = 'TestUse2';
        u2.Email = 'test2@email.com';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LastName = 'Testing2'; 
        u2.LanguageLocaleKey = 'en_US';
        u2.LocaleSidKey = 'en_US'; 
        u2.ProfileId = p.Id;
        u2.TimeZoneSidKey = 'America/Los_Angeles';
        u2.UserName = 'test2@email.com.casapellas';
        insert u2;
    }

    @isTest
    public static void dejarOwnerIgualCuandoNoEsUnaCola(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
                
        ID personAccountID = Schema.SObjectType.Account
            .getRecordTypeInfosByDeveloperName()
            .get('PersonAccount')
            .getRecordTypeId();

        Account acc = new Account(FirstName = 'Test',
                                  LastName = 'Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '50588888');
		acc.RecordTypeId = personAccountID;
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        insert acc;
        
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
            ];
        
        User u = [
            SELECT Id
            FROM User
            WHERE Alias = 'TestUser'
        ];
        
        User u2 = [
            SELECT Id
            FROM User
            WHERE Alias = 'TestUse2'
        ];
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'Test Account';
        mse.MessagingChannelId = canalFbPrincipal.ID;
        mse.MessageType = 'Facebook';
        mse.MessagingPlatformKey = 'Test Account';
        insert mse;
        
        MessagingSession ms = new MessagingSession();
        ms.MessagingChannelId = canalFbPrincipal.ID;
        ms.MessagingEndUserId = mse.ID;
        ms.OwnerId = u.Id;
        ms.Status = 'Active';
        insert ms;
        
        Case cs = new Case();
        cs.OwnerId = u2.Id;
        cs.SourceId = ms.Id;
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(cs, false);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess(), 'La creacion del caso falla');
        
        Case csActualizado = [
            SELECT OwnerId
            FROM Case
            WHERE Id =: cs.Id
            LIMIT 1
        ];
        
        MessagingSession sesion = [
            SELECT OwnerId
            FROM MessagingSession
            WHERE Id =: ms.Id
            LIMIT 1
        ];
        
        System.assertNotEquals(sesion.Id, csActualizado.OwnerId, 'El owner de la cola ahora es el de la mensajeria cuando no deberia.');
        System.assertEquals(u2.Id, csActualizado.OwnerId, 'El owner no coincide con el esperado.');
    }
    
    @isTest
    public static void setearOwnerSocialPostCorrectamente(){
        List<Group> colaSocialPost = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
				AND DeveloperName = 'Equipo_Inbound'
        ];
        
        SocialPost sp = new SocialPost();
        sp.Name = 'Test';
        insert sp;
        
        Case cs = new Case();
        cs.SourceId = sp.Id;
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(cs, false);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess(), 'La creacion del caso falla');
        
        Case csActualizado = [
            SELECT OwnerId
            FROM Case
            WHERE Id =: cs.Id
            LIMIT 1
        ];
        
        System.assertEquals(colaSocialPost[0].Id, csActualizado.OwnerId, 'El owner no coincide con el esperado.');
    }
    
    @isTest
    public static void setearOwnerSocialPostCuandoActualiza(){
        List<Group> colaSocialPost = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
				AND DeveloperName = 'Equipo_Inbound'
        ];
        
        SocialPost sp = new SocialPost();
        sp.Name = 'Test';
        insert sp;
        
        Case cs = new Case();
        insert cs;
        
        cs.SourceId = sp.Id;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(cs, false);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion del caso falla');
        
        Case csActualizado = [
            SELECT OwnerId
            FROM Case
            WHERE Id =: cs.Id
            LIMIT 1
        ];
        
        System.assertEquals(colaSocialPost[0].Id, csActualizado.OwnerId, 'El owner no coincide con el esperado.');
    }
    
    @isTest
    public static void corregirEmailCuandoVieneCorrupto(){
        Case cs = new Case();
        cs.SuppliedEmail = 'test@ventascasapellas.com';
        cs.SuppliedName = 'algo que va a eliminado test at gmail.com';
        
        Test.startTest();
        insert cs;
        Test.stopTest();
        
        Case csActualizado = [
			SELECT SuppliedEmail
            FROM Case
            WHERE Id =: cs.Id
        ];
        
        System.assertEquals('test@gmail.com', csActualizado.SuppliedEmail, 'El email adicional no se esta corrigiendo como deberia.');
    }
}