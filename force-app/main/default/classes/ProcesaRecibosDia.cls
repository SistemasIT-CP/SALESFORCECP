public class ProcesaRecibosDia {
	@future(callout = true)
    public static void procesaRecibos (){
    	procesaRecibosNow();    
    }
    
    public static void procesaRecibosNow (){
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        
        String anio;
        String mes;
        String dia;
        
        Ejecucion_Personalizada_WS__mdt [] ejecucion = 
            [SELECT MasterLabel, Activo__c, Fecha_de_ejecucion__c 
             FROM Ejecucion_Personalizada_WS__mdt 
             WHERE MasterLabel = 'RECIBOS' 
             		AND Activo__c = true 
             		AND Fecha_de_ejecucion__c != null 
             LIMIT 1
            ];
        
        if (ejecucion.size() == 1) {
            anio	= '' + ejecucion[0].Fecha_de_ejecucion__c.Year();		
            mes		= '' + ejecucion[0].Fecha_de_ejecucion__c.Month();		
            dia		= '' + ejecucion[0].Fecha_de_ejecucion__c.Day();
        } else {
            anio	= '' + Date.today().Year();
            mes 	= '' + Date.today().Month();
            dia 	= '' + Date.today().Day();
        }    
       
        String resp = port.GetAllRecibosDia(Label.strKey, Label.strApp, Label.strModulo, anio, mes, dia);
        
        Id rtId_Recibo = 
            [SELECT id 
             FROM RecordType 
             WHERE sObjectType='AllRecibidos__c' 
             		AND DeveloperName ='Principal'].Id;
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('cantidad de recibos: ' + rootElement.getChildElements().size());
        List<AllRecibidos__c> listRecibos = new List<AllRecibidos__c>();
        
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
			AllRecibidos__c recibo = new AllRecibidos__c ();
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){
                switch on detailElement.getName() {
                    when 'codigoCaja'				{ 
                        recibo.C_digo_de_caja__c	= detailElement.getText() != null ? detailElement.getText().trim() : null; 
                    }
                    when 'codigoCliente' 			{ 
                        recibo.CodigoCliente__c		= detailElement.getText() != null ? detailElement.getText().trim() : null; 
                    }
                    when 'codigoCompania'				{ 
                        recibo.Codigocompania__c  = detailElement.getText() != null ? detailElement.getText().trim() : null;
                    }
                    when 'codigoInstrumentoPago'				{ 
                        recibo.CodigoInstrumentoPago__c = detailElement.getText() != null ? detailElement.getText().trim() : null;
                    }
                    when 'codigoLinea'				{ 
                        recibo.CodigoLinea__c  = detailElement.getText() != null ? detailElement.getText().trim() : null;
                    }
                    when 'codigoMonedaAplicada'				{ 
                        recibo.CurrencyIsoCode  = detailElement.getText() == 'USD' ? 'USD' : 'NIO'; 
                    }
                    when 'codigoMonedaRecibida'	{ 
                        recibo.C_digo_moneda_recibida__c = detailElement.getText() == 'USD' ? 'USD' : 'COR';
                        System.debug(recibo.C_digo_moneda_recibida__c);                        
                    }
                    when 'codigoSucursal'				{ 
                        recibo.CodigoSucursal__c  = detailElement.getText() != null ? detailElement.getText().trim() : null;
                    }
                    when 'codigoTipoRecibo'				{ 
                        recibo.C_digo_tipo_de_recibo__c  = detailElement.getText() != null ? detailElement.getText().trim() : null; 
                    }
                    when 'codigoUnidadNegocio'				{ 
                        recibo.CodigoUnidadNegocio__c  = detailElement.getText() != null ? detailElement.getText().trim() : null;
                    }
                    when 'concepto' 		{ 
                        recibo.Concepto__c 	= detailElement.getText() != null ? detailElement.getText().trim() : null; 
                    }
                    when 'fecha' 		{ 
                         recibo.Fecha__c 	= detailElement.getText() != null ? Date.valueOf(detailElement.getText().substring(0,10)) : null;
                    }
                    when 'montoMonedaAplicada'	{ 
                        recibo.MontoAplicado__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                    }
                    when 'montoRecibido'	{ 
                        recibo.Monto_recibido__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0;
                        recibo.Saldo__c	 = recibo.Monto_recibido__c;
                    }
                    when 'numeroRecibo'		 	{ 
                        recibo.NumeroRecibido__c	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0; 
                        System.debug(recibo.NumeroRecibido__c);
                    }
                    when 'tasa' 		{ 
                        recibo.Tasa__c 	= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : null; 
                    }
                    when 'refer1' 		{ 
                        recibo.refer1__c 	= detailElement.getText().trim() != '' ? detailElement.getText().trim() : null; 
                    }
                    when 'refer2' 		{ 
                        recibo.refer2__c 	= detailElement.getText().trim() != '' ? detailElement.getText().trim() : null; 
                    }
                    when 'refer3' 		{ 
                        recibo.refer3__c 	= detailElement.getText().trim() != '' ? detailElement.getText().trim() : null; 
                    }
                    when 'refer4' 		{ 
                        recibo.refer4__c 	= detailElement.getText().trim() != '' ? detailElement.getText().trim() : null; 
                    }
                    when else 				{  }
                    
                }
            }
        	
            if(recibo.CodigoCliente__c != null){
                recibo.cuenta__r 	= new Account(CodigoCliente__c = recibo.CodigoCliente__c);
                recibo.RecordTypeId = rtId_Recibo;
                recibo.Saldo_aplicado__c = 0;
                Date fechha = recibo.Fecha__c;
                String myDtString = fechha.format();
                List<String> values=  myDtString.split('/');

                for (Integer i = 0; i < values.size(); i++) {
                    if (values[i].length() == 1) {
                        values[i] = '0' + values[i]; 
                    }
                }

                String val = values[2] + '-' + values[1] + '-' + values[0];
               
                recibo.Id_Externo__c =  recibo.C_digo_de_caja__c + '_' + 
                    				    recibo.NumeroRecibido__c + '_' + 
                     				    recibo.C_digo_tipo_de_recibo__c + '_' + 
                    				    val + '_' + 
                    				    recibo.Codigocompania__c + '_' + 
                    					recibo.CodigoSucursal__c + '_' +
                                     	recibo.CodigoInstrumentoPago__c + '_' + 
                    					recibo.C_digo_moneda_recibida__c + '_' +
                    					recibo.refer1__c + '_' +
                    					recibo.refer2__c + '_' +
                                        recibo.refer3__c + '_' +
                    					recibo.refer4__c;
                                        
            	listRecibos.add(recibo);
                System.debug(recibo.Id_Externo__c);
            }
    	}
        
        if (!listRecibos.isEmpty()) {   
            Database.UpsertResult[] srList  = Database.upsert(listRecibos,AllRecibidos__c.Id_Externo__c,false);
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());                        
                    }
                }
           	} 
        }
	}
}