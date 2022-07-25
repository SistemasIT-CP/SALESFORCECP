public class ProcesaWSVehiculoByChasis {
    
    public static wrapperVehiculoByChasis procesaVehiculoByChasis (String chasis){
        
        wrapperVehiculoByChasis chasisW = new wrapperVehiculoByChasis ();  
        
        if(chasis != null){
			
            try{
                
                Dom.Document doc = new Dom.Document();  
                doc.load(new WS_InformeNegociaciones.wsInformeNegociacionPort().GetVehiculoByChasis(Label.strKey, Label.strApp, Label.strModulo, chasis));  
                Dom.XMLNode rootElement = doc.getRootElement();  
                
                System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
                
                for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
                        switch on childElement.getName() {
                            when 'anno'{ 
                                chasisW.anio = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('anno:' + childElement.getText());
                            }
                            when 'chassis'{ chasisW.chassis	= childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('chassis:' + childElement.getText());
                            }
                            when 'color'{ chasisW.color = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('color:' + childElement.getText());
                            }
                            when 'colorInterno'{ chasisW.colorInterno = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('colorInterno:' + childElement.getText());
                            }
                            when 'descCodigoVehiculo'{ chasisW.descCodigoVehiculo	= childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('descCodigoVehiculo:' + childElement.getText());
                            }
                            when 'factura'{ 
                                chasisW.factura = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('factura:' + childElement.getText());
                            }
                            when 'impAduana'{ chasisW.impAduana = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('impAduana:' + childElement.getText());
                            }
                            when 'motor'{ chasisW.motor = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('motor:' + childElement.getText());
                            }
                            when 'numFactura'{ 
                                chasisW.numFactura = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('numFactura:' + childElement.getText());
                            }
                            when 'precio'{ chasisW.precio = childElement.getText() != null ? childElement.getText() : null; 
                                system.debug('precio:' + childElement.getText());
                            }
                            when else 				{  }
                        }
                    
                }
                
            }catch (Exception e){
                chasisW.error = e.getStackTraceString();
            }
            
            
        	
        }
        return  chasisW;
	}
    
    public class wrapperVehiculoByChasis{
        public string anio;
        public string chassis;
        public string color;
        public string colorInterno;
        public string descCodigoVehiculo;
        public string factura;
        public string impAduana;
        public string motor;
        public string numFactura;
        public string precio;
        public string error;
    }
}