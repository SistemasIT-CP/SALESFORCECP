public class RecibosDeNegociacionHelper {
    public static void validarMaximo(List<Recibos_de_la_negociaci_n__c> recibosNegList,
                                     Map<ID, Recibos_de_la_negociaci_n__c> recNegOldMap) {
        List<ID> recibosID = new List<ID>();
        for (Recibos_de_la_negociaci_n__c rn : recibosNegList) {
            recibosID.add(rn.Recibos__c);
        }

        Map<ID, AllRecibidos__c> recibosMap = new Map<ID, AllRecibidos__c>(
            [SELECT ID, Saldo_disponible__c, Saldo_aplicado__c, NumeroRecibido__c, CurrencyIsoCode 
            FROM AllRecibidos__c
            WHERE ID IN :recibosID
            ]);
        
        for (Recibos_de_la_negociaci_n__c rn : recibosNegList) {
            AllRecibidos__c r = recibosMap.get(rn.Recibos__c);
            Decimal montoViejo;

            if (recNegOldMap != null) {
                montoViejo = recNegOldMap.get(rn.ID).Monto_aplicado_a_la_negociaci_n__c;
            } else {
                montoViejo = 0;
            }

            Decimal diferencia =  r.Saldo_disponible__c - (rn.Monto_aplicado_a_la_negociaci_n__c - montoViejo); 
            if (diferencia < 0) {
                rn.addError('El monto aplicado al recibo ' + r.NumeroRecibido__c + ' es mayor al saldo disponible,'+
                                ' excede por la cantidad de: ' + r.CurrencyIsoCode + '$ ' + (-1) * diferencia +
                                ', favor de validar la información');
            }
        }
    }

    public static void validarVehiculoCerrado(List<Recibos_de_la_negociaci_n__c> recibosNegList) {
        List<Id> reciboId = new List<Id>();
        List<Id> vehiculosSinCerrar = new List<Id>();
        Map<Id, Id> vehiculoByRecId = new Map<Id, Id>();

        for (Recibos_de_la_negociaci_n__c recNeg : recibosNegList) {
            reciboId.add(recNeg.Recibos__c);
        }

        for (AllRecibidos__c rec : [SELECT Id, Vehiculo__c 
                                    FROM AllRecibidos__c 
                                    WHERE Id IN :reciboId]) {
            vehiculoByRecId.put(rec.Id, rec.Vehiculo__c);
        }

        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Id, Vehiculo__c
                                                    FROM Vehiculo_de_la_Oportunidad__c
                                                    WHERE Vehiculo__c IN :vehiculoByRecId.values()
                                                        AND Oportunidad__r.RecordType.DeveloperName = 'Avaluo'
                                                        AND Oportunidad__r.StageName != 'Cerrada ganada'
                                                        AND Oportunidad__r.StageName != 'Cerrada perdida']) {
            vehiculosSinCerrar.add(vehOpp.Vehiculo__c);
        }

        for (Recibos_de_la_negociaci_n__c recNeg : recibosNegList) {
            Id vehiculoId = vehiculoByRecId.containsKey(recNeg.Recibos__c)? vehiculoByRecId.get(recNeg.Recibos__c) : '';

            if (String.isNotBlank(vehiculoId) && vehiculosSinCerrar.contains(vehiculoId)) {
                recNeg.addError('No puede asociarse el recibo de un vehiculo que aun no está liberado');
            }
        }
    }
}