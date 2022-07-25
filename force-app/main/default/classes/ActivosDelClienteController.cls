public without sharing class ActivosDelClienteController {
    @AuraEnabled
    public static List<ActivosCliente> obtenerActivos(String IDCliente) {
        List<Account> accList = [
            SELECT ID, CodigoCliente__c
            FROM Account
            WHERE ID =: IDCliente
        ];

        ws_Clientes.wsClientesPort wsClientes = new ws_Clientes.wsClientesPort();
        wsClientes.timeout_x = 120000;
        String resultado = wsClientes.GetACVehiculosCliente(
                                    Label.strKey, 
                                    Label.strApp, 
                                    Label.strModulo,
                                    Integer.valueOf(accList[0].CodigoCliente__c)
                            );

        Dom.Document doc = new Dom.Document();  
        System.debug(resultado);  
        doc.load(resultado);  
        Dom.XMLNode rootElement = doc.getRootElement(); 

        List<ActivosCliente> activosList = new List<ActivosCliente>();
        
        for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
            ActivosCliente activo = new ActivosCliente ();             
            for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                switch on detailElement.getName() {
                    when 'chassis' { 
                        activo.chassis = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'descripcionMarca' { 
                        activo.descripcionMarca = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'descripcionModeloGenerico' { 
                        activo.descripcionModeloGenerico = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'kilometraje' { 
                        activo.kilometraje = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'motor' { 
                        activo.motor = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'numFactura' { 
                        activo.numFactura = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'estado' { 
                        activo.estado = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'MPP' { 
                        activo.MPP = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'anno' { 
                        activo.anno = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'fechaVenta' {
                        activo.fechaVenta = detailElement.getText() != null ? detailElement.getText() : null;
                    }
                    when 'placa' {
                        activo.placa = detailElement.getText() != null ? detailElement.getText() : null;
                    }
                }
            }

            activosList.add(activo);
        }

        return activosList;
    }

    public class ActivosCliente {
        @AuraEnabled public String anno {get;set;}
        @AuraEnabled public String chassis {get;set;}
        @AuraEnabled public String descripcionMarca {get;set;}
        @AuraEnabled public String descripcionModeloGenerico {get;set;}
        @AuraEnabled public String estado {get;set;}
        @AuraEnabled public String fechaVenta {get;set;}
        @AuraEnabled public String kilometraje {get;set;}
        @AuraEnabled public String MPP {get;set;}
        @AuraEnabled public String motor {get;set;}
        @AuraEnabled public String numFactura {get;set;}
        @AuraEnabled public String placa {get;set;}
    }
}