trigger DireccionesAlterTrigger on DireccionesAlter__c (before insert, before update, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            List<DireccionesAlter__c> dirList = new List<DireccionesAlter__c>();
            
            for (DireccionesAlter__c d : Trigger.new) {
                if (d.Contacto__c != Trigger.oldMap.get(d.ID).Contacto__c) {
                        dirList.add(d);
                }
            }
            
            DireccionesAlterHelper.verificarContacto(dirList);
            DireccionesAlterHelper.validarTipos(dirList, Trigger.oldMap);
        }
        
        if (Trigger.isInsert) {
            DireccionesAlterHelper.verificarContacto(Trigger.new);
            DireccionesAlterHelper.validarTipos(Trigger.new, null);
        	DireccionesAlterHelper.setearIDExternoYSecuenciaDireccion(Trigger.new);
        }
    }

    if (!System.isFuture()) {
        String actionTypeDireccion;
        List<DireccionesAlter__c> direccionAlterList;
        List<DireccionesAlter__c> cambioContactoList = new List<DireccionesAlter__c>();
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                actionTypeDireccion = '1';
                direccionAlterList = Trigger.new;
                DireccionesAlterHelper.modificarSecuenciaEnContacto(direccionAlterList);
            }

            if (Trigger.isUpdate) {
                direccionAlterList = new List<DireccionesAlter__c>();
                for (DireccionesAlter__c c : Trigger.new) {
                    if (c.Contacto__c != Trigger.oldMap.get(c.ID).Contacto__c) {
                        cambioContactoList.add(c);
                        System.debug('Entra donde tiene que entrar.');
                    } else if (c.SEQUENCEADDRESS__c == Trigger.oldMap.get(c.ID).SEQUENCEADDRESS__c &&
                               c.Id_Externo__c == Trigger.oldMap.get(c.ID).Id_Externo__c) {
                        direccionAlterList.add(c);
                    }
                }
                actionTypeDireccion = '2';
            }

            if (Trigger.isDelete) {
                direccionAlterList = Trigger.old;
                actionTypeDireccion = '3';
            }

            DireccionesAlterHelper.modificarContactosEnServicio(direccionAlterList, actionTypeDireccion);
            
            if(!cambioContactoList.isEmpty()) {
                DireccionesAlterHelper.cambiarContacto(cambioContactoList, Trigger.oldMap);
                DireccionesAlterHelper.modificarSecuenciaEnContacto(cambioContactoList);
            }
        }
    }
}