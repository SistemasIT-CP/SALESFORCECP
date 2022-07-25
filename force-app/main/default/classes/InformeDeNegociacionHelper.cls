public without sharing class InformeDeNegociacionHelper {
    public static void validarChasisOrdenAbierta(List<Informe_de_Negociaci_n__c> infNegList) {
        List<ID> informesConChasisOAList = new List<ID>();
        Boolean blntieneorden   = false;

   		for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            
            if (infNeg.OrdenAbierta__c=='1') {
                blntieneorden= true;
            }   
            else {
                blntieneorden= false;
            }             
System.debug('ENTRO A VALIDAR ORDEN ' + blntieneorden); 
            System.debug('blntieneorden= ' + blntieneorden);  
            if (blntieneorden) {
                infNeg.addError('No se puede eliminar el informe porque el chasis esta en proceso de venta. De clic en Verificar Orden Abierta.');
            }
         }
    }
    
    public static void validarExistenciaDeRecibos(List<Informe_de_Negociaci_n__c> infNegList) {
        List<ID> informesConRecibosList = new List<ID>();
        List<ID> infIDList = new List<ID>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            infIDList.add(infNeg.ID);
        }

        for (Recibos_de_la_negociaci_n__c recNeg : [SELECT ID, Informe_de_Negociaci_n__c
                                                    FROM Recibos_de_la_negociaci_n__c
                                                    WHERE Informe_de_Negociaci_n__c IN :infIDList]) {

            System.debug(recNeg.ID);
                                                    
            if (!informesConRecibosList.contains(recNeg.Informe_de_Negociaci_n__c)) {
                informesConRecibosList.add(recNeg.Informe_de_Negociaci_n__c);
            }
        }

        System.debug(informesConRecibosList);

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if (informesConRecibosList.contains(infNeg.ID)) {
                infNeg.addError('El informe de negociación: ' + infNeg.Name + ' tiene recibos asociados los cuales debe ' +
                                'eliminar primero, para poder eliminar el registro.');
            }
        }
    }

    public static void validarExistenciaDeAccDespachados(List<Informe_de_Negociaci_n__c> infNegList) {
        List<ID> informesConAccDespachadosList = new List<ID>();
        List<ID> infIDList = new List<ID>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            infIDList.add(infNeg.ID);
        }

        for (Accesorios_del_informe__c accInf : [SELECT ID, InformeNegociacion__c 
                                                FROM Accesorios_del_informe__c 
                                                WHERE  InformeNegociacion__c IN: infIDList 
                                                        AND Estado__c = 'Despachado']) {
            if (!informesConAccDespachadosList.contains(accInf.InformeNegociacion__c)) {
                informesConAccDespachadosList.add(accInf.InformeNegociacion__c);
            }
        }

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if (informesConAccDespachadosList.contains(infNeg.ID)) {
                infNeg.addError('El informe de negociación: ' + infNeg.Name + ' tiene accesorios despachados los cuales debe ' +
                                'cambiar de estado, para poder eliminar el registro.');
            }
        }
    }

    public static void eliminarSolicitud(List<Informe_de_Negociaci_n__c> infNegList) {
        List<ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud> eliminaSolicitudInfNegList = new List<ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
        	ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud wInforme = new ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud();
            wInforme.chasis = infNeg.Chasis__c;
            wInforme.informeNeg	= infNeg.Name;

            eliminaSolicitudInfNegList.add(wInforme);
        }

        if (!eliminaSolicitudInfNegList.isEmpty()) {
            ProcesaWSEliminarSolicitud.eliminarSolicitud(
                ProcesaWSEliminarSolicitud.generaXMLRequest(eliminaSolicitudInfNegList)
            );
        }
    }

    public static void obtenerAccesoriosDelChasis(List<Informe_de_Negociaci_n__c> infNegList) {
        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            ProcesaGetAccesoriosChasis.getAccesoriosChasis(infNeg.Chasis__c, infNeg.ID);
        }
    }

    public static void enviarReporteInforme(List<Informe_de_Negociaci_n__c> infNegList) {
        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            CtrlConsultaDisponibilidadAccesorios.solicitaAccesorioInformeAprobado('' + infNeg.ID);
        }
    }

    public static void validarModificaciones(List<Informe_de_Negociaci_n__c> infNegList) {
        List<ID> oppIDList = new List<ID>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if (!oppIDList.contains(infNeg.Oportunidad__c)) {
                oppIDList.add(infNeg.Oportunidad__c);
            }
        }

        Map<ID, Opportunity> oppMap;

        if (!oppIDList.isEmpty()) {
            oppMap = obtenerOportunidades(oppIDList);
        }

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            String mensajeError = '';

            if (oppMap != null) {
                if (String.isNotBlank(infNeg.Oportunidad__c)) {
                    if(oppMap.get(infNeg.Oportunidad__c).StageName == 'Listo para facturar') {
                        mensajeError = 'Para modificar el informe, su oportunidad debe estar en Formalización o una etapa anterior.';
                    }                    
                }
            }

            if (String.isNotBlank(infNeg.factura__c)) {
                mensajeError = 'No se puede modificar un informe ya facturado';
            }

            if (String.isNotBlank(mensajeError)) {
                infNeg.addError(mensajeError);
            }
        }
    }

    public static void quitarEstadoAprobado(List<Informe_de_Negociaci_n__c> infNegList) {
        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            infNeg.Estado__c = 'Esperando aprobacion';
            infNeg.Solicitar_accesorios__c = false;
        }
    }

    public static void setearAprobador(List<Informe_de_Negociaci_n__c> infNegList) {
        Map<ID, ProcessInstance> aprobadoresPorInfID = new Map<ID, ProcessInstance>();
        List<ID> infIDList = new List<ID>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            infIDList.add(infNeg.ID);
        }

        for (ProcessInstance pi : [SELECT LastActor.Name, TargetObjectId, ProcessDefinition.Name
                                    FROM ProcessInstance
                                    WHERE TargetObjectId IN :infIDList
                                            AND Status != 'Pending'
                                    ORDER BY Createddate]) {
            aprobadoresPorInfID.put(pi.TargetObjectId, pi);
        }


        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if(aprobadoresPorInfID.containsKey(infNeg.ID)) {
                ProcessInstance pi = aprobadoresPorInfID.get(infNeg.ID);

                System.debug(pi.ProcessDefinition.Name);

                if (pi.ProcessDefinition.Name.contains('Informe de negociación')) {
                    infNeg.Aprobado_por__c = pi.LastActor.Name;
                } else if (pi.ProcessDefinition.Name.contains('Validar precio mínimo')) {
                    infNeg.Aprobador_del_precio_minimo__c = pi.LastActor.Name;
                }
            }
        }
    }

    public static void cerrarAprobacionesExtras(List<Informe_de_Negociaci_n__c> infNegList) {
        Map<ID, String> estadoPorInfID = new Map<ID, String>();
        List<ID> oppIDList = new List<ID>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if (!oppIDList.contains(infNeg.Oportunidad__c)) {
                oppIDList.add(infNeg.Oportunidad__c);
            }
        }

        Map<ID, Opportunity> oppMap = obtenerOportunidades(oppIDList);

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            if (oppMap.get(infNeg.Oportunidad__c).RecordType.DeveloperName == 'Principal_Motos') {
                estadoPorInfID.put(infNeg.ID, infNeg.Estado__c);
            }
        }

        if (!estadoPorInfID.keySet().isEmpty()) {
            List<ProcessInstanceWorkitem > piwList = 
                [SELECT ID, ProcessInstanceId 
                FROM ProcessInstanceWorkitem 
                WHERE ProcessInstance.TargetObjectId IN :estadoPorInfID.keySet()
                        AND ProcessInstance.Status = 'Pending'
                ];

            if(!piwList.isEmpty()) {
                List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
    
                for (ProcessInstanceWorkitem  piw : piwList) {
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setWorkitemId(piw.ID);
                    req.setAction('Removed');
    
                    requests.add(req);
                }
    
                if (!requests.isEmpty()) {
                    List<Approval.ProcessResult> processResults = Approval.process(requests);
                }
            }
        }
    }

    public static Boolean seModificaUnDatoVisible(Informe_de_Negociaci_n__c infNeg, Informe_de_Negociaci_n__c oldInfNeg) {
        if (infNeg.Facturar_a_nombre_de__c != oldInfNeg.Facturar_a_nombre_de__c ||
            infNeg.Contacto_Comprador__c != oldInfNeg.Contacto_Comprador__c ||
            infNeg.Observaciones__c != oldInfNeg.Observaciones__c ||
            infNeg.Prima_USD__c != oldInfNeg.Prima_USD__c ||
            infNeg.Banco_US__c != oldInfNeg.Banco_US__c ||
            infNeg.KilometrajeIntercambio__c != oldInfNeg.KilometrajeIntercambio__c ||
            infNeg.Precio_USD_Intercambio__c !=  oldInfNeg.Precio_USD_Intercambio__c ||
            infNeg.AnioIntercambio__c != oldInfNeg.AnioIntercambio__c ||
            infNeg.X15_I_V__c != oldInfNeg.X15_I_V__c ||
            infNeg.Monto_IVA__c != oldInfNeg.Monto_IVA__c ||
            infNeg.Imp_Aduanas__c != oldInfNeg.Imp_Aduanas__c ||
            infNeg.Rebaja_Especial__c != oldInfNeg.Rebaja_Especial__c ||
            infNeg.total_negociado__c != oldInfNeg.total_negociado__c ||
            infNeg.Total_Accesorios__c != oldInfNeg.Total_Accesorios__c ||
            infNeg.Cantidad_de_Accesorios__c != oldInfNeg.Cantidad_de_Accesorios__c ||
            infNeg.Total_Recibos__c != oldInfNeg.Total_Recibos__c) {
                
            return true;
        } else {
            return false;
        }
    }

    public static void enviarMotosASegundaAprobacion(List<Id> infNegId) {
        Set<Id> ownerList = new Set<Id>();
        
        List<Informe_de_Negociaci_n__c> infNegList = [
            SELECT Oportunidad__r.Owner.Sucursal__c, Oportunidad__r.ModeloVehiculo__r.description1__c
            FROM Informe_de_Negociaci_n__c
            WHERE Id IN :infNegId AND Oportunidad__r.RecordType.DeveloperName = 'Principal_Motos'
        ];

        Map<String, List<Aprobador_por_Sucursal__mdt>> aprobadoresPorSucursalMap = new Map<String, List<Aprobador_por_Sucursal__mdt>>();
        List<Approval.ProcessSubmitRequest> aprobacionesList = new List<Approval.ProcessSubmitRequest>();
        Set<String> nombreAprobadores = new Set<String>();

        for (Aprobador_por_Sucursal__mdt apr : [SELECT Nombre_del_aprobador__c, Sucursal__c, Tipo_de_vehiculo__c
                                                FROM Aprobador_por_Sucursal__mdt 
                                                ]) {
            
            List<Aprobador_por_Sucursal__mdt> aprobadoresName;

            if (aprobadoresPorSucursalMap.containsKey(apr.Sucursal__c)) {
                aprobadoresName = aprobadoresPorSucursalMap.get(apr.Sucursal__c);
            } else {
                aprobadoresName = new List<Aprobador_por_Sucursal__mdt>();
            }

            nombreAprobadores.add(apr.Nombre_del_aprobador__c);
            aprobadoresName.add(apr);
            aprobadoresPorSucursalMap.put(apr.Sucursal__c, aprobadoresName);
        }

        Map<String, Id> usuarioPorNombre = new Map<String, Id>();

        for (User u : [SELECT Id, Name FROM User WHERE Name IN :nombreAprobadores]) {
            usuarioPorNombre.put(u.Name, u.Id);
        }

        for (Informe_de_Negociaci_n__c inf : infNegList) {
            if (aprobadoresPorSucursalMap.containsKey(inf.Oportunidad__r.Owner.Sucursal__c)) {
                String tipoVehiculo = '';

                if (inf.Oportunidad__r.ModeloVehiculo__r.description1__c.contains('MOTORES MARINOS')) {
                    tipoVehiculo = 'Motores marinos';
                } else {
                    tipoVehiculo = 'Motocicletas';
                }
            
                List<Aprobador_por_Sucursal__mdt> aprobadoresList = aprobadoresPorSucursalMap.get(inf.Oportunidad__r.Owner.Sucursal__c);

                for (Aprobador_por_Sucursal__mdt aprobador : aprobadoresList) {
                    if ((aprobador.Tipo_de_vehiculo__c == tipoVehiculo || aprobador.Tipo_de_vehiculo__c == 'Todos') && usuarioPorNombre.containsKey(aprobador.Nombre_del_aprobador__c)) {
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setObjectId(inf.Id);
                        req.setNextApproverIds(new List<ID>{usuarioPorNombre.get(aprobador.Nombre_del_aprobador__c)});

                        aprobacionesList.add(req);
                    }
                }
            }
        }

        if (!aprobacionesList.isEmpty()) {
            List<Approval.ProcessResult> aprList = Approval.process(aprobacionesList);
        }
    }

    public static void eliminarInformesLuegoDeAprobacion(List<Informe_de_Negociaci_n__c> infNegList) {
        List<Id> infIdList = new List<Id>();

        for (Informe_de_Negociaci_n__c infNeg : infNegList) {
            infIdList.add(infNeg.Id);
        }

        List<Informe_de_Negociaci_n__c> infToDelete = [
            SELECT Id 
            FROM Informe_de_Negociaci_n__c
            WHERE Id IN :infIdList
        ];

        List<Recibos_de_la_negociaci_n__c> recNegToDelete = [
            SELECT Id 
            FROM Recibos_de_la_negociaci_n__c
            WHERE Informe_de_Negociaci_n__c IN :infIdList 
        ];

        List<Accesorios_del_informe__c> accNegToDelete = [
            SELECT Id, Estado__c 
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c IN :infIdList
        ];

        for (Accesorios_del_informe__c accInf : accNegToDelete) {
            accInf.Estado__c = 'Solicitado';
        }

        if (!accNegToDelete.isEmpty()) {
            update accNegToDelete;
        }

        if (!accNegToDelete.isEmpty()) {
            delete accNegToDelete;
        }

        if (!recNegToDelete.isEmpty()) {
            delete recNegToDelete;
        }

        if (!infToDelete.isEmpty()) {
            delete infToDelete;
        }
    }

    private static Map<ID, Opportunity> obtenerOportunidades(List<ID> oportunidadIDList) {
        Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([
            SELECT StageName, RecordType.DeveloperName 
            FROM Opportunity 
            WHERE ID IN :oportunidadIDList
        ]);

        return oppMap;
    }
}