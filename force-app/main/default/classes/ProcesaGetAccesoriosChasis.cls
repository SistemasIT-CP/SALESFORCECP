public class ProcesaGetAccesoriosChasis {

    @future (callout = true)
    public static void getAccesoriosChasis (String chasis, String idInfNeg){
        
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        String resp = port.GetAccesoriosChasis(Label.strKey, Label.strApp, Label.strModulo, chasis);
        
        System.debug('res: ' + resp);
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().isEmpty());
        List<wAccesorioChasis> listWAccChasis = new List<wAccesorioChasis>();
        List<Accesorios_del_informe__c> listAccInf = new List<Accesorios_del_informe__c>();
        
        
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            	wAccesorioChasis acc = new wAccesorioChasis ();             
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'cantidad'		{ 
                        acc.cantidad	= detailElement.getText().trim() != '' ? Integer.valueOf(detailElement.getText()) : 0; 
                    	system.debug('cantidad:' + detailElement.getText());
                    }
                    when 'codigoArticulo'{ 
                        acc.codigoArticulo		= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('codigoArticulo:' + detailElement.getText());
                    }
                    when 'descripcion'	{ 
                        acc.descripcion	= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('descripcion:' + detailElement.getText());
                    }
                    when 'estado'		{ 
                        acc.estado	= detailElement.getText() != null ? detailElement.getText() : null; 
                        system.debug('estado:' + detailElement.getText());
                    }
                    
                    when else 				{  }
                    
                }
            }
        	
            if(acc.codigoArticulo != null){
                listWAccChasis.add(acc);    
            }
        	
    	}
        
        if(!listWAccChasis.isEmpty()){
            for(wAccesorioChasis wacc : listWAccChasis){
            	Accesorios_del_informe__c accInf 	= new Accesorios_del_informe__c ();
                accInf.Accesorio__r   				= new Accesorios__c(CodigoParte__c=wacc.codigoArticulo);  
                accInf.Cantidad__c	  				= wacc.cantidad;
                accInf.Descripcion__c 				= wacc.descripcion;
                accInf.Estado__c	  				= wacc.estado;
                accInf.Estado__c	  				= wacc.estado;
                if(!test.isRunningTest()){
                	accInf.InformeNegociacion__c		= idInfNeg;    
                }else{
                    accInf.InformeNegociacion__c		= (new Informe_de_Negociaci_n__c()).Id;
                }
                
            	listAccInf.add(accInf);        
            }
            
            
            if(!listAccInf.isEmpty()){
                
                Database.SaveResult[] srList  = Database.insert(listAccInf, false);
                
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()){
                        System.debug(sr.getId());
                    }else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                            System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                        }
                    }
                } 
            }
            
        }

	}
    
    public class wAccesorioChasis {
        public Integer cantidad;
        public String codigoArticulo;
        public String descripcion;
        public String estado;
    }
}