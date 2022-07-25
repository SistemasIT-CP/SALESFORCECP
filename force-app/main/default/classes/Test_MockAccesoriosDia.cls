@isTest
global class Test_MockAccesoriosDia implements WebServiceMock {
 
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
        ws_AccesoriosService.GetAccesoriosDiaResponse response_x = new ws_AccesoriosService.GetAccesoriosDiaResponse();
        response_x.return_x = '<ListaConsultaProductos>'+
                '<listInventario>'+
                    '<compania>CASA PELLAS, S.A.</compania>'+
                    '<icompan>01</icompan>'+
                    '<idesci>COVER DE LONA PARA HILUX DC 2016+</idesci>'+
                    '<idescr>COVER DE LONA  </idescr>'+
                    '<ifechi1>20160503</ifechi1>'+
                    '<ifecmod>20200707</ifecmod>'+
                    '<ifeule>187</ifeule>'+
                    '<inopar>70IPH3B10KA11    </inopar>'+
                    '<inpare>70LCOVERLONA     </inpare>'+
                    '<iprven>349</iprven>'+
               '</listInventario>'+
           +'</ListaConsultaProductos>';
        // end
        response.put('response_x', response_x); 
   }


}