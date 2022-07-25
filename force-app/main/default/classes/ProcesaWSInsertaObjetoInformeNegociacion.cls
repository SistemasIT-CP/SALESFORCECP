public class ProcesaWSInsertaObjetoInformeNegociacion {
    
    public static void insertaObjeto (String xmlRequest, String IdInfNeg){

        Boolean solicitudOK = true;

        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;

        String resp = port.InsertarObjeto(Label.strKey, Label.strApp, Label.strModulo,xmlRequest, 0, 0, 0, '');
        System.debug('res ProcesaWSInsertaObjetoInformeNegociacion: ' + resp);
        
        List<Informe_de_Negociaci_n__c> informe = 
            [SELECT ID, InformeSincronizado__c, XML__c 
            FROM Informe_de_Negociaci_n__c 
            WHERE Id =: IdInfNeg
            ];

        List<Accesorios_del_informe__c> accesoriosList = 
            [SELECT ID, Estado__c 
            FROM Accesorios_del_informe__c 
            WHERE InformeNegociacion__c =: IdInfNeg
            AND Estado__c != 'Despachado'
            ];    
        
        
        if (resp == 'Bien') {
            if (!accesoriosList.isEmpty()) {
                for (Accesorios_del_informe__c acc : accesoriosList) {
                    if(acc.Estado__c == 'No solicitado' || String.isBlank(acc.Estado__c)) {
                        acc.Estado__c = 'Solicitado';
                    }
                }

                informe[0].InformeSincronizado__c = true;
                informe[0].XML__c = xmlRequest + '\n\n RESPUESTA WS: ' + resp ;

                update informe;
                update accesoriosList;
            }
        } else {
            if(!informe.isEmpty()) {
            	informe[0].XML__c = xmlRequest + '\n\n RESPUESTA WS: ' + resp ;
                update informe;    
            }
        }
	}
}