public class Opp_Financiamiento_Bancario {

    
     @AuraEnabled
    public static List<String> getOpportunity (Id recordId) {
        
        List<String> retorno = new List<String>();
        
        String nombre_oppFB; 
        String tipo;
        String etapa;
        String oppId;
        String vendedor_nombre;
        String pasoEtapa;
        String tipo_opp;

        
        Opportunity oppPrincipal = [SELECT Id, Name,AccountId,Account.Name, Forma_de_pago__c,Forma_de_Pago_Multiple__c , StageName,RecordTypeName__c
                                    FROM Opportunity WHERE Id = :recordId LIMIT 1];				//Obtener la Oportunidad Principal
        System.debug(oppPrincipal); 
        
        ID finBancario = Schema.SObjectType.Opportunity
                                .getRecordTypeInfosByDeveloperName()
                                .get('Financiamiento_Bancario')
                                .getRecordTypeId();

        Id nombre_cuenta = oppPrincipal.AccountId;						//Obtener Id de la cuenta de la Opp Principal
        System.debug('Id de la cuenta' + nombre_cuenta);				
        
        String nombre_oportunidad = oppPrincipal.Name;					//Nombre de la Opp Principal
        
        String forma_pago = oppPrincipal.Forma_de_Pago_Multiple__c;		//Saber la forma de pago 
        System.debug('Las formas de pago son : ' + forma_pago);
        
        
        /******** Financiamiento Bancario ********/
        
        if (forma_pago.contains('Financiamiento Bancario')) {
            
            try {
                
                Opportunity oppFB = [SELECT Id, Name, Forma_de_pago__c, StageName,RecordTypeName__c,Account.Name,Vendedor__c
                                     FROM Opportunity WHERE RecordTypeId =: finBancario
                                     AND AccountId=:nombre_cuenta AND Name =:nombre_oportunidad LIMIT 1];
                
                System.debug(nombre_cuenta);
                System.debug('Opp Financiamiento Bancario: ' + oppFB);
                
                // Opportunity oppFB1 = oppFB[0];
                
                System.debug(oppFB);
                
                nombre_oppFB= oppFB.Name;					//Nombre de a Oportunidad F. Bancario
                retorno.add(nombre_oppFB);
                
                tipo = oppFB.RecordTypeName__c;	 			// Tipo de la oportunidad = F. Bancario
                retorno.add(tipo);
                
                etapa = (String)oppFB.StageName;				// Etapa de la oportunidad
                retorno.add(etapa);
                
                oppId = oppFB.Id;							//Id e la oportunidad
                retorno.add(oppId);
                System.debug('Id: ' + oppId);
                
                String vendedorId = oppFB.Vendedor__c;				// Vendedor de la oportunidad (Id)
                
                
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
                
                
                
                /** Etapas de Financiamiento Bancario **/
                String [] arrayEtapa = new String[5];
                
                arrayEtapa[0] = 'Recopilar Información';
                arrayEtapa[1] = 'Información Completa';
                arrayEtapa[2] = 'Formalización Bancaria';
                arrayEtapa[3] = 'Esperando Facturación';
                arrayEtapa[4] = 'Cerrada';
                
                
                for (integer i = 0; i<arrayEtapa.size();i++) {
                    
                    if (arrayEtapa[i].containsIgnoreCase(etapa)) {
                        
                        pasoEtapa = String.valueOf(i+1);					//Etapa actual en número
                        retorno.add(pasoEtapa);
                        continue;
                    } 
                } 
                
                tipo_opp = 'FB';
                retorno.add(tipo_opp);
                
            } // if Financiamiento Bancario
            
            
            catch (Exception e) {
                
                
                System.debug('No hay oportunidad paralela del tipo Financiamiento Banacario');
                
                nombre_oppFB = 'NE'; 
                retorno.add(nombre_oppFB);
                
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
            
        }  else {
            
            
                System.debug('No hay oportunidad paralela del tipo Financiamiento Banacario');
                
                nombre_oppFB = 'NE'; 
                retorno.add(nombre_oppFB);
                
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
        
    } // getOpportunity
    
}