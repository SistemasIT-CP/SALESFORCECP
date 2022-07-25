trigger InformeDeNegociacion on Informe_de_Negociaci_n__c (before update, before delete, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            List<Informe_de_Negociaci_n__c> modificaDatoVisible = new List<Informe_de_Negociaci_n__c>();
            List<Informe_de_Negociaci_n__c> informesAprobadosCambioDatoVisible = new List<Informe_de_Negociaci_n__c>();
            List<Informe_de_Negociaci_n__c> informesAprobadosCambioEstado = new List<Informe_de_Negociaci_n__c>();
            List<Informe_de_Negociaci_n__c> infEnAprobacionMotos = new List<Informe_de_Negociaci_n__c>();
            List<Id> enviarMotosASegundaAprobacion = new List<Id>();

            for (Informe_de_Negociaci_n__c infNeg : Trigger.new) {
                if (InformeDeNegociacionHelper.seModificaUnDatoVisible(infNeg, Trigger.oldMap.get(infNeg.ID))) {
                    modificaDatoVisible.add(infNeg);

                    if (infNeg.Estado__c == 'Aprobado') {
                        informesAprobadosCambioDatoVisible.add(infNeg);
                    }
                }

                if (infNeg.Estado__c == 'Aprobado' && Trigger.oldMap.get(infNeg.ID).Estado__c != 'Aprobado') {
                    informesAprobadosCambioEstado.add(infNeg);
                }
                
                if (infNeg.Texto_Bandera__c == 'Precio Aprobacion' && Trigger.oldMap.get(infNeg.ID).Texto_Bandera__c != 'Precio Aprobacion') {
                    informesAprobadosCambioEstado.add(infNeg);
                }

                if(String.isNotBlank(infNeg.Oportunidad__c)) {
                    if (infNeg.Horario_de_aprobacion__c != Trigger.oldMap.get(infNeg.ID).Horario_de_aprobacion__c) {
                        infEnAprobacionMotos.add(infNeg);
                    }
                }

                if(infNeg.Texto_Bandera__c != Trigger.oldMap.get(infNeg.Id).Texto_Bandera__c && String.isNotBlank(infNeg.Texto_Bandera__c) && infNeg.Texto_Bandera__c == 'Precio Aprobacion') {
                    enviarMotosASegundaAprobacion.add(infNeg.Id);
                }
            }

            if (!modificaDatoVisible.isEmpty()) {
                InformeDeNegociacionHelper.validarModificaciones(modificaDatoVisible);
            }

            if (!informesAprobadosCambioDatoVisible.isEmpty()) {
                InformeDeNegociacionHelper.quitarEstadoAprobado(informesAprobadosCambioDatoVisible);
            }

            if (!informesAprobadosCambioEstado.isEmpty()) {
                InformeDeNegociacionHelper.setearAprobador(informesAprobadosCambioEstado);
            }

            if (!infEnAprobacionMotos.isEmpty()) {
                InformeDeNegociacionHelper.cerrarAprobacionesExtras(infEnAprobacionMotos);
            }

            if (!enviarMotosASegundaAprobacion.isEmpty()) {
                InformeDeNegociacionHelper.enviarMotosASegundaAprobacion(enviarMotosASegundaAprobacion);
            }
        }

        if (Trigger.isDelete) {
            for (Informe_de_Negociaci_n__c infNeg : Trigger.old) {
                if (infNeg.Reservar__c) {
                    infNeg.addError('No puede eliminar el informe de negociación ' + infNeg.name +
                                    ', ya que se encuentra en estado reservado');
                }
            }
            
           
            InformeDeNegociacionHelper.validarChasisOrdenAbierta(Trigger.old);
            InformeDeNegociacionHelper.validarExistenciaDeRecibos(Trigger.old);
            InformeDeNegociacionHelper.validarExistenciaDeAccDespachados(Trigger.old);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Informe_de_Negociaci_n__c> infNegConChasis = new List<Informe_de_Negociaci_n__c>();

            for (Informe_de_Negociaci_n__c infNeg : Trigger.new) {
                if (String.isNotBlank(infNeg.Chasis__c)) {
                    infNegConChasis.add(infNeg);
                }
            }

            if (!infNegConChasis.isEmpty()) {
                InformeDeNegociacionHelper.obtenerAccesoriosDelChasis(infNegConChasis);
            }
        }

        if (Trigger.isUpdate) {
            List<Informe_de_Negociaci_n__c> infNegReportables = new List<Informe_de_Negociaci_n__c>();
            List<Informe_de_Negociaci_n__c> infNegEliminacionAprobado = new List<Informe_de_Negociaci_n__c>();
            
            Boolean enviar = false;

            for (Informe_de_Negociaci_n__c infNeg : Trigger.new) {
                if (infNeg.Solicitar_accesorios__c != Trigger.oldMap.get(infNeg.ID).Solicitar_accesorios__c) {
                    enviar = infNeg.Solicitar_accesorios__c;
                } else if (infNeg.Chasis__c != Trigger.oldMap.get(infNeg.ID).Chasis__c) {
                    enviar = true;
                }
    
                if (enviar) {
                    infNegReportables.add(infNeg);
                }

                if (infNeg.Estado_de_aprobaci_n__c != Trigger.oldMap.get(infNeg.Id).Estado_de_aprobaci_n__c) {
                    if (infNeg.Estado_de_aprobaci_n__c == 'Aprobado' && Trigger.oldMap.get(infNeg.Id).Estado_de_aprobaci_n__c == 'Pendiente') {
                        infNegEliminacionAprobado.add(infNeg);
                    }
                }
            }

            if (!infNegReportables.isEmpty()) {
                InformeDeNegociacionHelper.enviarReporteInforme(infNegReportables);
            }

            if (!infNegEliminacionAprobado.isEmpty()) {
                InformeDeNegociacionHelper.eliminarInformesLuegoDeAprobacion(infNegEliminacionAprobado);
            }
        }

        if (Trigger.isDelete) {
            InformeDeNegociacionHelper.eliminarSolicitud(Trigger.old);
        }
    }
}