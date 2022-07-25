public class Perfil_del_Cliente_PDF_Controller {
    public Id cuentaId {get; set;}                  //Id de la cuenta
    public string strFechaHoraMex {get; set;}       //Fecha-Hora
    public Account cuentaPN {get; set;}             // Variable para Visualforce de la cuenta Persona Natural
    public String genero {get; set;} 
    public Opportunity opp {get; set;}
    public List<String> apellidos {get; set;}
    
    public Perfil_del_Cliente_PDF_Controller(ApexPages.StandardController stdController) { 
		String pageLink = ApexPages.currentpage().getUrl();
        ID oppID;
        if (pageLink.contains('null')) {
            cuentaId = ApexPages.currentpage().getparameters().get('id');
            oppID = null;
        } else {
            cuentaId = stdController.getId();
            oppID = ApexPages.currentpage().getparameters().get('idOpp');
        }

        cuentaPN = 
            [SELECT ID, FirstName, MiddleName, LastName, Genero_UDC__pc,
                    Nacionalidad_UDC__r.Name, Tipo_de_Indentificaci_n__c, Cedula__c,
                    Direccion__c, Departamento__r.Name, Municipio__r.Name,
                    Email__c, Phone, Actividad_economica_UDC__r.Name, Profesion_UDC__r.Name,
                    Ocupacion_UDC__r.Name, PEP__c, Cargo_PEP__c, Algun_familiar_es_PEP__c, 
                    Cargo_PEP_del_familiar__c
            FROM Account 
            WHERE Id =: cuentaId
            LIMIT 1
            ];

        List<String> splitApellidos = cuentaPN.LastName.split(' ');
        apellidos = new List<String>();
        apellidos.add(splitApellidos[0]);

        System.debug(splitApellidos);

        if (splitApellidos.size() > 1) {
            String segundoApellido = '';
            for (Integer i = 1; i < splitApellidos.size(); i++) {
                segundoApellido += ' ' + splitApellidos[i];
            }
            apellidos.add(segundoApellido);
        } else {
            apellidos.add('-- --');
        }

        System.debug(apellidos);
        
        if (oppID != null) {
            opp = 
                [SELECT Origen_de_los_fondos__c, Procedencia_de_los_fondos__c, Compa_a__r.Name, Comentario_del_PIC__c
                FROM Opportunity 
                WHERE ID =: oppID 
                LIMIT 1
                ];   
        }
        
        try {
            Catalogo_UDC__c generoUDC = 
                [SELECT Id, Name 
                 FROM Catalogo_UDC__c 
                 WHERE Id =: cuentaPN.Genero_UDC__pc 
                 LIMIT 1
                ];   // Se busca en Catálogos UDC
            switch on generoUDC.Name {
                when  'Male' {
                    genero = 'Masculino';
                } when 'Female' {
                    genero = 'Femenino';
                } when else {
                    genero = generoUDC.Name;
                }
            }

        } catch(Exception e) {
            System.debug('Ha ocurrido la siguiente excepción: ' + e.getMessage());
            System.debug('Causa: ' + e.getCause());
            System.debug('Número de Línea: ' + e.getLineNumber());
            genero = '';
         }

        //Obtenemos fecha actual
        Datetime datFechaActual = Datetime.now();        
        //Formateamos la fecha
        strFechaHoraMex = datFechaActual.format('hh:mm:ss aa','America/Mexico_City');
        
        String cuenta = cuentaPn.FirstName.replaceAll(' ','_').replaceAll(',','_') + '_' + cuentaPn.LastName.replaceAll(' ','_').replaceAll(',','_');
        
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=PIC_'+ cuenta + '.pdf');
    }
}