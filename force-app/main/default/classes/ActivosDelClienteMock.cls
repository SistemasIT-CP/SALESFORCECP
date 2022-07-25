@isTest
global class ActivosDelClienteMock implements WebServiceMock { 
    
 global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
 		{
            // start - specify the response you want to send
            ws_Clientes.GetACVehiculosClienteResponse response_x = new ws_Clientes.GetACVehiculosClienteResponse();
            response_x.return_x = 
                '<VehiculoCollection>' +
                    '<listInventario>' +
                        '<anno>2021</anno>' +
                        '<chassis>123456</chassis>' +
                        '<codigoMarca></codigoMarca>' +
                        '<codigoModeloFabrica></codigoModeloFabrica>' +
                        '<codigoModeloGenerico></codigoModeloGenerico>' +
                        '<codigoVehiculo></codigoVehiculo>' +
                        '<descripcion></descripcion>' +
                        '<descripcionCodigoVehiculo></descripcionCodigoVehiculo>' +
                        '<descripcionLinea></descripcionLinea>' +
                        '<descripcionMarca>TEST</descripcionMarca>' +
                        '<descripcionModeloFabrica></descripcionModeloFabrica>' +
                        '<descripcionModeloGenerico>TEST</descripcionModeloGenerico>' +
                        '<estado>TEST</estado>' +
                        '<fechaVenta>19-02-2015</fechaVenta>' +
                        '<kilometraje>123</kilometraje>' +
                        '<MPP>true</MPP>' +
                        '<motor>TEST</motor>' +
                        '<numFactura>123</numFactura>' +
                        '<placa>123</placa>' +
                        '<codigocliente>changeID</codigocliente>' +
                    '</listInventario>' +
                    '</VehiculoCollection>';
            // end
            response.put('response_x', response_x); 
		}
}