public class ProcesaWS_UDCs {
    public static void getUDCs() {
        List<Catalogo_UDC__c> udcListInsert = new List<Catalogo_UDC__c>();
        List<String> errorsList = new List<String>();
        Map<String, ID> recordIDByDeveloperName = new Map<String, ID>();
        for (RecordType rt : [SELECT ID, DeveloperName
                                FROM Recordtype
                                WHERE SobjectType = 'Catalogo_UDC__c']) {
            recordIDByDeveloperName.put(rt.DeveloperName, rt.ID);
        }

        for(Codigo_WS_de_UDC__mdt udcCode : [SELECT DeveloperName, Product_Code__c, User_Defined_Code__c
                                            FROM Codigo_WS_de_UDC__mdt]) {
            String s =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP000000/">' + '\n' +
                                '<soapenv:Header>' + '\n' +
                                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" soapenv:mustUnderstand="1">' + '\n' +
                                        '<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + '\n' +
                                            '<wsse:Username>' + Label.Usuario + '</wsse:Username>'  + '\n' +
                                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + Label.Password +'</wsse:Password>' + '\n' +
                                        '</wsse:UsernameToken>' + '\n' +
                                    '</wsse:Security>'  + '\n' +
                                '</soapenv:Header>' + '\n' +
                            '<soapenv:Body>' + '\n' +
                                '<orac:lookupUDC>' + '\n' +
                                    '<description1></description1>' + '\n' +
                                    '<description2></description2>' + '\n' +
                                    '<productCode>' + udcCode.Product_Code__c +'</productCode>' + '\n' +
                                    '<userDefinedCode>' + udcCode.User_Defined_Code__c + '</userDefinedCode>' + '\n' +
                                    '<userDefinedCodeValue></userDefinedCodeValue>' + '\n' +
                                '</orac:lookupUDC>' + '\n' +
                            '</soapenv:Body>' + '\n' +
                        '</soapenv:Envelope>';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(Label.URL_WS_UDCs_LINEAS_MARCAS);
            req.setMethod('POST');
            req.setBody(s);
            req.setHeader('Content-Type', 'text/xml');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            if (res.getStatusCode() != 200) {
                System.debug('Ha ocurrido un error ' + res.getStatus() + ', codigo: ' + res.getStatusCode());
            } else {
                Dom.Document doc = new Dom.Document();
                doc.load(res.getBody());
                Dom.XMLNode root = doc.getRootElement();
                for (Dom.XMLNode child : root.getChildElements()) {
                    for (Dom.XMLNode child2 : child.getChildElements()) {
                        for (Dom.XMLNode child3 : child2.getChildElements()) {
                            if (child3.getName() == 'userDefinedCode'){
                                Catalogo_UDC__c d = new Catalogo_UDC__c();
                                if(recordIDByDeveloperName.get(udcCode.DeveloperName) != null) {
                                    d.RecordTypeId = recordIDByDeveloperName.get(udcCode.DeveloperName);
                                    for(Dom.XMLNode child4 : child3.getChildElements()) {
                                        if (child4.getName() == 'description1'){
                                            d.description1__c = child4.getText();
                                            d.Name = d.description1__c;
                                        } else if (child4.getName() == 'description2'){
                                            d.description2__c = child4.getText();
                                        } else if (child4.getName() == 'userDefinedCode'){
                                            d.productCode__c = child4.getText();
                                            d.ExternalId__c = udcCode.Product_Code__c + '_' + 
                                                              udcCode.User_Defined_Code__c + '_' + 
                                                              d.productCode__c.trim();
                                        }
                                    }
                                    if (d.Name != '.' && d.productCode__c != null) {
                                        udcListInsert.add(d);
                                    }
                                } else {
                                    System.debug(udcCode.DeveloperName);
                                }
                            }
                        }
                    }
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
}