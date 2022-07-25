@isTest
global class MockGetProductos implements WebServiceMock {
 
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
        ws_CatalogoProductos.GetProductosResponse response_x = new ws_CatalogoProductos.GetProductosResponse();
        response_x.return_x = '<ListaConsultaProductos>'+
            +'<listInventario>'+
                +'<aniomodelo>2021  </aniomodelo>'+
                +'<aniovehiculo>2020  </aniovehiculo>'+
                +'<codigocolorexterno>Z2S   </codigocolorexterno>'+
                +'<codigocolorinterno>.</codigocolorinterno>'+
                +'<codigomarca>04    </codigomarca>'+
                +'<codigomodelofabrica>AF416P</codigomodelofabrica>'+
                +'<codigomodelogenerico>S02</codigomodelogenerico>'+
                +'<codigovehiculo>PANEL C/A</codigovehiculo>'+
                +'<colorexterno>PLATEADO</colorexterno>'+
                +'<colorinterno>.</colorinterno>'+
                +'<descripcion>VEHÍCULO TIPO PANEL AÑO 2021  </descripcion>'+
                +'<especificaciones>00690064006F005C00660031005C007000610072000D000A007D000D000A00</especificaciones>'+
                +'<marca>SUZUKI</marca>'+
                +'<modelofabrica>AF416PVM61144 / APV PANEL</modelofabrica>'+
                +'<modelogenerico>Add purchase cat P2 codes here</modelogenerico>'+
                +'<idproducto>44829</idproducto>'+
            +'</listInventario>'+
            +'</ListaConsultaProductos>';

        response.put('response_x', response_x); 
   }
}