public class CallWSGuardarClienteCredito {
 public static void guardarClienteCredito (String numCliente){
     
      //Para debug de clientes en la tabla de credito
        List<Debug_log__c> debugToCredito = new List<Debug_log__c>();
          
            ClientesWS.wsClientesPort portObj = new ClientesWS.wsClientesPort(); 
            portObj.timeout_x = 120000; 
            String resp = portObj.InsertarClientesCredito(Label.strKey, 
                                                        Label.strApp, 
                                                        Label.strModulo, 
                                                        numCliente
                                                        );
     System.debug('respuesta:'+ resp);
     if (resp != 'Bien')
     {      
        Debug_log__c dlerror = new Debug_log__c();
        dlerror.Error__c = 'Cliente credito';
        dlerror.XML__c =resp;   
        dlerror.ID_Objeto__c=numCliente;
        insert dlerror;
         
         
     }
            
     
    }
}