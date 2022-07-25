public class AccesoriosNuevosController {

    @AuraEnabled
    public static List<Accesorios_del_informe__c> consultarAccesorios(ID informesID) {
        List<Accesorios_del_informe__c> listadoAccesorios = 
            [SELECT ID, Codigo_de_parte__c, Descripci_n_del_accesorio__c, Cantidad__c, Precio__c, Estado__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: informesID
            ];

        if (!listadoAccesorios.isEmpty()) {
            return listadoAccesorios;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static List<Accesorios__c> obtenerAccesorios() {
        List<Accesorios__c> listadoAccesorios = 
            [SELECT ID, DescripcionAmplia__c, Descripcion__c, CodigoParte__c, Precio__c, CantidadMinima__c
            FROM Accesorios__c
            ];

        if (!listadoAccesorios.isEmpty()) {
            return listadoAccesorios;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static List<Combo__c> obtenerCombos(String idInforme) {
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT Producto__r.Codigovehiculo__c
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: idInforme
            ];

        List<Combo__c> listadoCombos = new List<Combo__c>();
        
        if (!infList.isEmpty()) {
            for (Combo__c combo : [SELECT ID, Name, Id_Externo__c, Modelo__c
                                    FROM Combo__c   
                                    ]) {
                if (String.isNotBlank(combo.Modelo__c) && String.isNotBlank(infList[0].Producto__c)) {
                    if (combo.Modelo__c.contains(infList[0].Producto__r.Codigovehiculo__c)) {

                        listadoCombos.add(combo);
                    }
                }
            }

            if (!listadoCombos.isEmpty()) {
                return listadoCombos;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static Map<String, Map<String, String>> descripcionCombos(String idInforme){
        Map<String, Map<String, Decimal>> accesoriosPorCombos = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, String>> detalleAccesoriosPorCombos = new Map<String, Map<String, String>>();

        Set<ID> comboID = new Set<ID>();
        Set<ID> accesoriosID = new Set<ID>();

        for (Combo__c c : obtenerCombos(idInforme)) {
            comboID.add(c.ID);
        }

        List<Combo_Accesorio__c> combosList = 
            [SELECT ID, Combo__r.Id_Externo__c, Accesorio__c, Accesorio__r.CodigoParte__c, Cantidad__c
            FROM Combo_Accesorio__c
            WHERE Combo__c IN :comboID
            ];

        for (Combo_Accesorio__c comboAcc : combosList) {
            Map<String, Decimal> cantidadesPorAccesorios;

            if (accesoriosPorCombos.containsKey(comboAcc.Combo__r.Id_Externo__c)) {
                cantidadesPorAccesorios = accesoriosPorCombos.get(comboAcc.Combo__r.Id_Externo__c);
                Decimal cantidad = 0;

                if (cantidadesPorAccesorios.containsKey(comboAcc.Accesorio__r.CodigoParte__c)) {
                    cantidad = cantidadesPorAccesorios.get(comboAcc.Accesorio__r.CodigoParte__c);

                }

                cantidad += comboAcc.Cantidad__c;
                
                System.debug(cantidad);

                cantidadesPorAccesorios.put(comboAcc.Accesorio__r.CodigoParte__c, cantidad);

            } else {
                cantidadesPorAccesorios = new Map<String, Decimal>();

                cantidadesPorAccesorios.put(comboAcc.Accesorio__r.CodigoParte__c, comboAcc.Cantidad__c);
            }

            accesoriosPorCombos.put(comboAcc.Combo__r.Id_Externo__c, cantidadesPorAccesorios);
            accesoriosID.add(comboAcc.Accesorio__c);
        }
        
        Map<String, Accesorios__c> accesorioPorCodigoParte = new Map<String, Accesorios__c>(); 
        
        for (Accesorios__c acc : [SELECT Precio__c, CodigoParte__c, Descripcion__c
                                    FROM Accesorios__c
                                    WHERE ID IN :accesoriosID]) {
            accesorioPorCodigoParte.put(acc.CodigoParte__c, acc);
        }

        for (String codigoCombo : accesoriosPorCombos.keySet()) {
            Map<String, Decimal> numAccesoriosMap = accesoriosPorCombos.get(codigoCombo);
            Map<String, String> accesoriosDetalleMap = new Map<String, String>();

            for (String codigoAccesorio : numAccesoriosMap.keySet()) {
                accesoriosDetalleMap.put(codigoAccesorio, 
                                        numAccesoriosMap.get(codigoAccesorio) + 
                                                '_' + 
                                                accesorioPorCodigoParte.get(codigoAccesorio).Descripcion__c +
                                                '_' + 
                                                accesorioPorCodigoParte.get(codigoAccesorio).Precio__c
                                        );
            }

            detalleAccesoriosPorCombos.put(codigoCombo, accesoriosDetalleMap);
        }

        return detalleAccesoriosPorCombos;
    }

    @AuraEnabled
    public static String guardarCombos(String idInforme, List<Object> listaCombos){
        String respuesta = 'Error';

        List<String> combosList = new List<String>();
        Map<String, Decimal> accesoriosMap = new Map<String, Decimal>();
        List<String> accesoriosList = new List<String>();

        for (Integer i = 0; i < listaCombos.size(); i++) {
            combosList.add((String)listaCombos[i]);
        }

        for (Combo_Accesorio__c comboAcc : [SELECT Cantidad__c, Accesorio__r.CodigoParte__c
                                            FROM Combo_Accesorio__c
                                            WHERE Combo__r.Id_Externo__c IN :combosList
                                            ]) {

            Decimal i = 0;

            if (accesoriosMap.containsKey(comboAcc.Accesorio__r.CodigoParte__c)) {
                i = accesoriosMap.get(comboAcc.Accesorio__r.CodigoParte__c);
            }

            i += comboAcc.Cantidad__c;

            accesoriosMap.put(comboAcc.Accesorio__r.CodigoParte__c, i);
        }

        for (String codigoParte : accesoriosMap.keySet()) {
            accesoriosList.add(codigoParte + '=' + accesoriosMap.get(codigoParte));
        }
        
        if(!accesoriosList.isEmpty()) {
            respuesta = guardarAccesorio(idInforme, accesoriosList);
        }

        return respuesta;
    }

    @AuraEnabled
    public static String guardarAccesorio(String idInforme, List<Object> listaAccesorios){
        Map<String, Accesorios_del_informe__c> accesoriosExistentes = new Map<String, Accesorios_del_informe__c>();
        Map<String, Accesorios__c > accPorCodigoParte = new Map<String, Accesorios__c >();
        Map<String, Decimal> cantidadesPorAccesorios = new Map<String, Decimal>();
        List<String> codigosAcc = new List<String>();
        List<Accesorios_del_informe__c> accToUpsert = new List<Accesorios_del_informe__c>();

        for (Integer i = 0 ; i < listaAccesorios.size(); i++) {
            String val = (String) listaAccesorios[i];
            cantidadesPorAccesorios.put(val.split('=')[0], Decimal.valueOf(val.split('=')[1]));
            codigosAcc.add(val.split('=')[0]);
        }

        System.debug(cantidadesPorAccesorios);

        for (Accesorios_del_informe__c  acc : [SELECT ID, Codigo_de_parte__c, Cantidad__c
                                                FROM Accesorios_del_informe__c 
                                                WHERE InformeNegociacion__c =: idInforme
                                                      AND Estado__c != 'Despachado'
                                            ]) {
            accesoriosExistentes.put(acc.Codigo_de_parte__c, acc);
        }

        System.debug(accesoriosExistentes);

        for (Accesorios__c  acc : [SELECT ID, CodigoParte__c FROM Accesorios__c WHERE CodigoParte__c IN :codigosAcc]) {
            accPorCodigoParte.put(acc.CodigoParte__c, acc);
        } 

        for (String cod : cantidadesPorAccesorios.keySet()) {
            if(accesoriosExistentes.containsKey(cod)) {
                Accesorios_del_informe__c accInf = accesoriosExistentes.get(cod);
                accInf.Cantidad__c += cantidadesPorAccesorios.get(cod);

                accToUpsert.add(accInf);
            } else {
                if (accPorCodigoParte.containsKey(cod)) {
                    Accesorios_del_informe__c newAccInf = new Accesorios_del_informe__c();
                    newAccInf.InformeNegociacion__c = idInforme;
                    newAccInf.Accesorio__c = accPorCodigoParte.get(cod).ID;
                    newAccInf.Cantidad__c = cantidadesPorAccesorios.get(cod);
                    newAccInf.Estado__c = 'No solicitado';

                    accToUpsert.add(newAccInf);
                } else {
                    return 'Error: el accesorio elegido no tiene un codigo de parte válido.';
                }
            }
        }

        if(!accToUpsert.isEmpty()) {
            List<Database.UpsertResult> urList = Database.upsert(accToUpsert, false);
            Boolean error = false;

            String errorTexto = '';

            for (Database.UpsertResult ur : urList) {
                if (!ur.isSuccess()) {
                    error = true;
                    if (String.isBlank(errorTexto)) {
                        errorTexto = ur.getErrors()[0].getMessage();
                    }
                }
            }

            if (error) {
                return 'Error: ' + errorTexto;
            }
        }

        return 'Bien';
    }

    @AuraEnabled
    public static String eliminarAccesorio(String idAccesorio) {
        List<Accesorios_del_informe__c> accList = 
            [SELECT ID 
            FROM Accesorios_del_informe__c 
            WHERE ID =: idAccesorio
            ];

        if (!accList.isEmpty()) {
            List<Database.DeleteResult> drList = Database.delete(accList, false);

            String errorTexto = '';

            for (Database.DeleteResult dr : drList) {
                if (!dr.isSuccess()) {
                    return 'Error: ' + dr.getErrors()[0].getMessage();
                }
            }

            return 'Bien';
        } else {
            return 'Error: No se encontraron accesorios para eliminar.';
        }
    }

    @AuraEnabled
    public static String actualizarCantidades(String idInforme, String codigoParte, Decimal cantidadNueva){
        List<Accesorios_del_informe__c> accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: idInforme
                AND Codigo_de_parte__c =: codigoParte
            ];

        if (!accList.isEmpty()) {
            accList[0].Cantidad__c = cantidadNueva;

            List<Database.SaveResult> srList = Database.update(accList, false);

            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    return 'Error: ' + sr.getErrors()[0].getMessage();
                }
            }

            return 'Bien';
        } else {
            return 'Error: No se encontraron accesorios para editar.';
        }
    }

    public class ComboDetalle{
        @AuraEnabled public String numerocorto {get;set;}
        @AuraEnabled public String chasis {get;set;}
        @AuraEnabled public String codigomotor  {get;set;}
    }
}