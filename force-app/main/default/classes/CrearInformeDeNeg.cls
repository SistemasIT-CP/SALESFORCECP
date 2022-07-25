public without sharing class CrearInformeDeNeg {
    @AuraEnabled
    public static List<Vehiculo__c> obtenerVehiculos(String oppId) {

        List<Id> vehiculosId = new List<Id>();

        for (Vehiculo_de_la_oportunidad__c vehOpp : [
            SELECT Id, Vehiculo__c
            FROM Vehiculo_de_la_oportunidad__c 
            WHERE Oportunidad__c =: oppId
            ]){
                vehiculosId.add(vehOpp.Vehiculo__c);
        }

        if (!vehiculosId.isEmpty()) {
            List<Vehiculo__c> vehList = [
                SELECT Marca__c, Modelo__c, Marca__r.Name, Modelo__r.Name, Chasis__c
                FROM Vehiculo__c
                WHERE Id IN :vehiculosId
            ];

            return vehList;

        } else {
            return null;
        }
    }

    @AuraEnabled
    public static String CrearInformeNegociacion(String vehId, String oppId) {
        Vehiculo_de_la_oportunidad__c vehOpp = [
            SELECT Oportunidad__c, Vehiculo__c, Informe_de_negociacion__c, Precio_de_venta__c
            FROM Vehiculo_de_la_Oportunidad__c 
            WHERE Vehiculo__c =: vehId AND Oportunidad__c =: oppId
            LIMIT 1
        ];
        
        Opportunity opp = [
            SELECT Forma_de_Pago_Multiple__c, AccountId,Account.Name
            FROM Opportunity
            WHERE ID =: oppId
            LIMIT 1
        ];

        Vehiculo__c veh = [
            SELECT Chasis__c, Color__c, Motor__c
            FROM Vehiculo__c
            WHERE Id =: vehId
            LIMIT 1
        ];

        if (String.isNotBlank(vehOpp.Informe_de_negociacion__c)) {
            List<Informe_de_Negociaci_n__c> inf = [
                SELECT ID 
                FROM Informe_de_Negociaci_n__c 
                WHERE ID =: vehOpp.Informe_de_negociacion__c
            ];
            
            if (!inf.isEmpty()) {
            	return 'Ya se ha creado un informe para este vehículo.';    
            }
        }
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c();
        infNeg.Vehiculo__c = vehOpp.Vehiculo__c;
        infNeg.Oportunidad__c = vehOpp.Oportunidad__c;
        infNeg.Chasis__c = veh.Chasis__c;
        infNeg.Motor__c = veh.Motor__c;
        infNeg.Color_Externo__c = veh.Color__c;
        infNeg.Precio_de_Lista_sin_IMP__c = vehOpp.Precio_de_venta__c;
        infNeg.Forma_de_Pago_Informe__c = opp.Forma_de_Pago_Multiple__c;
        infNeg.Cuenta__c = opp.AccountId;
        infNeg.Facturar_a_nombre_de__c = opp.AccountId;

        Database.SaveResult sr = Database.insert(infNeg, false);

        if (!sr.isSuccess()) {
            System.debug(sr.getErrors());
            return sr.getErrors()[0].getMessage();
        }

        vehOpp.Informe_de_negociacion__c = infNeg.Id;
        
        Database.SaveResult ur = Database.update(vehOpp, false);

        if (!ur.isSuccess()) {
            System.debug(ur.getErrors());
            return ur.getErrors()[0].getMessage();
        }
        
        return 'Bien';
    }

    public class Vehiculo{
        public String marca;
        public String modelo;
        public String chasis;
    }
}