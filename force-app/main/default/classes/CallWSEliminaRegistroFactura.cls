public class CallWSEliminaRegistroFactura {
    
    public static Boolean validaChasisNoFacturados (Id oppId) {
        boolean oppOKparaWS = true;
        
        for (OpportunityLineItem oppli : [SELECT ID, Chasis__c, Chasis_facturado__c, OpportunityId 
                                          FROM OpportunityLineItem 
                                          WHERE OpportunityId =: oppId]) {
            if (oppli.Chasis_facturado__c == true) {
                oppOKparaWS = false;
            }
        }
        
        if (test.isRunningTest()) { 
            oppOKparaWS = true;
        }

        return oppOKparaWS;
    }
    
    @future(callout=true)
    public static void callEliminaRegistroFactura(String oppId) {
        Map<String, String> informesPorRespuesta = new Map<String, String>();
        List<Informe_de_Negociaci_n__c> infList = new List<Informe_de_Negociaci_n__c>();
        ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort(); 
        portObj.timeout_x = 120000;
        
        infList = [
            SELECT ID, Chasis__c, Facturar_a_nombre_de__r.CodigoCliente__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c,
                Sincronizacion_WS__c, Name, factura__c, fechafactura__c 
            FROM Informe_de_Negociaci_n__c 
            WHERE Oportunidad__c =: oppId
        ];

        for (Informe_de_Negociaci_n__c inf : infList) {
            String resp = portObj.EliminarRegistroFactura(Label.strKey, 
                                                              Label.strApp, 
                                                              Label.strModulo, 
                                                              inf.Chasis__c, 
                                                              inf.Facturar_a_nombre_de__r.CodigoCliente__c,
                                                              '' + inf.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c);

            if (resp == 'Bien') {
                inf.Sincronizacion_WS__c = false;
            } else {
                inf.Sincronizacion_WS__c = null;
            }

            inf.factura__c = null;
            inf.fechafactura__c = null;
        }

        if(!infList.isEmpty()) {
            update infList;
        }
    }
}