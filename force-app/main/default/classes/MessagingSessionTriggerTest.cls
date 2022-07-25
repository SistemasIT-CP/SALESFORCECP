@isTest
public class MessagingSessionTriggerTest {
    @TestSetup
    static void crearGruposYUsuarios() {
        Group g1 = new Group(Name='Grupo de prueba', type='Queue');
        insert g1;
        
        List<QueuesObject> qList = new List<QueuesObject>();
        
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
        QueuesObject q2 = new QueueSObject(QueueID = g1.id, SobjectType = 'MessagingSession');
        
        qList.add(q1);
        qList.add(q2);
        
        insert qList;
        
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
    public static void asociarConCasoDeSesionExistente() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
            ];
        
        String idCanalPrincipal =  String.valueOf(canalFbPrincipal.Id);
        
        MessagingChannel canalFbSecundario = 
            [SELECT Id, DeveloperName
            FROM MessagingChannel
            WHERE Id !=: idCanalPrincipal
            LIMIT 1
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
        ms.Status = 'Waiting';
        ms.Origin = 'InboundInitiated';
        insert ms;
        
        MessagingSession ms2 = new MessagingSession();
        ms2.MessagingChannelId = canalFbSecundario.ID;
        ms2.MessagingEndUserId = mse.ID;
        ms2.Status = 'Waiting';
        ms2.Origin = 'InboundInitiated';

        Test.startTest();
        Database.SaveResult sr = Database.insert(ms2, false);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess(), 'La creación de la sesión está fallando');
        
        MessagingSession primerMensaje = [
            SELECT CaseId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];

        System.assertEquals(true, String.isNotBlank(primerMensaje.CaseId), 'El primer mensaje no tiene caso directamente');
        
        MessagingSession segundoMensaje = [
            SELECT CaseId, MessagingEndUser.AccountId, MessagingEndUser.ContactId, OwnerId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];
        
        System.assertEquals(true, String.isNotBlank(segundoMensaje.CaseId), 'El segundo mensaje no tiene caso directamente');
        System.assertEquals(true, primerMensaje.CaseId == segundoMensaje.CaseId, 'El case no coincide en ambos mensajes');
        
        Case cs = [
            SELECT AccountId, ContactId, OwnerId
            FROM Case
            WHERE Id =: segundoMensaje.CaseId
        ];
        
