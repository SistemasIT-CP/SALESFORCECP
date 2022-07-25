public class ProcesaWSVehiculoByShortNumber {
    
    public static wrapperVehiculoByShortNumber procesaVehiculoByShortNumber (String chasis){
        
        wrapperVehiculoByShortNumber vehiculoW = new wrapperVehiculoByShortNumber ();  
        
        if(chasis != null){
            try{
                
                Dom.Document doc = new Dom.Document();  
                doc.load(new WS_InformeNegociaciones.wsInformeNegociacionPort().GetVehiculoByShortNumber(Label.strKey, Label.strApp, Label.strModulo, chasis));  
                Dom.XMLNode rootElement = doc.getRootElement();  
                
                System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
                
                for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
                        switch on childElement.getName() {
                            when 'anno'{ 
                                vehiculoW.anio = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('anno:' + childElement.getText());
                            }
                            when 'chassis'{ 
                                vehiculoW.chassis	= childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('chassis:' + childElement.getText());
                            }
                            when 'color'{ 
                                vehiculoW.color = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('color:' + childElement.getText());
                            }
                            when 'colorInterno'{ 
                                vehiculoW.colorInterno = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('colorInterno:' + childElement.getText());
                            }
                            when 'descCodigoVehiculo'{ 
                                vehiculoW.descCodigoVehiculo	= childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('descCodigoVehiculo:' + childElement.getText());
                            }
                            when 'factura'{ 
                                vehiculoW.factura = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('factura:' + childElement.getText());
                            }
                            when 'impAduana'{ 
                                vehiculoW.impAduana = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('impAduana:' + childElement.getText());
                            }
                            when 'motor'{ 
                                vehiculoW.motor = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('motor:' + childElement.getText());
                            }
                            when 'numFactura'{ 
                                vehiculoW.numFactura = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('numFactura:' + childElement.getText());
                            }
                            when 'precio'{ 
                                vehiculoW.precio = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('precio:' + childElement.getText());
                            }
                            when else 				{  }
                        }
                    
                }
                
            }catch(Exception e){
                vehiculoW.error = e.getStackTraceString();
            }
            
        	
        }
        return  vehiculoW;
	}
    
    public class wrapperVehiculoByShortNumber{
        public string anio;
        public string chassis;
        public string color;
        public string colorInterno;
        public string descCodigoVehiculo;
        public string factura;
        public string impAduana;
        public string motor;
        public string error;
        public string numFactura;
        public string precio;
        
    }
}