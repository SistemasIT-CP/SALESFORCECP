public class ConsumirCombos {
	public static void consumirCombos() {
    	String body;
        
        if(!Test.isRunningTest()) {
        	StaticResource sr = 
            [SELECT Id, Body 
             FROM StaticResource 
             WHERE Name = 'Combos' 
             LIMIT 1];
        
        	body = sr.Body.toString();    
        } else {
        	body = simularRespuesta();   
        }
        
        List<ComboDelAccesorio> combosAccList = (List<ComboDelAccesorio>) System.JSON.deserialize(body, List<ComboDelAccesorio>.class);
        
        System.debug('Hay ' + combosAccList.size() + ' combos');
        
        List<String> accesoriosCodigosList = new List<String>();
        List<String> comboCodigoList = new List<String>();
        Map<String, ID> accesoriosPorCodigoDeParte = new Map<String, ID>();
        Map<String, Combo__c> mapaDeCombos = new Map<String, Combo__c>();
        List<Combo_Accesorio__c> combosDelAccParaInsertar = new List<Combo_Accesorio__c>();
        List<String> unionesExistentes = new List<String>();
        
        for (ComboDelAccesorio cda : combosAccList) {
			accesoriosCodigosList.add(cda.codigoParte);
            comboCodigoList.add(cda.ID);
        }
        
        for (Accesorios__c acc : [SELECT ID, CodigoParte__c
                                  FROM Accesorios__c
                                  WHERE CodigoParte__c IN :accesoriosCodigosList
                                 ]){
        	accesoriosPorCodigoDeParte.put(acc.CodigoParte__c, acc.ID); 	                            
        }

        for (Combo__c combo : [SELECT ID, Id_Externo__c
                               FROM Combo__c 
                               WHERE Id_Externo__c in :comboCodigoList]) {
            mapaDeCombos.put(combo.Id_Externo__c, combo);
        }

        for (Combo_Accesorio__c comAcc : [SELECT Combo__r.Id_Externo__c, Accesorio__r.CodigoParte__c
                                          FROM Combo_Accesorio__c
                                          WHERE Combo__r.Id_Externo__c IN :comboCodigoList]) {
            unionesExistentes.add(comAcc.Combo__r.Id_Externo__c + '_' + comAcc.Accesorio__r.CodigoParte__c);
        }

        for (ComboDelAccesorio cda : combosAccList) {
            if(!unionesExistentes.contains(cda.ID + '_' + cda.codigoParte)) {
                if (accesoriosPorCodigoDeParte.containsKey(cda.codigoParte)) {
    
                    Combo_Accesorio__c ca = new Combo_Accesorio__c();
                    ca.Combo__c = mapaDeCombos.get(cda.ID).ID;
                    ca.Accesorio__c = accesoriosPorCodigoDeParte.get(cda.codigoParte);
                    ca.Cantidad__c = Decimal.valueOf(cda.cantidad);
                    
                    combosDelAccParaInsertar.add(ca); 
                    
                } else {
                    System.debug('El codigo de parte ' + cda.codigoParte + ' no corresponde a ningun accesorio');
                }
            } else {
                System.debug('No se va a crear la relacion ' + cda.ID + '_' + cda.codigoParte + ' porque ya existe.'); 
            }
        }

        System.debug(combosDelAccParaInsertar);
        
        if (!combosDelAccParaInsertar.isEmpty()) {
            System.debug('Cantidad de combos de Acc: ' + combosDelAccParaInsertar.size());
            upsert combosDelAccParaInsertar;
        }
    }
    
    public static String simularRespuesta() {
        String respuesta =  '['+
							'{"ID":"1143","nombreCombo":"ALFOMBRA DE CARGA GRIS PRADO","codigoParte":"70Q42457","cantidad":"3"},'+
							'{"ID":"1147","nombreCombo":"ALFOMBRA DE CARGA RAV4","codigoParte":"70Q40883","cantidad":"1"}'+
                            ']';
        
        return respuesta;
    }
    
    public class ComboDelAccesorio {
        public String ID;
        public String nombreCombo;
        public String codigoParte;
        public String cantidad;
    }
}