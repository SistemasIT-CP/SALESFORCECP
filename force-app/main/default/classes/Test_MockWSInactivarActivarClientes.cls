@isTest
global class Test_MockWSInactivarActivarClientes implements WebServiceMock { 
 
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        ClientesWS.InactivarActivarClienteResponse response_x = new ClientesWS.InactivarActivarClienteResponse();
        response_x.return_x = 'Bien';
        // end
        response.put('response_x', response_x); 
   }


}