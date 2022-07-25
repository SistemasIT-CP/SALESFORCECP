@isTest
global class MockGetFacturasAutomaticasPorFecha implements WebServiceMock {

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

            ws_Oportunidades.GetFacturasAutomaticasPorPeriodoResponse response_x = new ws_Oportunidades.GetFacturasAutomaticasPorPeriodoResponse();
            response_x.return_x = ProcesaWSGetFacturasAutomaticas.simulaRespuesta('Autos');
            response.put('response_x', response_x); 
       }
}