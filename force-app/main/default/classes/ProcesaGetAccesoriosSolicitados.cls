public class ProcesaGetAccesoriosSolicitados {
    public static List<wAccesoriosSolicitados> getAccesoriosSolicitados(){
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        String resp = port.GetAccesoriosSolicitados(Label.strKey, Label.strApp, Label.strModulo);
        
        List<wAccesoriosSolicitados> listWAccesorios = new List<wAccesoriosSolicitados>();
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
            wAccesoriosSolicitados accDesp = new wAccesoriosSolicitados();             
            for (Dom.XMLNode detailElement : childElement.getChildElements()){ 
                switch on detailElement.getName() {
                    when 'articu' { 
                        accDesp.codigoParte = detailElement.getText();
                    }
                    when 'ssoli' { 
                        accDesp.consecutivoInforme = detailElement.getText();
                    }
                    when else {}
                }
            }
        	
            if(accDesp.codigoParte != null && accDesp.consecutivoInforme != null){
                listWAccesorios.add(accDesp);    
            }
    	}
        
		return listWAccesorios;
	}
    
    public class wAccesoriosSolicitados {
        public String codigoParte;
        public String consecutivoInforme;
    }
}