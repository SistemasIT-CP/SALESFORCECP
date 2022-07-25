public without sharing class ProcesarScoringUAF{
	public static Map<ID, String> generarCalificacion(List<Opportunity> oppList) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        List<String> opcionesList = new List<String>();
        List<ID> accIDList = new List<ID>();
        List<ID> oppIDList = new List<ID>();

        for (Opportunity opp : oppList) {
            accIDList.add(opp.AccountID);
            oppIDList.add(opp.ID);

            opcionesList.add(opp.Canal_Contrata__c);
            opcionesList.add(opp.Sucursal__c);
            opcionesList.add(opp.Tipo_de_transacci_n__c);
            opcionesList.add(opp.Responsable_del_pago__c);
            opcionesList.add(opp.Origen_de_los_fondos__c);
            opcionesList.add(opp.Tipo_de_relaci_n_econ_mica__c);
        }

        Map<ID, Account> accMapPorId = new Map<ID, Account>([
            SELECT Pa_s__c, Pa_s__r.Name, Tipo_de_cliente__c, Tipo_Cliente__c, Tipo_de_Indentificaci_n__c,
                   Nivel_organizacional__c, Profesion_UDC__c, Profesion_UDC__r.Name, Ocupacion_UDC__c, Ocupacion_UDC__r.Name,
                   Actividad_economica_UDC__c, Actividad_economica_UDC__r.Name, PEP__c, RecordTypeId
            FROM Account
            WHERE ID IN :accIDList
        ]);

        for (Opportunity opp : oppList) {
            Account acc = accMapPorId.get(opp.AccountID);

            opcionesList.add(acc.Pa_s__r.Name);
            opcionesList.add(acc.Tipo_de_cliente__c);
            opcionesList.add(acc.Tipo_Cliente__c);
            opcionesList.add(acc.Tipo_de_Indentificaci_n__c);
            opcionesList.add(acc.Nivel_organizacional__c);

            if (acc.RecordTypeId == personAccountID) {
                opcionesList.add(acc.Profesion_UDC__r.Name);
                opcionesList.add(acc.Ocupacion_UDC__r.Name);
            } else {
                opcionesList.add(acc.Actividad_economica_UDC__r.Name);
            }
        }

        Map<ID, List<String>>  recibosPorOportunidadID = new Map<ID, List<String>>();
        Map<ID, Integer> calificacionRecibosPorOportunidadID = new Map<ID, Integer>();

        for (Recibos_de_la_negociaci_n__c recNeg : [SELECT Recibos__r.Instrumento_de_pago__c, Informe_de_Negociaci_n__r.Oportunidad__c
                                                    FROM Recibos_de_la_negociaci_n__c
                                                    WHERE Informe_de_Negociaci_n__r.Oportunidad__c IN: oppIDList
                                                    ]) {

            List<String> recibosList;
            if (!recibosPorOportunidadID.containsKey(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c)) {
                recibosList = new List<String>();
            } else {
                recibosList = recibosPorOportunidadID.get(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c);
            }

            recibosList.add(recNeg.Recibos__r.Instrumento_de_pago__c);

            recibosPorOportunidadID.put(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c, 
                                        recibosList);

            if (!opcionesList.contains(recNeg.Recibos__r.Instrumento_de_pago__c)) {
                opcionesList.add(recNeg.Recibos__r.Instrumento_de_pago__c);
            }
        }

        Map<String, Decimal> calificacionPorName = new Map<String, Decimal>();

        for (CriterioCalificacionCliente__mdt c : [SELECT MasterLabel, Valor__c 
                                                   FROM CriterioCalificacionCliente__mdt
                                                   WHERE MasterLabel IN :opcionesList]) {
            calificacionPorName.put(c.MasterLabel, c.Valor__c);
        }

        Map<ID, Decimal> puntajeRecibosPorOppID = new Map<ID, Decimal>();
        Map<ID, String> scoringPorOppID = new Map<ID, String>();

        for (Opportunity opp : oppList) {
            Decimal puntajeRecibos = 0;
            List<String> listadoRecibos = recibosPorOportunidadID.get(opp.ID);

            for (String tipoRecibo : listadoRecibos) {
                puntajeRecibos += calificacionPorName.get(tipoRecibo);
            }

            puntajeRecibosPorOppID.put(opp.ID, puntajeRecibos / listadoRecibos.size());
        }

        for (Opportunity opp : oppList) {
            Account acc = accMapPorId.get(opp.AccountID);

            Decimal detalleCuenta = 0;
            Decimal detalleOportunidad = 0;

            if (acc.PEP__c || (acc.Tipo_de_cliente__c.contains('PEP'))) {
                scoringPorOppID.put(opp.ID, '4_4');
            } else {
                detalleCuenta += calificacionPorName.get(acc.Tipo_de_cliente__c) * 0.2;
                detalleCuenta += calificacionPorName.get(acc.Tipo_Cliente__c) * 0.2;
                detalleCuenta += calificacionPorName.get(acc.Tipo_de_Indentificaci_n__c) * 0.2;
                detalleCuenta += calificacionPorName.get(opp.Tipo_de_relaci_n_econ_mica__c) * 0.1;
                detalleCuenta += calificacionPorName.get(acc.Nivel_organizacional__c) * 0.1;
                
                if (acc.RecordTypeId == personAccountID) {
                    detalleCuenta += calificacionPorName.get(acc.Profesion_UDC__r.Name) * 0.1;
                    detalleCuenta += calificacionPorName.get(acc.Ocupacion_UDC__r.Name) * 0.1;
                } else {
                    detalleCuenta += calificacionPorName.get(acc.Actividad_economica_UDC__r.Name) * 0.2;
                }

                detalleOportunidad += calificacionPorName.get(opp.Canal_Contrata__c) * 0.05;
                detalleOportunidad += calificacionPorName.get(opp.Sucursal__c) * 0.05;
                detalleOportunidad += puntajeRecibosPorOppID.get(opp.ID) * 0.2;
                detalleOportunidad += calificacionPorName.get(opp.Tipo_de_transacci_n__c) * 0.25;
                detalleOportunidad += calificacionPorName.get(opp.Responsable_del_pago__c) * 0.1;
                detalleOportunidad += calificacionPorName.get(opp.Origen_de_los_fondos__c) * 0.15;
                detalleOportunidad += calificacionPorName.get(acc.Pa_s__r.Name) * 0.2;

                scoringPorOppID.put(opp.ID, detalleCuenta + '_' + detalleOportunidad);
            }
        }

        return scoringPorOppID;
    }
}