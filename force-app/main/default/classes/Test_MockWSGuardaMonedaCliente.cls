@isTest
global class Test_MockWSGuardaMonedaCliente implements WebServiceMock { 
 
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
        ClientesWS.GuardarMonedaClienteResponse response_x = new ClientesWS.GuardarMonedaClienteResponse();
        response_x.return_x = 'Bien';
        // end
        response.put('response_x', response_x); 
   }


}