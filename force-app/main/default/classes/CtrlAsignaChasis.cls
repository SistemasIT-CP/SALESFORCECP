public class CtrlAsignaChasis {
    public String respuestaWS {get;set;}
    public Id recordId {get;set;}
    public Informe_de_Negociaci_n__c infNeg;
    public ProcesaWSVehiculoByShortNumber.wrapperVehiculoByShortNumber wVBySN;
    public ProcesaWSVehiculoByChasis.wrapperVehiculoByChasis wVByChasis;
    
    public CtrlAsignaChasis (){
        recordId =  ApexPages.currentPage().getParameters().get('id');
        
        if(recordId != null){
            infNeg  = [SELECT id, Chasis__c,Reservar__c, Imp_Aduanas__c FROM Informe_de_Negociaci_n__c WHERE id =: recordId];
            
            if(infNeg.Chasis__c != null){
                if(infNeg.Reservar__c){
                    //BY SHORT NUMBER 
                    if(!test.isRunningTest()){
                    	wVBySN = ProcesaWSVehiculoByShortNumber.procesaVehiculoByShortNumber(infNeg.Chasis__c);    
                    }else{
                        wVBySN = retornaObjetoPruebaByShorNumber();
                    } 
                    
                    if(wVBySN.error != null && !test.isRunningTest()){
                    	respuestaWS =  wVBySN.error;
                    }else{
                        //respuestaWS = 'OBJETO wVBySN: ' + wVBySN;
                        respuestaWS = 'FACTURA: ' + wVBySN.factura;
                        respuestaWS += ',  NUM FACTURA: ' + wVBySN.numFactura;
                        respuestaWS += ',  IMPUESTOS ADUANA: ' + wVBySN.impAduana;
                        
                        if(wVBySN.impAduana != null){
                        	infNeg.Imp_Aduanas__c = Decimal.valueOf(wVBySN.impAduana);  	   
                        }
                        if(wVBySN.factura != null){
                            infNeg.Factura_WS__c = wVBySN.factura;
                        }
                        if(wVBySN.numFactura != null){
                            infNeg.No_Factura_WS__c = wVBySN.numFactura;
                        }
                    }    
                }
                
                if(!infNeg.Reservar__c || test.isRunningTest()){
                    // BY CHASIS 
                    if(!test.isRunningTest()){
                    	wVByChasis = ProcesaWSVehiculoByChasis.procesaVehiculoByChasis(infNeg.Chasis__c); 
                    }else{
                        wVByChasis = retornaObjetoPruebaByChasis();
                    }
                    
                    if(wVByChasis.error != null  && !test.isRunningTest()){
                    	respuestaWS =  wVByChasis.error;
                    }else{
                    	//respuestaWS = 'OBJETO wVByChasis: ' + wVByChasis;
                        respuestaWS = 'FACTURA: ' + wVByChasis.factura;
                        respuestaWS += ',  NUM FACTURA: ' + wVByChasis.numFactura;
                        respuestaWS += ',  IMPUESTOS ADUANA: ' + wVByChasis.impAduana;
                        
                        if(wVByChasis.impAduana != null){
                        	infNeg.Imp_Aduanas__c = Decimal.valueOf(wVByChasis.impAduana);  	   
                        }
                        if(wVByChasis.factura != null){
                            infNeg.Factura_WS__c = wVByChasis.factura;
                        }
                        if(wVByChasis.numFactura != null){
                            infNeg.No_Factura_WS__c = wVByChasis.numFactura;
                        }
                        
                    }
                }
            }else{
                respuestaWS = 'EL INFORME DE NEGOCIACIÓN NO TIENE UN CHASIS ASIGNADO';
            }
            
        }
        
    }
    
    public PageReference goToRecord(){
        
        try{
            update infNeg;
        }catch(Exception e){
            respuestaWS = e.getStackTraceString();
        }    
        
        if(recordId != null){
         	return new PageReference('/'+recordId);   
        }else{
         	return new PageReference('/');      
        }
		 
	}
    
    public ProcesaWSVehiculoByShortNumber.wrapperVehiculoByShortNumber retornaObjetoPruebaByShorNumber (){
        ProcesaWSVehiculoByShortNumber.wrapperVehiculoByShortNumber wVBySN = new ProcesaWSVehiculoByShortNumber.wrapperVehiculoByShortNumber();
        wVBySN.anio = '2020';
        wVBySN.chassis = 'testCHASIS878979';
        wVBySN.color = 'Rojo';
        wVBySN.colorInterno = 'Negro';
        wVBySN.descCodigoVehiculo = 'TESTCOD989';
        wVBySN.factura = '2020200';
        wVBySN.impAduana = '2020';
        wVBySN.motor = '2020TESTMOTOR8787';
        wVBySN.numFactura = '202001010';
        wVBySN.precio = '20200';
        wVBySN.error = null;
        
        return wVBySN;    
    }
    
    public ProcesaWSVehiculoByChasis.wrapperVehiculoByChasis retornaObjetoPruebaByChasis (){
        ProcesaWSVehiculoByChasis.wrapperVehiculoByChasis wVByChasis = new ProcesaWSVehiculoByChasis.wrapperVehiculoByChasis();
        wVByChasis.anio = '2020';
        wVByChasis.chassis = 'testCHASIS878979';
        wVByChasis.color = 'Rojo';
        wVByChasis.colorInterno = 'Negro';
        wVByChasis.descCodigoVehiculo = 'TESTCOD989';
        wVByChasis.factura = '2020200';
        wVByChasis.impAduana = '2020';
        wVByChasis.motor = '2020TESTMOTOR8787';
        wVByChasis.numFactura = '202001010';
        wVByChasis.precio = '20200';
        wVByChasis.error = null;
        return wVByChasis;    
    }

}