public class ProcesaGetAccesoriosDespachados {

    public static List<wrapperAccesorios> getAccesoriosDespachados (){
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        String resp = port.GetAccesoriosDespachados(Label.strKey, Label.strApp, Label.strModulo);
        
        List<wrapperAccesorios> listWAccesorios = new List<wrapperAccesorios>();
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
        
        for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
            	wrapperAccesorios accDesp = new wrapperAccesorios ();             
            for (Dom.XMLNode detailElement : childElement.getChildElements()){ 
                switch on detailElement.getName() {
                    when 'articu' { 
                        accDesp.articu = detailElement.getText();
                    }
                    when 'articu1' { 
                        accDesp.articu1 = detailElement.getText();
                    }
                    when 'cosart' { 
                        accDesp.cosart = detailElement.getText();
                    }
                    when 'sbodeg' { 
                        accDesp.sbodeg = detailElement.getText();
                    }
                    when 'scant' { 
                        accDesp.scant = detailElement.getText();
                    }
                    when 'sdesc' { 
                        accDesp.sdesc = detailElement.getText();
                    }
                    when 'sfecham' { 
                        accDesp.sfecham = detailElement.getText();
                    }
                    when 'sfechamm' { 
                        accDesp.sfechamm = detailElement.getText();
                    }
                    when 'sflad' { 
                        accDesp.sflad = detailElement.getText();
                    }
                    when 'shechop' { 
                        accDesp.shechop = detailElement.getText();
                    }
                    when 'shechopm' { 
                        accDesp.shechopm = detailElement.getText();
                    }
                    when 'shoram' { 
                        accDesp.shoram = detailElement.getText();
                    }
                    when 'shoramm' { 
                        accDesp.shoramm = detailElement.getText();
                    }
                    when 'sid' { 
                        accDesp.sid = detailElement.getText();
                    }
                    when 'slinea' { 
                        accDesp.slinea = detailElement.getText();
                    }
                    when 'snprogr' {
                        accDesp.snprogr = detailElement.getText();
                    }
                    when 'ssoli' { 
                        accDesp.ssoli = detailElement.getText();
                    }
                    when 'vinsta' { 
                        accDesp.vinsta = detailElement.getText();
                    }
                    when else {}
                }
            }
        	
            if(accDesp.sid  != null && accDesp.articu != null){
                System.debug(accDesp.articu.trim() + '_' + accDesp.ssoli.trim());
                listWAccesorios.add(accDesp);    
            }
        	
    	}
        
		return listWAccesorios;
	}
    
    public class wrapperAccesorios {
        public string articu;
        public string articu1;
        public string cosart;
        public string sbodeg;
        public string scant;
        public string sdesc;
        public string sfecham;
        public string sfechamm;
        public string sflad;
        public string shechop;
        public string shechopm;
        public string shoram;
        public string shoramm;
        public string sid;
        public string slinea;
        public string snprogr;
        public string ssoli;
        public string vinsta;
        
    }
}