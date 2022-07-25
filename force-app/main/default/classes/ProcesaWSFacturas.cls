public class ProcesaWSFacturas {
    
    public static void procesaMaestroFactura (String resp){
        System.debug(resp);
        String errors = 'Errores: \n\n';
        List<String> errorsList = new List<String>();
        
        Dom.Document doc = new Dom.Document();  
        //doc.load( new ws_Clientes.wsClientesPort().GetFacturasMaestro(Label.strKey, Label.strApp, Label.strModulo,'2016','2') );  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
        List<FacturasMaestro__c> listFacturas = new List<FacturasMaestro__c>();
        
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
        //for ( Integer i=0; i <rootElement.getChildElements().size(); i++ ) {  
            	FacturasMaestro__c facturaMaestro = new FacturasMaestro__c ();             
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'CP'				{ 
                        facturaMaestro.CP__c 				= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('CP:' + detailElement.getText());
                    }
                    when 'ciudad' 			{ 
                        facturaMaestro.Ciudad__c			= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('ciudad:' + detailElement.getText());
                    }
                    when 'codSucursal' 		{ 
                        facturaMaestro.CodigoSucursal__c 	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('codSucursal:' + detailElement.getText());
                    }
                    when 'codigoCliente'	{ 
                        facturaMaestro.CodigoCliente__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('codigoCliente:' + detailElement.getText());
                    }
                    when 'contacto'		 	{ 
                        facturaMaestro.Contacto__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('contacto:' + detailElement.getText());
                    }
                    when 'direccion1'		{ 
                        facturaMaestro.Direccion_1__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('direccion1:' + detailElement.getText());
                    }
                    when 'direccion2'		{ 
                        facturaMaestro.Direccion_2__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('direccion2:' + detailElement.getText());
                    }
                    when 'fecha'	 		{ 
                        facturaMaestro.Fecha__c	 		= detailElement.getText() .trim() != '' ? Date.valueOf(detailElement.getText().substring(0,10)) : null; 
                    	system.debug('fecha:' + detailElement.getText());
                    } 
                    when 'fechaVence'	 	{ 
                        facturaMaestro.FechaVence__c 		= detailElement.getText() .trim() != '' ? Date.valueOf(detailElement.getText().substring(0,10)) : null; 
                    	system.debug('fechaVence:' + detailElement.getText());
                    } 
                    when 'lineaNegocio'		{ 
                        facturaMaestro.LineaNegocio__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('lineaNegocio:' + detailElement.getText());
                    }
                    when 'montoRecibido'	{ 
                        facturaMaestro.MontoRecibido__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('montoRecibido:' + detailElement.getText());
                    }
                    when 'nombreCliente'	{ 
                        facturaMaestro.NombreCliente__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('nombreCliente:' + detailElement.getText());
                    }
                    when 'nombreVendedor'	{ 
                        facturaMaestro.NombreVendedor__c 	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('nombreVendedor:' + detailElement.getText());
                    }
                    when 'numeroFactura'	{ 
                        facturaMaestro.NumeroFactura__c	= detailElement.getText().trim() != '' ? Integer.valueOf(detailElement.getText()) : 0; 
                    	system.debug('numeroFactura:' + detailElement.getText());
                    }
                    when 'pais'		 		{ 
                        facturaMaestro.Pais__c			= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('pais:' + detailElement.getText());
                    }
                    when 'saldo'			{ 
                        facturaMaestro.SaldoFactura__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('saldo:' + detailElement.getText());
                    }
                    when 'status'	 		{ 
                        facturaMaestro.StatusFactura__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('status:' + detailElement.getText());
                    }
                    when 'tipo'		 		{ 
                        facturaMaestro.TipoFactura__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('tipo:' + detailElement.getText());
                    }
                    when 'totalFactura'		{ 
                        facturaMaestro.TotalFactura__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('totalFactura:' + detailElement.getText());
                    }
                    when 'totalImpuesto'	{ 
                        facturaMaestro.TotalImpuesto__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    	system.debug('totalImpuesto:' + detailElement.getText());
                    }
                    when else 				{  }
                }
            }
        	
            if(facturaMaestro.CodigoCliente__c != ''){
                facturaMaestro.Cuenta__r = new Account(CodigoCliente__c=facturaMaestro.CodigoCliente__c);  
                //facturaMaestro.Cuenta__r = new Account(CodigoCliente__c='110612');  
            	listFacturas.add(facturaMaestro);    
            }
        	
    	}
        
        if(listFacturas.size()>0){
            //NumeroFactura__c
            Schema.SObjectField c = FacturasMaestro__c.Fields.NumeroFactura__c;
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