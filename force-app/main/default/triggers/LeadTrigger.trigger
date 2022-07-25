trigger LeadTrigger on Lead (before insert, before update, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            LeadHelper.setearUDC(Trigger.new);
            LeadHelper.uppercasearNombres(Trigger.new);
        }
        
        if(Trigger.isUpdate) {
         	ID autoloteID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Autolote')
                                    .getRecordTypeId();

            ID ventasID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Ventas')
                                    .getRecordTypeId();

            ID ventasMotosID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Venta_motos')
                                    .getRecordTypeId();

            ID anfitrionId = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Anfitrion')
                                    .getRecordTypeId();

            List<Lead> actualizarUDCList = new List<Lead>();
            List<Lead> uppercasearNombres = new List<Lead>();
            List<Lead> leadConvertidos = new List<Lead>();

            for (Lead ld : Trigger.new) {
                if (ld.RecordTypeId == autoloteID || 
                        ld.RecordTypeId == ventasID || 
                            ld.RecordTypeId == ventasMotosID ||
                                ld.RecordTypeId == anfitrionId) {
                                    
                    if (ld.Marca_a_cotizar_autolote__c != Trigger.oldMap.get(ld.ID).Marca_a_cotizar_autolote__c ||
                        ld.Marca_a_cotizar__c != Trigger.oldMap.get(ld.ID).Marca_a_cotizar__c ||
                        ld.Modelo_a_cotizar__c != Trigger.oldMap.get(ld.ID).Modelo_a_cotizar__c ||
                        ld.Pais_de_origen__c != Trigger.oldMap.get(ld.ID).Pais_de_origen__c) {
                            actualizarUDCList.add(ld);
                    }
                }

                if (ld.Name != Trigger.oldMap.get(ld.Id).Name || 
                    ld.Company != Trigger.oldMap.get(ld.Id).Company) {
                        uppercasearNombres.add(ld);
                }
                
                if (ld.IsConverted && !Trigger.oldMap.get(ld.ID).IsConverted) {
                    leadConvertidos.add(ld);

                    if (String.isBlank(ld.Title)) {
                    	ld.Title = 'Lead';
                    }
                }
            }
            
            if(!actualizarUDCList.isEmpty()) {
                LeadHelper.setearUDC(actualizarUDCList);
            }
            
            if(!uppercasearNombres.isEmpty()) {
                LeadHelper.uppercasearNombres(uppercasearNombres);
            }

            if(!leadConvertidos.isEmpty()) {
                LeadHelper.validarCamposRequeridosParaConversion(leadConvertidos);
            }
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            List<Lead> leadsJuridicosConvertidos = new List<Lead>();
            List<Lead> leadsPersonalesConvertidos = new List<Lead>();
            List<Lead> conversionDeOportundidad = new List<Lead>();

            for (Lead ld : Trigger.new) {
                if (ld.IsConverted && !Trigger.oldMap.get(ld.ID).IsConverted) {
                    if (String.isNotBlank(ld.Company)) {
                        leadsJuridicosConvertidos.add(ld);
                    } else {
                        leadsPersonalesConvertidos.add(ld);
                    }

                    if (String.isNotBlank(ld.ConvertedOpportunityId)) {
                        conversionDeOportundidad.add(ld);
                    }
                }
            }

            if (!leadsJuridicosConvertidos.isEmpty()) {
                LeadHelper.administrarCuentasContactos(leadsJuridicosConvertidos);
            }

            if (!leadsPersonalesConvertidos.isEmpty()) {
                LeadHelper.corregirEmail(leadsPersonalesConvertidos);
            }

            if (!conversionDeOportundidad.isEmpty()) {
                LeadHelper.setearCamposOportunidad(conversionDeOportundidad);
            }
        }
    }
}