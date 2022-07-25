public class ActualizaModelosUDC {
    public static void actualizaModelos () {
        Map<String, String> modeloCodeByName = new Map<String, String>();
        Map<String, String> marcaByModeloName = new Map<String, String>();
        List<Catalogo_UDC__c> modelosToUpsert = new List<Catalogo_UDC__c>();
        ID RTId = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Modelo')
                .getRecordTypeId();
        
        List<Product2> productList = 
            [SELECT Id, Codigomodelogenerico__c, modelogenerico__c, Marca_P__c, 
                    modelofabrica__c, Codigomodelofabrica__c 
            FROM Product2 
            WHERE (Codigomodelogenerico__c != '' 
                    AND Codigomodelogenerico__c != null)
                  OR (Codigomodelofabrica__c != '' 
                    AND Codigomodelofabrica__c != null)
            ];

        for (Product2 p : productList) {
            if (p.Marca_P__c == 'Yamaha' || p.Marca_P__c == 'Hero' || p.Marca_P__c == 'Genesis') {
                if (!modeloCodeByName.containsKey(p.modelofabrica__c)) {
                    modeloCodeByName.put(p.modelofabrica__c, p.Codigomodelofabrica__c);
                }
    
                if (!marcaByModeloName.containsKey(p.modelofabrica__c)) {
                    marcaByModeloName.put(p.modelofabrica__c, p.Marca_P__c);
                }
            } else {
                if (!modeloCodeByName.containsKey(p.modelogenerico__c)) {
                    modeloCodeByName.put(p.modelogenerico__c, p.codigomodelogenerico__c);
                }
    
                if (!marcaByModeloName.containsKey(p.modelogenerico__c)) {
                    marcaByModeloName.put(p.modelogenerico__c, p.Marca_P__c);
                }
            }
        }
        
        for (String name : modeloCodeByName.KeySet()) {
            Catalogo_UDC__c modelo = new Catalogo_UDC__c();
            modelo.RecordTypeId = RTId;
            modelo.productCode__c = modeloCodeByName.get(name);
            modelo.name = name.toUpperCase();
            modelo.description1__c = name.toUpperCase();
            modelo.description2__c = marcaByModeloName.get(name);
            modelo.ExternalId__c = 'Modelo_' + modelo.productCode__c;

            modelosToUpsert.add(modelo);
        }
            
        if (!modelosToUpsert.isEmpty()) {
            Database.UpsertResult[] srList  = Database.upsert(modelosToUpsert, Catalogo_UDC__c.ExternalId__c, false);
            
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                }
            } 
        }
    }
}