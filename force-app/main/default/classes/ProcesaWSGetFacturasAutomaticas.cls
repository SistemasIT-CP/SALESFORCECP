public class ProcesaWSGetFacturasAutomaticas { 
    @future(callout=true)
    public static void procesaFacturasAutomaticas(){
        ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort();
        portObj.timeout_x = 120000;
        String resp = portObj.GetFacturasAutomaticas(Label.strKey, Label.strApp, Label.strModulo);
        actualizarData(resp);
    }

    public static void actualizarData(String resp){
        List<Informe_de_Negociaci_n__c> informeListWS = new List<Informe_de_Negociaci_n__c>();
        Map<String, Informe_de_Negociaci_n__c> informeNuevoByKey = new Map<String, Informe_de_Negociaci_n__c>();
        Set<String> chasisList = new Set<String>();
        Set<Informe_de_Negociaci_n__c> informeListToUpdate = new Set<Informe_de_Negociaci_n__c>();
        Set<Decimal> codigoOportunidadList = new Set<Decimal>();

        Set<Id> oppSet 	= new Set<Id>();
        List<Opportunity> oppToUpdateList = new List<Opportunity>();
        
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        System.debug('cantidad de facturas recibidas: ' + rootElement.getChildElements().size());
        
        for (Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            Informe_de_Negociaci_n__c informe = new Informe_de_Negociaci_n__c();

            for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                switch on detailElement.getName() {
                    when 'codigocliente' {}

                    when 'chasis' { 
                        if (detailElement.getText() != null) {
                            informe.Chasis__c = detailElement.getText();
                        	chasisList.add(informe.Chasis__c);
                        }
                    }

                    when 'estado' { 
                        informe.Estado_de_la_factura__c = detailElement.getText() != null ? detailElement.getText() : null;
                    }

                    when 'oportunidad' {
                        informe.N_mero_de_la_oportunidad__c = detailElement.getText() != null ? detailElement.getText() : '0';
                    }

                    when 'fechafactura'	{ 
                        String fecha = detailElement.getText();

                        if (String.isNotBlank(fecha) && fecha != '0') {
                            String anio = fecha.substring(0, 4);
                            String mes = fecha.substring(4, 6);
                            String dias = fecha.substring(6, 8);
                        
                            informe.fechafactura__c = Date.valueOf(anio + '-' + mes + '-' + dias); 
                        } else {
                            informe.fechafactura__c = null;
                        }
                    }

                    when 'fechacreacion' { 
                        String fecha = detailElement.getText();

                        if (String.isNotBlank(fecha) && fecha != '0') {
                            String anio = fecha.substring(0, 4);
                            String mes = fecha.substring(4, 6);
                            String dias = fecha.substring(6, 8);
                            
                            informe.fechacreacion__c = Date.valueOf(anio + '-' + mes + '-' + dias);
                        } else {
                            informe.fechacreacion__c = null;
                        }
                    }

                    when 'horacreacion'	{}

                    when 'usuario' {} 

                    when 'progcreacion' {} 

                    when 'fechamod' {}

                    when 'horamod' {}

                    when 'usermod' {}

                    when 'progmod' {}

                    when 'negotiationformid' {}

                    when 'factura' { 
                        informe.factura__c = detailElement.getText() != null ? detailElement.getText() : null;
                    }

                    when else {}
                }
            }

            informeNuevoByKey.put(informe.N_mero_de_la_oportunidad__c + '_' + informe.Chasis__c, informe);
            System.debug(informe.N_mero_de_la_oportunidad__c + '_' + informe.Chasis__c);
            informeListWS.add(informe);
        }


        if (!informeListWS.isEmpty()) {
            List<Informe_de_Negociaci_n__c> informeListSF = 
                [SELECT Id, Chasis__c, N_mero_de_la_oportunidad__c, fechafactura__c, 
                 		fechacreacion__c, factura__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c
                FROM Informe_de_Negociaci_n__c 
                WHERE Chasis__c IN: chasisList
                      AND Oportunidad__r.StageName = 'Listo para facturar'
                      AND factura__c = null
                ];

            for (Informe_de_Negociaci_n__c infSF : informeListSF) {
                String key = infSF.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c + '_' + infSF.Chasis__c;

                System.debug(key);

                if (informeNuevoByKey.containsKey(key)) {
                    Informe_de_Negociaci_n__c informeCopia = informeNuevoByKey.get(key);
                    infSF.N_mero_de_la_oportunidad__c = informeCopia.N_mero_de_la_oportunidad__c;
                    infSF.fechafactura__c= informeCopia.fechafactura__c;
                    infSF.fechacreacion__c=  informeCopia.fechacreacion__c;
                    infSF.factura__c = informeCopia.factura__c;
                    infSF.Fecha_de_ultima_facturacion__c = Date.today();

                    informeListToUpdate.add(infSF);

                    codigoOportunidadList.add(infSF.Oportunidad__r.C_digo_de_Oportunidad_Numerico__c);

                    System.debug('Actualizando informe numero ' + infSF.N_mero_de_la_oportunidad__c);
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
        }
        
        if (!codigoOportunidadList.isEmpty()) {

            List<OpportunityLineItem> chasisOppList = 
                [SELECT Id, Chasis_facturado__c, Chasis__c, Opportunity.C_digo_de_Oportunidad_Numerico__c, Product2.Name
                 FROM OpportunityLineItem 
                 WHERE Chasis__c IN: chasisList
                ];
            
            for (OpportunityLineItem oppLI : chasisOppList) {
                String key = oppLI.Opportunity.C_digo_de_Oportunidad_Numerico__c + '_' + oppLI.Chasis__c;

                System.debug(key);

                if (informeNuevoByKey.containsKey(key)) {
                    oppLI.Chasis_facturado__c = true;

                    System.debug('Actualizando ' + oppLI.Product2.Name + 
                                 ' de la oportunidad ' + oppLI.Opportunity.C_digo_de_Oportunidad_Numerico__c);
                }
            }
            
            if (!chasisOppList.isEmpty()) {
                List<Database.SaveResult> srOppLILista  = Database.update(chasisOppList, false);

                Integer oppLIActualizados = 0;

                for (Database.SaveResult sr : srOppLILista) {
                    if (!sr.isSuccess()) {
                        for (Database.Error err : sr.getErrors()) {
                            System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                            System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                        }
                    } else {
                        oppLIActualizados++;
                    }
               }

               System.debug('Se actualizaron correctamente ' + oppLIActualizados + ' productos de la oportunidad');
            }
            
            List<Opportunity> oppList = 
                [SELECT Id, Permite_Ganar_Oportunidad__c, Name, StageName, 
                        (Select Id, Chasis__c, Chasis_facturado__c 
                         FROM OpportunityLineItems) 
                FROM Opportunity 
                WHERE C_digo_de_Oportunidad_Numerico__c IN :codigoOportunidadList
                ];
            
            Map<ID, Integer> oliFactByOppID = new Map<ID, Integer>();
            Map<ID, Integer> oliByOppID = new Map<ID, Integer>();
            
            for(Opportunity opp: oppList) {
                if (!opp.StageName.contains('Cerrada')) {
                    Boolean oppLista = true;
                    Integer cantFact = 0;
                    Integer cant = 0;
                    
                    for (OpportunityLineItem oppli : opp.OpportunityLineItems) {
                        cant += 1;
                        
                        if (oppli.Chasis_facturado__c == false) {
                            oppLista = false;
                        } else {
                            cantFact += 1; 
                        }
                    }
                    
                    oliFactByOppID.put(opp.ID, cantFact);
                    oliByOppID.put(opp.ID, cant);
                    
                    if (oppLista) {
                        oppSet.add(opp.Id);
                    }
                }
            }
            
            
            if (!oppSet.isEmpty()) {

                for (Opportunity opp: [SELECT Id,Permite_Ganar_Oportunidad__c, StageName, Name, RecordType.DeveloperName
                                      FROM Opportunity 
                                      WHERE Id IN:oppSet]) {
                    if (opp.StageName == 'Listo Para Facturar') {

                        if (oliFactByOppID.get(opp.ID) == oliByOppID.get(opp.ID)) {
                            opp.Permite_Ganar_Oportunidad__c = true;

                            opp.StageName = 'Facturado';

                            System.debug('Actualizando oportunidad ' + opp.Name);
                        }

                        oppToUpdateList.add(opp);
                    }
                }
                
                if (!oppToUpdateList.isEmpty()) {
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
        }
	}
    
    public static String simulaRespuesta(String oppType){
        if (oppType == 'Autos') {
            return '<ListaConsultaFacturas>'+
                +'<listFacturas>'+
                    +'<chasis>LBPKE1803J0071056</chasis>'+
                    +'<codigocliente>2626188</codigocliente>'+
                    +'<estado>FACTURADA</estado>'+
                    +'<fechacreacion>20200101</fechacreacion>'+
                    +'<fechafactura>20201107</fechafactura>'+
                    +'<fechamod>20201117</fechamod>'+
                    +'<horacreacion>90706</horacreacion>'+
                    +'<horamod>0</horamod>'+
                    +'<negotiationformid>223976</negotiationformid>'+
                    +'<oportunidad>558843</oportunidad>'+
                    +'<progcreacion>crm       </progcreacion>'+
                    +'<progmod>          </progmod>'+
                    +'<usermod>          </usermod>'+
                    +'<usuario>cpadmin   </usuario>'+
                    +'<factura>565678</factura>'+
                +'</listFacturas>'+
                +'</ListaConsultaFacturas>';
        } else {
            return '<ListaConsultaFacturas>'+
                +'<listFacturas>'+
                    +'<chasis>LBPKE1803J0071055</chasis>'+
                    +'<codigocliente>2626188</codigocliente>'+
                    +'<estado>FACTURADA</estado>'+
                    +'<fechacreacion>20200101</fechacreacion>'+
                    +'<fechafactura>20201107</fechafactura>'+
                    +'<fechamod>20201117</fechamod>'+
                    +'<horacreacion>90706</horacreacion>'+
                    +'<horamod>0</horamod>'+
                    +'<negotiationformid>223976</negotiationformid>'+
                    +'<oportunidad>555555</oportunidad>'+
                    +'<progcreacion>crm       </progcreacion>'+
                    +'<progmod>          </progmod>'+
                    +'<usermod>          </usermod>'+
                    +'<usuario>cpadmin   </usuario>'+
                    +'<factura>565678</factura>'+
                +'</listFacturas>'+
                +'</ListaConsultaFacturas>';
        }
    }
}