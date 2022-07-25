@isTest
global class Test_MockVehiculoByShortNumber implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetVehiculoByShortNumberResponse response_x = new WS_InformeNegociaciones.GetVehiculoByShortNumberResponse();
        response_x.return_x = '<Vehiculo>'+
               +'<anno>2015</anno>'+
               +'<chassis>L7GPCJLY5F1020991</chassis>'+
               +'<color>AZUL</color>'+
               +'<colorInterno>.</colorInterno>'+
               +'<descCodigoVehiculo>DY125-2A</descCodigoVehiculo>'+
               +'<factura>0</factura>'+
               +'<impAduana>0</impAduana>'+
               +'<motor>DY156FMI F5027023</motor>'+
               +'<numFactura>0</numFactura>'+
               +'<precio>0</precio>'+
            +'</Vehiculo>';

        response.put('response_x', response_x); 
   }


}