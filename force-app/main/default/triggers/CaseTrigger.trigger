trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            List<Case> casosMailIncorrecto = new List<Case>();

            for (Case cs : Trigger.new) {
                if(String.isNotBlank(cs.SuppliedEmail)) {
                    if (cs.SuppliedEmail.contains('@ventascasapellas.com')) {
                    	casosMailIncorrecto.add(cs);
                	}
                }
            }

            if (!casosMailIncorrecto.isEmpty()) {
                CaseHelper.modificarEmail(casosMailIncorrecto);
            }
        }
    }
    
    if (Trigger.isAfter) {
        List<Id> casosDeSocialPost = new List<Id>();
        
        if (Trigger.isInsert) {
            for (Case cs : Trigger.new) {
                if (String.isNotBlank(cs.SourceId) && String.valueOf(cs.SourceId).startsWith('0ST')) {                 
                    casosDeSocialPost.add(cs.Id);
                }
            }
        }
        
        if (Trigger.isUpdate) {
            for (Case cs : Trigger.new) { 
                if (cs.SourceId != Trigger.oldMap.get(cs.Id).SourceId) {
                    if (String.isNotBlank(cs.SourceId) && String.valueOf(cs.SourceId).startsWith('0ST')) {
                    	casosDeSocialPost.add(cs.Id);
                	}
                }
            }
        }
        
        if (!casosDeSocialPost.isEmpty()) {
            CaseHelper.setearOwnerParaSocialPost(casosDeSocialPost);
        }
    }
}