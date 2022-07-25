@isTest
global class Test_MockAccesoriosDisponibilidad implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetAccesoriosEstadoDisponibilidadResponse response_x = new WS_InformeNegociaciones.GetAccesoriosEstadoDisponibilidadResponse();
        response_x.return_x = '<ListConsultaInventarioEstado>'+
                +'<listInventario>'+
                    +'<estado>Disponible</estado>'+
                    +'<inopar>70KALFOMBRAJIMNY</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<estado>Disponible</estado>'+
                    +'<inopar>10BBLD616DYXX</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<estado>Poca Disponibilidad</estado>'+
                    +'<inopar>70ANS40D</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<estado>No disponible</estado>'+
                    +'<inopar>70KPOLARIZBRONZE</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<estado>No disponible</estado>'+
                    +'<inopar>70D1985077010</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<estado>Disponible</estado>'+
                    +'<inopar>70KMOCHIM</inopar>'+
                +'</listInventario>'+
            +'</ListConsultaInventarioEstado>';

        response.put('response_x', response_x); 
   }


}