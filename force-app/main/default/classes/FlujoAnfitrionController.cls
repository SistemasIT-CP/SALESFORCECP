public without sharing class FlujoAnfitrionController {
    @AuraEnabled
    public static List<Opportunity> getOpportunities (String searchKey) {
        try {
            searchKey = '%' + searchKey.replace(' ', '%') + '%';

            List<Opportunity> oppList = [
                SELECT Id, Name, Account.CodigoCliente__c,
                    Owner.Name, CreatedDate, Marca_UDC__c, Marca_UDC__r.Name
                FROM Opportunity
                WHERE (Name LIKE :searchKey OR Account.Name LIKE :searchKey 
                    OR Account.CodigoCliente__c LIKE :searchKey)
                    AND RecordType.DeveloperName = 'Principal_Autos'
                    AND StageName != 'Cerrada ganada'  
                    AND StageName != 'Cerrada perdida'
            ];

            return oppList;

        } catch (Exception e) {
            throw new AuraHandledException('No se ha encontrado ninguna oportunidad...');
        }
    }

    @AuraEnabled
    public static Map<String, List<String>> getModelosByMarca() {
        Map<String, List<String>> modelosByMarca = OportunidadCerradaController.getDependentPicklistValues(Lead.Modelo_a_cotizar__c);

        return modelosByMarca;
    }

    @AuraEnabled
    public static Map<String, List<User>> getUserBySucursal() {
        Map<String, List<User>> userBySucursal = new Map<String, List<User>>();

        for (User u : [SELECT Id, Name, Sucursal__c
                        FROM User
                        WHERE Sucursal__c != null
                            AND Profile.Name LIKE 'Vendedor%'
                            AND IsActive = true]) {

            List<User> uList = new List<User>();

            if (userBySucursal.containsKey(u.Sucursal__c)) {
                uList = userBySucursal.get(u.Sucursal__c);
            }

            uList.add(u);

            userBySucursal.put(u.Sucursal__c, uList);
        }

        return userBySucursal;
    }

    @AuraEnabled
    public static String crearTareaDeAnfitrion(Id userId, Id oppId) {
        Task tk = new Task();
        tk.Status = 'Completada';
        tk.Subject = 'Visita';
        tk.ActivityDate = Date.today();
        tk.OwnerId = userId;
        tk.WhatId = oppId;

        Database.SaveResult sr = Database.insert(tk, false);

        if (!sr.isSuccess()) {
            for (Database.Error err : sr.getErrors()) {
                return err.getMessage();
            }
        }

        return 'Ok';
    }

    @AuraEnabled
    public static String createLeadAnfitrion(String firstName,
                                             String middleName,
                                             String lastName,
                                             String email,
                                             String phone,
                                             String identification,
                                             String marca,
                                             String modelo,
                                             String owner
                                             ){
        try {
            ID anfitrionId = Schema.SObjectType.Lead
                    .getRecordTypeInfosByDeveloperName()
                    .get('Anfitrion')
                    .getRecordTypeId();

            List<User> userList = new List<User>();

            if (String.isNotBlank(owner)) {
                userList = [
                    SELECT Id 
                    FROM User 
                    WHERE Name =: owner
                        AND IsActive = true
                ];
            }

            Lead ld = new Lead();
                ld.FirstName = firstName;
                ld.MiddleName = middleName;
                ld.LastName = lastName;
                ld.Email = email;
                ld.Phone = phone;
                ld.Cedula_Nro__c = identification;
                ld.LeadSource = 'Presencial';
                ld.Status = 'Contacto exitoso';
                ld.Marca_a_cotizar__c = marca;
                ld.Modelo_a_cotizar__c = modelo;
                ld.RecordTypeId = anfitrionId;
                ld.OwnerId = !userList.isEmpty()? userList[0].Id : null;

            insert ld;

            return ld.Id; 

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}