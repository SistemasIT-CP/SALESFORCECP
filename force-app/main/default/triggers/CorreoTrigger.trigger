trigger CorreoTrigger on Correo__c (before insert, before update, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            CorreoHelper.verificarContacto(Trigger.new);
        }
        
        if (Trigger.isInsert) {
            CorreoHelper.setearIDExternoYSecuenciaEmail(Trigger.new);
        }
    } 

    if (!System.isFuture()) {
        String actionTypeCorreo;
        List<Correo__c> correosList;
        List<Correo__c> cambioContactoList = new List<Correo__c>();
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                actionTypeCorreo = '1';
                correosList = Trigger.new;
                CorreoHelper.modificarSecuenciaEnContacto(correosList);
            }

            if (Trigger.isUpdate) {
                correosList = new List<Correo__c>();
                for (Correo__c c : Trigger.new) {
                    if (c.Contacto__c != Trigger.oldMap.get(c.ID).Contacto__c) {
                        cambioContactoList.add(c);
                        System.debug('Entra donde tiene que entrar.');
                    } else if (c.electronicaddresslinenumber__c == Trigger.oldMap.get(c.ID).electronicaddresslinenumber__c &&
                               c.IdExterno_c__c == Trigger.oldMap.get(c.ID).IdExterno_c__c){
                        correosList.add(c);
                    }
                }
                actionTypeCorreo = '2';
            }

            if (Trigger.isDelete) {
                correosList = Trigger.old;
                actionTypeCorreo = '3';
            }

            CorreoHelper.modificarContactosEnServicio(correosList, actionTypeCorreo);
            
            if(!cambioContactoList.isEmpty()) {
                CorreoHelper.cambiarContacto(cambioContactoList, Trigger.oldMap);
                CorreoHelper.modificarSecuenciaEnContacto(cambioContactoList);
            }
        }
    }
}