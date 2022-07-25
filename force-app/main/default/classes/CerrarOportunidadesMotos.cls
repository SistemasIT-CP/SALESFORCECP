public class CerrarOportunidadesMotos{
    public static void cerrarOppMotos(){
        List<Id> oppMotosId = new List<Id>();
        List<Opportunity> oportunidadesActualizables = new List<Opportunity>();

        for (Opportunity opp : [SELECT Id
                                FROM Opportunity
                                WHERE RecordType.DeveloperName = 'Principal_Motos' 
                                    AND StageName = 'Facturado']){
            oppMotosId.add(opp.Id);
        }

        Map<Id, Integer> informesTotalesPorOppId = new Map<Id, Integer>();
        Map<Id, Integer> informesListosPorOppId = new Map<Id, Integer>();

        for (Informe_de_Negociaci_n__c inf : [SELECT Id, Oportunidad__c, Fecha_de_ultima_facturacion__c, factura__c 
                                                FROM Informe_de_Negociaci_n__c 
                                                WHERE Oportunidad__c IN :oppMotosId]){
            Integer informesTotales = 1;
            Integer informesListos = 0;

            if (informesTotalesPorOppId.containsKey(inf.Oportunidad__c)) {
                informesTotales += informesTotalesPorOppId.get(inf.Oportunidad__c);
            }

            if (String.isNotBlank(inf.factura__c) && inf.Fecha_de_ultima_facturacion__c != null && inf.Fecha_de_ultima_facturacion__c.addDays(3) <= Date.today()) {
                informesListos = 1;
            }

            if (informesListosPorOppId.containsKey(inf.Oportunidad__c)) {
                informesListos += informesListosPorOppId.get(inf.Oportunidad__c);
            }

            informesTotalesPorOppId.put(inf.Oportunidad__c, informesTotales);
            informesListosPorOppId.put(inf.Oportunidad__c, informesListos);
        }

        for (Opportunity opp : [SELECT Id, StageName
                                FROM Opportunity
                                WHERE RecordType.DeveloperName = 'Principal_Motos' 
                                    AND StageName = 'Facturado']) {
            if (informesTotalesPorOppId.containsKey(opp.Id) && informesListosPorOppId.containsKey(opp.Id)) {
                Integer informesTotales = informesTotalesPorOppId.get(opp.Id);
                Integer informesListos = informesListosPorOppId.get(opp.Id);

                if (informesTotales == informesListos) {
                    oportunidadesActualizables.add(opp);
                }
            }
        }

        for (Opportunity opp : oportunidadesActualizables) {
            opp.StageName = 'Cerrada ganada';
        }

        update oportunidadesActualizables;
    }
}