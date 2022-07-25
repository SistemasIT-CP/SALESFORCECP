public class ProcesaWSAccesoriosDia {
	@future (callout=true)    
    public static void getAccesoriosDias(Date dateProcess){
        ws_AccesoriosService.wsAccesoriosPort port = new ws_AccesoriosService.wsAccesoriosPort();
        port.timeout_x = 120000;
       	String resp = port.GetAccesoriosDia(Label.strKey, 
                                            Label.strApp, 
                                            Label.strModulo,
                                            String.valueOf(dateProcess.year()),
                                            String.valueOf(dateProcess.month()),
                                            String.valueOf(dateProcess.day())
                                           );

        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
        List<Accesorios__c> listAccesorios = new List<Accesorios__c>();
        
        Id RTIdCompany = 
            Schema.SObjectType.Catalogo_UDC__c
            		.getRecordTypeInfosByDeveloperName()
            		.get('Companias')
            		.getRecordTypeId();
        
        Map<String,Id> UDCCodeIdMap = new Map<String,Id>();
        
        List<Catalogo_UDC__c> udcCompaniesList = 
            [SELECT Id, productCode__c 
             FROM Catalogo_UDC__c 
             WHERE RecordTypeId =: RTIdCompany
            		AND ProductCode__c != null 
            ];
        
        if (!udcCompaniesList.isEmpty()) {
            for (Catalogo_UDC__c udc : udcCompaniesList) {
                if (udc.productCode__c.length() == 3 && udc.productCode__c.substring(0,1) == 'E') {
                    UDCCodeIdMap.put(udc.productCode__c.substring(1,3), udc.Id);
                } else {
                    UDCCodeIdMap.put(udc.productCode__c, udc.Id);
                }
            }
        }
        
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
           	Accesorios__c accesorio = new Accesorios__c ();             
            
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'compania'			{ 
                        accesorio.NombreCompania__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('compania:' + detailElement.getText());
                    }
                    when 'icompan' 			{ 
                        accesorio.CodigoCompania__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('icompan:' + detailElement.getText());
                    }
                    when 'idesci' 			{ 
                        accesorio.DescripcionAmplia__c 	= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('idesci:' + detailElement.getText());
                    }
                    when 'idescr'	{ 
                        accesorio.Descripcion__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('idescr:' + detailElement.getText());
                    }
                    when 'ifechi1'		 	{ 
                        String fecha = detailElement.getText();
                        if(fecha.length() == 8){
                            accesorio.FechaInclusion__c = Date.newInstance(Integer.valueOf(detailElement.getText().substring(0,4)),
                                                                           Integer.valueOf(detailElement.getText().substring(4,6)),
                                                                           Integer.valueOf(detailElement.getText().substring(6,8))
                                                                          );
                        }
                        system.debug('ifechi1:' + detailElement.getText());
                    }
                    when 'ifecmod'		 	{ 
                        String fecha = detailElement.getText();
                        if(fecha.length() == 8) {
                            accesorio.FechaModificacion__c = Date.newInstance(Integer.valueOf(detailElement.getText().substring(0,4)),
                                                                              Integer.valueOf(detailElement.getText().substring(4,6)),
                                                                              Integer.valueOf(detailElement.getText().substring(6,8))
                                                                             );
                        }
                    	system.debug('ifecmod:' + detailElement.getText());
                    }
                    when 'ifeule'		{ 
                        accesorio.CantidadMinima__c		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0;
                    	system.debug('ifeule:' + detailElement.getText());
                    }
                    when 'inopar'		{ 
                        accesorio.CodigoParte__c		= detailElement.getText() != null ? detailElement.getText() : null; 
                    	system.debug('inopar:' + detailElement.getText());
                    }
                    when 'inpare'	 		{ 
                        accesorio.CodParteEquivalente__c= detailElement.getText() != null ? detailElement.getText() : null;
                    	system.debug('inpare:' + detailElement.getText());
                    } 
                    when 'iprven'	 	{ 
                        accesorio.Precio__c 		= detailElement.getText().trim() != '' ? Decimal.valueOf(detailElement.getText()) : 0;
                    	system.debug('iprven:' + detailElement.getText());
                    } 
                    when else 				{  }
                }
            }
        	
            if(String.isNotBlank(accesorio.CodigoCompania__c)) {
                accesorio.Compa_a_UDC__c = UDCCodeIdMap.get(accesorio.CodigoCompania__c);  
            }
            
            if(String.isNotBlank(accesorio.CodigoParte__c)) {
                listAccesorios.add(accesorio);
            }
    	}
        
        if(!listAccesorios.isEmpty()) {
            Schema.SObjectField c = Accesorios__c.Fields.CodigoParte__c;
			Database.UpsertResult [] srList = Database.upsert(listAccesorios, c, false);
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                }
           } 
        }
	}
}