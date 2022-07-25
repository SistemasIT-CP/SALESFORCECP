@isTest
global class Test_MockWSAccesorios implements WebServiceMock {
   
   	global String consecutivo1;
    global String consecutivo2;
    
    global Test_MockWSAccesorios(String con1, String con2) {
        consecutivo1 = con1;
        consecutivo2 = con2;
    }
    
    global Test_MockWSAccesorios(String con1) {
        consecutivo1 = con1;
    }
    
    global Test_MockWSAccesorios() {}
    
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
        
            System.debug(requestName);

               if (requestName == 'InsertarObjeto') {
                   	WS_InformeNegociaciones.InsertarObjetoResponse response_x = new WS_InformeNegociaciones.InsertarObjetoResponse();
                    response_x.return_x = 'Bien';
                    response.put('response_x', response_x); 
               } else if(requestName =='GetAccesoriosDisponibles') {
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
               } else if (requestName =='GetAccesoriosEstadoDisponibilidad') {
                   WS_InformeNegociaciones.GetAccesoriosEstadoDisponibilidadResponse response_x = new WS_InformeNegociaciones.GetAccesoriosEstadoDisponibilidadResponse();
                    response_x.return_x = '<ListConsultaInventarioEstado>'+
                                            +'<listInventario>'+
                                                +'<estado>Disponible</estado>'+
                                                +'<inopar>70KALFOMBRAJIMNY</inopar>'+
                                            +'</listInventario>'+
                                            +'<listInventario>'+
                                                +'<estado>No disponible</estado>'+
                                                +'<inopar>10BBLD616DYXX</inopar>'+
                                            +'</listInventario>'+
                                            +'<listInventario>'+
                                                +'<estado>Poca Disponibilidad</estado>'+
                                                +'<inopar>70ANS40D</inopar>'+
                                            +'</listInventario>'+
                                            +'<listInventario>'+
                                                +'<estado>No disponible</estado>'+
                                                +'<inopar>70KPOLARIZBRONZE</inopar>'+
                                            +'</listInventario>'+ //
                                            +'<listInventario>'+
                                                +'<estado>No disponible</estado>'+
                                                +'<inopar>70D1985077010</inopar>'+
                                            +'</listInventario>'+
                        					+'<listInventario>'+
                                                +'<estado>No disponible</estado>'+
                                                +'<inopar>70H1500034368</inopar>'+
                                            +'</listInventario>'+
                                            +'<listInventario>'+
                                                +'<estado>Disponible</estado>'+
                                                +'<inopar>70KMOCHIM</inopar>'+
                                            +'</listInventario>'+
                                        +'</ListConsultaInventarioEstado>';
            
                    response.put('response_x', response_x); 
               } else if (requestName=='GetAccesoriosDespachados') {
                   	WS_InformeNegociaciones.GetAccesoriosDespachadosResponse response_x = new WS_InformeNegociaciones.GetAccesoriosDespachadosResponse();
                    response_x.return_x = '<ListaConsultaAccesorios>'+
                                            +'<listAUTD16>'+
                                                +'<articu>70D1985077010</articu>'+
                                                +'<articu1>70D1985077010</articu1>'+
                                                +'<cosart>0.00</cosart>'+
                                                +'<sbodeg>32</sbodeg>'+
                                                +'<scant>6</scant>'+
                                                +'<sdesc>TEST DESCRIPTION</sdesc>'+
                                                +'<sfecham>20200813</sfecham>'+
                                                +'<sfechamm>20200814</sfechamm>'+
                                                +'<sflad>68</sflad>'+
                                                +'<shechop>nortiz</shechop>'+
                                                +'<shechopm>nortiz</shechopm>'+
                                                +'<shoram>120412</shoram>'+
                                                +'<shoramm>0</shoramm>'+
                                                +'<sid>35</sid>'+
                                                +'<slinea>35</slinea>'+
                                                +'<snprogr>CRM</snprogr>'+
                                                +'<ssoli>' + consecutivo1 + '</ssoli>'+
                                                +'<vinsta>0.00</vinsta>'+
                                            +'</listAUTD16>'+
                                        +'</ListaConsultaAccesorios>';
                   response.put('response_x', response_x); 
               } else if(requestName=='GetAccesoriosSolicitados') {
                   	WS_InformeNegociaciones.GetAccesoriosSolicitadosResponse response_x = new WS_InformeNegociaciones.GetAccesoriosSolicitadosResponse();
                    response_x.return_x = '<ListaConsultaAccesorios>'+
                                            +'<listAUTD16>'+
                                                +'<articu>UNCODIGOINEXISTENTE</articu>'+
                                                +'<articu1>70D1985077010</articu1>'+
                                                +'<cosart>0.00</cosart>'+
                                                +'<sbodeg>32</sbodeg>'+
                                                +'<scant>6</scant>'+
                                                +'<sdesc>TEST DESCRIPTION</sdesc>'+
                                                +'<sfecham>20200813</sfecham>'+
                                                +'<sfechamm>20200814</sfechamm>'+
                                                +'<sflad>68</sflad>'+
                                                +'<shechop>nortiz</shechop>'+
                                                +'<shechopm>nortiz</shechopm>'+
                                                +'<shoram>120412</shoram>'+
                                                +'<shoramm>0</shoramm>'+
                                                +'<sid>35</sid>'+
                                                +'<slinea>35</slinea>'+
                                                +'<snprogr>CRM</snprogr>'+
                                                +'<ssoli>' + consecutivo2 + '</ssoli>'+
                                                +'<vinsta>0.00</vinsta>'+
                                            +'</listAUTD16>'+
                                        +'</ListaConsultaAccesorios>';
                   response.put('response_x', response_x); 
               } else if(requestName=='GetAccesoriosChasis') {
                   WS_InformeNegociaciones.GetAccesoriosChasisResponse response_x = new WS_InformeNegociaciones.GetAccesoriosChasisResponse();
                        response_x.return_x = '<ListaConsultaChasis>'+
                            +'<listChasisAccesorio>'+
                                +'<cantidad>1</cantidad>'+
                                +'<codigoArticulo>70LKI431310N</codigoArticulo>'+
                                +'<descripcion>JGO DE FORROS PARA KIA PICANTO</descripcion>'+
                                +'<estado>Despachado</estado>'+
                            +'</listChasisAccesorio>'+
                            +'<listChasisAccesorio>'+
                                +'<cantidad>1</cantidad>'+
                                +'<codigoArticulo>70LKI431310N</codigoArticulo>'+
                                +'<descripcion>JGO DE FORROS PARA KIA PICANTO</descripcion>'+
                                +'<estado>Despachado</estado>'+
                            +'</listChasisAccesorio>'+
                            +'<listChasisAccesorio>'+
                                +'<cantidad>1</cantidad>'+
                                +'<codigoArticulo>70LKI431310N</codigoArticulo>'+
                                +'<descripcion>JGO DE FORROS PARA KIA PICANTO</descripcion>'+
                                +'<estado>Despachado</estado>'+
                            +'</listChasisAccesorio>'+
                            +'<listChasisAccesorio>'+
                                +'<cantidad>1</cantidad>'+
                                +'<codigoArticulo>70LKI431310N</codigoArticulo>'+
                                +'<descripcion>JGO DE FORROS PARA KIA PICANTO</descripcion>'+
                                +'<estado>Despachado</estado>'+
                            +'</listChasisAccesorio>'+
                        +'</ListaConsultaChasis>';
                
                        response.put('response_x', response_x); 
               } else if(requestName=='EliminarSolicitud') {
                    WS_InformeNegociaciones.EliminarSolicitudResponse response_x = new WS_InformeNegociaciones.EliminarSolicitudResponse();
                    response_x.return_x = 'Bien';
                    response.put('response_x', response_x); 
               } else if(requestName=='InsertarFacturacionAutomatica') {
                    ws_Oportunidades.InsertarFacturacionAutomaticaResponse response_x = new ws_Oportunidades.InsertarFacturacionAutomaticaResponse();
                    response_x.return_x = 'Bien';
                    response.put('response_x', response_x); 
               } else if(requestName=='EliminarRegistroFactura'){
                   	ws_Oportunidades.EliminarRegistroFacturaResponse response_x = new ws_Oportunidades.EliminarRegistroFacturaResponse();
                    response_x.return_x = 'Bien';
                    response.put('response_x', response_x); 
               } else if(requestName=='GetFacturasAutomaticasPorPeriodo'){
                    ws_Oportunidades.GetFacturasAutomaticasPorPeriodoResponse response_x = new ws_Oportunidades.GetFacturasAutomaticasPorPeriodoResponse();
            		response_x.return_x = ProcesaWSGetFacturasAutomaticas.simulaRespuesta('Autos');
            		response.put('response_x', response_x); 
               } else if(requestName=='VerificarChasisTieneOrden'){
                    ws_Oportunidades.VerificarChasisTieneOrdenResponse response_x = new ws_Oportunidades.VerificarChasisTieneOrdenResponse();
                   if(consecutivo1 == '1'){
                       response_x.return_x = '1';
                   }
                   else{
                       response_x.return_x = '0';
                   }
            		response.put('response_x', response_x); 
               } else if(requestName=='InsertarClientesCredito'){
                   	ClientesWS.InsertarClientesCreditoResponse response_x = new ClientesWS.InsertarClientesCreditoResponse();
                    response_x.return_x = 'Bien';
                    response.put('response_x', response_x); 
               } else if(requestName=='GetFacturasAutomaticas'){
                    if (consecutivo1 == 'Autos') {
                        ws_Oportunidades.GetFacturasAutomaticasResponse response_x = new ws_Oportunidades.GetFacturasAutomaticasResponse();
                        response_x.return_x = ProcesaWSGetFacturasAutomaticas.simulaRespuesta('Autos');
                        response.put('response_x', response_x); 
                    } else {
                        ws_Oportunidades.GetFacturasAutomaticasResponse response_x = new ws_Oportunidades.GetFacturasAutomaticasResponse();
                        response_x.return_x = ProcesaWSGetFacturasAutomaticas.simulaRespuesta('Motos');
                        response.put('response_x', response_x); 
                    }
               } else if(requestName=='GetDevoluciones'){
                    if (consecutivo1 == 'Autos') {
                        ws_Oportunidades.GetDevolucionesResponse response_x = new ws_Oportunidades.GetDevolucionesResponse();
                        response_x.return_x = ProcesaWSGetDevoluciones.simulaRespuesta('Autos');
                        response.put('response_x', response_x); 
                    } else {
                        ws_Oportunidades.GetDevolucionesResponse response_x = new ws_Oportunidades.GetDevolucionesResponse();
                        response_x.return_x = ProcesaWSGetDevoluciones.simulaRespuesta('Motos');
                        response.put('response_x', response_x); 
                    }
               }
   }
}