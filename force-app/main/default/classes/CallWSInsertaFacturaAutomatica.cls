public class CallWSInsertaFacturaAutomatica {
    @future(callout=true)
    public static void insertaFactura (String oppId) {
        Map<Id, String> respList = llamarWsInsercionFacturas(oppId);

        List<Informe_de_Negociaci_n__c> infList = [
            SELECT Id, Sincronizacion_WS__c, Error_sincronizacion_WS__c
            FROM Informe_de_Negociaci_n__c 
            WHERE Id IN :respList.keySet()
        ];

        for (Informe_de_Negociaci_n__c infNeg : infList) {
            String resp = respList.get(infNeg.Id);

            if (resp == 'Bien') {
                infNeg.Sincronizacion_WS__c = true;
                infNeg.Error_sincronizacion_WS__c = '';
            } else {
                infNeg.Sincronizacion_WS__c = false;
                
                if (resp.length() > 250) {
                    infNeg.Error_sincronizacion_WS__c = resp.substring(0, 250);    
                } else {
                    infNeg.Error_sincronizacion_WS__c = resp;
                }
            }
        }
    
        if (!infList.isEmpty()) {
            update infList;
        }
    }
    
    public static Map<Id, String> llamarWsInsercionFacturas (String oppId) {
        Map<Id, String> respuestaPorInforme = new Map<Id, String>();

		if (String.IsNotBlank(oppId)) {
            List<Informe_de_Negociaci_n__c> infNegList = 
               [SELECT ID, Facturar_a_nombre_de__c, Facturar_a_nombre_de__r.CodigoCliente__c, Chasis__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c, 
                	   Name,Error_sincronizacion_WS__c, Sincronizacion_WS__c, Consecutivo_del_Informe__c 
                FROM Informe_de_Negociaci_n__c  
                WHERE Oportunidad__c =: oppId
               ];
            
            if (!infNegList.isEmpty()) {
                for (Informe_de_Negociaci_n__c infNeg: infNegList) {
                    String xml = crearXML(infNeg);
                    
                    ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort();
                    portObj.timeout_x = 120000;
                    String resp = portObj.InsertarFacturacionAutomatica(Label.strKey, Label.strApp, Label.strModulo, xml);   

                    respuestaPorInforme.put(infNeg.Id, resp);     
                }
            }
        }

        return respuestaPorInforme;
    }
    
    public static String crearXML(Informe_de_Negociaci_n__c infNeg) {
        Datetime now = Datetime.now(); 
		Integer offset = UserInfo.getTimezone().getOffset(now); 
        Datetime local = now.addSeconds(offset/1000);
        Date hoy = local.date();
        
        String dia = '' + hoy.day();
        String Mes = '' + hoy.month();
        String anio	= '' + hoy.year();
        
        if (mes.length() == 1) {
        	mes = '0' + mes;
        }
        
        if (dia.length() == 1) {
        	dia = '0' + dia;
        }
        
        String hora =  '' + local;
        hora = hora.substring(11);
        hora = hora.replace(':','');
        
        XmlStreamWriter w = new XmlStreamWriter();
                w.writeStartDocument('utf-8','1.0');
                    w.writeStartElement(null, 'FACTURACIONAUTOMATICA ', null);
                        w.writeStartElement(null, 'billing_items', null);
                            w.writeStartElement(null, 'AutomaticBillingItem', null);
                                w.writeStartElement(null, 'CODIGOCLIENTE', null);
                                    w.writeCharacters(infNeg.Facturar_a_nombre_de__r.CodigoCliente__c);
                                w.writeEndElement();
                                w.writeStartElement(null, 'CHASIS', null);
                                    w.writeCharacters(infNeg.Chasis__c);
                                w.writeEndElement();
                                w.writeStartElement(null, 'OPORTUNIDAD', null);
                                    w.writeCharacters('' + infNeg.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c);
                                w.writeEndElement();
                                w.writeStartElement(null, 'FECHACREACION', null);
                					w.writeCharacters(anio + mes + dia);
                                w.writeEndElement();
                                w.writeStartElement(null, 'HORACREACION', null);
                                    w.writeCharacters(hora);
                                w.writeEndElement();
                                w.writeStartElement(null, 'USUARIO', null);
                                    w.writeCharacters('cpadmin');
                                w.writeEndElement();
                                w.writeStartElement(null, 'PROGCREACION', null);
                                    w.writeCharacters('SF');
                                w.writeEndElement();
                                w.writeStartElement(null, 'NEGOTIATIONFORMID', null);
                                    w.writeCharacters(infNeg.Consecutivo_del_Informe__c);
                                w.writeEndElement();
                            w.writeEndElement();
                        w.writeEndElement();
                    w.writeEndElement();        
                w.writeEndDocument();
        
        String xml = w.getXmlString();
        
        return xml;
    }
}