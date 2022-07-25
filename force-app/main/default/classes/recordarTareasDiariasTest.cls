@isTest
public with sharing class recordarTareasDiariasTest {

    @TestSetup
    public static void crearUsuarios() {
        Profile vendedorProfile = [SELECT Id FROM Profile WHERE Name='Vendedor' LIMIT 1];
        Profile gerenteProfile = [SELECT Id FROM Profile WHERE Name='Gerente/Jefe de Marca' LIMIT 1];
        
        UserRole vendedorRol = [SELECT ID FROM UserRole WHERE Name = 'Vendedor Sucursal Altamira' LIMIT 1];
        UserRole gerenteMarcaRol = [SELECT ID FROM UserRole WHERE Name = 'Gerente Suzuki' LIMIT 1];
        UserRole jefeSucRol = [SELECT ID FROM UserRole WHERE Name = 'Jefe de Sucursal  Altamira' LIMIT 1];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'es';
        u.LocaleSidKey = 'es_MX'; 
        u.ProfileId = vendedorProfile.Id;
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.UserName = 'test@email.com.casapellas';
        u.UserRoleId = vendedorRol.Id;
        u.IsActive = true;
        
        User gerente = new User();
        gerente.Alias = 'Gerente';
        gerente.Email = 'gerente@email.com';
        gerente.EmailEncodingKey = 'UTF-8';
        gerente.LastName = 'Prueba'; 
        gerente.LanguageLocaleKey = 'es';
        gerente.LocaleSidKey = 'es_MX'; 
        gerente.ProfileId = gerenteProfile.Id;
        gerente.TimeZoneSidKey = 'America/Mexico_City';
        gerente.UserName = 'gerente@email.com.casapellas';
        gerente.UserRoleId = gerenteMarcaRol.Id;
        gerente.IsActive = true;
        
        User jefe = new User();
        jefe.Alias = 'jefe';
        jefe.Email = 'jefe@email.com';
        jefe.EmailEncodingKey = 'UTF-8';
        jefe.LastName = 'Prueba'; 
        jefe.LanguageLocaleKey = 'es';
        jefe.LocaleSidKey = 'es_MX'; 
        jefe.ProfileId = gerenteProfile.Id;
        jefe.TimeZoneSidKey = 'America/Mexico_City';
        jefe.UserName = 'jefe@email.com.casapellas';
        jefe.UserRoleId = jefeSucRol.Id;
        jefe.IsActive = true;

        List<User> uList = new List<User>{u, gerente, jefe};
        
        insert uList;
    }

    @IsTest
    public static void testearLlamadoGeneral() {    
        List<User> uList = [
            SELECT ID
            FROM User
            WHERE Alias = 'TestUser'
        ];
        
        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Id linNegocioID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Lineas_de_negocio')
                                    .getRecordTypeId();
        
        Id marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Marcas')
                                    .getRecordTypeId();
        
        Catalogo_UDC__c suzuki = new Catalogo_UDC__c();
        suzuki.RecordTypeId = marcasUDCID;
        suzuki.Name = 'SUZUKI';
        
        Catalogo_UDC__c casaPellas = new Catalogo_UDC__c();
        casaPellas.RecordTypeId = companiaID;
        casaPellas.Name = 'CASA PELLAS, S.A';
        
        Catalogo_UDC__c suzukiLinea = new Catalogo_UDC__c();
        suzukiLinea.Name = 'Autos Suzuki';
        suzukiLinea.RecordTypeId = linNegocioID;
                
        List<Catalogo_UDC__c> udcList = new List<Catalogo_UDC__c>{suzuki, casaPellas, suzukiLinea};
        insert udcList;
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Account acc = new Account();
        acc.Name = 'Cuenta de prueba';
        acc.Cedula__c = '123456';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.today();
        opp.StageName = 'Contacto Exitoso';
        opp.Marca_UDC__c = suzuki.Id;
        opp.AccountId = acc.Id;
        insert opp;
        
        List<Task> tkList = new List<Task>();
        List<Event> evList = new List<Event>();

        for (Integer i = 0; i < 5; i++) {
            Task tk = new Task();
            tk.Subject = 'Tarea numero ' + i;
            if (math.mod(i, 2) == 0) {
            	tk.ActivityDate = Date.today();    
            } else {
                tk.ActivityDate = Date.today().addDays(-1);
            }
            tk.Status = 'Pending';
            tk.OwnerId = uList[0].ID;
            tk.WhatId = opp.ID;

            tkList.add(tk);
        }

        insert tkList;
        
        for (Integer i = 0; i < 5; i++) {
            Event e = new Event();
			e.Subject = 'Tarea numero ' + i;
            e.OwnerId = uList[0].ID;
            e.WhatId = opp.ID;
            e.StartDateTime = DateTime.now().addMinutes(1);
            e.DurationInMinutes = 60;
            
			evList.add(e);            
        }
        
        insert evList;
        
        SchedulableContext sc = null;
        CallTareasDiarias x = new CallTareasDiarias();

        Test.startTest();
        x.execute(sc);
        Test.stopTest();
        
    }
}