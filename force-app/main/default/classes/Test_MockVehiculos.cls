@isTest
global class Test_MockVehiculos implements WebServiceMock {
 
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
        ws_clientes.GetACVehiculosResponse response_x = new ws_clientes.GetACVehiculosResponse();
        response_x.return_x = '<VehiculoCollection>'+
               +'<Vehiculo>'+
                  +'<MPP>false</MPP>'+
                  +'<anno>2007</anno>'+
                  +'<chassis>JS2YA21SX75100279</chassis>'+
                  +'<estado>I</estado>'+
                  +'<factura>0</factura>'+
                  +'<marca>SUZUKI</marca>'+
                  +'<modelo>SWIFT</modelo>'+
                  +'<motor>M16A-1202513</motor>'+
                  +'<numFactura>0</numFactura>'+
                  +'<recorrido>5250</recorrido>'+
                  +'<tipo></tipo>'+
               +'</Vehiculo>'+
            +'</VehiculoCollection>';

        response.put('response_x', response_x); 
   }


}