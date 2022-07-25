public without sharing class VehiculoDeLaOportunidadHelper {
    public static void crearCotizacion(List<Vehiculo_de_la_Oportunidad__c> vehiculoList) {
        ID principalAutoloteId = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal_Autolote')
                                    .getRecordTypeId();
        
        List<Quote> quotesList = new List<Quote>();
        Set<Id> oppIdLista = new Set<Id>();

        for (Vehiculo_de_la_Oportunidad__c vehiculo : vehiculoList) {
            oppIdLista.add(vehiculo.Oportunidad__c);
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT RecordTypeId, Name, Id
            FROM Opportunity
            WHERE Id IN :oppIdLista
        ]);

        for (Vehiculo_de_la_Oportunidad__c vehiculo : vehiculoList) {
            if (oppMap.containsKey(vehiculo.Oportunidad__c)) {
                Opportunity oppPadre = oppMap.get(vehiculo.Oportunidad__c);
                if (oppPadre.RecordTypeId == principalAutoloteId) {
    
                    Quote q = new Quote();
                    q.Name = oppPadre.Name;
                    q.Vehiculo__c = vehiculo.Vehiculo__c;
                    q.OpportunityId = oppPadre.Id;
                    q.ExpirationDate = Date.today().addDays(10);
                    quotesList.add(q);
                }
            }
        }

        if (!quotesList.isEmpty()) {
            insert quotesList;
        }
    }

    public static void liberarVehiculos(List<Vehiculo_de_la_Oportunidad__c> vehiculoList) {
        List<Id> vehiculoIdList = new List<Id>();

        for (Vehiculo_de_la_Oportunidad__c vehOpp : vehiculoList) {
            vehiculoIdList.add(vehOpp.Vehiculo__c);
        }

        List<Vehiculo__c> vehList = [
            SELECT Estado__c 
            FROM Vehiculo__c 
            WHERE Id IN :vehiculoIdList
        ];

        for (Vehiculo__c v : vehList) {
            v.Estado__c = 'Libre';
        }

        if (!vehList.isEmpty()) {
            update vehList;
        }
    }
}