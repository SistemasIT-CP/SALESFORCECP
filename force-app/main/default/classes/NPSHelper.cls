public with sharing class NPSHelper {
    public static void asociarCuentasCase(List<NPS_Casa_Pellas__c> npsList, String objeto) {
        List<ID> listID = new List<ID>();
        Map<ID, ID> cuentaPorID = new Map<ID, ID>();

        for (NPS_Casa_Pellas__c nps : npsList) {
            if (objeto == 'Caso') {
                listID.add(nps.Numero_de_caso__c);
            } else if (objeto == 'Oportunidad') {
                listID.add(nps.Oportunidad__c);
            }
        }

        if (objeto == 'Caso') {
            for (Case c : [SELECT ID, AccountId
                           FROM Case
                           WHERE ID IN :listID]) {
                if (String.isNotBlank(c.AccountID)) {
                    cuentaPorID.put(c.ID, c.AccountID);
                }
            }
        } else if (objeto == 'Oportunidad') {
            for (Opportunity o : [SELECT ID, AccountId
                           FROM Opportunity
                           WHERE ID IN :listID]) {
                if (String.isNotBlank(o.AccountID)) {
                    cuentaPorID.put(o.ID, o.AccountID);
                }
            }
        }

        for (NPS_Casa_Pellas__c nps : npsList) {
            
            if (objeto == 'Caso') {
                if (cuentaPorID.containsKey(nps.Numero_de_caso__c)) {
                    nps.Cuenta__c = cuentaPorID.get(nps.Numero_de_caso__c);
                }
            } else if (objeto == 'Oportunidad') {
                if (cuentaPorID.containsKey(nps.Oportunidad__c)) {
                    nps.Cuenta__c = cuentaPorID.get(nps.Oportunidad__c);
                }
            }
        }
    }
}