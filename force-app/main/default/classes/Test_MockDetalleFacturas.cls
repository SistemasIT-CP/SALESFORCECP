@isTest
global class Test_MockDetalleFacturas implements WebServiceMock {
 
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
        ws_Clientes.GetFacturaDetalleDiaResponse response_x = new ws_Clientes.GetFacturaDetalleDiaResponse();
        response_x.return_x = '<ListaFacturaDetalle>'+
           +'<FacturaDetalle>'+
              +'<codigoItem>23B86130G6000</codigoItem>'+
              +'<descripcion>MOLDURA DE VIDR</descripcion>'+
              +'<descuentoDeLinea>0</descuentoDeLinea>'+
              +'<numeroFactura>627</numeroFactura>'+
              +'<precio>25.511032156589635633281432092189788818359375</precio>'+
              +'<totalLinea>25.511032156589635633281432092189788818359375</totalLinea>'+
              +'<unidadOrdenada>1</unidadOrdenada>'+
              +'<unidadSurtida>0</unidadSurtida>'+
           +'</FacturaDetalle>'+
           +'</ListaFacturaDetalle>';

        response.put('response_x', response_x); 
   }


}