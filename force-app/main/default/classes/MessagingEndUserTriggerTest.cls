@isTest
public class MessagingEndUserTriggerTest {
    @TestSetup
    static void crearCuentas() {
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
                                  Phone = '+50550588888');
		acc.RecordTypeId = personAccountID;
        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        insert acc;
        
        Account acc2 = new Account(FirstName = 'Test',
                                  LastName = 'Account',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '123456',
                                  Phone = '+50550588887');
        
		acc2.RecordTypeId = personAccountID;
        acc2.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        insert acc2;
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account cuentaJuridica = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '100003',
                                  Phone = '50512345678');

        cuentaJuridica.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        cuentaJuridica.RecordTypeID = juridicaAccountID;
        insert cuentaJuridica;
    }
    
	@isTest
    public static void validarTelefonoTest() {
        List<MessagingChannel> canalWpp = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            WHERE DeveloperName LIKE 'WhatsApp%'
            LIMIT 1
            ];
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'whatsapp:50588888';
        mse.MessagingChannelId = canalWpp[0].ID;
        mse.MessageType = 'WhatsApp';
        mse.MessagingPlatformKey = 'whatsapp:50588888';

        Test.startTest();
        Database.SaveResult sr = Database.insert(mse, false);
        Test.stopTest();
        
        System.assertEquals(false, sr.isSuccess(), 'La validacion de telefono no está funcionando como deberia');
        System.assertEquals('El telefono debe comenzar con un código de area válido.', sr.getErrors()[0].getMessage(), 'El mensaje de error no es el esperado');
    }
    
    @isTest
    public static void validarCuentaPersonalInsertTest() {  
        List<MessagingChannel> canalWpp = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            WHERE DeveloperName LIKE 'WhatsApp%'
            LIMIT 1
            ];
        
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE RecordType.DeveloperName = 'Juridicos'
            ];
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'whatsapp:+50550588888';
        mse.MessagingChannelId = canalWpp[0].ID;
        mse.MessageType = 'WhatsApp';
        mse.MessagingPlatformKey = 'whatsapp:+50550588888';
        mse.AccountId = accList[0].ID;
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(mse, false);
        Test.stopTest();
        
        System.assertEquals(false, sr.isSuccess(), 'La validacion de cuenta personal en el insert no está funcionando como deberia');
        System.assertEquals('La cuenta asociada solo puede ser personal.', sr.getErrors()[0].getMessage(), 'El mensaje de error no es el esperado');
    }
    
    @isTest
    public static void validarCuentaPersonalUpdateTest() {  
        List<MessagingChannel> canalWpp = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            WHERE DeveloperName LIKE 'WhatsApp%'
            LIMIT 1
            ];
        
        List<Account> cuentaJuridica =
            [SELECT ID
            FROM Account
            WHERE RecordType.DeveloperName = 'Juridicos'
            ];
        
        List<Account> cuentaPersonal =
            [SELECT ID
            FROM Account
            WHERE RecordType.DeveloperName != 'Juridicos'
            LIMIT 1
            ];
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'whatsapp:+50550588888';
        mse.MessagingChannelId = canalWpp[0].ID;
        mse.MessageType = 'WhatsApp';
        mse.MessagingPlatformKey = 'whatsapp:+50550588888';
        mse.AccountId = cuentaPersonal[0].ID;
        insert mse;
        
        mse.AccountId = cuentaJuridica[0].ID;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(mse, false);
        Test.stopTest();
        
        System.assertEquals(false, sr.isSuccess(), 'La validacion de cuenta personal en el update no está funcionando como deberia');
        System.assertEquals('La cuenta asociada solo puede ser personal.', sr.getErrors()[0].getMessage(), 'El mensaje de error no es el esperado');
    }
    
    @isTest
    public static void setearCuentaUnicaTest() {  
        List<MessagingChannel> canalWpp = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            WHERE DeveloperName LIKE 'WhatsApp%'
            LIMIT 1
            ];
        
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Phone = '+50550588888'
            ];
        
        List<Contact> conList =
            [SELECT ID
            FROM Contact
            WHERE AccountId =: accList[0].Id
            ];
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'whatsapp:+50550588888';
        mse.MessagingChannelId = canalWpp[0].ID;
        mse.MessageType = 'WhatsApp';
        mse.MessagingPlatformKey = 'whatsapp:+50550588888';
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(mse, false);
        Test.stopTest();
        
        List<MessagingEndUser> mseList = [
            SELECT AccountId, ContactId
            FROM MessagingEndUser
            WHERE ID =: mse.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion de cuenta y contacto no está funcionando cuando deberia');
        System.assertEquals(accList[0].Id, mseList[0].AccountId, 'La cuenta asociada no es la correcta');
        System.assertEquals(conList[0].Id, mseList[0].ContactId, 'El contacto asociado no es el correcto');
    }
    
    @isTest
    public static void setearCuentaRepetidaTest() {  
        List<MessagingChannel> canalWpp = 
            [SELECT ID, DeveloperName
            FROM MessagingChannel
            WHERE DeveloperName LIKE 'WhatsApp%'
            LIMIT 1
            ];
        
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Phone = '+50550588888'
            ];
        
        List<Account> cuentasActualizables =
            [SELECT ID, Phone
            FROM Account
            WHERE Phone = '+50550588887'
            ];
        
        List<Contact> conList =
            [SELECT ID
            FROM Contact
            WHERE AccountId =: accList[0].Id
            ];
        
        cuentasActualizables[0].Phone = '+50550588888';
        update cuentasActualizables;
        
        MessagingEndUser mse = new MessagingEndUser();
        mse.Name = 'whatsapp:+50550588888';
        mse.MessagingChannelId = canalWpp[0].ID;
        mse.MessageType = 'WhatsApp';
        mse.MessagingPlatformKey = 'whatsapp:+50550588888';
        
        Test.startTest();
        Database.SaveResult sr = Database.insert(mse, false);
        Test.stopTest();
        
        List<MessagingEndUser> mseList = [
            SELECT AccountId, ContactId
            FROM MessagingEndUser
            WHERE ID =: mse.Id
        ];
        
        System.assertEquals(true, sr.isSuccess(), 'La actualizacion de cuenta y contacto no está funcionando cuando deberia');
        System.assertEquals(null, mseList[0].AccountId, 'La cuenta asociada no es la correcta');
        System.assertEquals(null, mseList[0].ContactId, 'El contacto asociado no es el correcto');
    }
}