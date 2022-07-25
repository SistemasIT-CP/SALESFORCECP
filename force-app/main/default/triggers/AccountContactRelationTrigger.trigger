trigger AccountContactRelationTrigger on AccountContactRelation (before insert, after insert, before delete, after update) {

    List<AccountContactRelation> acrList = new List<AccountContactRelation>();

    if (Trigger.isBefore && Trigger.isInsert) {
        for (AccountContactRelation acr : Trigger.new) {
            if (String.isBlank(acr.IdExterno__c)) {
                acrList.add(acr);
            }
        }

        if (!acrList.isEmpty()) {
            AccountContactRelationHelper.setExternalID(acrList);
            AccountContactRelationHelper.cargoCompleto(acrList);
        }
        
    } else if (Trigger.isAfter && Trigger.isInsert) {
        if(!System.isFuture()) {
            for (AccountContactRelation acr : Trigger.new) {
                if (String.isNotBlank(acr.IdExterno__c)) {
                    acrList.add(acr);
                }
            }

            if (!acrList.isEmpty()){
                AccountContactRelationHelper.sendRelationToWS(acrList);
            }
        }
    } else if (Trigger.isBefore && Trigger.isDelete) {
        if(!System.isFuture()) {
            for (AccountContactRelation acr : Trigger.old) {
                if (String.isNotBlank(acr.IdExterno__c)) {
                    acrList.add(acr);
                }
            }

            if (!acrList.isEmpty()) {
                AccountContactRelationHelper.deleteRelationToWS(acrList);
            }

            AccountContactRelationHelper.validacionObjetosRelacionados(Trigger.old);
        }
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        for (AccountContactRelation acr : Trigger.new) {
            if (acr.Cargo__c != Trigger.oldMap.get(acr.ID).Cargo__c) {
                acrList.add(acr);
            }
        }
        
        if (!acrList.isEmpty()) {
            AccountContactRelationHelper.actualizarCargo(acrList);
        }
    }
}