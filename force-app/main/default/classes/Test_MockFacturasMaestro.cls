@isTest
global class Test_MockFacturasMaestro implements WebServiceMock {
 
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
        ws_Clientes.GetFacturasMaestroDiaResponse response_x = new ws_Clientes.GetFacturasMaestroDiaResponse();
        response_x.return_x = '<ListaFacturas>'+
           +'<Factura>'+
           +'   <CP>505</CP>'+
           +'   <ciudad></ciudad>'+
           +'   <codSucursal>11012</codSucursal>'+
           +'   <codigoCliente>331053</codigoCliente>'+
           +'   <contacto></contacto>'+
           +'   <direccion1></direccion1>'+
           +'   <direccion2></direccion2>'+
           +'   <fecha>2020-01-18T15:32:41.946</fecha>'+
           +'   <fechaVence>2020-01-18T15:32:41.946</fechaVence>'+
           +'   <lineaNegocio>1101203</lineaNegocio>'+
           +'   <montoRecibido>29.337833</montoRecibido>'+
           +'   <nombreCliente>SALAZAR BENAVIDES CARLOS</nombreCliente>'+
           +'   <nombreVendedor>GUIDO VARGAS FREDDY DE JESUS</nombreVendedor>'+
           +'   <numeroFactura>627</numeroFactura>'+
           +'   <pais></pais>'+
           +'   <saldo>0.0</saldo>'+
           +'   <status></status>'+
           +'   <tipo>Y1</tipo>'+
           +'   <totalFactura>25.511032</totalFactura>'+
           +'   <totalImpuesto>3.8268021552552502</totalImpuesto>'+
           +'</Factura>'+
           +'</ListaFacturas>';
        // end
        response.put('response_x', response_x); 
   }


}