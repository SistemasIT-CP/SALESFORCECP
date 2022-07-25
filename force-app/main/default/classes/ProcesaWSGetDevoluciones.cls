public class ProcesaWSGetDevoluciones { 
    @future(callout=true)
    public static void procesaDevoluciones(){
        ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort();
        portObj.timeout_x = 120000;
        String resp = portObj.GetDevoluciones(Label.strKey, Label.strApp, Label.strModulo);

        List<Informe_de_Negociaci_n__c> informeListWS = new List<Informe_de_Negociaci_n__c>();
        Map<String, Informe_de_Negociaci_n__c> informeNuevoByKey = new Map<String, Informe_de_Negociaci_n__c>();
        Set<String> chasisList = new Set<String>();
        Set<Informe_de_Negociaci_n__c> informeListToUpdate = new Set<Informe_de_Negociaci_n__c>();
        Set<Decimal> codigoOportunidadList = new Set<Decimal>();
        List<Opportunity> oppToUpdateList = new List<Opportunity>();
        Map<Id, String> informesPorRespuestaWS = new Map<Id, String>();

        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  

        System.debug(resp);
        
        for (Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            Informe_de_Negociaci_n__c informe = new Informe_de_Negociaci_n__c();

            for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                switch on detailElement.getName() { 
                    when 'chasis' { 
                        if (detailElement.getText() != null) {
                            informe.Chasis__c = detailElement.getText();
                        	chasisList.add(informe.Chasis__c);
                        }
                    }

                    when 'oportunidad' {
                        informe.N_mero_de_la_oportunidad__c = detailElement.getText() != null ? detailElement.getText() : '0';
                    }

                    when 'fechadevolucion'	{ 
                        String fecha = detailElement.getText();

                        if (String.isNotBlank(fecha) && fecha != '0') {
                            String anio = fecha.substring(0, 4);
                            String mes = fecha.substring(4, 6);
                            String dias = fecha.substring(6, 8);
                        
                            informe.Fecha_de_devolucion__c = Date.valueOf(anio + '-' + mes + '-' + dias); 
                        } else {
                            informe.Fecha_de_devolucion__c = null;
                        }
                    }

                    when 'nodevolucion' { 
                        informe.Devolucion__c = detailElement.getText() != null ? detailElement.getText() : null;
                    }

                    when else {}
                }
            }

            informeNuevoByKey.put(informe.N_mero_de_la_oportunidad__c + '_' + informe.Chasis__c, informe);
            informeListWS.add(informe);
        }

        if (!informeListWS.isEmpty()) {
            List<Informe_de_Negociaci_n__c> informeListSF = 
                [SELECT Id, Chasis__c, N_mero_de_la_oportunidad__c, fechafactura__c, 
                 		fechacreacion__c, factura__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c
                FROM Informe_de_Negociaci_n__c 
                WHERE Chasis__c IN: chasisList
                ];
            
            for (Informe_de_Negociaci_n__c infSF : informeListSF) {
                String key = infSF.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c + '_' + infSF.Chasis__c;

                System.debug(key);
                if (informeNuevoByKey.containsKey(key)) {
                    Informe_de_Negociaci_n__c informeCopia = informeNuevoByKey.get(key);
                    infSF.fechafactura__c = null;
                    infSF.factura__c = '';
                    infSF.Devolucion__c = informeCopia.Devolucion__c;
                    infSF.Fecha_de_devolucion__c = informeCopia.Fecha_de_devolucion__c;

                    informeListToUpdate.add(infSF);

                    codigoOportunidadList.add(infSF.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c);
                }
            }
        }
        
        if (!codigoOportunidadList.isEmpty()) {          
            List<Opportunity> oppList = 
                [SELECT Id, Permite_Ganar_Oportunidad__c, Name, StageName, RecordType.DeveloperName
                FROM Opportunity 
                WHERE C_digo_de_Oportunidad_Numerico__c IN :codigoOportunidadList
                ];
            
            for(Opportunity opp: oppList) {
                if (opp.StageName == 'Facturado' || (opp.StageName == 'Cerrada ganada' && opp.RecordType.DeveloperName == 'Principal_Motos')) {
                    opp.StageName = 'Listo para facturar';
                    opp.Permite_Ganar_Oportunidad__c = false;
                    
                    oppToUpdateList.add(opp);
                }
            }
            
            if (!oppToUpdateList.isEmpty()) {
                for (Opportunity opp : oppToUpdateList) {
                    informesPorRespuestaWS = CallWSInsertaFacturaAutomatica.llamarWsInsercionFacturas(opp.Id);
                }
            }

            for (Informe_de_Negociaci_n__c infNeg : informeListToUpdate) {
                if (informesPorRespuestaWS.containsKey(infNeg.Id)) {
                    String respWSInforme = informesPorRespuestaWS.get(infNeg.Id);

                    if (respWSInforme == 'Bien') {
                        infNeg.Sincronizacion_WS__c = true;
                    } else {
                        if (respWSInforme.length() > 250) {
                            infNeg.Error_sincronizacion_WS__c = respWSInforme.substring(0, 250);    
                        } else {
                            infNeg.Error_sincronizacion_WS__c = respWSInforme;
                        }
                    }
                }
            }

            System.debug('informes a actualizar:' + informeListToUpdate);

           	List<Database.SaveResult> srInformesLista = Database.update(new List<Informe_de_Negociaci_n__c>(informeListToUpdate), false);
            Integer informesActualizados = 0;

           	for (Database.SaveResult sr : srInformesLista) {
                if (!sr.isSuccess()){
					for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                } else {
                    informesActualizados++;
                }
            }
            
            System.debug('Se actualizaron correctamente ' + informesActualizados + ' informes.');

            List<Database.SaveResult> srOppLista  = Database.update(oppToUpdateList, false);
            Integer oppActualizadas = 0;

            for (Database.SaveResult sr : srOppLista) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                } else {
                    oppActualizadas++;
                }
            }

            System.debug('Oportunidades actualizadas ' + oppActualizadas);
        }
	}
    
    public static String simulaRespuesta(String oppType){
        if (oppType == 'Autos') {
            return '<ListaConsultaFacturas>'+
                +'<listFacturas>'+
                    +'<chasis>LBPKE1803J0071056</chasis>'+
                    +'<codigocliente>2626188</codigocliente>'+
                    +'<estado>DEVOLUCION</estado>'+
                    +'<fechacreacion>20200101</fechacreacion>'+
                    +'<fechadevolucion>20210913</fechadevolucion>'+
                    +'<fechafactura>20210901</fechafactura>'+
                    +'<horacreacion>20201117</horacreacion>'+
                    +'<negotiationformid>223976</negotiationformid>'+
                    +'<nodevolucion>777777</nodevolucion>'+
                    +'<oportunidad>558843</oportunidad>'+
                    +'<progcreacion>crm       </progcreacion>'+
                    +'<progmod>          </progmod>'+
                    +'<usermod>AGUIDO    </usermod>'+
                    +'<usuario>jlvallejos</usuario>'+
                    +'<factura>999999</factura>'+
                +'</listFacturas>'+
                +'</ListaConsultaFacturas>';
        } else {
            return '<ListaConsultaFacturas>'+
                +'<listFacturas>'+
                    +'<chasis>LBPKE1803J0071055</chasis>'+
                    +'<codigocliente>2626188</codigocliente>'+
                    +'<estado>DEVOLUCION</estado>'+
                    +'<fechacreacion>20200101</fechacreacion>'+
                    +'<fechadevolucion>20210913</fechadevolucion>'+
                    +'<fechafactura>20210901</fechafactura>'+
                    +'<horacreacion>20201117</horacreacion>'+
                    +'<negotiationformid>223976</negotiationformid>'+
                    +'<nodevolucion>777777</nodevolucion>'+
                    +'<oportunidad>555555</oportunidad>'+
                    +'<progcreacion>crm       </progcreacion>'+
                    +'<progmod>          </progmod>'+
                    +'<usermod>AGUIDO    </usermod>'+
                    +'<usuario>jlvallejos</usuario>'+
                    +'<factura>999999</factura>'+
                +'</listFacturas>'+
                +'</ListaConsultaFacturas>';
        }
    }
}