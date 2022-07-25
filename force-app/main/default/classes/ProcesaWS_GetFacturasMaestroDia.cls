public class ProcesaWS_GetFacturasMaestroDia {
    
    public static void getFacturasMaestroDia (){
        
        System.debug('CallWS_GetVehiculosList.getVehiculosList()');
        
        String anio = ''+Date.today().Year();
        String mes = ''+Date.today().Month();
        String dia = ''+(Date.today().Day());
        
        System.debug('anio: ' + anio);
        System.debug('mes: ' + mes);
        System.debug('dia: ' + dia);
        
        List<String> errorsList = new List<String>();
        List<ObjResponseGetFacturaMestroDia> facturasList = new List<ObjResponseGetFacturaMestroDia>();
        List<FacturasMaestro__c> facturasToUpsert = new List<FacturasMaestro__c>();
        
        HttpResponse response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //QA
        // https://app.casapellas.com.ni:9445/GCPSFWSREST/gcpwsrest/ClientesRest/getClientesList
        request.setEndpoint(Label.getFacturasMaestroDia);   
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('key', Label.strKey);
        request.setHeader('app', Label.strApp);
        request.setHeader('mod', Label.strModulo);
        request.setHeader('anio', anio );
        request.setHeader('mes', mes);
        request.setHeader('dia', dia);
        request.setTimeout(120000);
        
        
        try{
        	response = http.send(request);
            System.debug('RESPONSE: ' + response);
            
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
               	System.debug('RESPUESTA: ' + response.getBody());
                facturasList = ObjResponseGetFacturaMestroDia.parse(response.getBody());
                System.debug('REGISTROS DE LA RESPUESTA getFacturasMaestroDia: ' + facturasList.size());
                if(facturasList.size()>0){
                	for(ObjResponseGetFacturaMestroDia f: facturasList){
                        FacturasMaestro__c Factura					= new FacturasMaestro__c();
                        Factura.NumeroFactura__c					= f.numeroFactura; 										//Cuenta__c
                        Factura.TipoFactura__c						= f.tipoFactura;										//Chasis__c
                        Factura.Cuenta__r	 						= new Account(CodigoCliente__c = ''+f.codigoCliente);	//Factura__c
                        Factura.CodigoSucursal__c			 		= f.codigoSucursal;										//Descripci_n_Linea_de_neogco__c
                        Factura.Compania__c							= f.codigoCompania;										//Motor__c
                        Factura.Codigo_de_la_unidad_de_negocio__c	= f.codigoUnidadNegocio;								//Descripcion__c
                        Factura.NombreVendedor__c					= f.nombreVendedor; 									//SE LLAMA DESCRIPCION PERO TIENE ETIQUETA CODIGO DEL VEHICULO DescCodigoVehiculo__c
                        Factura.LineaNegocio__c						= f.codigoLineaNegocio;									//Descripcion_codigo_del_vehiculo
                        Factura.Moneda__c							= f.moneda;												//Codigo_del_modelo_generico__c
                        Factura.Tasa__c								= f.tasa;												//Descripcion_del_modelo_generico
                        Factura.Subtotal__c							= f.subTotal;											//marca__c
                        Factura.TotalFactura__c						= f.total;												//Descripcion_de_la_marca__c
                        Factura.Fecha__c							= f.fecha != null ? Date.valueOf(f.fecha.substring(0,10)) : null;	//Codigo_modelo_fabrica__c
                        Factura.Id_Externo_Factura__c				= f.numeroFactura+'_'+f.codigoCliente+'_'+f.codigoSucursal+'_'+f.codigoUnidadNegocio;
                        facturasToUpsert.add(factura);
                        
                        System.debug('================DETALLE FACTURA===============');
                        System.debug('numeroFactura: '	 			+ f.numeroFactura);
                        System.debug('tipoFactura: ' 				+ f.tipoFactura);
                        System.debug('codigoCliente: ' 				+ f.codigoCliente);
                        System.debug('codigoSucursal: ' 			+ f.codigoSucursal);
                        System.debug('codigoCompania: ' 			+ f.codigoCompania);
                        System.debug('codigoUnidadNegocio: ' 		+ f.codigoUnidadNegocio);
                        System.debug('nombreVendedor: ' 			+ f.nombreVendedor);
                        System.debug('codigoLineaNegocio: ' 		+ f.codigoLineaNegocio);
                        System.debug('tasa: ' 						+ f.tasa);
                        System.debug('subtotal: ' 					+ f.subtotal);
                        System.debug('total: ' 						+ f.total);
                        System.debug('fecha: ' 						+ f.fecha);
                        System.debug('IdExterno: ' 					+ f.numeroFactura+'_'+f.codigoCliente+'_'+f.codigoSucursal+'_'+f.codigoUnidadNegocio);
                        
                   	}
                    
                    if(facturasToUpsert.size()>0){
                        Database.SaveResult[] srList  = Database.insert(facturasToUpsert, false);
                
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