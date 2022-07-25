public class ProcesaDetalleFacturas {
    
    public static void procesaDetalleFact (String resp){
        
        String errors = 'Errores: \n\n';
        List<String> errorsList = new List<String>();
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
        List<FacturaDetalle__c> listFacturas = new List<FacturaDetalle__c>();
        
        //for ( Integer i=0; i <rootElement.getChildElements().size(); i++ ) {  
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            	FacturaDetalle__c facturaDetalle = new FacturaDetalle__c ();             
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'codigoItem'				{ 
                        facturaDetalle.CodigoItem__c 				= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('codigoItem:' + detailElement.getText());
                    }
                    when 'descripcion' 			{ 
                        facturaDetalle.Descripcion__c				= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('descripcion:' + detailElement.getText());
                    }
                    when 'descuentoDeLinea' 		{ 
                        facturaDetalle.DescuentoDeLinea__c 	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('descuentoDeLinea:' + detailElement.getText());
                    }
                    when 'numeroFactura'	{ 
                        facturaDetalle.NumeroFactura__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('numeroFactura:' + detailElement.getText());
                    }
                    when 'precio'		 	{ 
                        facturaDetalle.Precio__c		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('precio:' + detailElement.getText());
                    }
                    when 'totalLinea'		{ 
                        facturaDetalle.TotalLinea__c		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('totalLinea:' + detailElement.getText());
                    }
                    when 'unidadOrdenada'		{ 
                        facturaDetalle.UnidadOrdenada__c		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0;  
                    	system.debug('unidadOrdenada:' + detailElement.getText());
                    }
                    when 'unidadSurtida'	 		{ 
                        facturaDetalle.UnidadSurtida__c	 		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0;  
                    	system.debug('unidadSurtida:' + detailElement.getText());
                    } 
                    
                    when else 				{  }
                    
                }
            }
        	
            if(facturaDetalle.NumeroFactura__c != null){
                /*facturaMaestro.Cuenta__r = new Account(CodigoCliente__c=facturaMaestro.CodigoCliente__c);  */
                facturaDetalle.Facturas_Maestro__r = new FacturasMaestro__c(NumeroFactura__c=facturaDetalle.NumeroFactura__c);
                facturaDetalle.IdExt_Detalle_Factura__c = facturaDetalle.CodigoItem__c+'_'+facturaDetalle.NumeroFactura__c;
            	listFacturas.add(facturaDetalle);    
            }
        	
    	}
        
        if(listFacturas.size()>0){
            Schema.SObjectField c = FacturaDetalle__c.Fields.IdExt_Detalle_Factura__c;
			Database.UpsertResult [] srList = Database.upsert(listFacturas, c, false);
            //Database.SaveResult[] srList  = Database.insert(listFacturas, false);
                
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()){
                        
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                            System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                            
                            errorsList.add('Ha ocurrido un error en la FacturaMaestro:' + err.getStatusCode() + ': ' + err.getMessage() + '\n' + 'Los campos que interfieren en el error son: ' + err.getFields()+ '\n\n');
                            
                        }
                    }
               }             	
        }

	}
}