public class PC_PJuridica_PDF_Controller {
    public string strFechaHoraMex {get;set;}				//Fecha-Hora 
    public Account cuentaPJ {get;set;} 						// Variable para Visualforce de la cuenta Persona Jurídica
    public Opportunity opp {get;set;}
    public String oppID {get;set;}
    public Account representanteLegal {get; set;}

    public PC_PJuridica_PDF_Controller(ApexPages.StandardController stdController) {
        String pageLink = ApexPages.currentpage().getUrl();
        String cuentaId;
        if (pageLink.contains('null')) {
            cuentaId = ApexPages.currentpage().getparameters().get('id');
            oppID = null;
        } else {
            cuentaId = stdController.getId();
            oppID = ApexPages.currentpage().getparameters().get('idOpp');
        }

        cuentaPJ = 
            [SELECT Name, Cedula__c, Email__c, Phone, Direccion__c,
                    Departamento__r.Name, Municipio__r.Name, Actividad_economica_UDC__r.Name,
                    Representante_Legal__r.Name, Representante_Legal__r.Numero_de_documento__c,
                    Representante_Legal__r.Phone, Representante_Legal__c, Representante_Legal__r.AccountId
            FROM Account 
            WHERE ID =: cuentaId
            LIMIT 1 
            ];
        
        if (String.isNotBlank(cuentaPJ.Representante_Legal__c)) {     
            representanteLegal = [
                SELECT PEP__c, Cargo_PEP__c, Algun_familiar_es_PEP__c, Cargo_PEP_del_familiar__c
                FROM Account
                WHERE ID =: cuentaPJ.Representante_Legal__r.AccountId
                LIMIT 1
            ];
        }
        
        if (oppID != null) {
            opp = 
                [SELECT Name, Compa_a__r.Name, Origen_de_los_fondos__c, Procedencia_de_los_fondos__c, Comprador__c, Comprador__r.Name, 
                        Comprador__r.Numero_de_documento__c, Comentario_del_PIC__c
                FROM Opportunity
                WHERE ID =: oppID
                LIMIT 1
                ];
        }
        
        //Obtenemos fecha actual
        Datetime datFechaActual = Datetime.now();
        //Formateamos la fecha
        strFechaHoraMex = datFechaActual.format('hh:mm:ss aa','America/Mexico_City');
        
        String cuenta = cuentaPJ.Name.replaceAll(' ','_').replaceAll(',','_');
        
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=PIC_'+ cuenta + '.pdf');
    }
    
}