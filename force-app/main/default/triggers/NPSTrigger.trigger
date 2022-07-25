trigger NPSTrigger on NPS_Casa_Pellas__c (before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            List<NPS_Casa_Pellas__c> oppNPSList = new List<NPS_Casa_Pellas__c>();
            List<NPS_Casa_Pellas__c> caseNPSList = new List<NPS_Casa_Pellas__c>();

            for (NPS_Casa_Pellas__c nps : Trigger.new) {
                if (String.isNotBlank(nps.Numero_de_caso__c)) {
                    caseNPSList.add(nps);
                } else if (String.isNotBlank(nps.Oportunidad__c)) {
                    oppNPSList.add(nps);
                }
            }

            if (!caseNPSList.isEmpty()) {
                NPSHelper.asociarCuentasCase(caseNPSList, 'Caso');
            }

            if (!oppNPSList.isEmpty()) {
                NPSHelper.asociarCuentasCase(oppNPSList, 'Oportunidad');
            }
        }
    }
}