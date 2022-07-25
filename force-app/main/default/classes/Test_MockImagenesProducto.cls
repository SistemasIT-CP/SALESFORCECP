@isTest
global class Test_MockImagenesProducto implements WebServiceMock {
 
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
        ws_CatalogoProductos.GetProductosImagenesDiaResponse response_x = new ws_CatalogoProductos.GetProductosImagenesDiaResponse();
        response_x.return_x = '<ListaConsultaProductos>'+
                +'<listInventario>'+
                    +'<codigovehiculo>VITARA M/T 4X2</codigovehiculo>'+
                    +'<idproducto>305011</idproducto>'+
                    +'<urlimagen>URL</urlimagen>'+
                +'</listInventario>'+
                +'<listInventario>'+
                    +'<codigovehiculo>CELERIO-DLX</codigovehiculo>'+
                    +'<idproducto>305007</idproducto>'+
                    +'<urlimagen>URL</urlimagen>'+
                +'</listInventario>'+
            +'</ListaConsultaProductos>';

        response.put('response_x', response_x); 
   }


}