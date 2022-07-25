trigger MessagingSessionTrigger on MessagingSession (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<ID> msjeEList = new List<ID>();
            
            for (MessagingSession msj : Trigger.new) {
                if (msj.Origin == 'InboundInitiated') {
                	msjeEList.add(msj.Id);    
                }
            }
            
            if (!msjeEList.isEmpty()) {
            	MessagingSessionHelper.asignarCasos(msjeEList);        
            }
        }
        
        if (Trigger.isUpdate) {
            List<MessagingSession> msjAuxList = new List<MessagingSession>();
            List<ID> msjeEList = new List<ID>();
            
            for (MessagingSession msj : Trigger.new) {
                if (msj.Mensaje_tomado_por_agente__c != Trigger.oldMap.get(msj.Id).Mensaje_tomado_por_agente__c) {
                    if (msj.Mensaje_tomado_por_agente__c && String.isNotBlank(msj.CaseId)) {
                        msjeEList.add(msj.Id); 
                    }
                }
            }
            
            if (!msjeEList.isEmpty()) {
            	MessagingSessionHelper.setearOwnerDeCaso(msjeEList);        
            }
        }
    }
}