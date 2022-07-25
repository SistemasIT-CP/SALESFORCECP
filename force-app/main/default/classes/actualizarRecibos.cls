public class actualizarRecibos {
    public static void actualizarRecibos() {
        Dom.Document doc = new Dom.Document();
        Map<String, String> monedaPorIdExterno = new Map<String, String>();

        if(!test.isRunningTest()) {
            List<StaticResource> srList =
                [SELECT Id, Body 
                 FROM StaticResource 
                 WHERE Name = 'Listado_de_recibos' 
                ];
    
            doc.load(srList[0].Body.toString());  
        } else {
            doc.load(simularXML());
        }

        Dom.XMLNode rootElement = doc.getRootElement();  

        for (Dom.XMLNode rowElement : rootElement.getChildElements() ) {
            String idExterno = '';
            String monedaNueva = '';

            for (Dom.XMLNode detailElement : rowElement.getChildElements() ){
                switch on detailElement.getName() {
                    when 'idExterno'				{ 
                        idExterno = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'CodigoMonedaRecibida'	{ 
                        monedaNueva = detailElement.getText() == 'USD' ? 'USD' : 'COR';      
                    }
                    when else {}
                }
            }

            monedaPorIdExterno.put(idExterno, monedaNueva);
    	}

        System.debug(monedaPorIdExterno.size());

        List<AllRecibidos__c> recibosList = 
            [SELECT C_digo_moneda_recibida__c, Id_Externo__c  
            FROM AllRecibidos__c
            WHERE Id_Externo__c IN :monedaPorIdExterno.keySet()
            ];

        for (AllRecibidos__c rec : recibosList) {
            String moneda = monedaPorIdExterno.get(rec.Id_Externo__c);

            rec.C_digo_moneda_recibida__c = moneda;
        }

        System.debug(recibosList);

        update recibosList;
    }

    public static String simularXML() {
        String xml = '<?xml version="1.0" encoding="UTF-8"?>'+
                        '<root>'+
                            '<row>'+
                                '<codigoCompania>E03</codigoCompania>'+
                                '<codigoSucursal>00080</codigoSucursal>'+
                                '<CodigoCaja>48</CodigoCaja>'+
                                '<CodigoTipoRecibo>PR</CodigoTipoRecibo>'+
                                '<NumeroRecibo>3150</NumeroRecibo>'+
                                '<Fecha>2012-08-08</Fecha>'+
                                '<CodigoInstrumentoPago>!</CodigoInstrumentoPago>'+
                                '<CodigoMonedaRecibida>COR</CodigoMonedaRecibida>'+
                                '<Refer1>100002</Refer1>'+
                                '<Refer2>85</Refer2>'+
                                '<Refer3>SISTEMAS CONTROLES E INGENIERIA SA</Refer3>'+
                                '<Refer4>1094846</Refer4>'+
                                '<idExterno>48_3150_PR_2012-08-08_E03     _00080_!_null_100002_85_SISTEMAS CONTROLES E INGENIERIA SA_1094846</idExterno>'+
                            '</row>'+
                        '</root>';

        return xml;
    }
}