public with sharing class AccesoriosComboParaNegociacionHelper {

    public static void crearAccesoriosDelInforme(
        List<AccesoriosComboParaNegociacion__c> combosDeAccesorioNuevo
    ) {

        List<ID> combosID = new List<ID>();

        for (AccesoriosComboParaNegociacion__c accesoriosCombo : combosDeAccesorioNuevo) {
            if (!combosID.contains(accesoriosCombo.Combo_del_informe__c)) {
                combosID.add(accesoriosCombo.Combo_del_informe__c);
            }
        }
        
        Map<ID, CombosDeInformeDeNegociacion__c> combosByID = 
                                new Map<ID, CombosDeInformeDeNegociacion__c>(
                                        [SELECT Informe_de_Negociaci_n__c 
                                        FROM CombosDeInformeDeNegociacion__c 
                                        WHERE ID IN :combosID]                          
                                );
        
        List<Accesorios_del_informe__c> accesoriosInfList = new List<Accesorios_del_informe__c> ();

        for (AccesoriosComboParaNegociacion__c accCN : combosDeAccesorioNuevo) {
                Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
                accInf.Accesorio__c = accCN.Accesorio__c;
                accInf.Cantidad__c = accCN.Cantidad__c;
                accInf.Combo__c = accCN.Combo_del_informe__c;
                accInf.InformeNegociacion__c = combosByID.get(accCN.Combo_del_informe__c).Informe_de_Negociaci_n__c;
                accInf.Descripcion__c = accCN.Descripcion__c;
                accInf.Estado__c = 'No solicitado';
                accesoriosInfList.add(accInf);
        }
        
        insert accesoriosInfList;

        for(Accesorios_del_informe__c accInforme : accesoriosInfList){
            try {
                CtrlConsultaDisponibilidadAccesorios.validaDisponibilidadFROMAccesoriosDelComboParaInforme(
                                                                ''+accInforme.InformeNegociacion__c
                );
            } catch (Exception e) {
                if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,' 
                                            + ' El informe se encuentra en el estado')) {
                    accInforme.addError('Los accesorios no pudieron ser agregados al informe de negociación,' 
                            + ' ya que este se encuentra en un estado donde ya no es posible agregar esta acción'
                    );
                }
            }
        }
    }
}