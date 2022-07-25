trigger AccesoriosComboParaNegociacionTrigger on AccesoriosComboParaNegociacion__c (after update) {
    if (Trigger.IsAfter) {
        if (Trigger.IsUpdate) {
            List<AccesoriosComboParaNegociacion__c> accComboNegList = new List<AccesoriosComboParaNegociacion__c>();

            for (AccesoriosComboParaNegociacion__c c : Trigger.new) {
                 if (c.Asociar_al_informe_Negociacion__c && !(Trigger.oldMap.get(c.ID).Asociar_al_informe_Negociacion__c)) {
                    accComboNegList.add(c);
                 }
            }

            if (!accComboNegList.isEmpty()){
                AccesoriosComboParaNegociacionHelper.crearAccesoriosDelInforme(accComboNegList);
            }
        }
    }
}