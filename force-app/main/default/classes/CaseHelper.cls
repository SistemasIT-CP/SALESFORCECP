public without sharing class CaseHelper {
    public static void modificarEmail(List<Case> csList) {
        for (Case cs : csList) {
            List<String> nombreDescompuesto = cs.SuppliedName.split(' ');
            Integer i = nombreDescompuesto.size();

            String nuevoEmail = nombreDescompuesto[i - 3] + '@' + nombreDescompuesto[i - 1];

            cs.SuppliedEmail = nuevoEmail;
        }
    }
    
    public static void setearOwnerParaSocialPost(List<Id> listaCasosId) {
        List<Group> colaSocialPost = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
				AND DeveloperName = 'Equipo_Inbound'
        ];
        
        if (!colaSocialPost.isEmpty()) {
            List<Case> casosList = [
                SELECT OwnerId
                FROM Case
                WHERE Id IN :listaCasosId
            ];
            
            for (Case c : casosList) {
                c.OwnerId = colaSocialPost[0].Id;
            }
            
            if (!casosList.isEmpty()) {
                update casosList;
            }
        }
    }
}