public class ProcesaWSAccesoriosEstadoDisponibilidad {
    
    public static List<wrapperAccesorios> procesaAccesorios (List<String> accesorios) {
        String accesoriosSeparadosporComa;
        String errors = 'Errores: \n\n';
        List<String> errorsList = new List<String>();
        List<wrapperAccesorios> listWAccesorios = new List<wrapperAccesorios>();
        
        if (!accesorios.isEmpty()) {
            List<string> accesoriosConComillas = new List<String>();

            for(String s : accesorios) {
                s = '\''+ s + '\'';
                accesoriosConComillas.add(s);
            }
            
            accesoriosSeparadosporComa = String.join(accesoriosConComillas,',');
            
            WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();

            port.timeout_x = 120000; 

            String resp = port.GetAccesoriosEstadoDisponibilidad(Label.strKey, Label.strApp, Label.strModulo, accesoriosSeparadosporComa);
            System.debug('RESPUESTA WS: ' + resp);

            Dom.Document doc = new Dom.Document();  
            doc.load(resp);  
            Dom.XMLNode rootElement = doc.getRootElement();  
            
            for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
                wrapperAccesorios accesorioW = new wrapperAccesorios ();             

                for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                    switch on detailElement.getName() {
                        when 'inopar' { 
                            accesorioW.inopar = detailElement.getText() != null ? detailElement.getText() : null; 
                        } when 'estado' { 
                            accesorioW.estado = detailElement.getText() != null ? detailElement.getText() : null; 
                        } when else {

                        }
                    }
                }
                
                if(accesorioW.inopar != null) {
                    listWAccesorios.add(accesorioW);    
                }
            }
        }
        
        return  listWAccesorios;
	}
    
    public class wrapperAccesorios {
        public String estado;
        public string inopar;
    }
}