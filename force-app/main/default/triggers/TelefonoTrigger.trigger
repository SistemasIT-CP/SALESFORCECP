trigger TelefonoTrigger on Telefono__c (before insert, before update, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        List<Telefono__c> cambioidExternoList = new List<Telefono__c>();
        if (Trigger.isInsert) {
            TelefonoHelper.setearIDExternoYSecuenciaTelefono(Trigger.new);
        } 
        
        if (Trigger.isInsert || Trigger.isUpdate) {
            TelefonoHelper.verificarContacto(Trigger.new);
        }
    }

    if (!System.isFuture()) {
        String actionTypeTelefono;
        List<Telefono__c> telefonoList;
        List<Telefono__c> cambioContactoList  = new List<Telefono__c>();
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                actionTypeTelefono = '1';
                telefonoList = Trigger.new;
                TelefonoHelper.modificarSecuenciaEnContacto(telefonoList);
            }

            if (Trigger.isUpdate) {
                telefonoList = new List<Telefono__c>();
                for (Telefono__c c : Trigger.new) {
                    if (c.Contacto__c != Trigger.oldMap.get(c.ID).Contacto__c) {
                        cambioContactoList.add(c);
                        System.debug('Entra donde tiene que entrar.');
                    } else if (c.phonelinenumber__c == Trigger.oldMap.get(c.ID).phonelinenumber__c &&
                               c.IdExterno__c == Trigger.oldMap.get(c.ID).IdExterno__c){
                        telefonoList.add(c);
                    }
                }
                actionTypeTelefono = '2';
            }

            if (Trigger.isDelete) {
                telefonoList = Trigger.old;
                actionTypeTelefono = '3';
            }

            TelefonoHelper.modificarContactosEnServicio(telefonoList, actionTypeTelefono);
            if(!cambioContactoList.isEmpty()) {
                TelefonoHelper.cambiarContacto(cambioContactoList, Trigger.oldMap);
                TelefonoHelper.modificarSecuenciaEnContacto(cambioContactoList);
            }
        }
    }
}