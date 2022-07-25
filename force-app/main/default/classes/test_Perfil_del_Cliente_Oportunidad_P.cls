@isTest
public class test_Perfil_del_Cliente_Oportunidad_P {
    @TestSetup
    static void createAccount(){
		Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Id RTIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName()
                                                .get('Jurídicos')
                                                .getRecordTypeId();
        Account acc = new Account ();
        acc.RecordTypeId = 	RTIdAcc;											
        acc.Name = 'Industrias ACME S.A de C.V';
		acc.Cedula__c = '123QWERTY';
        acc.Email__c = 'acme@industrias.com';
        acc.Phone = '23437678';
        insert acc;
    }
    
    @isTest
    public static void test_getAccountIdFalse() {

        Account acc = 
            [SELECT ID, Name, RecordType.DeveloperName 
            FROM Account 
            WHERE Name = 'INDUSTRIAS ACME S.A DE C.V'
            LIMIT 1
            ];

        Opportunity opp = new Opportunity();

        opp.AccountId = acc.ID;
        opp.Name = 'Opp Test 1';
        opp.CloseDate = DATE.TODAY() + 7;
        opp.Desea_realizar_intercambio__c = 'NO';
        opp.StageName = 'Contacto Exitoso';
        opp.Sucursal__c = 'Altamira';
        opp.Walk_Around__c = 'No';
        opp.Prueba_de_manejo__c = 'No';
        opp.Tour_CP__c = 'No';

        insert opp;

        Task newTask = new Task(whatID = opp.Id, 
                                Subject='Follow Up Test Task'
                                );
        insert newTask;

        List<String> retorno_informacion = new List<String> ();

        Opportunity opp_casapellas = 
            [SELECT ID, Name, StageName
            FROM Opportunity
            WHERE ID =: opp.ID
            LIMIT 1
            ];

        System.debug('opp: ' + opp_casapellas);

        Test.startTest();
        List<String> retorno = Perfil_del_Cliente_Oportunidad_Principal.getAccountId(opp_casapellas.Id);
        Test.stopTest();
        
        System.debug('retorno: ' + retorno);
        
        System.assertEquals(true, 
                            retorno.contains(String.valueOf(acc.ID)),
                            'El controlador no esta captando correctamente el ID de la cuenta'
                            );

        System.assertEquals(true, 
                            retorno.contains(acc.Name),
                            'El nombre de la cuenta retornado no es el esperado'
                            );

        System.assertEquals(false, 
                            retorno.contains(acc.RecordType.DeveloperName),
                            'El registerType retornado no es el esperado'
                            );
    }
    
    @isTest
    public static void test_getAccountIdTrue() {
        
        Account acc = 
            [SELECT ID, Name, RecordType.DeveloperName 
            FROM Account 
            WHERE Name = 'Industrias ACME S.A de C.V'
            LIMIT 1
            ];

        Opportunity opp = new Opportunity();

        opp.AccountId = acc.ID;
        opp.Name = 'Opp Test 2';
        opp.CloseDate = DATE.TODAY() + 7;
        opp.Desea_realizar_intercambio__c = 'NO';
        opp.StageName = 'Contacto Exitoso';
        opp.Sucursal__c = 'Granada';

        insert opp;

        Opportunity opp_casapellas = 
            [SELECT ID, Name, StageName, Sucursal__c
            FROM Opportunity
            WHERE ID =: opp.ID
            LIMIT 1
            ];

        Test.startTest();
        List<String> retorno = Perfil_del_Cliente_Oportunidad_Principal.getAccountId(opp_casapellas.Id);
        Test.stopTest();

        System.assertEquals(true, 
                            retorno.contains(String.valueOf(acc.ID)),
                            'El controlador no esta captando correctamente el ID de la cuenta'
                            );

        System.assertEquals(true, 
                            retorno.contains(acc.Name),
                            'El nombre de la cuenta retornado no es el esperado'
                            );

        System.assertEquals(false, 
                            retorno.contains(acc.RecordType.DeveloperName),
                            'El registerType retornado no es el esperado'
                            );
    }
    
    @isTest
    public static void obtenerComentariosTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp Test 2';
        opp.CloseDate = DATE.TODAY() + 7;
        opp.Desea_realizar_intercambio__c = 'NO';
        opp.StageName = 'Contacto Exitoso';
        opp.Sucursal__c = 'Granada';
        opp.Comentario_del_PIC__c = 'Un comentario de prueba';

        insert opp;

        Test.startTest();
        String comentario = Perfil_del_Cliente_Oportunidad_Principal.getComentario(opp.Id);
        Test.stopTest();

        System.assertEquals('Un comentario de prueba', 
                            comentario,
                            'El comentario no ha retornado correctamente.'
                            );
    }
    
    @isTest
    public static void setearComentariosTest() {
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp Test 2';
        opp.CloseDate = DATE.TODAY() + 7;
        opp.Desea_realizar_intercambio__c = 'NO';
        opp.StageName = 'Contacto Exitoso';
        opp.Sucursal__c = 'Granada';
        opp.Comentario_del_PIC__c = 'Un comentario de prueba';
        insert opp;

        Test.startTest();
        String respuesta = Perfil_del_Cliente_Oportunidad_Principal.setComentario(opp.Id, 'Un comentario distinto.');
        Test.stopTest();

        List<Opportunity> oppModificada = [
            SELECT Comentario_del_PIC__c
            FROM Opportunity
            WHERE Id =: opp.Id
        ];

        System.assertEquals('Bien', 
                            respuesta,
                            'El seteo del comentario no ha funcionado correctamente.'
                            );

        System.assertEquals('Un comentario distinto.', 
                            oppModificada[0].Comentario_del_PIC__c,
                            'El comentario nuevo no es el esperado.'
                            );
    }
}