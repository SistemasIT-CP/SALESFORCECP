@isTest
public class Test_HTTP_UDC_Mock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req){
        HttpResponse respuesta = new HttpResponse();

        if (req.getEndpoint().endsWith('/GetUDCs')) {
            respuesta = respuestaWSgetUDCsJSON(req);
        } else if (req.getEndpoint().endsWith('/FoundationEnvironmentManager?WSDL')) {
            respuesta = respuestaWSgetUDCs(req);
        }
        
        return respuesta;
    }
    
    public HttpResponse respuestaWSgetUDCsJSON(HttpRequest req){
        List<ObjResponseUDCs> udcList = new List<ObjResponseUDCs>();
        ObjResponseUDCs udc = new ObjResponseUDCs();
  		udc.codigo = '8979878789';
        udc.descripction1 = 'TESTDESCRIPCION';
        udc.descripction2 = 'TESTDESCRIPCION';
        udc.nombreudc = 'Marcas';
        
        udcList.add(udc);
        
        String myJSON = JSON.serialize(udcList);
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(201);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(myJSON);
                
        return response;
    }  
    
    public HttpResponse respuestaWSgetUDCs(HttpRequest req){
        String myXML;
        if (req.getBody().contains('CC')) {
            myXML = '<Envelope>'+ 
                        +'<Body>'+
                            +'<lookupUDCResponse>'+
                                +'<e1MessageList/>'+
                                +'<userDefinedCode>'+
                                    +'<description1>TESTACTECONOMICA</description1>'+
                                    +'<description2>Mayorista</description2>'+
                                    +'<userDefinedCode>COM</userDefinedCode>'+
                                +'</userDefinedCode>'+
                            +'</lookupUDCResponse>'+
                        +'</Body>'+
                    +'</Envelope>';
        } else {
            myXML = '<Envelope>'+ 
                        +'<Body>'+
                            +'<lookupUDCResponse>'+
                                +'<e1MessageList/>'+
                            +'</lookupUDCResponse>'+
                        +'</Body>'+
                    +'</Envelope>';
        }
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'text/xml');
        response.setBody(myXML);
                
        return response;
    }  
    
}