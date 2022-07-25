public class ProcesaWSAccesoriosDisponibles {
    
    public static List<wrapperAccesorios> procesaAccesorios (List<String> accesorios){
        String accesoriosSeparadosporComa;
        String errors = 'Errores: \n\n';
        List<String> errorsList = new List<String>();
        List<wrapperAccesorios> listWAccesorios = new List<wrapperAccesorios>();
        
        if(accesorios.size()>0){
            List<string> accesoriosConComillas = new List<String>();
            for(String s: accesorios){
                s = '\''+ s + '\'';
                accesoriosConComillas.add(s);
            }
            
            accesoriosSeparadosporComa = string.join(accesoriosConComillas,',');
            
            Dom.Document doc = new Dom.Document();  
            doc.load(new WS_InformeNegociaciones.wsInformeNegociacionPort().GetAccesoriosDisponibles(Label.strKey, Label.strApp, Label.strModulo, accesoriosSeparadosporComa));  
            Dom.XMLNode rootElement = doc.getRootElement();  
            
            System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
            
            
            for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
                    wrapperAccesorios accesorioW = new wrapperAccesorios ();             
                for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                    switch on detailElement.getName() {
                        when 'inopar'				{ 
                            accesorioW.inopar	= detailElement.getText() != null ? detailElement.getText() : null; 
                            system.debug('inopar:' + detailElement.getText());
                        }
                        when else 				{  }
                    }
                }
                
                if(accesorioW.inopar != null){
                    listWAccesorios.add(accesorioW);    
                }
                
            }
        	
        }
        return  listWAccesorios;
	}
    
    public class wrapperAccesorios {
        public string inopar;
    }
}