public class ProcesaWSEliminarSolicitud {
    @Future(Callout = true)
    public static void eliminarSolicitud (String xml){
        
        System.debug('XML: '+xml);

		//xml = xml.replace('>', '&gt;');
        //xml = xml.replace('<', '&lt;');
        
       
        //wsInformeNegociacionQA.wsInformeNegociacionPort port = new wsInformeNegociacionQA.wsInformeNegociacionPort();
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        String resp = port.EliminarSolicitud(Label.strKey, Label.strApp, Label.strModulo, xml);
        System.debug('res: ' + resp);
        
	}
    
    public static String generaXMLRequest (List<ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud> eliminaSolicitudInfNegList){
        String xmlReq;
        XmlStreamWriter w =new XmlStreamWriter();
        
        for(ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud eliminaInfNeg: eliminaSolicitudInfNegList){
                w.writeStartElement(null, 'SolicitudesItems', null); 
            		w.writeStartElement(null, 'INFORME', null);
                        w.writeCharacters(''+eliminaInfNeg.informeNeg);		
                    w.writeEndElement();
            		w.writeStartElement(null, 'CHASIS', null);
                        w.writeCharacters(''+eliminaInfNeg.chasis);		
                    w.writeEndElement();
        		w.writeEndElement();
        }
        
        String s='<?xml version="1.0" encoding="iso-8859-1"?>'+
					+'<SOLICITUDESACCESORIOS xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
						+'<solicitudes_items>'+
                          +w.getXmlString()+
             			+'</solicitudes_items>'+
            		+'</SOLICITUDESACCESORIOS>';
        
        
        return s;
    }
    
    public class WrapperEliminaSolicitud {
        public String informeNeg;
        public String chasis;
    }
    
    
    
}