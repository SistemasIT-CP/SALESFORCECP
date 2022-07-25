trigger OpportunityTrigger on Opportunity (after update, after insert, before insert, before update) {
    Id principalAutosID = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autos')
                            .getRecordTypeId();

    Id principalMotosID = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Motos')
                            .getRecordTypeId();

    Id principalAutoloteId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autolote')
                            .getRecordTypeId();

    Id avaluoId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Avaluo')
                            .getRecordTypeId();

    if (Trigger.isAfter) {     
        if (Trigger.isUpdate) {
            List<Opportunity> insertarFactList = new List<Opportunity>();
            List<Opportunity> eliminarFactList = new List<Opportunity>();
            List<Opportunity> actualizarFormaPago = new List<Opportunity>();
            List<Opportunity> oportunidadesPerdidas = new List<Opportunity>();
            List<Opportunity> avaluoCerrado = new List<Opportunity>();
            List<Opportunity> avaluoGanado = new List<Opportunity>();
            List<Opportunity> autoloteGanado = new List<Opportunity>();
            Set<Id> parentOpportunitiesId =  new Set<Id>();

            for (Opportunity opp : Trigger.new) {
                if (opp.StageName == 'Listo Para Facturar' 
                    	&& Trigger.oldMap.get(opp.ID).StageName == 'Formalizacion') {
                    insertarFactList.add(opp);
                }

                if (opp.RecordTypeId == avaluoId) {
                    if (opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
                        if (opp.StageName.contains('Cerrada')) {
                            avaluoCerrado.add(opp);
                        }

                        if (opp.StageName == 'Cerrada ganada') {
                            avaluoGanado.add(opp);
                        }
                    }

                    if (opp.Oportunidad_original__c != Trigger.oldMap.get(opp.Id).Oportunidad_original__c && String.isNotBlank(Trigger.oldMap.get(opp.Id).Oportunidad_original__c)) {
                        parentOpportunitiesId.add(Trigger.oldMap.get(opp.Id).Oportunidad_original__c);
                    }
                }

                if (opp.RecordTypeId == principalAutoloteId) {
                    if (opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
                        if (opp.StageName == 'Cerrada ganada') {
                            autoloteGanado.add(opp);
                        }
                    }
                }
                
                if (opp.StageName == 'Formalizacion' 
                    	&& Trigger.oldMap.get(opp.ID).StageName == 'Listo Para Facturar') {
                    if (opp.Permite_Ganar_Oportunidad__c == Trigger.oldMap.get(opp.ID).Permite_Ganar_Oportunidad__c) {
                        eliminarFactList.add(opp);
                    }
                }

                if (opp.Forma_de_Pago_Multiple__c != Trigger.oldMap.get(opp.ID).Forma_de_Pago_Multiple__c) {
                    if(String.isBlank(opp.Forma_de_Pago_Multiple__c) 
                       		|| opp.Forma_de_Pago_Multiple__c.split(';').size() == 1) {
                        actualizarFormaPago.add(opp);
                    }
                }

                if (opp.StageName == 'Cerrada perdida' 
                    	&& Trigger.oldMap.get(opp.ID).StageName != 'Cerrada perdida') {
                    if (opp.RecordTypeId != avaluoId) {
                        oportunidadesPerdidas.add(opp);
                    }
                }
            }

            if (!insertarFactList.isEmpty()) {
                OpportunityHelper.insertarFacturaAutomatica(insertarFactList);
            }

            if (!eliminarFactList.isEmpty()) {
                OpportunityHelper.eliminarFacturaAutomatica(eliminarFactList);
            }

            if (!actualizarFormaPago.isEmpty()) {
                OpportunityHelper.actualizarFormaPago(actualizarFormaPago);
            }

            if (!oportunidadesPerdidas.isEmpty()) {
                if (!OpportunityHelper.validarOrdenAbierta(oportunidadesPerdidas)) {                    
                    OpportunityHelper.oportunidadesPerdidas(oportunidadesPerdidas);
                }
            }

            if (!avaluoCerrado.isEmpty()) {
                OpportunityHelper.liberarVehiculos(avaluoCerrado);
            }

            if (!avaluoGanado.isEmpty()) {
                OpportunityHelper.setearFechaCompra(avaluoGanado);
            }

            if (!autoloteGanado.isEmpty()) {
                OpportunityHelper.setearFechaVenta(autoloteGanado);
            }

            if (!parentOpportunitiesId.isEmpty()) {
                OpportunityHelper.desactivarIntercambioEnPadres(parentOpportunitiesId);
            }
        }

        if (Trigger.isInsert) {
            OpportunityHelper.aprobacionListaNegra(Trigger.new);
        }
    }
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            List<Opportunity> oppList = new List<Opportunity>();
            List<Opportunity> oppOriginales = new List<Opportunity>();
            List<Opportunity> setearNombreTelefono = new List<Opportunity>();

            for (Opportunity opp : Trigger.new) {
                if (String.isNotBlank(opp.AccountID)) {
                    oppList.add(opp);
                }

                if (opp.RecordTypeID == principalAutosID || opp.RecordTypeID == principalMotosID){
                    if(String.isNotBlank(opp.Marca_UDC__c)) {
                        oppOriginales.add(opp);
                    }
                    
                    setearNombreTelefono.add(opp);
                } 
                
                if (opp.RecordTypeId == principalAutoloteId)  {
                    setearNombreTelefono.add(opp);
                    oppOriginales.add(opp);
                }
            }

            OpportunityHelper.validarDuplicados(Trigger.new);

            if (!setearNombreTelefono.isEmpty()) {
                OpportunityHelper.setearNombreYTelefono(setearNombreTelefono);
            }
            
            if (!oppOriginales.isEmpty()) {
            	OpportunityHelper.setearCompaniaYLinea(oppOriginales);    
            }
            if (!oppList.isEmpty()) {
                OpportunityHelper.setearOppInactiva(oppList);
            }
        }
        
        if (Trigger.isUpdate) {
            List<Opportunity> oppList = new List<Opportunity>();
            List<Opportunity> oportunidadesAFacturar = new List<Opportunity>();
            List<Opportunity> avaluosEnFormalizacion = new List<Opportunity>();
            List<Opportunity> avaluosEnNegociacion = new List<Opportunity>();
            List<Opportunity> avaluosEnAprobacionAutolote = new List<Opportunity>();
            List<Opportunity> facturarIntercambiosIdList = new List<Opportunity>();
            List<Opportunity> cambiarIntercambioIdList = new List<Opportunity>();

            for (Opportunity opp : Trigger.new) {
                if (opp.RecordTypeID == principalAutosID || opp.RecordTypeID == principalMotosID || opp.RecordTypeId == principalAutoloteId){
                    if (opp.AccountId != Trigger.oldMap.get(opp.ID).AccountId 
                        	|| opp.Marca_UDC__c != Trigger.oldMap.get(opp.ID).Marca_UDC__c 
                        		|| opp.ModeloVehiculo__c != Trigger.oldMap.get(opp.ID).ModeloVehiculo__c) {
                            oppList.add(opp);   
                    }

                    if (opp.StageName == 'Listo Para Facturar' 
                    	&& Trigger.oldMap.get(opp.ID).StageName == 'Formalizacion') {

                            oportunidadesAFacturar.add(opp);

                            if (opp.Desea_realizar_intercambio__c == 'SI') {
                                facturarIntercambiosIdList.add(opp);
                            }
                    }

                    if (opp.Desea_realizar_intercambio__c != Trigger.oldMap.get(opp.Id).Desea_realizar_intercambio__c) {
                        if (opp.Desea_realizar_intercambio__c == 'NO') {
                            cambiarIntercambioIdList.add(opp);
                        }
                    }
                }
                
                if (opp.RecordTypeId == avaluoId) {
                    if (opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
                        if (opp.StageName == 'Formalizacion') {
                            avaluosEnFormalizacion.add(opp);
                        }

                        if (opp.StageName == 'Negociacion') {
                            avaluosEnNegociacion.add(opp);
                        }

                        if (opp.StageName == 'Aprobacion Autolote') {
                            avaluosEnAprobacionAutolote.add(opp);
                        }   
                    }
                }
            }


            if (!cambiarIntercambioIdList.isEmpty()) {
                OpportunityHelper.validarAvaluosAbiertos(cambiarIntercambioIdList);
            }

            if (!facturarIntercambiosIdList.isEmpty()) {
                OpportunityHelper.validarAvaluosAbiertos(facturarIntercambiosIdList);
            }

            if (!oppList.isEmpty()) {
            	OpportunityHelper.setearNombreYTelefono(oppList);
            }

            if (!oportunidadesAFacturar.isEmpty()) {
                OpportunityHelper.setearScoring(oportunidadesAFacturar);
            }

            if (!avaluosEnFormalizacion.isEmpty()) {
                OpportunityHelper.validarRecibosExistentes(avaluosEnFormalizacion);
                OpportunityHelper.setearAuEnVehiculos(avaluosEnFormalizacion);
            }
            
            if (!avaluosEnAprobacionAutolote.isEmpty()) {
                OpportunityHelper.validarDatosVehiculo(avaluosEnAprobacionAutolote);
            }
            
            if (!avaluosEnNegociacion.isEmpty()) {
                OpportunityHelper.validarPrecioAprobador(avaluosEnNegociacion);
            }
        }
    }
}