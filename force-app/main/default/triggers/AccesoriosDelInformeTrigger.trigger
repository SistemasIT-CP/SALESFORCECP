trigger AccesoriosDelInformeTrigger on Accesorios_del_informe__c (after update, before update, after Insert, before insert, after Delete, before delete) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            List<Accesorios_del_informe__c> accConInforme = new List<Accesorios_del_informe__c>();
            for (Accesorios_del_informe__c accInf : Trigger.new) {
                if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                    accConInforme.add(accInf);
                }
            }

            if (!accConInforme.isEmpty()) {
                AccesoriosDelInformeHelper.validarInformeReservado(accConInforme, 'agregar');
                AccesoriosDelInformeHelper.setearConsecutivoYEstado(accConInforme);
            }
        }

        if (Trigger.isUpdate) {
            List<Accesorios_del_informe__c> modificarAccDespachado = new List<Accesorios_del_informe__c>();
            List<Accesorios_del_informe__c> solicitarAccesorioEquivalente = new List<Accesorios_del_informe__c>();
            
            for (Accesorios_del_informe__c accInf : Trigger.new) {
                if (accInf.Estado__c == 'Despachado' && Trigger.oldMap.get(accInf.ID).Estado__c == 'Despachado') {
                    modificarAccDespachado.add(accInf);
                }

                if (accInf.Solicitar_Accesorio_Equivalente__c && !Trigger.oldMap.get(accInf.ID).Solicitar_Accesorio_Equivalente__c) {
                    System.debug('Se solicita un acc equivalente');
                    System.debug(accInf.Codigo_equivalente__c);
                    if (String.isBlank(accInf.Codigo_equivalente__c)) {
                        solicitarAccesorioEquivalente.add(accInf);
                    }
                }
            }

            if (!modificarAccDespachado.isEmpty()) {
                AccesoriosDelInformeHelper.validarAccesorioDespachado(modificarAccDespachado, 'modificar');
            }
            
            if (!solicitarAccesorioEquivalente.isEmpty()) {
                AccesoriosDelInformeHelper.validarAccesorioEquivalente(solicitarAccesorioEquivalente);
            }
        } 

        if (Trigger.isDelete) {
            List<Accesorios_del_informe__c> eliminarAccDespachado = new List<Accesorios_del_informe__c>();
            List<Accesorios_del_informe__c> accConInforme = new List<Accesorios_del_informe__c>();

            for (Accesorios_del_informe__c accInf : Trigger.old) {
                if (accInf.Estado__c == 'Despachado') {
                    eliminarAccDespachado.add(accInf);
                }

                if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                    accConInforme.add(accInf);
                }
            }

            if (!eliminarAccDespachado.isEmpty()) {
                AccesoriosDelInformeHelper.validarAccesorioDespachado(eliminarAccDespachado, 'eliminar');
            }

            if (!accConInforme.isEmpty()) {
                AccesoriosDelInformeHelper.validarInformeReservado(accConInforme, 'eliminar');
            }
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Accesorios_del_informe__c> accConInforme = new List<Accesorios_del_informe__c>();

            if (!System.isFuture()) {
                for (Accesorios_del_informe__c accInf : Trigger.new) {
                    if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                        accConInforme.add(accInf);
                    }
                }   
            }

            if (!accConInforme.isEmpty()) {
                AccesoriosDelInformeHelper.solicitarAccesorioInformeAprobado(accConInforme, 'Insercion');
                AccesoriosDelInformeHelper.consultarDisponibilidad(accConInforme);
            }
        }
        
        if (Trigger.isUpdate) {
            List<Accesorios_del_informe__c> accConInforme = new List<Accesorios_del_informe__c>();
            List<Accesorios_del_informe__c> validarDisponibilidad = new List<Accesorios_del_informe__c>();

            if (!System.isFuture()) {
                for (Accesorios_del_informe__c accInf : Trigger.new) {
                    if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                        accConInforme.add(accInf);
                    }

                    if ((accInf.Estado__c != 'Despachado' && Trigger.oldMap.get(accInf.ID).Estado__c == 'Despachado') ||
                        accInf.Cantidad__c != Trigger.oldMap.get(accInf.ID).Cantidad__c ||
                        accInf.Solicitar_Accesorio_Equivalente__c != Trigger.oldMap.get(accInf.ID).Solicitar_Accesorio_Equivalente__c) {
                        validarDisponibilidad.add(accInf);
                    }
                }   
            }

            if (!accConInforme.isEmpty()) {
                AccesoriosDelInformeHelper.solicitarAccesorioInformeAprobado(accConInforme, 'Actualizacion');
                AccesoriosDelInformeHelper.consultarDisponibilidad(accConInforme);
            }
        }

        if (Trigger.isDelete) {
            List<Accesorios_del_informe__c> accConInforme = new List<Accesorios_del_informe__c>();

            for (Accesorios_del_informe__c accInf : Trigger.old) {
                if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                    accConInforme.add(accInf);
                }
            }

            if (!accConInforme.isEmpty()) {
                AccesoriosDelInformeHelper.solicitarAccesorioInformeAprobado(accConInforme, 'Eliminacion');
            }
        }
    }
}