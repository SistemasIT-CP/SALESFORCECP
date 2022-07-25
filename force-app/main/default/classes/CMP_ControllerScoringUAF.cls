public class CMP_ControllerScoringUAF {
 
    @AuraEnabled
    public static Calificacion getCalificacionCliente(String recordId) 
    {
       try 
       {
            Calificacion calificacionesLst = new Calificacion();
            Opportunity op = 
                [SELECT Id, AccountId, RecordTypeId, Name, Description, StageName,Tipo_de_relaci_n_econ_mica__c 
                FROM Opportunity 
                where Id=:recordId
                ];
           
            List<Calificaci_n_del_cliente__c> calificacionesClientes = 
                [SELECT Id, Name, Oportunidad__c, Cuenta__c, Tipo_de_Cliente__c, Criterio__c, 
                          Descripci_n__c,Calificaci_n__c, Ponderaci_n__c, Total__c,Tipo__c 
                  FROM Calificaci_n_del_cliente__c 
                  where Oportunidad__c =:op.Id 
                 		AND Cuenta__c=:op.AccountId 
                 		AND Tipo__c='CC'
                ];
           
            system.debug('calificacionesClientes '+calificacionesClientes);
            Calificacion califObj=new Calificacion();
            califObj.Tipocliente=calificacionesClientes[0].Tipo_de_Cliente__c;
            califObj.Nombre=calificacionesClientes[0].Name;
            califObj.Total=calificacionesClientes[0].Total__c;
            califObj.CalificacionFinal=calificacionesClientes[0].Ponderaci_n__c;
            califObj.calificaciones=calificacionesClientes;
            calificacionesLst=califObj;
            
            system.debug('calificacionesLst '+calificacionesLst);
           
        return calificacionesLst;
           
       }
       catch(Exception err)
       {
           throw new AuraHandledException('Error detectado '+err.getMessage()+' Linea '+err.getLineNumber());
       } 

    }
    
    @AuraEnabled
    public static CalificacionOP getCalificacionOportunidad(String recordId) {
        try{
            CalificacionOP calificacionesLst=new CalificacionOP();
            Opportunity op = [
                SELECT Id, AccountId, RecordTypeId, Name, Description, StageName,
                Tipo_de_relaci_n_econ_mica__c,Canal_Contrata__c,
                Sucursal__c,Forma_de_Pago_UAF__c,Tipo_de_transacci_n__c,
                Responsable_del_pago__c,Origen_de_los_fondos__c
                FROM Opportunity 
                where Id=:recordId
            ];
            
            List<Calificaci_n_del_cliente__c> calificacionesClientesOP = [
                SELECT Id, Name, Oportunidad__c, Cuenta__c, Tipo_de_Cliente__c, Criterio__c, 
                Descripci_n__c,Calificaci_n__c, Ponderaci_n__c, Total__c,Tipo__c 
                FROM Calificaci_n_del_cliente__c 
                where Oportunidad__c =:op.Id 
                AND Cuenta__c=:op.AccountId 
                AND Tipo__c='CO'
            ];
            
            system.debug('calificacionesOPs '+calificacionesClientesOP);
            CalificacionOP califObjO=new CalificacionOP();
            
            califObjO.TotalOP=calificacionesClientesOP[0].Total__c;
            califObjO.CalificacionFinalOP=calificacionesClientesOP[0].Ponderaci_n__c;
            califObjO.calificacionesOP=calificacionesClientesOP;
            calificacionesLst=califObjO;
            
            system.debug('calificacionesLst '+calificacionesLst);
            
            return calificacionesLst;
        }
        catch(Exception err){
            throw new AuraHandledException('Error detectado '+err.getMessage()+' Linea '+err.getLineNumber());
        } 
    }
    
    public class Calificacion
    {
        @AuraEnabled
        public Decimal Total{set;get;}
        @AuraEnabled
        public String CalificacionFinal {set;get;}
        @AuraEnabled
        public String Tipocliente {set;get;}
        @AuraEnabled
        public String Nombre {set;get;}
        @AuraEnabled
        public List<Calificaci_n_del_cliente__c> calificaciones{set;get;}
        @AuraEnabled
        public List<Calificaci_n_del_cliente__c> calificacionesOp{set;get;} 
       
    }
    
    public class CalificacionOP
    {
        @AuraEnabled
        public Decimal TotalOP{set;get;}
        @AuraEnabled
        public String CalificacionFinalOP {set;get;}
        @AuraEnabled
        public List<Calificaci_n_del_cliente__c> calificacionesOP{set;get;} 
       
    }
}