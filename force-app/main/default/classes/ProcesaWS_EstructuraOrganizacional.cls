public class ProcesaWS_EstructuraOrganizacional {
    
    public static void getEstructuras (){
        
        List<String> errorsList = new List<String>();
        List <Estructura_Organizacional__c> estListInsert = new List<Estructura_Organizacional__c>();
        
        HttpResponse response;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //QA
        //request.setEndpoint('http://ap1.casapellas.com.ni:9089/GCPWSREST/gcpwsrest/EOrganizacionalRest/GetEOrganizacional');  
        request.setEndpoint(Label.URL_WS_EstructuraOrganizacional);  
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('key', Label.strKey);
        request.setHeader('app', Label.strApp);
        request.setHeader('mod', Label.strModulo);
        
        try{
        	response = http.send(request);
            
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
               	System.debug('RESPUESTA: ' + response.getBody());
                List<ObjResponseEstructuraOrg> estList = ObjResponseEstructuraOrg.parse(response.getBody());
                
                if(estList.size()>0){
                    for(ObjResponseEstructuraOrg est: estList){
                        estListInsert.add(new Estructura_Organizacional__c(CodCompania__c = est.codcompania, Compania__c= est.compania, CodUnidadNegocio__c = est.codunidadnegocio, UnidadNegocio__c = est.unidadnegocio, CodSucursal__c = est.codsucursal, Sucursal__c = est.sucursal));
                    }
                    
                    if(estListInsert.size()>0){
                        Database.SaveResult[] srList  = Database.insert(estListInsert, false);
                
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
                                
                            }else {
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                                    System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                                    
                                    errorsList.add('Ha ocurrido un error en la UDC:' + err.getStatusCode() + ': ' + err.getMessage() + '\n' + 'Los campos que interfieren en el error son: ' + err.getFields()+ '\n\n');
                                    
                                }
                            }
                       } 
                    
                        if(errorsList.size()>0){
                            //ProcesaWSClientes.notificaLlamadoWS(errorsList);
                        }
                    }
                }
                //ObjResponsePromedioKg_M3 ObjRAE = ObjResponsePromedioKg_M3.parse(response.getBody());
            }
            
            //generaSolicitudEmail(generaJSONBody(dateoutput));
            //generaSolicitudEmail(response.getBody());
            //generaSolicitudEmail(generaJSONBody(dateoutput));
            
        }catch (CallOutException ex){/*generaSolicitudEmail('Hubo una excepcion: ' + ex.getMessage() +', '+ ex.getStackTraceString());*/}
    }

}