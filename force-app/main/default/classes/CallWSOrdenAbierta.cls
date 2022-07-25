public with sharing class CallWSOrdenAbierta {
    /*Validar si el chasis tiene una orden abierta*/
    @AuraEnabled
    public static String validaChasisOrdenAbierta (Id opportunityId) {
        Integer OrdenesAbiertas=0;
       // System.debug('ENTRO A VALIDAR ORDEN ABIERTA  '+ opportunityId);
       List<Informe_de_Negociaci_n__c> infList= [
           SELECT ID, Chasis__c FROM 
           Informe_de_Negociaci_n__c 
           WHERE Oportunidad__c=: opportunityId
       ];
     
       if (infList.isEmpty())
       {
        return 'Debe existir un informe de negociacion en la oportunidad para verificar si hay orden abierta.';
       }

       for (Informe_de_Negociaci_n__c inf: infList) {
       
            if (String.isBlank(inf.Chasis__c)) {
                return 'Debe existir un chasis en la oportunidad para verificar si hay orden abierta.';
            }

           String resp=tieneOrdenAbierta(inf.Chasis__c);
            if (resp == '1')
            {
                inf.OrdenAbierta__c='1';  
                OrdenesAbiertas= OrdenesAbiertas+1;
            }else {
                inf.OrdenAbierta__c='0';   
            }  
       }
       
       update infList;

       if ( OrdenesAbiertas >0)
       {       
        return 'Existe una orden abierta en JDE';
       
       }else {
           {            
            return 'Ok: No hay orden abierta para los chasis asociados a esta oportunidad';         
           
           }
       }      
   }

   public static string tieneOrdenAbierta(String chasis ){

       ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort(); 
       portObj.timeout_x = 120000;
                 
       String resp = portObj.VerificarChasisTieneOrden(Label.strKey,Label.strApp, Label.strModulo, chasis);
       system.debug(resp);
       return resp;
   }

}