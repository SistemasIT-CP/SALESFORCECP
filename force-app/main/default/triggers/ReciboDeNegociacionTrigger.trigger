trigger ReciboDeNegociacionTrigger on Recibos_de_la_negociaci_n__c (before insert, before update, after insert, after delete) {
    if (Trigger.IsBefore) {
        if (Trigger.isInsert) {
            RecibosDeNegociacionHelper.validarMaximo(Trigger.new, null);
            RecibosDeNegociacionHelper.validarVehiculoCerrado(Trigger.new);
        }

        if (Trigger.isUpdate) {
            List<Recibos_de_la_negociaci_n__c> recNegList = new List<Recibos_de_la_negociaci_n__c>();

            for (Recibos_de_la_negociaci_n__c recNeg : Trigger.new) {
                if(recNeg.Monto_aplicado_a_la_negociaci_n__c != Trigger.oldMap.get(recNeg.ID).Monto_aplicado_a_la_negociaci_n__c) {
                    recNegList.add(recNeg);
                }
            }

            if (!recNegList.isEmpty()) {
                RecibosDeNegociacionHelper.validarMaximo(recNegList, Trigger.oldMap);
            }
        }
    }
}