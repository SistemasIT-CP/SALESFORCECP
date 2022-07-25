public class CtrlConsultaDisponibilidadAccesorios {
    public String idInfNeg;
    public String accesorios;
    public List<String>	accesoriosList;	
    public List<String>	accesoriosNoDispList;	
        
    public ctrlConsultaDisponibilidadAccesorios(){
        System.debug('CTRL CONSULTA DISPONIBILIDAD');
    }
    
    public pageReference validaDisponibilidad (){
        
        idInfNeg = ApexPages.currentPage().getParameters().get('id');
        accesoriosList = new List<String>();
        accesoriosNoDispList = new List<String>();
        accesorios = '';
        
        List<Accesorios_del_informe__c> accInfList = 
            [SELECT Id, Codigo_de_parte__c, InformeNegociacion__c, Estado__c, Estado_disponibilidad__c, 
                    Codigo_equivalente__c, Estado_disponibilidad_codigo_equivalente__c 
            FROM Accesorios_del_informe__c 
            WHERE Estado__c != 'Despachado' 
                    AND InformeNegociacion__c =: idInfNeg
            ];
        
        for (Accesorios_del_informe__c accInf : accInfList) {
             accesoriosList.add(accInf.Codigo_de_parte__c);
        }
        
        if (!accesoriosList.isEmpty()) {

            List<ProcesaWSAccesoriosEstadoDisponibilidad.wrapperAccesorios> respAccesorios =
                            ProcesaWSAccesoriosEstadoDisponibilidad.procesaAccesorios(accesoriosList);    

            Map<String, String> estadoPorInopar = new Map<String, String>();

            if (!respAccesorios.isEmpty()) {
                for (ProcesaWSAccesoriosEstadoDisponibilidad.wrapperAccesorios accW : respAccesorios) {
                    estadoPorInopar.put(accW.inopar, accW.estado);
                }

                for (Accesorios_del_informe__c accInf : accInfList) {
                    if (estadoPorInopar.containsKey(accInf.Codigo_de_parte__c)) {
                        accInf.Estado_disponibilidad__c = estadoPorInopar.get(accInf.Codigo_de_parte__c);

                        if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad') {
                            accesoriosNoDispList.add(accInf.Codigo_equivalente__c);
                        }
                    } else {
                        accInf.Estado_disponibilidad__c = 'No encontrado';
                    }
                }
                
                if (!accesoriosNoDispList.isEmpty()) {
                    List<ProcesaWSAccesoriosDisponibles.wrapperAccesorios> respAccesoriosEquivalente = 
                                    ProcesaWSAccesoriosDisponibles.procesaAccesorios(accesoriosNoDispList);        
                	
                    List<String> inoparList = new List<String>();

                    for (ProcesaWSAccesoriosDisponibles.wrapperAccesorios accW : respAccesoriosEquivalente) {
                        inoparList.add(accW.inopar);
                    }

                    if (!respAccesoriosEquivalente.isEmpty()) {
                        for(Accesorios_del_informe__c accInf : accInfList){
                            if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad') {
                                if (inoparList.contains(accInf.Codigo_equivalente__c)) {
                                    accInf.Estado_disponibilidad_codigo_equivalente__c = 'Disponible';    
                                } else {
                                    accInf.Estado_disponibilidad_codigo_equivalente__c = 'No disponible';    
                                }
                            }    
                        }

                    } else {
                        for (Accesorios_del_informe__c accInf : accInfList) {
                            if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad'){
                            	accInf.Estado_disponibilidad_codigo_equivalente__c = 'No disponible';
                            }
                        }
                    }
                }


                update accInfList;	                
            } else {
                System.debug('Accesorios no encontrados');
            }
        }   
        
		PageReference  p = new PageReference ('/'+idInfNeg);
        
        p.setRedirect(true);

		return p;
    } 
    
    @future(callout = true)
    public static void validaDisponibilidadFROMAccesoriosDelComboParaInforme (String idInfNeg){
        
        List<String> accesoriosList = new List<String>();	
    	List<String> accesoriosNoDispList = new List<String>();
        
        List<Accesorios_del_informe__c> accInfList = 
            [SELECT Id, Codigo_de_parte__c, InformeNegociacion__c, Estado__c, Estado_disponibilidad__c, 
                    Codigo_equivalente__c, Estado_disponibilidad_codigo_equivalente__c 
            FROM Accesorios_del_informe__c 
            WHERE Estado__c != 'Despachado' 
                    AND InformeNegociacion__c =: idInfNeg
            ];
        
        for (Accesorios_del_informe__c accInf : accInfList) {
             accesoriosList.add(accInf.Codigo_de_parte__c);
        }
        
        if (!accesoriosList.isEmpty()) {

            List<ProcesaWSAccesoriosEstadoDisponibilidad.wrapperAccesorios> respAccesorios =
                            ProcesaWSAccesoriosEstadoDisponibilidad.procesaAccesorios(accesoriosList);    

            Map<String, String> estadoPorInopar = new Map<String, String>();

            
            if (respAccesorios.isEmpty()) {
                for (ProcesaWSAccesoriosEstadoDisponibilidad.wrapperAccesorios accW : respAccesorios) {
                    estadoPorInopar.put(accW.inopar, accW.estado);
                }

                System.debug(estadoPorInopar);
                
                for (Accesorios_del_informe__c accInf : accInfList) {
                    if (estadoPorInopar.containsKey(accInf.Codigo_de_parte__c)) {
                        accInf.Estado_disponibilidad__c = estadoPorInopar.get(accInf.Codigo_de_parte__c);

                        if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad') {
                            accesoriosNoDispList.add(accInf.Codigo_equivalente__c);
                        }
                    } else {
                        accInf.Estado_disponibilidad__c = 'No encontrado';
                    }
                }
                
                if (!accesoriosNoDispList.isEmpty()) {
                    List<ProcesaWSAccesoriosDisponibles.wrapperAccesorios> respAccesoriosEquivalente = 
                                    ProcesaWSAccesoriosDisponibles.procesaAccesorios(accesoriosNoDispList);        
                	
                    List<String> inoparList = new List<String>();

                    for (ProcesaWSAccesoriosDisponibles.wrapperAccesorios accW : respAccesoriosEquivalente) {
                        inoparList.add(accW.inopar);
                    }

                    if (respAccesoriosEquivalente.isEmpty()) {
                        for(Accesorios_del_informe__c accInf : accInfList){
                            if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad') {
                                if (inoparList.contains(accInf.Codigo_equivalente__c)) {
                                    accInf.Estado_disponibilidad_codigo_equivalente__c = 'Disponible';    
                                } else {
                                    accInf.Estado_disponibilidad_codigo_equivalente__c = 'No disponible';    
                                }
                            }    
                        }

                    } else {
                        for (Accesorios_del_informe__c accInf : accInfList) {
                            if (accInf.Estado_disponibilidad__c == 'No disponible' || accInf.Estado_disponibilidad__c == 'Poca Disponibilidad'){
                            	accInf.Estado_disponibilidad_codigo_equivalente__c = 'No disponible';
                            }
                        }
                    }
                }


                update accInfList;	                
            } else {
                System.debug('Accesorios no encontrados');
            }
        }   
    } 
   	
    @future(callout = true)
    public static void solicitaAccesorioInformeAprobado (String idInfNeg){
        String s='<?xml version="1.0" encoding="UTF-8"?>'+
					+'<AccesoriosManagement xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                          +generaXMLRequest(idInfNeg)+
             		+'</AccesoriosManagement>';
        
        System.debug('XML: ' + s);

        ProcesaWSInsertaObjetoInformeNegociacion.insertaObjeto(s, IdInfNeg);
    }
    
    
    public static String generaXMLRequest (String idInfNeg) {
        List<String> equivalentesList = new List<String> ();
        Map<String, String> accesorioDescripcion = new Map<String, String>();
        
        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID, InformeNegociacion__c, Cantidad__c, Descripcion__c, Codigo_de_parte__c, Estado__c,
            Codigo_equivalente__c,Solicitar_Accesorio_Equivalente__c, Consecutivo__c, Descripci_n_del_accesorio__c
            FROM Accesorios_del_informe__c 
            WHERE InformeNegociacion__c =: idInfNeg
            AND Estado__c != 'Despachado'
        ]; 	   
        
        for (Accesorios_del_informe__c aIN : accInfList) {
            if (aIN.Solicitar_Accesorio_Equivalente__c) {
                equivalentesList.add(aIN.Codigo_equivalente__c);    
            }
        }
        
        if (equivalentesList.size() > 0) {
            for (Accesorios__c accesorio : [SELECT id, CodigoParte__c, DescripcionAmplia__c 
                                            FROM Accesorios__c 
                                            WHERE CodigoParte__c IN: equivalentesList]) { 
                accesorioDescripcion.put(accesorio.CodigoParte__c, accesorio.DescripcionAmplia__c);
            } 
        }
        
        
        List<Informe_de_Negociaci_n__c>	infNegList 	= 
            [SELECT id, Name, Cuenta__r.CodigoCliente__c, Cuenta__r.Name, Chasis__c, CreatedById, createdDate, Consecutivo_del_Informe__c, 
                    lastmodifiedDate, Oportunidad__r.Sucursal__c, Oportunidad__r.C_digo_de_Oportunidad_Numerico__c,
                    Oportunidad__r.Compa_a__r.productCode__c, Oportunidad__r.L_neas_de_Negocio__r.productCode__c,
                    InformeSincronizado__c, Oportunidad__r.L_neas_de_Negocio__r.Name
            FROM Informe_de_Negociaci_n__c 
            WHERE id =: idInfNeg
            ];
        
		String xmlReq; 
        
        if (!infNegList.isEmpty()) {
        
            List<Catalogo_Sucursales__c> catSucList = 
                [SELECT Id, Codigo_de_la_sucursal__c 
                FROM Catalogo_Sucursales__c  
                WHERE Name =: infNegList[0].Oportunidad__r.Sucursal__c
                ];
                
            User usrCreador = 
                [SELECT ID, Name, Email, Id_Empleado__c 
                FROM User 
                WHERE id =: infNegList[0].CreatedById
                ];

            String usrEmail = usrCreador.Email.split('@').get(0);
                                    
            if(usrEmail.length() > 10) {
                usrEmail = usrEmail.substring(0, 10);
            }

            System.debug(usrCreador);
    
            String ins_Upd = infNegList[0].InformeSincronizado__c == true ? 'False' : 'True';
                
            if (infNegList.size() > 0) { 
                XmlStreamWriter w = new XmlStreamWriter();
                w.writeStartElement(null, 'AUTD15', null);
                    w.writeStartElement(null, 'SID', null);
                        w.writeCharacters('' + infNegList[0].Consecutivo_del_Informe__c);					// Codigo de informe de negocion ANTES Name
                    w.writeEndElement();
                    w.writeStartElement(null, 'SSOLI', null);
                        w.writeCharacters('' + infNegList[0].Consecutivo_del_Informe__c); 				//Codigo de informe de negocion (Sera el codigo de la solicitud) ANTES Name
                    w.writeEndElement();
                    w.writeStartElement(null, 'SDE', null);
                        w.writeCharacters('' + infNegList[0].Oportunidad__r.L_neas_de_Negocio__r.Name);	//SIN DESCRIPCION EN EXCEL		
                    w.writeEndElement();
                    w.writeStartElement(null, 'SNCLTE', null);
                        w.writeCharacters('' + infNegList[0].Cuenta__r.CodigoCliente__c);					//Codigo del cliente
                    w.writeEndElement();
                    w.writeStartElement(null, 'SPARA', null);
                        w.writeCharacters('ACCESORIOS');												//Por defecto enviar ACCESORIOS
                    w.writeEndElement();
                    w.writeStartElement(null, 'SMARC', null);
                        w.writeCharacters('0');															//Por defecto enviar 0
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCHAS', null);
                        w.writeCharacters('' + infNegList[0].chasis__c);									//Chasis
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCODIGO', null);
                        w.writeCharacters('' + usrCreador.Id_Empleado__c);								
                    w.writeEndElement();
                    w.writeStartElement(null, 'SVEND', null);											//Por defecto enviar " "
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCLTE', null);
                        w.writeCharacters('' + infNegList[0].Cuenta__r.Name);								//Nombre del cliente
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCOM1', null);											//Por defecto enviar " "
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCOM2', null);											//Por defecto enviar " "
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCOM3', null);											//Por defecto enviar " "
                    w.writeEndElement();
                    w.writeStartElement(null, 'SFECH', null);
                        String dia = '' + infNegList[0].CreatedDate.day();
                        if (dia.length() == 1) {
                            dia = '0' + infNegList[0].CreatedDate.day();
                        }
    
                        String mes = '' + infNegList[0].CreatedDate.Month();
                        if (mes.length() == 1) {
                            mes = '0' + infNegList[0].CreatedDate.Month();
                        }
    
                        w.writeCharacters('' + infNegList[0].CreatedDate.year() + mes + dia);					//Fecha de registro del informe de negociacion AAAAMMDD
                    w.writeEndElement();
                    w.writeStartElement(null, 'SFLAG', null);											//Por defecto enviar " "
                    w.writeEndElement();		
                    w.writeStartElement(null, 'SMOTI', null);											//Por defecto enviar " "	
                    w.writeEndElement();
                    w.writeStartElement(null, 'SCONT', null);
                        w.writeCharacters('0');															//Por defecto enviar 0
                    w.writeEndElement();
                    w.writeStartElement(null, 'SFECHAM', null);
                        String diaSolicitud = '' + Date.today().day();
                        if (diaSolicitud.length() == 1) {
                            diaSolicitud = '0' + Date.today().day();
                        }	
                
                        String mesSolicitud = '' + Date.today().Month();
                        if (mesSolicitud.length() == 1) {
                            mesSolicitud = '0' + Date.today().Month();
                        }	
    
                        w.writeCharacters('' + Date.today().year() + mesSolicitud + diaSolicitud);				//Fecha de la solicitud AAAAMMDD
                    w.writeEndElement();
                
                    w.writeStartElement(null, 'SHORAM', null);
                
                        String hora 	= '' + infNegList[0].lastmodifiedDate.Hour();
                        String minuto 	= '' + infNegList[0].lastmodifiedDate.Minute();
                        String segundo 	= '' + infNegList[0].lastmodifiedDate.Second();
                
                        if (hora.length() == 1) {
                            hora = '0' + infNegList[0].lastmodifiedDate.Hour();
                        }
                
                        if (minuto.length() == 1) {
                            minuto = '0' + infNegList[0].lastmodifiedDate.Minute();
                        }	
                
                        if (segundo.length() == 1) {
                            segundo = '0' + infNegList[0].lastmodifiedDate.Second();
                        }	
                        
                        w.writeCharacters(hora + minuto + segundo);														//HORA DE LA SOLICITUD HHMMSS
                    w.writeEndElement();
                
                    w.writeStartElement(null, 'SHECHOP', null);
                        w.writeCharacters(usrEmail);																//Usuario que registro la solicitud  .Id_Empleado__c
                    w.writeEndElement();
                    w.writeStartElement(null, 'SNPROGR', null);
                        w.writeCharacters('SF');																//Programa que envía la solicitud
                    w.writeEndElement();
                    w.writeStartElement(null, 'NOOPORTUN', null);
                        w.writeCharacters('' + infNegList[0].Oportunidad__r.C_digo_de_Oportunidad_Numerico__c);		//Numero de la oportunidad
                    w.writeEndElement();
                    w.writeStartElement(null, 'COMPANS', null);
                        w.writeCharacters('' + infNegList[0].Oportunidad__r.Compa_a__r.productCode__c);				//Código de la compañia que envía la solicitud
                    w.writeEndElement();
                    w.writeStartElement(null, 'SUCURSS', null);
                        w.writeCharacters('ALT');								//Codigo de la sucursal que envia la solicitud DEFAULT ALT
                    w.writeEndElement();
                    w.writeStartElement(null, 'LINEASS', null);
                        w.writeCharacters('' + infNegList[0].Oportunidad__r.L_neas_de_Negocio__r.productCode__c);		//Codigo de la linea de negocio que envia la solicitud
                    w.writeEndElement();
                    w.writeStartElement(null, 'INSERTAR', null);
                        w.writeCharacters(ins_Upd);																	//True si es una nueva solicitud o false si es una actualizacion
                    w.writeEndElement();
                w.writeEndElement();
                
                w.writeStartElement(null, 'ListAUTD16', null);
    
                for (Accesorios_del_informe__c acc : accInfList) {
                    w.writeStartElement(null, 'AUTD16', null); 
                    
                        w.writeStartElement(null, 'SID', null);
                            w.writeCharacters('' + acc.Consecutivo__c);								//Consecutivo accesorio
                        w.writeEndElement();
                        w.writeStartElement(null, 'SARTESP', null);
                            if (String.isBlank(acc.Codigo_de_parte__c)) {
                                w.writeCharacters('1');												//Enviar 1 si es un accesorio especial, de lo contrario enviar 0
                            } else {
                                w.writeCharacters('0');												//Enviar 1 si es un accesorio especial, de lo contrario enviar 0
                            }
                            
                        w.writeEndElement();
                        w.writeStartElement(null, 'SSOLI', null);
                            w.writeCharacters('' + infNegList[0].Consecutivo_del_Informe__c);			//'Codigo de informe de negocion (Sera el codigo de la solicitud'
                        w.writeEndElement();
                        w.writeStartElement(null, 'SCANT', null);
                            w.writeCharacters('' + acc.Cantidad__c);									//Cantidad solicitada
                        w.writeEndElement();
                        w.writeStartElement(null, 'SDESC', null);
                            String descripcion = acc.Solicitar_Accesorio_Equivalente__c?
                                                accesorioDescripcion.get(acc.Codigo_equivalente__c) : 
                                                acc.Descripci_n_del_accesorio__c;

                            Integer largoDescripcion = descripcion.length() > 50? 50 : descripcion.length();
                            
                            w.writeCharacters(descripcion.substring(0, largoDescripcion));

                        w.writeEndElement();
                        w.writeStartElement(null, 'ARTICU', null);
                            String codigo = acc.Solicitar_Accesorio_Equivalente__c? 
                                            '' + acc.Codigo_equivalente__c : 
                                            '' + acc.Codigo_de_parte__c;

                            Integer largoCodigo = codigo.length() > 17? 17 : codigo.length();
                            
                            w.writeCharacters(codigo.substring(0, largoCodigo));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COSART', null);
                            w.writeCharacters('0');													//Por defecto enviar 0
                        w.writeEndElement();
                        w.writeStartElement(null, 'VINSTA', null);
                            w.writeCharacters('0');													//Por defecto enviar 0
                        w.writeEndElement();
                        w.writeStartElement(null, 'SBODEG', null); 									// VACIO POR DEFAULT
                        w.writeEndElement();
                        w.writeStartElement(null, 'SFLAD', null);
                            String d = acc.Estado__c == 'Despachado'? 'D' : '';
                            w.writeCharacters(d);													//Enviar D si el accesorios esta en estado Despachado, de lo contrario enviar " "
                        w.writeEndElement();
                        w.writeStartElement(null, 'SFECHAM', null);
                            w.writeCharacters('' + Date.today().year() + mesSolicitud + diaSolicitud);	//'Fecha de la solicitud'	
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHORAM', null);
                            w.writeCharacters(hora + minuto + segundo);									//'Hora de la solicitud'
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHECHOP', null);
                            w.writeCharacters(usrEmail);											//'Usuario que registro la solicitud'
                        w.writeEndElement();
                        w.writeStartElement(null, 'SNPROGR', null);
                            w.writeCharacters('SF');												//'Programa que envia la solicitud'
                        w.writeEndElement();
                        w.writeStartElement(null, 'SFECHAMM', null);
                            if (ins_Upd == 'false') {
                                w.writeCharacters('' + Date.today().year() + mesSolicitud + diaSolicitud);	//'Fecha de modificacion de la solicitud'    
                            } else {
                                w.writeCharacters('0');				    
                            }
                            
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHORAMM', null);
                            if (ins_Upd == 'false') {
                                w.writeCharacters(hora + minuto + segundo);									//'Hora de modificacion de la solicitud'
                            } else {
                                w.writeCharacters('0');				    
                            }
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHECHOPM', null);
                            if (ins_Upd == 'false') {
                                w.writeCharacters(usrEmail);											//'Usuario que envia la modificacion de la solicitud'
                            } else {
                                w.writeCharacters('');				    
                            }
                        w.writeEndElement();
                        w.writeStartElement(null, 'SNPROGRM', null);
                            if (ins_Upd == 'false') {
                                w.writeCharacters('SF');												//'Programa que envia la modificacion de la solicitud'
                            } else {
                                w.writeCharacters('');				    
                            }
                        w.writeEndElement();
                    w.writeEndElement();    
                }
    
                w.writeEndElement();    
                xmlReq = w.getXmlString();
            }               
        } else {
            xmlReq = 'TEST';
        }
        
        return xmlReq;
    }
}