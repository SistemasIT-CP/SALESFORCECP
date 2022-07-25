public class Opp_Financiamiento_Interno {
    
    @AuraEnabled
    public static List<String> getOpportunity (Id recordId) {
        
        List<String> retorno = new List<String>();
        
        String nombre_oppFI; 
        String tipo;
        String etapa;
        String oppId;
        String vendedor_nombre;
        String pasoEtapa;
        String tipo_opp;
        
        
        Opportunity oppPrincipal = [SELECT Id, Name,AccountId,Account.Name, Forma_de_pago__c,Forma_de_Pago_Multiple__c , StageName,RecordTypeName__c
                                    FROM Opportunity WHERE Id = :recordId LIMIT 1];
        System.debug(oppPrincipal);
        
        ID finInterno = Schema.SObjectType.Opportunity
                                .getRecordTypeInfosByDeveloperName()
                                .get('Financiamiento_Interno')
                                .getRecordTypeId();
        
        
        Id nombre_cuenta = oppPrincipal.AccountId;						//Obtener Id de la cuenta de la Opp Principal
        System.debug('Id de la cuenta' + nombre_cuenta);				
        
        String nombre_oportunidad = oppPrincipal.Name;					//Nombre de la Opp Principal
        
        String forma_pago = oppPrincipal.Forma_de_Pago_Multiple__c;		//Saber la forma de pago 
        System.debug('Las formas de pago son : ' + forma_pago);
        
        
        /******** Financiamiento Interno ********/
        if (forma_pago.contains('Ciclo Casa Pellas') || forma_pago.contains('Go Leasing')) {
            
            System.debug([SELECT AccountId, Name FROM Opportunity WHERE RecordTypeId =: finInterno]);
            
            try {
                
                Opportunity oppFI = [SELECT Id, Name, Forma_de_pago__c, StageName,RecordTypeName__c,Vendedor__c, RecordTypeId
                                     FROM Opportunity WHERE RecordTypeId =: finInterno
                                     AND AccountId =: nombre_cuenta AND Name =: nombre_oportunidad];
                
                System.debug(nombre_cuenta);
                System.debug('Opp Financiamiento Interno: ' + oppFI);
                
                System.debug(oppFI);
                
                
                nombre_oppFI= oppFI.Name;					//Nombre de a Oportunidad F. Bancario
                retorno.add(nombre_oppFI);
                
                tipo = oppFI.RecordTypeName__c;	 			// Tipo de la oportunidad = F. Bancario
                retorno.add(tipo);
                
                etapa = (String)oppFI.StageName;				// Etapa de la oportunidad
                retorno.add(etapa);
                
                oppId = oppFI.Id;							//Id e la oportunidad
                retorno.add(oppId);
                System.debug('Id: ' + oppId);
                
                String vendedorId = oppFI.Vendedor__c;				// Vendedor de la oportunidad (Id)
                
                try {
                    
                    User vendedor = [SELECT Id, Name FROM User WHERE Id=: vendedorId LIMIT 1];
                    //User vendedorOpp = vendedor[0];
                    vendedor_nombre = vendedor.Name;
                    retorno.add(vendedor_nombre);
                    System.debug('Vendedor:' + vendedor_nombre);
                    
                } catch (Exception e) {
                    
                    vendedor_nombre = 'No asignado';
                    retorno.add(vendedor_nombre);
                    System.debug('Vendedor:' + vendedor_nombre);
                    
                }
                
                
                /** Etapas de Financiamiento Interno **/
                String [] arrayEtapa = new String[8];
                
                arrayEtapa[0] = 'Oportunidad Identificada';
                arrayEtapa[1] = 'Pre - Filtro';
                arrayEtapa[2] = 'Recopilar Información';
                arrayEtapa[3] = 'Información Completa';
                arrayEtapa[4] = 'Aprovación Por Comité';
                arrayEtapa[5] = 'Firma de Contrato';
                arrayEtapa[6] = 'Esperando Facturación';
                arrayEtapa[7] = 'Cerrada';     
                
                for (integer i = 0; i<arrayEtapa.size();i++) {
                    
                    if (arrayEtapa[i].containsIgnoreCase(etapa)) {
                        
                        pasoEtapa = String.valueOf(i+1);
                        System.debug('Número de etapa: ' + pasoEtapa);
                        retorno.add(pasoEtapa);
                        continue;
                    } 
                } 
                
                tipo_opp = 'FI';
                retorno.add(tipo_opp);
                
            } // if Financiamiento Interno
            
            catch (Exception e) {
                
                
                System.debug('No hay oportunidad paralela del tipo Financiamiento Banacario');
                
                nombre_oppFI = 'NE'; 
                retorno.add(nombre_oppFI);
                
                tipo = 'NE';
                retorno.add(tipo);
                
                etapa = 'NE';
                retorno.add(etapa);
                
                oppId = 'NE';
                retorno.add(oppId);
                
                vendedor_nombre = 'NE';
                retorno.add(vendedor_nombre);
                
                pasoEtapa = 'NE';
                retorno.add(pasoEtapa);
                
                tipo_opp = 'NE';
                retorno.add(tipo_opp);
                
            }
            
            
            
        } else {
            
            
                System.debug('No hay oportunidad paralela del tipo Financiamiento Banacario');
                
                nombre_oppFI = 'NE'; 
                retorno.add(nombre_oppFI);
                
                tipo = 'NE';
                retorno.add(tipo);
                
                etapa = 'NE';
                retorno.add(etapa);
                
                oppId = 'NE';
                retorno.add(oppId);
                
                vendedor_nombre = 'NE';
                retorno.add(vendedor_nombre);
                
                pasoEtapa = 'NE';
                retorno.add(pasoEtapa);
                
                tipo_opp = 'NE';
                retorno.add(tipo_opp);
            
            
        }
        
        System.debug(retorno);
        return retorno;
        
    }
}