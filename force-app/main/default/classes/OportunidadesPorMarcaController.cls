public without sharing class OportunidadesPorMarcaController {
    @AuraEnabled
    public static List<Opportunity> obtenerOportunidades(String cuentaID) {
        ID usuario = UserInfo.getUserId();

        List<String> marcasHabilitadas = new List<String>();

        List<User> usuarioList = 
            [SELECT Marca__c
            FROM User
            WHERE ID =: usuario 
            ];

        if (usuarioList.isEmpty()) {
            return null;
        } else {
            if (String.isNotBlank(usuarioList[0].Marca__c)) {
                marcasHabilitadas = usuarioList[0].Marca__c.split(';');
            }
        }

        List<Opportunity> oppList = 
            [SELECT Name, OwnerID, StageName, Owner.Name
            FROM Opportunity
            WHERE AccountID =: cuentaID
                  AND Marca_UDC__r.Name IN :marcasHabilitadas
                  AND Stagename != 'Cerrada perdida' 
                  AND Stagename != 'Cerrada ganada'
            ];

        System.debug(oppList);

        if (!oppList.isEmpty()) {
            return oppList;
        } else {
            return null;
        }
    }
}