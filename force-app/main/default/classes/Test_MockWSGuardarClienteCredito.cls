@isTest
global class Test_MockWSGuardarClienteCredito implements WebServiceMock { 
      global boolean blnresult;
    
      global  Test_MockWSGuardarClienteCredito(Boolean result){
            blnresult=result;
      }
        
      global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) 
            {
      // start - specify the response you want to send
      ClientesWS.InsertarClientesCreditoResponse response_x = new ClientesWS.InsertarClientesCreditoResponse();
      
      if (blnresult) {
            response_x.return_x = 'Bien';
      } else {
            response_x.return_x = 'Incorrecto';
      }            
      
      // end
      response.put('response_x', response_x); 
      }
}