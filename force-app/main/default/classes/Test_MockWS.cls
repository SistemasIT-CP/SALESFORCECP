@isTest
global class Test_MockWS implements WebServiceMock { 
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
        if (requestName == 'InactivarActivarCliente') {
            new Test_MockWSInactivarActivarClientes().doInvoke(stub, 
                                                                request, 
                                                                response, 
                                                                endpoint, 
                                                                soapAction, 
                                                                requestName, 
                                                                responseNS, 
                                                                responseName, 
                                                                responseType
                                                                );
        } else if (requestName == 'GuardarMonedaCliente') {
            new Test_MockWSGuardaMonedaCliente().doInvoke(stub, 
                                                                request, 
                                                                response, 
                                                                endpoint, 
                                                                soapAction, 
                                                                requestName, 
                                                                responseNS, 
                                                                responseName, 
                                                                responseType
                                                                );
        } else if (requestName=='InsertarClientesCredito') {
             new Test_MockWSGuardarClienteCredito(true).doInvoke(stub, 
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

        return;
   }
}