@isTest
global class Test_HTTP_Mock implements HttpCalloutMock { 
    global HttpResponse respond(HttpRequest req){
        String r;

        if(req.getBody().contains('processContact')) {
            r = '<S:Envelope>' +
                    '<S:Body>' +
                        '<ns0:processContactResponse>' +
                            '<e1MessageList />' + 
                            '<contactId>5</contactId>' + 
                            '<entityID>changedID</entityID>' +
                        '</ns0:processContactResponse>' +
                    '</S:Body>' +
                '</S:Envelope>';
        } else if(req.getBody().contains('processAddressBook')) {
            r = '<Envelope>'+
                    '<Body>'+
                        '<processAddressBookResponse>'+
                            '<e1MessageList/>'+
                            '<address>'+
                                '<addressLine1>test street</addressLine1>'+
                                '<addressLine2></addressLine2>'+
                                '<addressLine3></addressLine3>'+
                                '<addressLine4></addressLine4>'+
                                '<city>MAN</city>'+
                                '<countryCode>NI</countryCode>'+
                                '<countyCode></countyCode>'+
                                '<mailingName>TEST FWY1</mailingName>'+
                                '<postalCode></postalCode>'+
                                '<stateCode>MAN</stateCode>'+
                            '</address>'+
                            '<businessUnit>2414</businessUnit>'+
                            '<entity>'+
                                '<entityId>changedID</entityId>'+
                                '<entityLongId>NDOC901025</entityLongId>'+
                                '<entityTaxId></entityTaxId>'+
                            '</entity>'+
                            '<entityName>TEST FWY1</entityName>'+
                            '<entityTypeCode>E</entityTypeCode>'+
                            '<languageCode></languageCode>'+
                        '</processAddressBookResponse>'+
                    '</Body>'+
                '</Envelope>';
        }

        HttpResponse response = new HttpResponse();

        if(r != null) {
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            response.setBody(r); 
        } else {
            response.setStatusCode(505);
            response.setBody('Oh, something is wrong');
        }
        
        return response; 
    }
}