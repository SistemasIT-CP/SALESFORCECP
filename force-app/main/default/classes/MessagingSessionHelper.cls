public without sharing class MessagingSessionHelper {
    public static void asignarCasos (List<Id> msjeIdLista) {
        ID casosATipificar = Schema.SObjectType.Case
                .getRecordTypeInfosByDeveloperName()
                .get('Casos_a_tipificar')
                .getRecordTypeId();
        
        List<ID> msjeEList = new List<ID>();
        List<ID> msjIdList = new List<ID>();
        Map<String, ID> casosPorUsuarioMsj = new Map<String, ID>();

       	Map<ID, Case> casosParaMapear = new Map<ID, Case>();
        List<Case> casosParaInsertar = new List<Case>();

        List<MessagingSession> msjeLista = [
            SELECT Id, MessagingEndUserID, caseId, MessagingChannelId, Owner.Name, ChannelType
            FROM MessagingSession
            WHERE Id IN :msjeIdLista
		];
        
        for (MessagingSession msj : msjeLista) {
            msjeEList.add(msj.MessagingEndUserID);
        }

        List<Horario_de_oficina__mdt> horariosList = 
            [SELECT Id_de_horario_de_oficina__c
            FROM Horario_de_oficina__mdt
            ];
        
        Map<Id,MessagingEndUser> endUserMap = new Map<Id,MessagingEndUser>([
            SELECT Id,AccountId,ContactId
            FROM MessagingEndUser
            WHERE Id IN :msjeEList
        ]);
        
        for (MessagingSession msj : [SELECT ID, CaseID, MessagingEndUserID, MessagingChannelId
                                     FROM MessagingSession 
                                     WHERE MessagingEndUserID IN :msjeEList 
                                     		AND CaseId != null
                                     		AND Case.IsClosed = false
                                     ORDER BY CreatedDate DESC]) {
			String key = msj.MessagingEndUserID + '_' + msj.MessagingChannelId;
                                         
            if (!casosPorUsuarioMsj.containsKey(key)){
               casosPorUsuarioMsj.put(key, msj.CaseID);
            }
        }
        
        Map<Id, Case> casosExistentes = new Map<Id, Case>([
            SELECT Id, SourceId
            FROM Case
            WHERE Id IN :casosPorUsuarioMsj.values()
        ]);
        
        List<Case> casosParaActualizar = new List<Case>();

        for (MessagingSession msj : msjeLista) {
            String key = msj.MessagingEndUserID + '_' + msj.MessagingChannelId;
            
            if (casosPorUsuarioMsj.containsKey(key)) {
                Case cs = casosExistentes.get(casosPorUsuarioMsj.get(key));
                cs.SourceId = msj.Id;
                casosParaMapear.put(msj.Id, cs);
                casosParaActualizar.add(cs);
            } else {             
                MessagingEndUser msjE = endUserMap.get(msj.MessagingEndUserId);
                Case c = new Case();
                c.CurrencyIsoCode = 'USD';
                c.Priority = 'Alta';
                c.SourceId = msj.ID;
                c.Status = 'Nuevo';
                c.AccountId = msjE.AccountId;
                c.ContactId = msjE.ContactId;
                c.Origin = msj.ChannelType == 'Facebook'? 'Facebook Messenger' : 'Whatsapp';
                c.RecordTypeID = casosATipificar;
                c.BusinessHoursId = horariosList[0].Id_de_horario_de_oficina__c;
                
                casosParaInsertar.add(c);
                casosParaMapear.put(c.SourceId, c);
            }
        }

        if (!casosParaInsertar.isEmpty()) {
            insert casosParaInsertar;
        }
        
        if (!casosParaActualizar.isEmpty()) {
            update casosParaActualizar;
        }
        
        for (MessagingSession msj : msjeLista) {
            if (String.isBlank(msj.CaseId) && casosParaMapear.containsKey(msj.ID)) {
                msj.CaseId = casosParaMapear.get(msj.ID).ID;    
            }
        }
        
        if (!msjeLista.isEmpty()) {
            update msjeLista;
        }
    }
    
    public static void setearOwnerDeCaso(List<Id> msjeIdLista){
        List<Id> casosId = new List<Id>();
        Map<Id, Id> ownerPorCasoId = new Map<Id, Id>();
        
        for (MessagingSession sesion : [SELECT CaseId, OwnerId 
                                        FROM MessagingSession 
                                        WHERE CaseId != null 
                                        	AND Id IN :msjeIdLista]){
            casosId.add(sesion.CaseId);
            ownerPorCasoId.put(sesion.CaseId, sesion.OwnerId);
        }
        
        List<Case> casosList = [
            SELECT OwnerId, Owner.Profile.Name
            FROM Case
            WHERE Id IN :casosId
            	AND Owner.Profile.Name != 'Agente Contact Center'
        ];

        
        for (Case cs : casosList) {
            System.debug(cs.Owner.Profile.Name);
            cs.OwnerId = ownerPorCasoId.get(cs.Id);   
        }
        
        if (!casosList.isEmpty()) {
            update casosList;
        }
    }
}