trigger OpportunityLineItem on OpportunityLineItem (after insert, after update, after delete, before delete) {
	if(Trigger.isAfter){
        if (Trigger.isInsert) {
        	OpportunityLineItemHelper.generarCotizaciones(Trigger.new);    
        }
        
    	if (Trigger.isUpdate) {
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            List<OpportunityLineItem> actualizacionChasis = new List<OpportunityLineItem>();
            List<OpportunityLineItem> actualizarDatosEsquela = new List<OpportunityLineItem>();
            List<ID> productosConChasis = new List<ID>();

        	if (CheckRecursividad.runOnce() || Test.isRunningTest()) {
                for (OpportunityLineItem oli : Trigger.new) {
					if (oli.UnitPrice != Trigger.oldMap.get(oli.ID).UnitPrice) {
						oliList.add(oli);
                    }
                    
                    if (oli.Chasis__c != Trigger.oldMap.get(oli.ID).Chasis__c) {
                        if (String.isNotBlank(oli.Chasis__c) && oli.Chasis__c != 'SIN CHASIS') {
                            productosConChasis.add(oli.ID);
                    	}
                        
                        if (String.isNotBlank(oli.Chasis__c) && String.isBlank(Trigger.oldMap.get(oli.Id).Chasis__c)) {
                            actualizarDatosEsquela.add(oli);
                        }

                        actualizacionChasis.add(oli);
                    }

                    if (oli.Prima__c != Trigger.oldMap.get(oli.Id).Prima__c) {
                        if (oli.Prima__c != null) {
                            if (!actualizarDatosEsquela.contains(oli)) {
                                actualizarDatosEsquela.add(oli);
                            }
                        }
                    }
                }
        	}
            
            if (!oliList.isEmpty()) {
                OpportunityLineItemHelper.actualizarPrecioUnitario(oliList);
            }

            if (!productosConChasis.isEmpty()) {
                OpportunityLineItemHelper.enviarReporte(productosConChasis);
            }

            if (!actualizacionChasis.isEmpty()) {
                OpportunityLineItemHelper.crearDetalleChasis(actualizacionChasis);
            }

            if (!actualizarDatosEsquela.isEmpty()) {
                //OpportunityLineItemHelper.actualizarDatosEsquela(actualizarDatosEsquela);
            }
        }
        
        if (Trigger.IsDelete) {
     		OpportunityLineItemHelper.eliminarCotizaciones(Trigger.old);	   
            //OpportunityLineItemHelper.actualizarDatosEsquela(Trigger.old);
    	}
    }

    if (Trigger.isBefore){
        if (Trigger.isDelete) {
            OpportunityLineItemHelper.validarInformesExistentes(Trigger.old);
            OpportunityLineItemHelper.validarOrdenAbierta(Trigger.old);
        }
    }
}