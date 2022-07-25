@isTest
global class Test_MockVehiculoByChasis implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetVehiculoByChasisResponse response_x = new WS_InformeNegociaciones.GetVehiculoByChasisResponse();
        response_x.return_x = '<Vehiculo>'+
               +'<anno>0</anno>'+
               +'<factura>0</factura>'+
               +'<numFactura>0</numFactura>'+
            +'</Vehiculo>';

        response.put('response_x', response_x); 
   }


}