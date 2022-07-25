public without sharing class AccesoriosDelInformeHelper {
    public static void validarInformeReservado(List<Accesorios_del_informe__c> accInfList, String accion) {
        Map<ID, Informe_de_Negociaci_n__c> infNegMap = obtenerInformes(accInfList);

        for (Accesorios_del_informe__c accInf : accInfList) {
            if (infNegMap.get(accInf.InformeNegociacion__c).Reservar__c) {
                accInf.addError('El informe se encuentra Reservado, por lo que no es posible ' + accion + ' los accesorios');
            }
        }
    }

    public static void setearConsecutivoYEstado(List<Accesorios_del_informe__c> accInfList) {
        Map<ID, Decimal> conteoPorInfID = new Map<ID, Decimal>();
        Map<ID, Informe_de_Negociaci_n__c> infNegMap = obtenerInformes(accInfList);

        for (Informe_de_Negociaci_n__c inf : infNegMap.values()) {
            Decimal conteo = inf.Cantidad_de_Accesorios__c == null? 0 : inf.Cantidad_de_Accesorios__c;
            conteoPorInfID.put(inf.ID, conteo);
        }

        for (Accesorios_del_informe__c accInf : accInfList) {
            if (!infNegMap.get(accInf.InformeNegociacion__c).Reservar__c && accInf.Estado__c  != 'Despachado') {
                accInf.Estado__c = 'No solicitado';
            }

            Decimal conteo = conteoPorInfID.get(accInf.InformeNegociacion__c) + 1;
            accInf.Consecutivo__c = conteo;

            conteoPorInfID.put(accInf.InformeNegociacion__c, conteo);
        }
    }

    public static void validarAccesorioDespachado(List<Accesorios_del_informe__c> accInfList, String accion) {
        Boolean omitirValidacion = obtenerValidacion();

        if (!omitirValidacion) {
            for (Accesorios_del_informe__c accInf : accInfList) {
                accInf.addError('No puede ' + accion + ' un accesorio ya despachado.');
            }
        }
    }

    public static void validarAccesorioEquivalente(List<Accesorios_del_informe__c> accInfList) {
        for (Accesorios_del_informe__c accInf : accInfList) {
            accInf.addError('No puede solicitarse un accesorio equivalente si el accesorio no tiene codigo equivalente.');
        }
    }

    public static void solicitarAccesorioInformeAprobado(List<Accesorios_del_informe__c> accInfList, String accion) {
        Map<ID, Informe_de_Negociaci_n__c> infMapByID = new Map<ID, Informe_de_Negociaci_n__c>();

        if (accion != 'Eliminacion') {
            infMapByID = obtenerInformes(accInfList);
        }

        for (Accesorios_del_informe__c accInf : accInfList) {
            Boolean validacion = false;

            if (!infMapByID.KeySet().isEmpty()) {
                Informe_de_Negociaci_n__c inf = infMapByID.get(accInf.InformeNegociacion__c);

                if (accion == 'Insercion' && inf.InformeSincronizado__c && !inf.Reservar__c) {
                    validacion = true;
                }

                if (accion == 'Actualizacion' && inf.InformeSincronizado__c) {
                    validacion = true;
                }
            } else {
                validacion = true;
            }

            if (validacion) {
                CtrlConsultaDisponibilidadAccesorios.solicitaAccesorioInformeAprobado(accInf.InformeNegociacion__c);
            }
        }
    }

    public static void consultarDisponibilidad(List<Accesorios_del_informe__c> accInfList) {
        for (Accesorios_del_informe__c accInf : accInfList) {
            CtrlConsultaDisponibilidadAccesorios.validaDisponibilidadFROMAccesoriosDelComboParaInforme(accInf.InformeNegociacion__c);
        }
    }

    private static Map<ID, Informe_de_Negociaci_n__c> obtenerInformes(List<Accesorios_del_informe__c> accInfList) {
        List<ID> infNegIDList = new List<ID>();

        for (Accesorios_del_informe__c accInf : accInfList) {
            if (String.isNotBlank(accInf.InformeNegociacion__c)) {
                if (!infNegIDList.contains(accInf.InformeNegociacion__c)) {
                    infNegIDList.add(accInf.InformeNegociacion__c);
                }
            }
        }

        Map<ID, Decimal> conteoPorInfID = new Map<ID, Decimal>();

        Map<ID, Informe_de_Negociaci_n__c> infNegMap = new Map<ID, Informe_de_Negociaci_n__c>([
            SELECT Reservar__c, Cantidad_de_Accesorios__c, InformeSincronizado__c
            FROM Informe_de_Negociaci_n__c
            WHERE ID IN :infNegIDList
        ]);

        return infNegMap;
    }

    private static Boolean obtenerValidacion() {
        List<Profile> profList = [
            SELECT Name
            FROM Profile
            WHERE ID =: UserInfo.getProfileId()
        ];

        List<Omitir_validaci_n_despachado__mdt> validacion = [
            SELECT ID
            FROM Omitir_validaci_n_despachado__mdt
            WHERE MasterLabel = 'OMITIR VALIDACION' AND Activo__c = true
        ];

        Boolean omitirValidacion = false;
        
        if (!validacion.isEmpty() && (profList[0].Name == 'System Administrator' || profList[0].Name == 'Administrador del sistema')) {
            omitirValidacion = true;
        }

        return omitirValidacion;
    }
}