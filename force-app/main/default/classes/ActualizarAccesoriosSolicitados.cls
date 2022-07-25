public without sharing class ActualizarAccesoriosSolicitados {
    @future(callout=true)
    public static void ActualizarAccesoriosSolicitados(String idInforme) {
        List<Accesorios_del_informe__c> accInfList = new List<Accesorios_del_informe__c>();
        List<Accesorios_del_informe__c> accesoriosToUpdate = new List<Accesorios_del_informe__c>();
        Map<String, ProcesaGetAccesoriosSolicitados.wAccesoriosSolicitados> wrapperPorCodigo = new Map<String, ProcesaGetAccesoriosSolicitados.wAccesoriosSolicitados>(); 

        if (idInforme == 'Todos') {
            accInfList = 
                [SELECT Id, Codigo_de_parte__c, InformeNegociacion__r.Consecutivo_del_Informe__c, Estado__c, Codigo_equivalente__c, Solicitar_Accesorio_Equivalente__c 
                FROM Accesorios_del_informe__c 
                WHERE Estado__c != 'Solicitado' AND InformeNegociacion__r.Oportunidad__r.Stagename != 'Cerrada perdida' AND InformeNegociacion__r.Oportunidad__r.Stagename != 'Cerrada ganada'
                ];
        } else if (String.isNotBlank(idInforme)) {
            accInfList = 
                [SELECT Id, Codigo_de_parte__c, InformeNegociacion__r.Consecutivo_del_Informe__c, Estado__c, Codigo_equivalente__c, Solicitar_Accesorio_Equivalente__c 
                FROM Accesorios_del_informe__c 
                WHERE Estado__c != 'Solicitado' AND InformeNegociacion__c =: idInforme AND InformeNegociacion__r.Oportunidad__r.Stagename != 'Cerrada perdida' 
                        AND InformeNegociacion__r.Oportunidad__r.Stagename != 'Cerrada ganada'
                ];
        }
        
        if (!accInfList.isEmpty()) {
            List<ProcesaGetAccesoriosSolicitados.wAccesoriosSolicitados> wAccSoliList = ProcesaGetAccesoriosSolicitados.getAccesoriosSolicitados();  
            
            for (ProcesaGetAccesoriosSolicitados.wAccesoriosSolicitados wrapp : wAccSoliList) {
                wrapperPorCodigo.put(wrapp.codigoParte.trim() + '_' + wrapp.consecutivoInforme.trim(), wrapp);
            }
            
            for (Accesorios_del_informe__c acc : accInfList) {
                String nameINFNeg = '';
                String accBusqueda = '';

                if (acc.InformeNegociacion__r.Consecutivo_del_Informe__c.isNumeric()) {
                    nameINFNeg = '' + Decimal.valueOf(acc.InformeNegociacion__r.Consecutivo_del_Informe__c);
                }

                if (acc.Solicitar_Accesorio_Equivalente__c) {
                    accBusqueda = acc.Codigo_equivalente__c;
                } else {
                    accBusqueda = acc.Codigo_de_parte__c;
                }

                System.debug(accBusqueda + '_' + nameINFNeg);

                if (wrapperPorCodigo.containsKey(accBusqueda + '_' + nameINFNeg)) {
                    acc.Estado__c = 'Solicitado';
                    accesoriosToUpdate.add(acc);
                }
            }

            if (!accesoriosToUpdate.isEmpty()) {
                update accesoriosToUpdate;
            }
        }
    }
}