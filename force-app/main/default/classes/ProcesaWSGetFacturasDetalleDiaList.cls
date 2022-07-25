public class ProcesaWSGetFacturasDetalleDiaList {
    
    public static void getFacturasDetalleDiaList (String linea){
        
        System.debug('ProcesaWSGetFacturasDetalleDiaList.getFacturasDetalleDiaList()');
        
        String anio = ''+Date.today().Year();
        String mes = ''+Date.today().Month();
        String dia = ''+(Date.today().Day());
        
        System.debug('anio: ' + anio);
        System.debug('mes: ' + mes);
        System.debug('dia: ' + dia);
        System.debug('linea: ' + linea);
        
        List<String> errorsList = new List<String>();
        List<ObjRespGetFacturasDetalleDiaList> detalleFactList = new List<ObjRespGetFacturasDetalleDiaList>();
        List<FacturaDetalle__c> detallesFactToUpsert = new List<FacturaDetalle__c>();
        
        HttpResponse response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //QA
        //http://ap1.casapellas.com.ni:9089/GCPSFWSREST/gcpwsrest/FacturasRest/getFacturasDetalleDiaList
        request.setEndpoint(Label.URL_WS_GetFacturasDetalleDiaList);   
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('key', Label.strKey);
        request.setHeader('app', Label.strApp);
        request.setHeader('mod', Label.strModulo);
        request.setHeader('anio', anio );
        request.setHeader('mes', mes);
        request.setHeader('dia', dia);
        request.setHeader('linea', linea);
        request.setTimeout(120000);
        
        
        try{
        	response = http.send(request);
            System.debug('RESPONSE: ' + response);
            
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
               	System.debug('RESPUESTA: ' + response.getBody());
                detalleFactList = ObjRespGetFacturasDetalleDiaList.parse(response.getBody());
                System.debug('REGISTROS DE LA RESPUESTA getFacturasMaestroDia: ' + detalleFactList.size());
                if(detalleFactList.size()>0){
                	for(ObjRespGetFacturasDetalleDiaList f: detalleFactList){
                        FacturaDetalle__c fact				= new FacturaDetalle__c();
                        fact.Cuenta__r						= new Account(CodigoCliente__c = ''+f.codigocliente); 	//Cuenta__c
                        fact.Codigo_de_la_sucursal__c		= f.codigoSucursal;										//Chasis__c
                        fact.CodigoDeLaUnidadDeNegocio__c	= f.codigoUnidadNegocio;								//NumFactura__c
                        fact.NumeroFactura__c				= f.numeroFactura;										//Descripci_n_Linea_de_neogco__c
                        fact.Cantidad__c					= f.cantidad;											//Motor__c
                        fact.Precio__c						= f.precio;												//Descripcion__c
                        fact.TotalLinea__c					= f.totalLinea;		 									//SE LLAMA DESCRIPCION PERO TIENE ETIQUETA CODIGO DEL VEHICULO DescCodigoVehiculo__c
                        fact.CodigoItem__c					= f.codigoItem;											//Descripcion_codigo_del_vehiculo
                        fact.Descripcion__c					= f.descripcion;										//Codigo_del_modelo_generico__c
                        fact.Facturas_Maestro__r			= new FacturasMaestro__c(Id_Externo_Factura__c = f.numeroFactura+'_'+f.codigocliente+'_'+f.codigoSucursal+'_'+f.codigoUnidadNegocio);
                        
                        System.debug('================DETALLE FACTURA===============');
                        System.debug('Código de Cliente: '	 		+ f.codigocliente);
                        System.debug('Código de Sucursal: ' 		+ f.codigoSucursal);
                        System.debug('Código Unidad de Negocio: ' 	+ f.codigoUnidadNegocio);
                        System.debug('Número de Factura: ' 			+ f.numeroFactura);
                        System.debug('Cantidad: ' 					+ f.cantidad);
                        System.debug('Precio: ' 					+ f.precio);
                        System.debug('Total Linea: ' 				+ f.totalLinea);
                        System.debug('Código Item: ' 				+ f.codigoItem);
                        System.debug('Descripción: ' 				+ f.descripcion);
                        System.debug('Llave factura: ' 				+ f.numeroFactura+'_'+f.codigocliente+'_'+f.codigoSucursal+'_'+f.codigoUnidadNegocio);
                        
                        detallesFactToUpsert.add(fact);
                        
                   	}
                    
                    if(detallesFactToUpsert.size()>0){
                        Database.SaveResult[] srList = Database.insert(detallesFactToUpsert, false);
                
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
                                
                            }else {
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                                    System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                                    errorsList.add('Ha ocurrido un error en la UDC:' + err.getStatusCode() + ': ' + err.getMessage() + '\n' + 'Los campos que interfieren en el error son: ' + err.getFields()+ '\n\n');
                                }
                            }
                       } 
                    
                        if(errorsList.size()>0){
                            //ProcesaWSClientes.notificaLlamadoWS(errorsList);
                        }
                    }
                }
                
            }
            
            
            
        }catch (CallOutException ex){/*generaSolicitudEmail('Hubo una excepcion: ' + ex.getMessage() +', '+ ex.getStackTraceString());*/
        	System.debug('Excepción: ' + ex.getMessage());
        }
    	
	}

}