trigger ContactTrigger on Contact (before insert, before update, after insert, after update, after delete, before delete) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert) {
            ContactHelper.checkContactCreation(Trigger.new);
            ContactHelper.actualizarContactID(Trigger.new);
        	ContactHelper.upperCaseName(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            List<Contact> contList = new List<Contact>();
            for (Contact con : Trigger.new) {
                String name = con.FirstName + con.MiddleName + con.LastName;
                Contact oldCon = Trigger.oldMap.get(con.ID);
                String oldName = (oldCon.FirstName + oldCon.MiddleName + oldCon.LastName).toUpperCase();
                
                if(name != oldName) {
                    contList.add(con);
                }
            }
            ContactHelper.upperCaseName(contList);
        }
        
        if (Trigger.isDelete) {
            ContactHelper.eliminarRelaciones(Trigger.oldMap);
        }
    }

    if (Trigger.isAfter) {
        if(!System.isFuture() && !System.isBatch()){
            String actionTypeContact;
            List<Contact> ctList = new List<Contact>();
            Map<ID, Contact> oldTriggerMap;
            if (Trigger.isInsert) {
                actionTypeContact = '1';
                for (Contact con : Trigger.new) {
                    if (!con.Creado_desde_un_Lead__c) {
                        ctList.add(con);
                    } else {
                        System.debug('Se esta creando un contacto proveniente de un lead');
                    }
                }
            }

            if (Trigger.isUpdate) {
                for (Contact con : Trigger.new) {
                    if(con.Envio_correcto_a_WS__c == Trigger.oldMap.get(con.ID).Envio_correcto_a_WS__c &&
                        con.Secuencia_correo__c == Trigger.oldMap.get(con.ID).Secuencia_correo__c &&
                        con.Secuencia_direccion__c == Trigger.oldMap.get(con.ID).Secuencia_direccion__c &&
                        con.Secuencia_telefono__c == Trigger.oldMap.get(con.ID).Secuencia_telefono__c) {
						
                        actionTypeContact = '2';
                    }
                    
                    if (!con.Creado_desde_un_Lead__c) {
                        ctList.add(con);
                    }
                }
                
                oldTriggerMap = Trigger.oldMap;
            }

            if (Trigger.isDelete) {
                actionTypeContact = '3';
                
                for (Contact con : Trigger.old) {
                    if (!con.Creado_desde_un_Lead__c) {
                        ctList.add(con);
                    } else {
                        System.debug('Se esta eliminando un contacto proveniente de un lead');
                    }
                }
            }

            ContactHelper.modificarContactosEnServicio(ctList, oldTriggerMap, actionTypeContact);
        } 
    }
}