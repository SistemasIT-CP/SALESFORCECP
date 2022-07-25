trigger VehiculoDeLaOportunidadTrigger on Vehiculo_de_la_Oportunidad__c (after insert, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            VehiculoDeLaOportunidadHelper.crearCotizacion(Trigger.new);
        }

        if (Trigger.isDelete) {
            List<Vehiculo_de_la_Oportunidad__c> vehiculosDeVentaAutolote = new List<Vehiculo_de_la_Oportunidad__c>();
            List<Id> oppIdList = new List<Id>(); 

            for (Vehiculo_de_la_Oportunidad__c vehOpp : Trigger.old) {
                oppIdList.add(vehOpp.Oportunidad__c);
            }

            Map<Id, Opportunity> oppPorIdMap = new Map<Id, Opportunity>([
                SELECT RecordType.DeveloperName
                FROM Opportunity
                WHERE Id IN :oppIdList
            ]);

            for (Vehiculo_de_la_Oportunidad__c vehOpp : Trigger.old) {
                if (oppPorIdMap.containsKey(vehOpp.Oportunidad__c)) {
                    if (oppPorIdMap.get(vehOpp.Oportunidad__c).RecordType.DeveloperName == 'Principal_Autolote') {
                        vehiculosDeVentaAutolote.add(vehOpp);
                    }
                }
            }

            if (!vehiculosDeVentaAutolote.isEmpty()) {
                VehiculoDeLaOportunidadHelper.liberarVehiculos(vehiculosDeVentaAutolote);
            }
        }
    }
}