        System.assertEquals(segundoMensaje.MessagingEndUser.AccountId, cs.AccountId, 'El account no es el esperado en el caso');
        System.assertEquals(segundoMensaje.MessagingEndUser.ContactId, cs.ContactId, 'El contact no es el esperado en el caso');
        System.assertEquals(segundoMensaje.OwnerId, cs.OwnerId, 'El owner no es el esperado en el caso');
    }
    
    @isTest
    public static void asociarConCasoNuevo() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
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
        ms.Status = 'Active';
        ms.Origin = 'InboundInitiated';

        Test.startTest();
        Database.SaveResult sr = Database.insert(ms, false);
        Test.stopTest();
        
        Map<Id, Group> colasPorId = new Map<Id, Group>([
            SELECT Id, Name
			FROM Group 
			WHERE Type = 'Queue'
        ]);
        
        System.assertEquals(true, sr.isSuccess(), 'La creación de la sesión está fallando');
        
        MessagingSession primerMensaje = [
            SELECT CaseId, MessagingEndUser.AccountId, MessagingEndUser.ContactId, OwnerId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];

        System.assertEquals(true, String.isNotBlank(primerMensaje.CaseId), 'El primer mensaje no tiene caso directamente');
        
        Case cs = [
            SELECT AccountId, ContactId, OwnerId
            FROM Case
            WHERE Id =: primerMensaje.CaseId
        ];
        
        System.assertEquals(primerMensaje.MessagingEndUser.AccountId, cs.AccountId, 'El account no es el esperado en el caso');
        System.assertEquals(primerMensaje.MessagingEndUser.ContactId, cs.ContactId, 'El contact no es el esperado en el caso');
        System.assertEquals(primerMensaje.OwnerId, cs.OwnerId, 'El owner no es el esperado en el caso');
    }
        
    @isTest
    public static void noAsociarCasoNuevoSiEsMensajeSaliente() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
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
        ms.Status = 'Active';
        ms.Origin = 'TriggeredOutbound';

        Test.startTest();
        Database.SaveResult sr = Database.insert(ms, false);
        Test.stopTest();
        System.assertEquals(true, sr.isSuccess(), 'La creación de la sesión está fallando');
        
        MessagingSession primerMensaje = [
            SELECT CaseId, MessagingEndUser.AccountId, MessagingEndUser.ContactId, OwnerId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];

        System.assertEquals(null, primerMensaje.CaseId, 'El mensaje saliente tiene un caso cuando no deberia');
    }
    
    @isTest
    public static void cambiarOwnerDeColaAUsuarioCaso() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
            ];
        
        Group g = [
            SELECT Id
            FROM Group 
            WHERE Type = 'Queue'
            	AND Name = 'Grupo de prueba'
        ];
        
        User u = [
            SELECT Id, Alias
            FROM User
            WHERE Alias = 'TestUser'
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
        ms.OwnerId = g.Id;
        ms.Status = 'Waiting';
        ms.Origin = 'InboundInitiated';
        insert ms;
        
        MessagingSession mensajeInsertado = [
            SELECT CaseId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];

        ms.OwnerId = u.Id;
        ms.Mensaje_tomado_por_agente__c = true;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(ms, false);
        Test.stopTest();

        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        
        Case csActualizado = [
            SELECT Id, OwnerId, Owner.Alias
            FROM Case
            WHERE Id =: mensajeInsertado.CaseId
        ];
        
        System.assertEquals(u.Id, csActualizado.OwnerId, 'El owner del caso no se esta actualizando correctamente');
    }
    
    @isTest
    public static void cambiarOwnerDeUsuarioAColaCaso() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
            ];
        
        Group g = [
            SELECT Id
            FROM Group 
            WHERE Type = 'Queue'
            	AND Name = 'Grupo de prueba'
        ];
        
        User u = [
            SELECT Id
            FROM User
            WHERE Alias = 'TestUser'
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
        ms.OwnerId = g.Id;
        ms.Status = 'Waiting';
        ms.Origin = 'InboundInitiated';
        insert ms;
        
        MessagingSession mensajeActualizado = [
            SELECT CaseId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];
        
        ms.OwnerId = u.Id;
        ms.Mensaje_tomado_por_agente__c = true;
        update ms;
                
        Case cs = [
            SELECT Id, OwnerId
            FROM Case
            WHERE Id =: mensajeActualizado.CaseId
        ];
        
        System.debug([SELECT OwnerId FROM Case WHERE Id =: mensajeActualizado.CaseId]);
        
        ms.Mensaje_tomado_por_agente__c = false;
        update ms;
        
        ms.OwnerId = g.Id;
        ms.Mensaje_tomado_por_agente__c = true;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(ms, false);
        Test.stopTest();
        
        System.debug([SELECT OwnerId FROM Case WHERE Id =: mensajeActualizado.CaseId]);
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        
        Case csActualizado = [
            SELECT Id, OwnerId
            FROM Case
            WHERE Id =: cs.Id
        ];
        
        System.assertEquals(u.Id, csActualizado.OwnerId, 'El owner del caso no se esta actualizando correctamente');
    }
        
    @isTest
    public static void cambiarOwnerDeUsuarioAUsuarioCaso() {
        MessagingChannel canalFbPrincipal = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            LIMIT 1
            ];
        
        Group g = [
            SELECT Id
            FROM Group 
            WHERE Type = 'Queue'
            	AND Name = 'Grupo de prueba'
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
        ms.OwnerId = g.Id;
        ms.Status = 'Waiting';
        ms.Origin = 'InboundInitiated';
        insert ms;
        
        MessagingSession mensajeActualizado = [
            SELECT CaseId
            FROM MessagingSession
            WHERE Id =: ms.Id
        ];
        
        ms.OwnerId = u.Id;
        ms.Mensaje_tomado_por_agente__c = true;
        update ms;
        
        Case cs = [
            SELECT Id, OwnerId
            FROM Case
            WHERE Id =: mensajeActualizado.CaseId
        ];

		ms.Mensaje_tomado_por_agente__c = false;
        update ms;
        
        ms.OwnerId = u2.Id;
        ms.Mensaje_tomado_por_agente__c = true;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(ms, false);
        Test.stopTest();
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion esta fallando cuando no deberia');
        
        Case csActualizado = [
            SELECT Id, OwnerId
            FROM Case
            WHERE Id =: cs.Id
        ];
        
        System.assertEquals(u.Id, csActualizado.OwnerId, 'El owner del caso no se esta actualizando correctamente');
    }
}