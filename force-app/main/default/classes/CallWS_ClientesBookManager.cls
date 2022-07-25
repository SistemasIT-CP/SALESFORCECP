public class CallWS_ClientesBookManager {
    public static List<String> InsertarCliente(
                    Id ObjId, 
                    String actionTypeAcc
    ) {
        List<String> respuesta = new List<String>();
        
        try {
            String xml = generaXMLRequest(ObjId, 
                                        actionTypeAcc);

            String s =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">' + '\n' +
                                '<soapenv:Header>' + '\n' +
                                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"' + '\n' +
                                                    'soapenv:mustUnderstand="1">' + '\n' +
                                        '<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                            'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + '\n' +
                                            '<wsse:Username>' + Label.Usuario + '</wsse:Username>' + '\n' +
                                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + Label.Password + '</wsse:Password>' + '\n' +
                                        '</wsse:UsernameToken>' + '\n' +
                                    '</wsse:Security>' + '\n' +
                                '</soapenv:Header>' + '\n' +
                            '<soapenv:Body>' + '\n' +
                                '<orac:processAddressBook>' + '\n' +
                                             xml + '\n' +
                                '</orac:processAddressBook>' + '\n' +
                            '</soapenv:Body>' + '\n' +
                        '</soapenv:Envelope>';
        
            HttpResponse res = makeCall(s);
            
            System.debug(xml);

            if (res.getStatusCode() == 200) {
                respuesta.add('200');
                System.debug('Todo ha salido bien!');
                String idCliente;
                if(actionTypeAcc == '1') {
                    Dom.Document doc = new Dom.Document();  
                    doc.load(res.getBody());  
                    Dom.XMLNode rootElement = doc.getRootElement();  
                    for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
                        for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                            if(detailElement.getChildElements().size() > 0) {
                                for (Dom.XMLNode detailElement2 : detailElement.getChildElements()) {
                                    if(detailElement2.getChildElements().size() > 0) {
                                        for (Dom.XMLNode detailElement3 : detailElement2.getChildElements()) { 
                                            switch on detailElement3.getName() {
                                                when 'entityId' { 
                                                    idCliente = detailElement3.getText();
                                                }
                                            }    
                                        }
                                    }
                                }
                            }
                        }
                    }
                }



                if (idCliente != null) {
                    respuesta.add(idCliente);
                }
            } else {
                System.debug('Ha ocurrido un error ' + res.getStatus() + ', codigo: ' + res.getStatusCode());
					
                String error = 'Status: ' + res.getStatus() + ', codigo: ' + res.getStatusCode();
                String objeto = 'CUENTA';
                String horario = Datetime.now().format();
    
                if (respuesta.isEmpty()) {
                    respuesta.add('500');
                    respuesta.add(error);
                    respuesta.add(horario);
                    respuesta.add('' + ObjId);
                    respuesta.add(objeto);
                    respuesta.add(xml);
                }
            }
        } catch (Exception e) {
            System.debug(e);
            String msjeError = '';
            if(e.getTypeName() == 'System.NullPointerException') {
                msjeError += 'Un campo requerido tiene un valor nulo.';
            } else if(e.getTypeName() == 'System.CalloutException') {
                msjeError += 'No se ha podido comunicar correctamente con el WS.';
            } else if(e.getTypeName() == 'System.DmlException') {
                msjeError += 'No se ha podido realizar un insert/update.';
            } else {
                msjeError += e.getMessage();
            }

            String objeto = 'CUENTA';
            String horario = Datetime.now().format();

            respuesta.add('500');
            respuesta.add(msjeError);
            respuesta.add(horario);
            respuesta.add('' + ObjId);
            respuesta.add(objeto);
        }

        return respuesta;
    }

    public static List<String> InsertarContacto(
                    Id ObjId, 
                    String actionTypeContact, 
                    String actionTypeCorreo, 
                    String actionTypeTelefono, 
                    String actionTypeDireccion, 
                    String objEjecucion,
                    List<String> criterios
    ) {
        List<String> respuesta = new List<String>();

        try{
            List<String> xmlList = generaXMLRequestContact(ObjId, 
                                                actionTypeContact, 
                                                actionTypeCorreo, 
                                                actionTypeTelefono, 
                                                actionTypeDireccion, 
                                                objEjecucion,
                                                criterios
                                                );

            for (String xml : xmlList) {
                String s =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">' + '\n' +
                                '<soapenv:Header>' + '\n' +
                                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"' + '\n' +
                                                    'soapenv:mustUnderstand="1">' + '\n' +
                                        '<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                            'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + '\n' +
                                            '<wsse:Username>' + Label.Usuario + '</wsse:Username>' + '\n' +
                                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + Label.Password + '</wsse:Password>' + '\n' +
                                        '</wsse:UsernameToken>' + '\n' +
                                    '</wsse:Security>' + '\n' +
                                '</soapenv:Header>' + '\n' +
                                '<soapenv:Body>' + '\n' +
                                    '<orac:processContact>'+ '\n' +
                                        xml +
                                    '</orac:processContact>'+ '\n' +
                                '</soapenv:Body>'+ '\n' +
                            '</soapenv:Envelope>';
            
                HttpResponse res = makeCall(s);

                String response;

                System.debug(xml);
                
                if(res.getStatusCode() == 200) {
                    System.debug('Todo ha salido bien');
                    if (respuesta.isEmpty()) {
                        respuesta.add('200');
                    }
                    
                } else {         
                    System.debug('Ha ocurrido un error ' + res.getStatus() + ', codigo: ' + res.getStatusCode());
					
                    String error = 'Status: ' + res.getStatus() + ', codigo: ' + res.getStatusCode();
                    String objeto = objEjecucion == 'CUENTA'? 'CONTACTO 0 DE CUENTA JURIDICA' : objEjecucion;
                    String horario = Datetime.now().format();

                    if (respuesta.isEmpty()) {
                        respuesta.add('500');
                        respuesta.add(error);
                        respuesta.add(horario);
                        respuesta.add('' + ObjId);
                        respuesta.add(objeto);
                        respuesta.add(xml);
                    }
                }
            }
        } catch (Exception e) {            
            System.debug(e);
            String msjeError = '';
            if(e.getTypeName() == 'System.NullPointerException') {
                msjeError += 'Un campo requerido tiene un valor nulo.';
            } else if(e.getTypeName() == 'System.CalloutException') {
                msjeError += 'No se ha podido comunicar correctamente con el WS.';
            } else if(e.getTypeName() == 'System.DmlException') {
                msjeError += 'No se ha podido realizar un insert/update.';
            } else {
                msjeError += e.getMessage();
            }
            
            String objeto = objEjecucion == 'CUENTA'? 'CONTACTO 0 DE CUENTA JURIDICA' : objEjecucion;
            String horario = Datetime.now().format();

            respuesta.add('500');
            respuesta.add(msjeError);
            respuesta.add(horario);
            respuesta.add('' + ObjId);
            respuesta.add(objeto);
        }

        return respuesta;
    }
    
    public static List<String> InsertarClienteDesdeCuenta(
                    Account acc, 
                    String actionTypeAcc
    ) {
        List<String> respuesta = new List<String>();
        
        try {
            String xml = generaXMLRequestCuenta(acc, 
                                        		actionTypeAcc);

            String s =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">' + '\n' +
                                '<soapenv:Header>' + '\n' +
                                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"' + '\n' +
                                                    'soapenv:mustUnderstand="1">' + '\n' +
                                        '<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                            'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + '\n' +
                                            '<wsse:Username>' + Label.Usuario + '</wsse:Username>' + '\n' +
                                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + Label.Password + '</wsse:Password>' + '\n' +
                                        '</wsse:UsernameToken>' + '\n' +
                                    '</wsse:Security>' + '\n' +
                                '</soapenv:Header>' + '\n' +
                            '<soapenv:Body>' + '\n' +
                                '<orac:processAddressBook>' + '\n' +
                                             xml + '\n' +
                                '</orac:processAddressBook>' + '\n' +
                            '</soapenv:Body>' + '\n' +
                        '</soapenv:Envelope>';
        
            HttpResponse res = makeCall(s);
            
            System.debug(xml);

            if (res.getStatusCode() == 200) {
                respuesta.add('200');
                System.debug('Todo ha salido bien!');
                String idCliente;
                if(actionTypeAcc == '1') {
                    Dom.Document doc = new Dom.Document();  
                    doc.load(res.getBody());  
                    Dom.XMLNode rootElement = doc.getRootElement();  
                    for (Dom.XMLNode childElement : rootElement.getChildElements()) {  
                        for (Dom.XMLNode detailElement : childElement.getChildElements()) { 
                            if(detailElement.getChildElements().size() > 0) {
                                for (Dom.XMLNode detailElement2 : detailElement.getChildElements()) {
                                    if(detailElement2.getChildElements().size() > 0) {
                                        for (Dom.XMLNode detailElement3 : detailElement2.getChildElements()) { 
                                            switch on detailElement3.getName() {
                                                when 'entityId' { 
                                                    idCliente = detailElement3.getText();
                                                }
                                            }    
                                        }
                                    }
                                }
                            }
                        }
                    }
                }



                if (idCliente != null) {
                    respuesta.add(idCliente);
                }
            } else {
                System.debug('Ha ocurrido un error ' + res.getStatus() + ', codigo: ' + res.getStatusCode());
					
                String error = 'Status: ' + res.getStatus() + ', codigo: ' + res.getStatusCode();
                String objeto = 'CUENTA';
                String horario = Datetime.now().format();
    
                if (respuesta.isEmpty()) {
                    respuesta.add('500');
                    respuesta.add(error);
                }
            }
        } catch (Exception e) {
            System.debug(e);
            String msjeError = '';
            if(e.getTypeName() == 'System.NullPointerException') {
                msjeError += 'Un campo requerido tiene un valor nulo.';
            } else if(e.getTypeName() == 'System.CalloutException') {
                msjeError += 'No se ha podido comunicar correctamente con el WS.';
            } else if(e.getTypeName() == 'System.DmlException') {
                msjeError += 'No se ha podido realizar un insert/update.';
            } else {
                msjeError += e.getMessage();
            }

            String objeto = 'CUENTA';
            String horario = Datetime.now().format();

            respuesta.add('500');
            respuesta.add(msjeError);
        }

        return respuesta;
    }

    @future(callout=true)
    public static void Inserta_Actualiza_Contacto(
                    Id ObjId, 
                    String actionTypeContact, 
                    String actionTypeCorreo, 
                    String actionTypeTelefono, 
                    String actionTypeDireccion, 
                    String objEjecucion,
                    List<String> criterios
    ) {
        try{
            List<String> xmlList = generaXMLRequestContact(ObjId, 
                                                actionTypeContact, 
                                                actionTypeCorreo, 
                                                actionTypeTelefono, 
                                                actionTypeDireccion, 
                                                objEjecucion,
                                                criterios
                                                );

            for (String xml : xmlList) {
                String s =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:orac="http://oracle.e1.bssv.JP010000/">' + '\n' +
                                '<soapenv:Header>' + '\n' +
                                    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                    'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"' + '\n' +
                                                    'soapenv:mustUnderstand="1">' + '\n' +
                                        '<wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"' + '\n' +
                                                            'xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' + '\n' +
                                            '<wsse:Username>' + Label.Usuario + '</wsse:Username>' + '\n' +
                                            '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + Label.Password + '</wsse:Password>' + '\n' +
                                        '</wsse:UsernameToken>' + '\n' +
                                    '</wsse:Security>' + '\n' +
                                '</soapenv:Header>' + '\n' +
                                '<soapenv:Body>' + '\n' +
                                    '<orac:processContact>'+ '\n' +
                                        xml +
                                    '</orac:processContact>'+ '\n' +
                                '</soapenv:Body>'+ '\n' +
                            '</soapenv:Envelope>';
            
                HttpResponse res = makeCall(s);

                String response;
                
                System.debug(xml);
                
                if(res.getStatusCode() == 200) {
                    System.debug('Todo ha salido bien');

                    if(objEjecucion == 'CONTACTO' && actionTypeContact != '3') {
                        Contact cont =
                        [SELECT Envio_correcto_a_WS__c
                        FROM Contact 
                        WHERE ID =: ObjID
                        ];

                        cont.Envio_correcto_a_WS__c = true;

                        update cont;
                    }

                    List<Debug_log__c> debugList = 
                        [SELECT ID 
                        FROM Debug_log__c
                        WHERE ID_Objeto__c =: ObjId
                        ];

                    if (!debugList.isEmpty()) {
                        delete debugList;
                    }
                    
                } else {
                    System.debug('Ha ocurrido un error ' + res.getStatus() + ', codigo: ' + res.getStatusCode());
                    if(actionTypeContact != '3') {
                        ID errorId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Error')
                                .getRecordTypeId();

                        Debug_log__c dl = new Debug_log__c();
                        dl.Error__c = 'Status: ' + res.getStatus() + ', codigo: ' + res.getStatusCode();
                        dl.Horario__c = Datetime.now().format();
                        dl.ID_Objeto__c = '' + ObjId;
                        dl.Objeto__c = objEjecucion == 'CUENTA'? 'CONTACTO 0 DE CUENTA JURIDICA' : objEjecucion;
                        dl.XML__c = xml;  
                        dl.RecordTypeId = errorId;
                        
                        insert dl;
                    }
                }
            }
        } catch (Exception e) {
            System.debug(e);
            String msjeError = '';
            if(e.getTypeName() == 'System.NullPointerException') {
                msjeError += 'Un campo requerido tiene un valor nulo.';
            } else if(e.getTypeName() == 'System.CalloutException') {
                msjeError += 'No se ha podido comunicar correctamente con el WS.';
            } else if(e.getTypeName() == 'System.DmlException') {
                msjeError += 'No se ha podido realizar un insert/update.';
            } else {
                msjeError += e.getMessage();
            }

            ID errorId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Error')
                                .getRecordTypeId();

            Debug_log__c dl = new Debug_log__c();
            dl.Error__c = msjeError;
            dl.Horario__c = Datetime.now().format();
            dl.ID_Objeto__c = '' + ObjId;
            dl.Objeto__c = objEjecucion == 'CUENTA'? 'CONTACTO 0 DE CUENTA JURIDICA' : objEjecucion;
            dl.RecordTypeId = errorId;
            
            insert dl;
        }
    }
    
    public static HTTPResponse makeCall (String s) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.URL_WS_CLIENTE);
        req.setMethod('POST');
        req.setBody(s);
        req.setHeader('Content-Type', 'text/xml');
        req.setTimeout(100000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        return res;
    }

    public static String generaXMLRequest(
                    Id ObjId, 
                    String actionTypeAcc
    ) {
        String xmlReq;
        Account acc;
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        if (ObjId != null) {
            if(actionTypeAcc =='3'){
                acc = 
                    [SELECT Direccion__c, Ciudad_UDC__c, Ciudad_UDC__r.Name, Pa_s__r.Name,
                            Nacionalidad_UDC__c, Nacionalidad_UDC__r.productCode__c,
                            Pa_s__r.productCode__c, Name, Departamento__r.productCode__c, Pa_s__c,
                            Departamento__c, Profesion_UDC__c, Profesion_UDC__r.productCode__c,
                            Ocupacion_UDC__c, Ocupacion_UDC__r.productCode__c,  Tipo_de_t_lefono__c,
                            Tipo_de_t_lefono__r.productCode__c, Phone, Email__c, 
                            Actividad_economica_UDC__c, Actividad_economica_UDC__r.productCode__c, Cedula__c,
                            CodigoCliente__c, INDUSTRYCLASSIFICATIONCODE__c, ID, BUSINESSUNIT__c, Tipo_de_b_squeda__c,
                            Tipo_de_b_squeda__r.productcode__c, RecordTypeID, Numero_de_documento__pc, Extranjero__c,
                            Categorycode001__c, categorycode002__c, Categorycode003__c, Categorycode004__c, Categorycode005__c,
                            Categorycode006__c, Categorycode007__c, Categoria_8_UDC__c, Categoria_8_UDC__r.productCode__c,
                            Categorycode009__c, Categorycode010__c, Categorycode011__c, Categoria_12__c, Categorycode013__c, 
                            Categorycode014__c, Categorycode015__c, Categorycode016__c, Categorycode017__c, Categorycode018__c, 
                            Categoria_20__c, Categoria_21__c, Categoria_22__c, Categorycode023__c, Categorycode024__c, 
                            Categoria_25__c, Categoria_26_UDC__c, Categoria_26_UDC__r.productCode__c, Categoria_27__c, Categorycode028__c, 
                            Categorycode029__c, Categoria_30__c, Categor_a_19_segmento_UDC__c, Categor_a_19_segmento_UDC__r.productcode__c,
                            Tipo_de_email__c, Tipo_de_email__r.productcode__c, NIT__c, NRC__c, Municipio__c, Municipio__r.Name
                    FROM Account 
                    WHERE ID =: ObjId 
                    ALL ROWS
                    ];
            } else {
                acc = 
                [SELECT Direccion__c, Ciudad_UDC__c, Ciudad_UDC__r.Name, Pa_s__r.Name,
                        Nacionalidad_UDC__c, Nacionalidad_UDC__r.productCode__c,
                        Pa_s__r.productCode__c, Name, Departamento__r.productCode__c, Pa_s__c,
                        Departamento__c, Profesion_UDC__c, Profesion_UDC__r.productCode__c,
                        Ocupacion_UDC__c, Ocupacion_UDC__r.productCode__c,  Tipo_de_t_lefono__c,
                        Tipo_de_t_lefono__r.productCode__c, Phone, Email__c, 
                        Actividad_economica_UDC__c, Actividad_economica_UDC__r.productCode__c, Cedula__c,
                        CodigoCliente__c, INDUSTRYCLASSIFICATIONCODE__c, ID, BUSINESSUNIT__c, Tipo_de_b_squeda__c,
                        Tipo_de_b_squeda__r.productcode__c, RecordTypeID, Numero_de_documento__pc, Extranjero__c,
                 		Categorycode001__c, categorycode002__c, Categorycode003__c, Categorycode004__c, Categorycode005__c,
                        Categorycode006__c, Categorycode007__c, Categoria_8_UDC__c, Categoria_8_UDC__r.productCode__c,
                        Categorycode009__c, Categorycode010__c, Categorycode011__c, Categoria_12__c, Categorycode013__c, 
                        Categorycode014__c, Categorycode015__c, Categorycode016__c, Categorycode017__c, Categorycode018__c, 
                        Categoria_20__c, Categoria_21__c, Categoria_22__c, Categorycode023__c, Categorycode024__c, 
                        Categoria_25__c, Categoria_26_UDC__c, Categoria_26_UDC__r.productCode__c, Categoria_27__c, Categorycode028__c, 
                        Categorycode029__c, Categoria_30__c, Categor_a_19_segmento_UDC__c, Categor_a_19_segmento_UDC__r.productcode__c,
                 		Tipo_de_email__c, Tipo_de_email__r.productcode__c, NIT__c, NRC__c, Municipio__c, Municipio__r.Name
                FROM Account 
                WHERE id =: ObjId
                ];
            }
            
            List<String> direcciones = new List<String>();
            
            if (String.isNotBlank(acc.Direccion__c)) {
                Integer inicio = 0;
                Integer fin = inicio + 40 < acc.Direccion__c.length()? inicio + 40 : acc.Direccion__c.length();
                while(inicio < fin) {
                    direcciones.add(acc.Direccion__c.substring(inicio, fin));
                    inicio = inicio + 40;
                    fin = inicio + 40 < acc.Direccion__c.length()? inicio + 40 : acc.Direccion__c.length(); 
                }    
            }

            List<String> telefonoSeparado = new List<String>();

            if (String.isNotBlank(acc.Phone)) {
                telefonoSeparado = telefonoSeparado(acc.Phone);
            }

            XmlStreamWriter w = new XmlStreamWriter();
            
            w.writeStartElement(null,'addressBook',null);
                w.writeStartElement(null, 'address', null);
                    for (Integer j = 0; j < 4; j++) {
                        w.writeStartElement(null, 'addressLine' + (j + 1), null);
                            if(direcciones.size() > j) {
                                w.writeCharacters(direcciones[j]);
                            }
                        w.writeEndElement();
                    }
            		w.writeStartElement(null, 'city', null);
            			if(acc.Ciudad_UDC__c != null){
                            w.writeCharacters(acc.Ciudad_UDC__r.Name);
                        }    
                    w.writeEndElement();
                    w.writeStartElement(null, 'countryCode', null);
                        if(acc.Pa_s__c != null){
                        	w.writeCharacters(acc.Pa_s__r.productCode__c);    
                    	}
                    w.writeEndElement();
            		w.writeStartElement(null, 'countyCode', null);
            			if (acc.Municipio__c != null) {
                            w.writeCharacters(acc.Municipio__r.Name);
                        }    
                    w.writeEndElement();
                    w.writeStartElement(null, 'dateEffective', null);
                    w.writeEndElement();
                    w.writeStartElement(null, 'mailingName', null);
                        w.writeCharacters(acc.Name);
                    w.writeEndElement();
            		w.writeStartElement(null, 'mailingNameSecondary', null);
                    w.writeEndElement();
            		w.writeStartElement(null, 'postalCode', null);
                    w.writeEndElement();
                    w.writeStartElement(null, 'stateCode', null);
                        if(acc.Departamento__c != null){
                            w.writeCharacters(acc.Departamento__r.productCode__c);
                    	}    
            		w.writeEndElement();
                w.writeEndElement(); 

                w.writeStartElement(null, 'businessUnit', null);
                    if (String.isNotBlank(acc.BUSINESSUNIT__c)) {
                        w.writeCharacters(acc.BUSINESSUNIT__c); 
                    } else {
                        w.writeCharacters('2414');
                    }
                w.writeEndElement();
                w.writeStartElement(null, 'callSalesTeamAlignment', null);
                w.writeEndElement();

                w.writeStartElement(null, 'categoryCodesAddressBook', null);
            		if (String.isNotBlank(acc.Categorycode001__c)) {
                        w.writeStartElement(null,'categoryCode001',null);
                        	w.writeCharacters(acc.Categorycode001__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.categorycode002__c)) {
                        w.writeStartElement(null,'categoryCode002',null);
                        	w.writeCharacters(acc.categorycode002__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode003__c)) {
                        w.writeStartElement(null,'categoryCode003',null);
                        	w.writeCharacters(acc.Categorycode003__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode004__c)) {
                        w.writeStartElement(null,'categoryCode004',null);
                        	w.writeCharacters(acc.Categorycode004__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode005__c)) {
                        w.writeStartElement(null,'categoryCode005',null);
                        	w.writeCharacters(acc.Categorycode005__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode006__c)) {
                        w.writeStartElement(null,'categoryCode006',null);
                        	w.writeCharacters(acc.Categorycode006__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode007__c)) {
                        w.writeStartElement(null,'categoryCode007',null);
                        	w.writeCharacters(acc.Categorycode007__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_8_UDC__c)) {
                        w.writeStartElement(null,'categoryCode008',null);
                        	w.writeCharacters(acc.Categoria_8_UDC__r.productcode__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode009__c)) {
                        w.writeStartElement(null,'categoryCode009',null);
                        	w.writeCharacters(acc.Categorycode009__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode010__c)) {
                        w.writeStartElement(null,'categoryCode010',null);
                        	w.writeCharacters(acc.Categorycode010__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode011__c)) {
                        w.writeStartElement(null,'categoryCode011',null);
                        	w.writeCharacters(acc.Categorycode011__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_12__c)) {
                        w.writeStartElement(null,'categoryCode012',null);
                        	w.writeCharacters(acc.Categoria_12__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode013__c)) {
                        w.writeStartElement(null,'categoryCode013',null);
                        	w.writeCharacters(acc.Categorycode013__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode014__c)) {
                        w.writeStartElement(null,'categoryCode014',null);
                        	w.writeCharacters(acc.Categorycode014__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode015__c)) {
                        w.writeStartElement(null,'categoryCode015',null);
                        	w.writeCharacters(acc.Categorycode015__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode016__c)) {
                        w.writeStartElement(null,'categoryCode016',null);
                        	w.writeCharacters(acc.Categorycode016__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode017__c)) {
                        w.writeStartElement(null,'categoryCode017',null);
                        	w.writeCharacters(acc.Categorycode017__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode018__c)) {
                        w.writeStartElement(null,'categoryCode018',null);
                        	w.writeCharacters(acc.Categorycode018__c);
                        w.writeEndElement(); 
                    }
                        
            		if (String.isNotBlank(acc.Categor_a_19_segmento_UDC__c)) {
                        w.writeStartElement(null,'categoryCode019',null);
                        	w.writeCharacters(acc.Categor_a_19_segmento_UDC__r.productcode__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_20__c)) {
                        w.writeStartElement(null,'categoryCode020',null);
                        	w.writeCharacters(acc.Categoria_20__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_21__c)) {
                        w.writeStartElement(null,'categoryCode021',null);
                        	w.writeCharacters(acc.Categoria_21__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_22__c)) {
                        w.writeStartElement(null,'categoryCode022',null);
                        	w.writeCharacters(acc.Categoria_22__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode023__c)) {
                        w.writeStartElement(null,'categoryCode023',null);
                        	w.writeCharacters(acc.Categorycode023__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode024__c)) {
                        w.writeStartElement(null,'categoryCode024',null);
                        	w.writeCharacters(acc.Categorycode024__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_25__c)) {
                        w.writeStartElement(null,'categoryCode025',null);
                        	w.writeCharacters(acc.Categoria_25__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_26_UDC__c)) {
                        w.writeStartElement(null,'categoryCode026',null);
                        	w.writeCharacters(acc.Categoria_26_UDC__r.productcode__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_27__c)) {
                        w.writeStartElement(null,'categoryCode027',null);
                        	w.writeCharacters(acc.Categoria_27__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode028__c)) {
                        w.writeStartElement(null,'categoryCode028',null);
                        	w.writeCharacters(acc.Categorycode028__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categorycode029__c)) {
                        w.writeStartElement(null,'categoryCode029',null);
                        	w.writeCharacters(acc.Categorycode029__c);
                        w.writeEndElement(); 
                    }
            
            		if (String.isNotBlank(acc.Categoria_30__c)) {
                        w.writeStartElement(null,'categoryCode030',null);
                        	w.writeCharacters(acc.Categoria_30__c);
                        w.writeEndElement(); 
                    }
                w.writeEndElement();
                    
                w.writeStartElement(null, 'classifications', null); 
                    w.writeStartElement(null, 'classificationCode001', null);
                        if(acc.Profesion_UDC__c != null){
                            w.writeCharacters(rellenarConNBlancos(3, acc.Profesion_UDC__r.productCode__c));
                        } else {
                            w.writeCharacters('  0');
                        }
                    w.writeEndElement();
            
                    w.writeStartElement(null, 'classificationCode002', null);
                        if(acc.Ocupacion_UDC__c != null){
                            w.writeCharacters(rellenarConNBlancos(3, acc.Ocupacion_UDC__r.productCode__c));
                        } else {
                            w.writeCharacters('  0');
                        }
                    w.writeEndElement();
            
                    w.writeStartElement(null, 'classificationCode003', null);
                        if(acc.Actividad_economica_UDC__c != null){
                            w.writeCharacters(rellenarConNBlancos(3, acc.Actividad_economica_UDC__r.productCode__c));
                        } else {
                            w.writeCharacters('  0');
                        }
                    w.writeEndElement();
                    
                    w.writeStartElement(null, 'classificationCode004', null);
                        if(acc.Nacionalidad_UDC__c != null){
                            w.writeCharacters(rellenarConNBlancos(3, acc.Nacionalidad_UDC__r.productCode__c));
                        } else {
                            w.writeCharacters('  0');
                        }
                    w.writeEndElement();
            
                    w.writeStartElement(null, 'classificationCode005', null);
                    w.writeEndElement();
                w.writeEndElement(); 

                if (actionTypeAcc != '3') {
                    if (String.isNotBlank(acc.Email__c)) {
                    	w.writeStartElement(null, 'electronicAddresses', null);
                            w.writeStartElement(null, 'actionType', null);
                                w.writeCharacters(actionTypeAcc);
                            w.writeEndElement();
                            w.writeStartElement(null, 'contactId', null);
                                    w.writeCharacters('0');
                            w.writeEndElement();
                            w.writeStartElement(null, 'electronicAddress', null);
                                w.writeCharacters(acc.Email__c);
                            w.writeEndElement();
                            w.writeStartElement(null, 'electronicAddressClassificationCode', null);
                            w.writeEndElement();
                            w.writeStartElement(null, 'electronicAddressLineNumber', null);
                                    w.writeCharacters('1');
                            w.writeEndElement();
                            w.writeStartElement(null, 'electronicAddressTypeCode', null);
                                if (String.isNotBlank(acc.Tipo_de_email__c)) {
                                    w.writeCharacters(acc.Tipo_de_email__r.productcode__c);    
                                }
                            w.writeEndElement();
                            w.writeStartElement(null, 'messageIndicatorCode', null);
                                w.writeCharacters('0');
                            w.writeEndElement();
                        w.writeEndElement();    
                    }
                }
                        
                w.writeStartElement(null, 'employeeGroupApprovalsCode', null);
                w.writeEndElement();

                w.writeStartElement(null, 'entity', null);
                    w.writeStartElement(null, 'entityId', null);
                        if(String.isNotBlank(acc.CodigoCliente__c) && actionTypeAcc != '1'){
                            w.writeCharacters(acc.CodigoCliente__c); 	   
                        }
                    w.writeEndElement();
            		                w.writeStartElement(null, 'entityLongId', null);
                    if(String.isNotBlank(acc.Cedula__c) && acc.RecordTypeID == personAccountID) {
                        w.writeCharacters(acc.Cedula__c); 	   
                    }
                    w.writeEndElement();
                    w.writeStartElement(null, 'entityTaxId', null);
                        System.debug(acc.NRC__c);
                        if (String.isNotBlank(acc.NRC__c)) {
                            w.writeCharacters(acc.NRC__c);
                        } else if(String.isNotBlank(acc.Cedula__c)){
                            w.writeCharacters(acc.Cedula__c);
                        }
                    w.writeEndElement();
                w.writeEndElement();
                w.writeStartElement(null, 'entityName', null);
                    w.writeCharacters(acc.Name);
                w.writeEndElement();     
                w.writeStartElement(null, 'entityNameSecondary', null);
                w.writeEndElement();     
                w.writeStartElement(null, 'entityTaxIdAdditional', null);
            		if(String.isNotBlank(acc.NIT__c)) {
                        w.writeCharacters(acc.NIT__c);
                    }
                w.writeEndElement();     
                w.writeStartElement(null, 'entityTypeCode', null);
                    if(acc.Tipo_de_b_squeda__c != null) {
                        w.writeCharacters(acc.Tipo_de_b_squeda__r.productCode__c);
                    } else {
                        w.writeCharacters('C'); //Customers es el tipo de busqueda default
                    }
                w.writeEndElement();     
                w.writeStartElement(null, 'industryClassificationCode', null); //
                    if(String.isNotBlank(acc.INDUSTRYCLASSIFICATIONCODE__c)){
                        w.writeCharacters(acc.INDUSTRYCLASSIFICATIONCODE__c);    
                    }
                w.writeEndElement();     
                w.writeStartElement(null, 'isEntityTypeEmployee', null);
                w.writeEndElement();     
                w.writeStartElement(null, 'isEntityTypeNettingIndicator', null);
                w.writeEndElement();     
                w.writeStartElement(null, 'isEntityTypePayables', null);
                w.writeEndElement();     
                w.writeStartElement(null, 'isEntityTypePurchaser', null);
                w.writeEndElement();     
                w.writeStartElement(null, 'isEntityTypeReceivables', null);
                w.writeEndElement();  
                w.writeStartElement(null, 'languageCode', null);
                w.writeEndElement();  
            
                w.writeStartElement(null, 'parent', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                
                w.writeStartElement(null, 'personCorporationCode', null);
                    if(acc.RecordTypeId == personAccountID){
                        w.writeCharacters('1');
                    } else {
                        w.writeCharacters('2');
                    }    
                w.writeEndElement();

                if (actionTypeAcc =='1' || actionTypeAcc =='2') {
                    w.writeStartElement(null, 'phoneNumbers', null);
                        w.writeStartElement(null, 'actionType', null);
                            w.writeCharacters(actionTypeAcc);
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'areaCode', null); 
                            if(!telefonoSeparado.isEmpty()) {
                                w.writeCharacters(telefonoSeparado[0].removeStart('+'));
                            } 
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'contactId', null);
                                w.writeCharacters('0');
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'phoneLineNumber', null);
                                w.writeCharacters('1');
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'phoneNumber', null);
                            if(!telefonoSeparado.isEmpty()) {
                                w.writeCharacters(telefonoSeparado[1]);
                            }
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'phoneTypeCode', null);
                            if(acc.Tipo_de_t_lefono__c != null){
                                w.writeCharacters(acc.Tipo_de_t_lefono__r.productCode__c);
                            }
                        w.writeEndElement(); 
                    w.writeEndElement(); 
                }

                w.writeStartElement(null, 'processing', null);
                    w.writeStartElement(null, 'actionType', null);
                        w.writeCharacters(actionTypeAcc);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'processingVersion', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                
                w.writeStartElement(null, 'relatedAddress1', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'relatedAddress2', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'relatedAddress3', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'relatedAddress4', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'relatedAddress5', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'relatedAddress6', null);
                    w.writeStartElement(null, 'entityId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityLongId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'entityTaxId', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                
                w.writeStartElement(null, 'remark', null);
                w.writeEndElement(); 
                
                w.writeStartElement(null, 'statistics', null);
                    w.writeStartElement(null, 'dunBradStreetId', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'numberOfEmployees', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'rateGrowth', null);
                        w.writeCharacters(acc.Extranjero__c? '1' : '0');
                    w.writeEndElement();
                    w.writeStartElement(null, 'revenueRangeCode', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'yearCompanyFounded', null);
                    w.writeEndElement();
                w.writeEndElement(); 
            
                w.writeStartElement(null, 'stock', null);
                    w.writeStartElement(null, 'stockExchange', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'stockTickerSymbol', null);
                    w.writeEndElement(); 
                w.writeEndElement(); 
                w.writeStartElement(null, 'taxExemptCertificate', null);
                w.writeEndElement(); 
            
                w.writeStartElement(null, 'userReservedData', null);
                    w.writeStartElement(null, 'userReservedAmount', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'userReservedCode', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'userReservedDate', null);
                    w.writeEndElement();
                    w.writeStartElement(null, 'userReservedNumber', null);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'userReservedReference', null);
                    w.writeEndElement();
                w.writeEndElement(); 
            w.writeEndElement();

            xmlReq = w.getXmlString();
        }

        return xmlReq;
    }
    
    public static String generaXMLRequestCuenta(
                    Account acc, 
                    String actionTypeAcc
    ) {
        System.debug(acc);
        
        String xmlReq;
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        Map<ID, Catalogo_UDC__c> mapUDC = new Map<ID, Catalogo_UDC__c>(
            [SELECT ID, Name, productcode__c
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Genero'
               OR RecordType.DeveloperName = 'Departamento'
               OR RecordType.DeveloperName = 'Municipio'
               OR RecordType.DeveloperName = 'Pais'
               OR RecordType.DeveloperName = 'Nacionalidad'
               OR RecordType.DeveloperName = 'Tipo_de_Telefono'
               OR RecordType.DeveloperName = 'Tipos_de_eMail'
            ]);
            
        List<String> direcciones = new List<String>();
        
        if (String.isNotBlank(acc.Direccion__c)) {
            Integer inicio = 0;
            Integer fin = inicio + 40 < acc.Direccion__c.length()? inicio + 40 : acc.Direccion__c.length();
            while(inicio < fin) {
                direcciones.add(acc.Direccion__c.substring(inicio, fin));
                inicio = inicio + 40;
                fin = inicio + 40 < acc.Direccion__c.length()? inicio + 40 : acc.Direccion__c.length(); 
            }    
        }

        List<String> telefonoSeparado = new List<String>();

        if (String.isNotBlank(acc.Phone)) {
            telefonoSeparado = telefonoSeparado(acc.Phone);
        }

        XmlStreamWriter w = new XmlStreamWriter();
        
        w.writeStartElement(null,'addressBook',null);
            w.writeStartElement(null, 'address', null);
                for (Integer j = 0; j < 4; j++) {
                    w.writeStartElement(null, 'addressLine' + (j + 1), null);
                        if(direcciones.size() > j) {
                            w.writeCharacters(direcciones[j]);
                        }
                    w.writeEndElement();
                }
                w.writeStartElement(null, 'city', null);
                    if(acc.Ciudad_UDC__c != null){
                        w.writeCharacters(mapUDC.get(acc.Ciudad_UDC__c).Name);
                    }    
                w.writeEndElement();
                w.writeStartElement(null, 'countryCode', null);
                    if(acc.Pa_s__c != null){
                        w.writeCharacters(mapUDC.get(acc.Pa_s__c).productCode__c);    
                    }
                w.writeEndElement();
                w.writeStartElement(null, 'countyCode', null);
                    if (acc.Municipio__c != null) {
                        w.writeCharacters(mapUDC.get(acc.Municipio__c).Name);
                    }    
                w.writeEndElement();
                w.writeStartElement(null, 'dateEffective', null);
                w.writeEndElement();
                w.writeStartElement(null, 'mailingName', null);
        			if (acc.RecordTypeID == personAccountID) {
                        w.writeCharacters((String.isNotBlank(acc.FirstName)? acc.FirstName + ' ' : '') +
                                          (String.isNotBlank(acc.MiddleName)? acc.MiddleName + ' ' : '') +
                                          (String.isNotBlank(acc.LastName)? acc.LastName + ' ' : '')
                                         );
                    } else {
                    	w.writeCharacters(acc.Name);    
                    }
                w.writeEndElement();
                w.writeStartElement(null, 'mailingNameSecondary', null);
                w.writeEndElement();
                w.writeStartElement(null, 'postalCode', null);
                w.writeEndElement();
                w.writeStartElement(null, 'stateCode', null);
                    if(acc.Departamento__c != null){
                        w.writeCharacters(mapUDC.get(acc.Departamento__c).productCode__c);
                    }    
                w.writeEndElement();
            w.writeEndElement(); 

            w.writeStartElement(null, 'businessUnit', null);
                if (String.isNotBlank(acc.BUSINESSUNIT__c)) {
                    w.writeCharacters(acc.BUSINESSUNIT__c); 
                } else {
                    w.writeCharacters('2414');
                }
            w.writeEndElement();
            w.writeStartElement(null, 'callSalesTeamAlignment', null);
            w.writeEndElement();

            w.writeStartElement(null, 'categoryCodesAddressBook', null);
                if (String.isNotBlank(acc.Categorycode001__c)) {
                    w.writeStartElement(null,'categoryCode001',null);
                        w.writeCharacters(acc.Categorycode001__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.categorycode002__c)) {
                    w.writeStartElement(null,'categoryCode002',null);
                        w.writeCharacters(acc.categorycode002__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode003__c)) {
                    w.writeStartElement(null,'categoryCode003',null);
                        w.writeCharacters(acc.Categorycode003__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode004__c)) {
                    w.writeStartElement(null,'categoryCode004',null);
                        w.writeCharacters(acc.Categorycode004__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode005__c)) {
                    w.writeStartElement(null,'categoryCode005',null);
                        w.writeCharacters(acc.Categorycode001__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode006__c)) {
                    w.writeStartElement(null,'categoryCode006',null);
                        w.writeCharacters(acc.Categorycode006__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode001__c)) {
                    w.writeStartElement(null,'categoryCode007',null);
                        w.writeCharacters(acc.Categorycode001__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_8_UDC__c)) {
                    w.writeStartElement(null,'categoryCode008',null);
                        w.writeCharacters(acc.Categoria_8_UDC__r.productcode__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode009__c)) {
                    w.writeStartElement(null,'categoryCode009',null);
                        w.writeCharacters(acc.Categorycode009__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode010__c)) {
                    w.writeStartElement(null,'categoryCode010',null);
                        w.writeCharacters(acc.Categorycode010__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode011__c)) {
                    w.writeStartElement(null,'categoryCode011',null);
                        w.writeCharacters(acc.Categorycode011__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_12__c)) {
                    w.writeStartElement(null,'categoryCode012',null);
                        w.writeCharacters(acc.Categoria_12__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode013__c)) {
                    w.writeStartElement(null,'categoryCode013',null);
                        w.writeCharacters(acc.Categorycode013__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode014__c)) {
                    w.writeStartElement(null,'categoryCode014',null);
                        w.writeCharacters(acc.Categorycode014__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode015__c)) {
                    w.writeStartElement(null,'categoryCode015',null);
                        w.writeCharacters(acc.Categorycode015__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode016__c)) {
                    w.writeStartElement(null,'categoryCode016',null);
                        w.writeCharacters(acc.Categorycode016__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode017__c)) {
                    w.writeStartElement(null,'categoryCode017',null);
                        w.writeCharacters(acc.Categorycode017__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode018__c)) {
                    w.writeStartElement(null,'categoryCode018',null);
                        w.writeCharacters(acc.Categorycode018__c);
                    w.writeEndElement(); 
                }
                    
                if (String.isNotBlank(acc.Categor_a_19_segmento_UDC__c)) {
                    w.writeStartElement(null,'categoryCode019',null);
                        w.writeCharacters(acc.Categor_a_19_segmento_UDC__r.productcode__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_20__c)) {
                    w.writeStartElement(null,'categoryCode020',null);
                        w.writeCharacters(acc.Categoria_20__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_21__c)) {
                    w.writeStartElement(null,'categoryCode021',null);
                        w.writeCharacters(acc.Categoria_21__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_22__c)) {
                    w.writeStartElement(null,'categoryCode022',null);
                        w.writeCharacters(acc.Categoria_22__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode023__c)) {
                    w.writeStartElement(null,'categoryCode023',null);
                        w.writeCharacters(acc.Categorycode023__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode024__c)) {
                    w.writeStartElement(null,'categoryCode024',null);
                        w.writeCharacters(acc.Categorycode024__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_25__c)) {
                    w.writeStartElement(null,'categoryCode025',null);
                        w.writeCharacters(acc.Categoria_25__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_26_UDC__c)) {
                    w.writeStartElement(null,'categoryCode026',null);
                        w.writeCharacters(acc.Categoria_26_UDC__r.productcode__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_27__c)) {
                    w.writeStartElement(null,'categoryCode027',null);
                        w.writeCharacters(acc.Categoria_27__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode028__c)) {
                    w.writeStartElement(null,'categoryCode028',null);
                        w.writeCharacters(acc.Categorycode028__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categorycode029__c)) {
                    w.writeStartElement(null,'categoryCode029',null);
                        w.writeCharacters(acc.Categorycode029__c);
                    w.writeEndElement(); 
                }
        
                if (String.isNotBlank(acc.Categoria_30__c)) {
                    w.writeStartElement(null,'categoryCode030',null);
                        w.writeCharacters(acc.Categoria_30__c);
                    w.writeEndElement(); 
                }
            w.writeEndElement();
                
            w.writeStartElement(null, 'classifications', null); 
                w.writeStartElement(null, 'classificationCode001', null);
                    if(acc.Profesion_UDC__c != null){
                        w.writeCharacters(rellenarConNBlancos(3, acc.Profesion_UDC__r.productCode__c));
                    } else {
                        w.writeCharacters('  0');
                    }
                w.writeEndElement();
        
                w.writeStartElement(null, 'classificationCode002', null);
                    if(acc.Ocupacion_UDC__c != null){
                        w.writeCharacters(rellenarConNBlancos(3, acc.Ocupacion_UDC__r.productCode__c));
                    } else {
                        w.writeCharacters('  0');
                    }
                w.writeEndElement();
        
                w.writeStartElement(null, 'classificationCode003', null);
                    if(acc.Actividad_economica_UDC__c != null){
                        w.writeCharacters(rellenarConNBlancos(3, acc.Actividad_economica_UDC__r.productCode__c));
                    } else {
                        w.writeCharacters('  0');
                    }
                w.writeEndElement();
                
                w.writeStartElement(null, 'classificationCode004', null);
                    if(acc.Nacionalidad_UDC__c != null){
                        w.writeCharacters(rellenarConNBlancos(3, mapUDC.get(acc.Nacionalidad_UDC__c).productCode__c));
                    } else {
                        w.writeCharacters('  0');
                    }
                w.writeEndElement();
        
                w.writeStartElement(null, 'classificationCode005', null);
                w.writeEndElement();
            w.writeEndElement(); 
                
            w.writeStartElement(null, 'creditMessageCode', null);
            w.writeEndElement();

            if (actionTypeAcc != '3') {
                if (String.isNotBlank(acc.Email__c)) {
                    w.writeStartElement(null, 'electronicAddresses', null);
                        w.writeStartElement(null, 'actionType', null);
                            w.writeCharacters(actionTypeAcc);
                        w.writeEndElement();
                        w.writeStartElement(null, 'contactId', null);
                                w.writeCharacters('0');
                        w.writeEndElement();
                        w.writeStartElement(null, 'electronicAddress', null);
                            w.writeCharacters(acc.Email__c);
                        w.writeEndElement();
                        w.writeStartElement(null, 'electronicAddressClassificationCode', null);
                        w.writeEndElement();
                        w.writeStartElement(null, 'electronicAddressLineNumber', null);
                                w.writeCharacters('1');
                        w.writeEndElement();
                        w.writeStartElement(null, 'electronicAddressTypeCode', null);
                            if (String.isNotBlank(acc.Tipo_de_email__c)) {
                                w.writeCharacters(mapUDC.get(acc.Tipo_de_email__c).productcode__c);    
                            }
                        w.writeEndElement();
                        w.writeStartElement(null, 'messageIndicatorCode', null);
                            w.writeCharacters('0');
                        w.writeEndElement();
                    w.writeEndElement();    
                }
            }
                    
            w.writeStartElement(null, 'employeeGroupApprovalsCode', null);
            w.writeEndElement();

            w.writeStartElement(null, 'entity', null);
                w.writeStartElement(null, 'entityId', null);
                    if(String.isNotBlank(acc.CodigoCliente__c) && actionTypeAcc != '1'){
                        w.writeCharacters(acc.CodigoCliente__c); 	   
                    }
                w.writeEndElement();            
                w.writeStartElement(null, 'entityLongId', null);
                    if(String.isNotBlank(acc.Cedula__c) && acc.RecordTypeID == personAccountID) {
                        w.writeCharacters(acc.Cedula__c); 	   
                    }
                w.writeEndElement();
                w.writeStartElement(null, 'entityTaxId', null);
                    if(String.isNotBlank(acc.Cedula__c)){
                        w.writeCharacters(acc.Cedula__c);
                    }
                w.writeEndElement();
            w.writeEndElement();
            w.writeStartElement(null, 'entityName', null);
                if (acc.RecordTypeID == personAccountID) {
                    w.writeCharacters((String.isNotBlank(acc.FirstName)? acc.FirstName + ' ' : '') +
                                      (String.isNotBlank(acc.MiddleName)? acc.MiddleName + ' ' : '') +
                                      (String.isNotBlank(acc.LastName)? acc.LastName + ' ' : '')
                                     );
                } else {
                    w.writeCharacters(acc.Name);    
                }
            w.writeEndElement();     
            w.writeStartElement(null, 'entityNameSecondary', null);
            w.writeEndElement();     
            w.writeStartElement(null, 'entityTaxIdAdditional', null);
        		if(String.isNotBlank(acc.NIT__c)) {
                    w.writeCharacters(acc.NIT__c);
                }
            w.writeEndElement();     
            w.writeStartElement(null, 'entityTypeCode', null);
                if(acc.Tipo_de_b_squeda__c != null) {
                    w.writeCharacters(acc.Tipo_de_b_squeda__r.productCode__c);
                } else {
                    w.writeCharacters('C'); //Customers es el tipo de busqueda default
                }
            w.writeEndElement();     
            w.writeStartElement(null, 'industryClassificationCode', null); //
                if(String.isNotBlank(acc.INDUSTRYCLASSIFICATIONCODE__c)){
                    w.writeCharacters(acc.INDUSTRYCLASSIFICATIONCODE__c);    
                }
            w.writeEndElement();     
            w.writeStartElement(null, 'isEntityTypeEmployee', null);
            w.writeEndElement();     
            w.writeStartElement(null, 'isEntityTypeNettingIndicator', null);
            w.writeEndElement();     
            w.writeStartElement(null, 'isEntityTypePayables', null);
            w.writeEndElement();     
            w.writeStartElement(null, 'isEntityTypePurchaser', null);
            w.writeEndElement();     
            w.writeStartElement(null, 'isEntityTypeReceivables', null);
            w.writeEndElement();  
            w.writeStartElement(null, 'languageCode', null);
            w.writeEndElement();  
        
            w.writeStartElement(null, 'parent', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            
            w.writeStartElement(null, 'personCorporationCode', null);
                if(acc.RecordTypeId == personAccountID){
                    w.writeCharacters('1');
                } else {
                    w.writeCharacters('2');
                }    
            w.writeEndElement();

            if (actionTypeAcc =='1' || actionTypeAcc =='2') {
                w.writeStartElement(null, 'phoneNumbers', null);
                    w.writeStartElement(null, 'actionType', null);
                        w.writeCharacters(actionTypeAcc);
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'areaCode', null); 
                        if(!telefonoSeparado.isEmpty()) {
                            w.writeCharacters(telefonoSeparado[0].removeStart('+'));
                        } 
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'contactId', null);
                            w.writeCharacters('0');
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'phoneLineNumber', null);
                            w.writeCharacters('1');
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'phoneNumber', null);
                        if(!telefonoSeparado.isEmpty()) {
                            w.writeCharacters(telefonoSeparado[1]);
                        }
                    w.writeEndElement(); 
                    w.writeStartElement(null, 'phoneTypeCode', null);
                        if(acc.Tipo_de_t_lefono__c != null){
                            w.writeCharacters(mapUDC.get(acc.Tipo_de_t_lefono__c).productCode__c);
                        }
                    w.writeEndElement(); 
                w.writeEndElement(); 
            }

            w.writeStartElement(null, 'processing', null);
                w.writeStartElement(null, 'actionType', null);
                    w.writeCharacters(actionTypeAcc);
                w.writeEndElement(); 
                w.writeStartElement(null, 'processingVersion', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            
            w.writeStartElement(null, 'relatedAddress1', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'relatedAddress2', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'relatedAddress3', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'relatedAddress4', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'relatedAddress5', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'relatedAddress6', null);
                w.writeStartElement(null, 'entityId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityLongId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'entityTaxId', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            
            w.writeStartElement(null, 'remark', null);
            w.writeEndElement(); 
            
            w.writeStartElement(null, 'statistics', null);
                w.writeStartElement(null, 'dunBradStreetId', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'numberOfEmployees', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'rateGrowth', null);
                    w.writeCharacters(acc.Extranjero__c? '1' : '0');
                w.writeEndElement();
                w.writeStartElement(null, 'revenueRangeCode', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'yearCompanyFounded', null);
                w.writeEndElement();
            w.writeEndElement(); 
        
            w.writeStartElement(null, 'stock', null);
                w.writeStartElement(null, 'stockExchange', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'stockTickerSymbol', null);
                w.writeEndElement(); 
            w.writeEndElement(); 
            w.writeStartElement(null, 'taxExemptCertificate', null);
            w.writeEndElement(); 
        
            w.writeStartElement(null, 'userReservedData', null);
                w.writeStartElement(null, 'userReservedAmount', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'userReservedCode', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'userReservedDate', null);
                w.writeEndElement();
                w.writeStartElement(null, 'userReservedNumber', null);
                w.writeEndElement(); 
                w.writeStartElement(null, 'userReservedReference', null);
                w.writeEndElement();
            w.writeEndElement(); 
        w.writeEndElement();

        xmlReq = w.getXmlString();

        return xmlReq;
    }
  
    public static List<String> generaXMLRequestContact(
                    Id ObjId, 
                    String actionTypeContact, 
                    String actionTypeCorreo, 
                    String actionTypeTelefono, 
                    String actionTypeDireccion , 
                    String objEjecucion,
                    List<String> criterios
    ){
        List<String> xmlReqList = new List<String>();
        String xmlReq;
        Contact cont;
        Account acc;
        String codigoObjRelacionado = '';
        String segmentacion = '';
        String CodigoClienteCuenta = '';

        Id EmailId;
        Id TelId;
        Id ContactId;
        Id DirecId;
        Id AccId;
        Id AuxAccId;
        
        List<Correo__c> correosList = new List<Correo__c>();
        List<Telefono__c> telList = new List<Telefono__c>();
        List<DireccionesAlter__c> dirList = new List<DireccionesAlter__c>();
        Map<String, String> contactIdByCodigoCliente = new Map<String, String>();
        Map<String, String> cargoByIDExterno = new Map<String, String>();
        List<String> telefonoSeparado = new List<String>();
        
        if (ObjId != null) { 
            if (objEjecucion == 'CONTACTO') {
            	ContactId = ObjId;

                for (String c : criterios) {
                    if(c.contains('_0')) {
                        CodigoClienteCuenta = c.split('_')[0];
                    }
                }

                if (String.isNotBlank(CodigoClienteCuenta)) {
                    List<Account> accList = [
                        SELECT Segmentaci_n_por_linea__c, IsPersonAccount, 
                            Actividad_economica_UDC__c, Actividad_economica_UDC__r.Name
                        FROM Account 
                        WHERE CodigoCliente__c =: CodigoClienteCuenta
                    ];

                    if (!accList.isEmpty()) {
                        if (accList[0].IsPersonAccount) {
                            if (String.isNotBlank(accList[0].Actividad_economica_UDC__c)) {
                                segmentacion = accList[0].Actividad_economica_UDC__r.Name;
                            }
                        } else {
                            segmentacion = accList[0].Segmentaci_n_por_linea__c;
                        }
                    }
                }
                
            } else if (objEjecucion == 'CORREO') {
                EmailId = ObjId;
                if (actionTypeCorreo != '0' && actionTypeCorreo != '3') {
                    correosList = 
                        [SELECT EMAILADDRESS__c, Tipo_de_correo_electr_nico__r.productCode__c,
                                electronicaddresslinenumber__c, Contacto__c, Cliente__c
                        FROM Correo__c 
                        WHERE Id =: EmailId
                        ];
                } else if(actionTypeCorreo == '3') {
                    correosList = 
                        [SELECT EMAILADDRESS__c, Tipo_de_correo_electr_nico__r.productCode__c,
                                electronicaddresslinenumber__c, Contacto__c, Cliente__c
                        FROM Correo__c 
                        WHERE Id =: EmailId  
                        ALL ROWS
                        ];  
                }

                if (!correosList.isEmpty()) {
                    if (correosList[0].Contacto__c != null) {
                        ContactId = correosList[0].Contacto__c;
                        AuxAccId = correosList[0].Cliente__c;
                    } else {
                        AccId = correosList[0].Cliente__c;
                    }
                }
                
            } else if (objEjecucion == 'TELEFONO') {
                TelId = ObjId;
                if (actionTypeTelefono != '0' && actionTypeTelefono != '3') {
                    telList = 
                        [SELECT areacode__c, Contacto__c, phonelinenumber__c, phonenumber__c, 
                                Tipo_de_t_lefono__r.productCode__c, Cliente__c
                        FROM Telefono__c 
                        WHERE Id =: TelId
                        ];  
                } else if(actionTypeTelefono == '3') {
                    telList = 
                        [SELECT areacode__c, Contacto__c, phonelinenumber__c, phonenumber__c, 
                                Tipo_de_t_lefono__r.productCode__c, Cliente__c 
                        FROM Telefono__c 
                        WHERE Id =: TelId  
                        ALL ROWS
                        ];  
                }

                if (!telList.isEmpty()) {
                    if (telList[0].Contacto__c != null) {
                        ContactId = telList[0].Contacto__c;
                        AuxAccId = telList[0].Cliente__c;
                    } else {
                        AccId = telList[0].Cliente__c;
                    }
                }
                
            } else if (objEjecucion == 'DIRECCION') {
                DirecId = ObjId;
                if(actionTypeDireccion != '0' && actionTypeDireccion != '3') { 
                    dirList = 
                        [SELECT Direccion__c, Ciudad_UDC__c, Ciudad_UDC__r.Name, Contacto__c, Tipo_de_direcci_n__c, 
                                Municipio__c, Municipio__r.productCode__c, Departamento__c,
                                Tipo_de_direcci_n__r.productCode__c,Pa_s__c, Pa_s__r.productCode__c,
                                Pa_s__r.Name, Departamento__r.productCode__c, Cliente__c
                        FROM DireccionesAlter__c 
                        WHERE Id =: DirecId
                        ];  
                } else if (actionTypeDireccion == '3') {
                    dirList = 
                        [SELECT Direccion__c, Ciudad_UDC__c, Ciudad_UDC__r.Name, Contacto__c, Tipo_de_direcci_n__c, 
                                Municipio__c, Municipio__r.productCode__c, Departamento__c,
                                Tipo_de_direcci_n__r.productCode__c,Pa_s__c, Pa_s__r.productCode__c,
                                Pa_s__r.Name, Departamento__r.productCode__c, Cliente__c
                        FROM DireccionesAlter__c 
                        WHERE Id =: DirecId  
                        ALL ROWS
                        ];  
                }
                if (!dirList.isEmpty()) {
                    if (dirList[0].Contacto__c != null) {
                        ContactId = dirList[0].Contacto__c;
                        AuxAccId = dirList[0].Cliente__c;
                    } else {
                        AccId = dirList[0].Cliente__c;
                    }
                }
            } else if (objEjecucion == 'CUENTA') {
				AccId = ObjId;
                correosList.add(new Correo__c());
                telList.add(new Telefono__c());
            }
            
            System.debug(criterios);
            
            if(criterios.contains('Eliminar')) {
                List<String> auxWS = criterios[3].split('_');
                ContactId = auxWS[0] == 'nada'? null : auxWS[0];
                AccId = AuxAccId;
                codigoObjRelacionado = auxWS[1];
                System.debug('Se va a eliminar de la cuenta ' + ContactId);
                System.debug('Y está relacionado con la cuenta ' + AuxAccId);
                System.debug('En la cuenta vieja es el objeto numero ' + codigoObjRelacionado);
            }
            
            
            if (ContactId != null) {
                if (actionTypeContact == '3') {
                    cont = 
                        [SELECT ID, contactid__c, Title, Tipo_de_contacto_UDC__c,
                                Tipo_de_contacto_UDC__r.productCode__c, Name, AccountId, 
                                Account.CodigoCliente__c, Account.Cedula__c, Account.NRC__c,
                                Genero_UDC__c, Genero_UDC__r.productCode__c,
                                FirstName, LastName, MiddleName, Email, Phone,
                                Numero_de_documento__c, Lugar_de_nacimiento__c
                        FROM Contact 
                        WHERE ID =: ContactId 
                        ALL ROWS
                        ];
                } else {
                    cont = 
                        [SELECT ID, contactid__c, Title, Tipo_de_contacto_UDC__c,
                                Tipo_de_contacto_UDC__r.productCode__c, Name, AccountId,
                                Account.CodigoCliente__c, Account.Cedula__c, Account.NRC__c,
                                Genero_UDC__c, Genero_UDC__r.productCode__c,
                                FirstName, LastName, MiddleName, Email, Phone,
                                Numero_de_documento__c, Lugar_de_nacimiento__c
                        FROM Contact 
                        WHERE ID =: ContactId 
                        ];
                }
            } else {
                acc = 
                    [SELECT Name, Email__c, Cedula__c, Tipo_de_t_lefono__c, 
                            Tipo_de_t_lefono__r.productCode__c, Phone, Tipo_de_email__c,
                     		Tipo_de_email__r.productCode__c, NRC__c, Segmentaci_n_por_linea__c,
                            Actividad_economica_UDC__c, Actividad_economica_UDC__r.Name, IsPersonAccount
                    FROM Account  
                    WHERE ID =: AccId 
                    ];
                if (objEjecucion == 'CUENTA') {
                    if (!correosList.isEmpty() && String.isNotBlank(acc.Email__c)) {
                        correosList[0].EMAILADDRESS__c = acc.Email__c;
                        correosList[0].electronicaddresslinenumber__c = '1';
                        correosList[0].Tipo_de_correo_electr_nico__c = acc.Tipo_de_email__c;
                        correosList[0].Tipo_de_correo_electr_nico__r = acc.Tipo_de_email__r;
                        actionTypeCorreo = actionTypeContact;
                    }
                    
                    if (!telList.isEmpty() && String.isNotBlank(acc.Phone)) {

                        if (String.isNotBlank(acc.Phone)) {
                            telefonoSeparado = telefonoSeparado(acc.Phone);
                        }

                        telList[0].phonelinenumber__c = '1';
                        telList[0].Tipo_de_t_lefono__c = acc.Tipo_de_t_lefono__c;
                        telList[0].Tipo_de_t_lefono__r = acc.Tipo_de_t_lefono__r;

                        if (!telefonoSeparado.isEmpty()) {
                            telList[0].phonenumber__c = telefonoSeparado[1];
                            telList[0].areacode__c = telefonoSeparado[0].removeStart('+');
                        } else {
                            telList[0].phonenumber__c = '';
                            telList[0].areacode__c = '505';
                        }

                        actionTypeTelefono = actionTypeContact;
                    }
                }

                if (acc != null) {
                    cont = new Contact();
                    cont.LastName = acc.Name;
                    cont.Email = acc.Email__c;
                    cont.Numero_de_documento__c = acc.Cedula__c;
                    cont.Account = acc;
                    cont.Account.Cedula__c = acc.Cedula__c;
                    cont.Account.NRC__c = acc.NRC__c;

                    if (acc.IsPersonAccount) {
                        if (String.isNotBlank(acc.Actividad_economica_UDC__c)) {
                            segmentacion = acc.Actividad_economica_UDC__r.Name;
                        }
                    } else {
                        segmentacion = acc.Segmentaci_n_por_linea__c;
                    }

                }
            }

            if(criterios.contains('Parent')) {
                contactIdByCodigoCliente.put(cont.Account.CodigoCliente__c, cont.contactid__c);
            }
            
            if (criterios[0] == 'Only relation') {
                List<String> idExternoSplit = criterios[1].split('_');
                contactIdByCodigoCliente.put(idExternoSplit[0], idExternoSplit[1]);
                if (criterios.size() > 2) {
                	if ((actionTypeContact == '1' && objEjecucion == 'CONTACTO') || (criterios[2] == 'Cargo')) {
                        List<AccountContactRelation> acrList = 
                            [SELECT Cargo__c, IdExterno__c
                            FROM AccountContactRelation
                            WHERE IdExterno__c =: criterios[1]
                            ];
                        
                        if (!acrList.isEmpty()) {
                            cargoByIDExterno.put(acrList[0].IdExterno__c, acrList[0].Cargo__c);
                        }
                    }    
                }
            }
            
            if (criterios.contains('All relation')) {
                for (AccountContactRelation acr : [SELECT IdExterno__c, Cargo__c 
                                                    FROM AccountContactRelation
                                                    WHERE ContactId =: ObjId]) {
                    List<String> idExternoSplit = acr.IdExterno__C.split('_');
                    if(!contactIdByCodigoCliente.containsKey(idExternoSplit[0])) {
                        contactIdByCodigoCliente.put(idExternoSplit[0], idExternoSplit[1]);
                        cargoByIDExterno.put(acr.IdExterno__c, acr.Cargo__c);
                    }
                }
            }
            
            System.debug('cont nulo: ' + (cont == null));
            System.debug('acc nulo: ' + (acc == null));
            
			if (actionTypeContact != '3' && (cont == null || acc == null)) {
                acc = 
                    [SELECT Tipo_de_t_lefono__c, Tipo_de_t_lefono__r.productCode__c
                    FROM Account 
                    WHERE ID =: cont.AccountID
                    ];
            }

            System.debug(contactIdByCodigoCliente);
            
            for (String codigoCliente : contactIdByCodigoCliente.keySet()) {
		
                String idContacto = contactIdByCodigoCliente.get(codigoCliente);
                
                XmlStreamWriter w = new XmlStreamWriter();

                w.writeStartElement(null,'contact',null);
                
                    if (dirList.size() > 0) {
                        for (DireccionesAlter__c  dir : dirList) {

                            List<String> direccionesAlter = new List<String>();
                            Integer inicio = 0;
                            Integer fin = dir.Direccion__c.length() > 40? 40 : dir.Direccion__c.length();
                            while(inicio < fin) {
                                direccionesAlter.add(dir.Direccion__c.substring(inicio, fin));
                                inicio = inicio + 40;
                                fin = inicio + 40 < dir.Direccion__c.length()? inicio + 40 : dir.Direccion__c.length(); 
                            }

                            w.writeStartElement(null, 'alternateAddresses', null);
                                w.writeStartElement(null, 'actionType', null);
                                    w.writeCharacters(actionTypeDireccion);  
                                w.writeEndElement();
                                for (Integer j = 0; j < 4; j++) {
                                    w.writeStartElement(null, 'addressLine' + (j + 1), null);
                                        if(direccionesAlter.size() > j) {
                                            w.writeCharacters(direccionesAlter[j]);
                                        }
                                    w.writeEndElement();
                                }
                                w.writeStartElement(null, 'city', null);
                                    if(dir.Ciudad_UDC__c != null){
                                        w.writeCharacters(dir.Ciudad_UDC__r.Name);
                                    }  
                                w.writeEndElement();
                                w.writeStartElement(null, 'contactAddressTypeCode', null);
                                    if(dir.Tipo_de_direcci_n__c != null){
                                        w.writeCharacters(dir.Tipo_de_direcci_n__r.productCode__c);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'contactId', null);
                                    if(String.isNotBlank(idContacto)) {
                                        w.writeCharacters(idContacto);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'countryCode', null);
                                    if(dir.Pa_s__c != null){
                                        w.writeCharacters(dir.Pa_s__r.productCode__c);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'countyCode', null);
                                    if(dir.Municipio__c != null){
                                        w.writeCharacters(dir.Municipio__r.productCode__c);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'stateCode', null);
                                    if(dir.Departamento__c != null){
                                        w.writeCharacters(dir.Departamento__r.productCode__c);
                                    }
                                w.writeEndElement();
                            w.writeEndElement();
                        }
                    }
                    
                    w.writeStartElement(null,'categoryCodesContact',null);
                            for (Integer i = 1; i < 21; i++) {
                                String j = i < 10? '0' + i : '' + i;
                                w.writeStartElement(null,'categoryCode0' + j,null);
                                w.writeEndElement(); 
                            }
                    w.writeEndElement();
                    
                    w.writeStartElement(null,'contactId',null);
                        if(String.isNotBlank(idContacto)) {
                            w.writeCharacters(idContacto);
                        }
                    w.writeEndElement();
                	
                    w.writeStartElement(null,'contactTitle',null);
                        if (cargoByIDExterno.get(codigoCliente + '_' + idContacto) != null) {
                            System.debug('cargo: ' + cargoByIDExterno.get(codigoCliente + '_' + idContacto));
                            
                            w.writeCharacters(cargoByIDExterno.get(codigoCliente + '_' + idContacto));
                        } else if(String.isNotBlank(segmentacion)) {
                            System.debug('segmentacion: ' + segmentacion);

                            w.writeCharacters(segmentacion);
                        } else if(String.isNotBlank(cont.Title)) {
                            w.writeCharacters(cont.Title);
                        } else {
                            w.writeCharacters('');
                        }
                    w.writeEndElement();
                
                    w.writeStartElement(null,'contactTypeCode',null);
                    w.writeEndElement();
                    
                    if (!correosList.isEmpty()) {
                        for (Correo__c  corr : correosList) {
                            w.writeStartElement(null, 'electronicAddresses', null);
                                w.writeStartElement(null, 'actionType', null);
                                    w.writeCharacters(actionTypeCorreo);  
                                w.writeEndElement();
                                w.writeStartElement(null, 'contactId', null);
                                    if(String.isNotBlank(idContacto)) {
                                        w.writeCharacters(idContacto);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'electronicAddress', null);
                                    w.writeCharacters(corr.EMAILADDRESS__c);  
                                w.writeEndElement();
                                w.writeStartElement(null, 'electronicAddressLineNumber', null);
                            		if(objEjecucion == 'CORREO' && String.isNotBlank(codigoObjRelacionado)) {
                                        w.writeCharacters(codigoObjRelacionado);
                                    } else {
                                    	w.writeCharacters(corr.electronicaddresslinenumber__c);    
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'electronicAddressTypeCode', null);
                                    if(corr.Tipo_de_correo_electr_nico__c != null){
                                        w.writeCharacters(corr.Tipo_de_correo_electr_nico__r.productCode__c);
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'messageIndicatorCode', null);
                                    w.writeCharacters('0');  
                                w.writeEndElement();
                            w.writeEndElement();
                        }
                    }

                    w.writeStartElement(null, 'entity', null);
                        w.writeStartElement(null, 'entityId', null);
                            w.writeCharacters(codigoCliente);
                        w.writeEndElement();
                        w.writeStartElement(null, 'entityLongId', null);
                			if(String.isNotBlank(cont.Account.Cedula__c)) {
                            	w.writeCharacters(cont.Account.Cedula__c);
                            }
                        w.writeEndElement();
                        w.writeStartElement(null, 'entityTaxId', null);
                			if(String.isNotBlank(cont.Account.NRC__c)) {
                                w.writeCharacters(cont.Account.NRC__c);
                            } else if(String.isNotBlank(cont.Account.Cedula__c)) {
                            	w.writeCharacters(cont.Account.Cedula__c);    
                            }
                        w.writeEndElement();
                    w.writeEndElement();
                    w.writeStartElement(null, 'entityNameContact', null);
                        if (cont.Name != null) {
                            w.writeCharacters(cont.Name); 
                        } else {
                            w.writeCharacters(cont.LastName);
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'genderCode', null);
                        if(cont.Genero_UDC__c != null) {
                            w.writeCharacters(cont.Genero_UDC__r.productCode__c); 
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'givenName', null);
                        if(cont.FirstName != null){
                            w.writeCharacters(cont.FirstName);
                        } else {
                            w.writeCharacters('');
                        } 
                    w.writeEndElement();
                    w.writeStartElement(null, 'mailingName', null);
                		if (cont.Name != null) {
                            w.writeCharacters(cont.Name); 
                        } else {
                            w.writeCharacters(cont.LastName);
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'middleName', null);
                        if(cont.MiddleName != null){
                            w.writeCharacters(cont.MiddleName);
                        } else {
                            w.writeCharacters('');
                        } 
                    w.writeEndElement();
                    w.writeStartElement(null, 'nickName', null);
                        if(String.isNotBlank(cont.Numero_de_documento__c)) {
                            w.writeCharacters(cont.Numero_de_documento__c);    
                        }
                    w.writeEndElement();

                    if (telList.size() > 0) {
                        for (Telefono__c  tel : telList) {
                            w.writeStartElement(null, 'phoneNumbers', null);
                                w.writeStartElement(null, 'actionType', null);
                                    w.writeCharacters(actionTypeTelefono);  
                                w.writeEndElement();
                                w.writeStartElement(null, 'areaCode', null);
                                    w.writeCharacters(tel.areacode__c.removeStart('+'));  
                                w.writeEndElement();
                                w.writeStartElement(null, 'contactId', null);
                                    if(contactIdByCodigoCliente.get(codigoCliente) != null) {
                                        w.writeCharacters(contactIdByCodigoCliente.get(codigoCliente));
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'phoneLineNumber', null);
                                    if(objEjecucion == 'TELEFONO' && String.isNotBlank(codigoObjRelacionado)) {
                                        w.writeCharacters(codigoObjRelacionado);
                                    } else {
                                    	w.writeCharacters(tel.phonelinenumber__c);      
                                    }
                                w.writeEndElement();
                                w.writeStartElement(null, 'phoneNumber', null);
                                    w.writeCharacters(tel.phonenumber__c);  
                                w.writeEndElement();
                                w.writeStartElement(null, 'phoneTypeCode', null);
                                    if(tel.Tipo_de_t_lefono__c != null){
                                        w.writeCharacters(tel.Tipo_de_t_lefono__r.productCode__c);
                                    }  
                                w.writeEndElement();
                            w.writeEndElement();
                        }
                    }

                    w.writeStartElement(null, 'processing', null);
                        w.writeStartElement(null, 'actionType', null);
                            w.writeCharacters(actionTypeContact);  
                        w.writeEndElement();
                    w.writeEndElement();
                    w.writeStartElement(null, 'remark', null);
                		if(cont.Email != null) {
                        	w.writeCharacters(cont.Email);    
                        } else {
                            w.writeCharacters('');
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'salutationName', null);
                        if(cont.Lugar_de_nacimiento__c != null) {
                            w.writeCharacters(cont.Lugar_de_nacimiento__c); 
                        } else {
                            w.writeCharacters('');
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'surname', null);
                		if(cont.LastName.length() < 25) {
                    		w.writeCharacters(cont.LastName);
                        } else {
                            w.writeCharacters(cont.LastName.substring(0, 25));
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'typeCode', null);
                        if(cont.Tipo_de_contacto_UDC__c != null) {
                            w.writeCharacters(cont.Tipo_de_contacto_UDC__r.productCode__c); 
                        }
                    w.writeEndElement();
                    w.writeStartElement(null, 'yearOfBirth', null);
                    w.writeEndElement();
                w.writeEndElement();

                xmlReq = w.getXmlString();
                xmlReqList.add(xmlReq);

                }
            }

        return xmlReqList;
    }

    private static String rellenarConNBlancos (Integer largoEsperado, String texto) {
        String nuevo = '';

        for (Integer i = 0; i < largoEsperado - texto.length(); i++) {
            nuevo += ' ';    
        }

        nuevo += texto;

        return nuevo;
    }

    private static List<String> telefonoSeparado (String telefono) {
        List<String> telefonoSeparado = new List<String>();
        List<String> codigosDeAreaList = new List<String>();

        for (Codigo_de_Area_Valido__mdt cda :  
                            [SELECT Codigo_Pais__c, Numero__c
                            FROM Codigo_de_Area_Valido__mdt
                            ]) {
            codigosDeAreaList.add(cda.Codigo_Pais__c);
        }

        for (String cod : codigosDeAreaList) {
            if (telefono.startsWith(cod)) {
                telefonoSeparado.add(cod);
                break;
            }
        }

        if (telefonoSeparado.isEmpty()) {
            telefonoSeparado.add('505');
            telefonoSeparado.add(telefono);
        } else {
            telefonoSeparado.add(telefono.removeStart(telefonoSeparado[0]));
        }

        return telefonoSeparado;
    }
}