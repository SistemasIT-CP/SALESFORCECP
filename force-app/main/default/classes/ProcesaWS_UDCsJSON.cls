public class ProcesaWS_UDCsJSON {
	public static void getUDCJSON() {
        List<Catalogo_UDC__c> udcListInsert = new List<Catalogo_UDC__c>();
        List<String> errorsList = new List<String>();
        Map<String, ID> recordIDByDeveloperName = new Map<String, ID>();
        Map<String, String> codeByDeveloperName = new Map<String, String>();

        for (RecordType rt : [SELECT ID, DeveloperName
                                FROM Recordtype
                                WHERE SobjectType = 'Catalogo_UDC__c']) {
            recordIDByDeveloperName.put(rt.DeveloperName, rt.ID);
        }

        for(Codigo_WS_de_UDC__mdt udcCode : [SELECT DeveloperName, Product_Code__c, User_Defined_Code__c
                                            FROM Codigo_WS_de_UDC__mdt]) {
            codeByDeveloperName.put(udcCode.DeveloperName, udcCode.Product_Code__c + '_' + 
                                                                udcCode.User_Defined_Code__c );
        }

        HttpResponse response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(Label.URL_WS_UDC);   
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('key', Label.strKey);
        request.setHeader('app', Label.strApp);
        request.setHeader('mod', Label.strModulo);

        try{
        	response = http.send(request);
            if (response.getStatusCode() != 201) {
                System.debug('Ha ocurrido un error ' + response.getStatus() + ', codigo: ' + response.getStatusCode());
            } else {
                System.debug('Todo ha salido bien!');
				List<ObjResponseUDCs> udcList = ObjResponseUDCs.parse(response.getBody());
                if (!udcList.isEmpty()) {
                    for(ObjResponseUDCs udc: udcList){
                        String udcName = udc.nombreudc.replaceAll(' ', '_');
                        if(recordIDByDeveloperName.get(udcName) != null && udc.descripction1 != '.') {
                            Catalogo_UDC__c d = new Catalogo_UDC__c();
                            d.RecordTypeId = recordIDByDeveloperName.get(udcName);
                            d.description1__c = udc.descripction1;
                            d.Name = d.description1__c;
                            d.description2__c = udc.descripction2;
                            d.productCode__c = udc.codigo.trim();
                            d.ExternalId__c = codeByDeveloperName.get(udcName) + '_' + d.productCode__c;
                            udcListInsert.add(d);
                        } else if (recordIDByDeveloperName.get(udcName) == null) {
                            System.debug(udc.nombreudc);
                        }
                    }
                }

                if (!udcListInsert.isEmpty()) {
                    Database.UpsertResult[] srList  = Database.upsert(udcListInsert, Catalogo_UDC__c.ExternalId__c, false);                
                    Integer success = 0;
                    for (Database.UpsertResult sr : srList) {
                        if (!sr.isSuccess()) {
                            for (Database.Error err : sr.getErrors()) {
                                errorsList.add('Ha ocurrido un error en la UDC:' + err.getStatusCode() + ': ' + err.getMessage() + 
                                    '\n' + 'Los campos que interfieren en el error son: ' + err.getFields()+ '\n\n');
                            }
                        } else {
                            success++;
                        }
                    }
        
                    System.debug(success);
                }
        
                if (!errorsList.isEmpty()) {
                    System.debug(errorsList.size());
                }
            }
        } catch (CallOutException ex) {
            errorsList.add('Hubo una excepcion: ' + ex.getMessage() +', '+ ex.getStackTraceString());
        }                
    }
}