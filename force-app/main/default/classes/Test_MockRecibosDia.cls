@isTest
global class Test_MockRecibosDia implements WebServiceMock {
 
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
        WS_InformeNegociaciones.GetAllRecibosDiaResponse response_x = new WS_InformeNegociaciones.GetAllRecibosDiaResponse();
        response_x.return_x = '<ListaRecibos>'+
               +'<Recibo>'+
                  +'<codigoCaja>44</codigoCaja>'+
                  +'<codigoCliente>changedID</codigoCliente>'+
                  +'<codigoCompania>E08</codigoCompania>'+
                  +'<codigoInstrumentoPago>!</codigoInstrumentoPago>'+
                  +'<codigoLinea>20</codigoLinea>'+
                  +'<codigoMonedaAplicada>USD</codigoMonedaAplicada>'+
                  +'<codigoMonedaRecibida>USD</codigoMonedaRecibida>'+
                  +'<codigoSucursal>00060</codigoSucursal>'+
                  +'<codigoTipoRecibo>PR</codigoTipoRecibo>'+
                  +'<codigoUnidadNegocio>6020</codigoUnidadNegocio>'+
                  +'<concepto>PRIMA VEH APV</concepto>'+
                  +'<fecha>2020-07-30T00:00:00.0</fecha>'+
                  +'<montoMonedaAplicada>2252.25</montoMonedaAplicada>'+
                  +'<montoRecibido>2252.25</montoRecibido>'+
                  +'<numeroRecibo>136472</numeroRecibo>'+
            	  +'<refer1>225225</refer1>'+
                  +'<refer2>136472</refer2>'+
            	  +'<refer3>aaaa</refer3>' +
            	  +'<refer3>bbbb</refer3>' +
                  +'<tasa>1</tasa>'+
               +'</Recibo>'+
         	+'</ListaRecibos>';

        response.put('response_x', response_x); 
   }
}