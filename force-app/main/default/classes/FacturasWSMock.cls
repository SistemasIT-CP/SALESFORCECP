@isTest
global class FacturasWSMock implements WebServiceMock {
    
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
               
               	if (requestName == 'EliminarRegistroFactura') {	
                    ws_Oportunidades.EliminarRegistroFacturaResponse response_x = new ws_Oportunidades.EliminarRegistroFacturaResponse();
                	response_x.return_x = 'Bien';
					response.put('response_x', response_x); 
                } else if (requestName == 'InsertarFacturacionAutomatica') {
                    ws_Oportunidades.InsertarFacturacionAutomaticaResponse response_x = new ws_Oportunidades.InsertarFacturacionAutomaticaResponse();
        			response_x.return_x = 'Bien';
					response.put('response_x', response_x);
                } else if (requestName == 'GetFacturasAutomaticas') {
                    new MockGetFacturasAutomaticas().doInvoke(	stub, 
                                                                request, 
                                                                response, 
                                                                endpoint, 
                                                                soapAction, 
                                                                requestName, 
                                                                responseNS, 
                                                                responseName, 
                                                                responseType
                                                                );
                } else if (requestName == 'GetDevoluciones') {
                    new MockGetDevoluciones().doInvoke(	stub, 
                                                                request, 
                                                                response, 
                                                                endpoint, 
                                                                soapAction, 
                                                                requestName, 
                                                                responseNS, 
                                                                responseName, 
                                                                responseType
                                                                );
                } else if (requestName == 'GetFacturasAutomaticasPorPeriodo') {
                    new MockGetFacturasAutomaticasPorFecha().doInvoke(	stub, 
                                                                request, 
                                                                response, 
                                                                endpoint, 
                                                                soapAction, 
                                                                requestName, 
                                                                responseNS, 
                                                                responseName, 
                                                                responseType
                                                                );
                }
    }
}