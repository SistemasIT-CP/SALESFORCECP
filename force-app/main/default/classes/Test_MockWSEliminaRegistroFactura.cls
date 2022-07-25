@isTest
global class Test_MockWSEliminaRegistroFactura implements WebServiceMock { 
 
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
        ws_Oportunidades.EliminarRegistroFacturaResponse response_x = new ws_Oportunidades.EliminarRegistroFacturaResponse();
        response_x.return_x = 'Bien';
        // end
        response.put('response_x', response_x); 
   }


}