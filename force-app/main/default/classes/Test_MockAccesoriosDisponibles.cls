@isTest
global class Test_MockAccesoriosDisponibles implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetAccesoriosDisponiblesResponse response_x = new WS_InformeNegociaciones.GetAccesoriosDisponiblesResponse();
        response_x.return_x = '<ListaConsultaInventario>'+
                +'<listInventario>'+
                    +'<inopar>70KALFOMBRAJIMNY</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<inopar>70KALFOMBRAVB</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<inopar>10BBLD616DYXX</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<inopar>70ANS40D</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<inopar>70KMOCHIM</inopar>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<inopar>70KALFOMBRASWIFT</inopar>'+
                +'</listInventario>'+
            +'</ListaConsultaInventario>';

        response.put('response_x', response_x); 
   }


}