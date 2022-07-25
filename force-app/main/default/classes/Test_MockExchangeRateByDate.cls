@isTest
global class Test_MockExchangeRateByDate implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetExchangeRateByDateResponse response_x = new WS_InformeNegociaciones.GetExchangeRateByDateResponse();
        response_x.return_x = 0;

        response.put('response_x', response_x); 
   }


}