@isTest
global class HTTPErrorMock implements HttpCalloutMock { 

    global HttpResponse respond(HttpRequest req){
        HttpResponse respuesta = new HttpResponse();
        respuesta.setStatusCode(500);
        respuesta.setStatus('Error');
        respuesta.setBody('Oh, something is wrong');

        return respuesta;
    }
}