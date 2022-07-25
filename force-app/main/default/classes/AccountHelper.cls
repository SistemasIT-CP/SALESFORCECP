public without sharing class AccountHelper {
    public static void modificarCuentaEnServicio(List<Account> cuentasLista, Map<ID, Account> oldTriggerMap, String actionTypeAcc) {
        if(!cuentasLista.isEmpty()) {
            List<ID> idList = new List<ID>();
            for (Account ac : cuentasLista) {
                idList.add(ac.ID);
            }
    
            Integer size = 10;
            
            if(idList.size() < 10 || Test.isRunningTest()) {
                size = idList.size();
            }
            
            System.debug('SE ENVIAN ' + idList.size() + ' CUENTAS AL BATCH CON ACTION ' + actionTypeAcc);
            Database.executeBatch(new BatchWSClientes(actionTypeAcc, idList, oldTriggerMap), size); 
        }
    }
    
    public static void validarRepresentanteLegal(List<Account> accountList) {
        List<ID> accountID = new List<ID>();
        for (Account acc : accountList) {
            accountID.add(acc.ID);
        }
        
        Map<ID, Set<ID>> relatedContactsToAccount = CorreoHelper.relatedContactsToAccount(accountID);
        
        for(Account acc : accountList) {
            Set<ID> contactRelated = relatedContactsToAccount.get(acc.ID);
            
            if (acc.Representante_Legal__c != null && (contactRelated == null || !contactRelated.contains(acc.Representante_Legal__c))) {
                acc.Representante_Legal__c.addError('Debe elegir un contacto relacionado a la cuenta.');
            }
        }
    }
    
    public static void EliminarRelaciones(List<ID> accountIDList) {
        Map<ID, Contact> contactByID = new Map<ID, Contact>(
            [SELECT ID
             FROM Contact
             WHERE IsPersonAccount = true 
                    AND AccountID IN :accountIDList
            ]);
        
        ContactHelper.eliminarRelaciones(contactByID);
    }
    
    private static String limpiarEspaciosExtra(String nombreCompleto) {

        String nombreToReturn = '';

        if(String.isNotBlank(nombreCompleto)) {
            for (String partName : nombreCompleto.split(' ')) {
                if (String.isNotBlank(partName)) {
                    nombreToReturn += partName.trim() + ' ';
                }
            }
        }

        return nombreToReturn.trim();
    }

    public static void upperCaseName(List<Account> accountList) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        for (Account acc : accountList) {
            String nombre;
            if (acc.RecordTypeId == personAccountID) {
                String segundonombre = String.isNotBlank(acc.MiddleName)? acc.MiddleName : '';
                nombre = acc.FirstName + ' ' + segundonombre + ' ' + acc.LastName;
            } else {
                nombre = acc.Name; 
            }

            nombre = limpiarEspaciosExtra(nombre);
            
            if(nombre.length() > 40) {
                acc.addError('El Nombre tiene un max. permitido de 40 caracteres.');    
            }
            
            if (acc.RecordTypeId == personAccountID) {
                acc.FirstName = limpiarEspaciosExtra(acc.FirstName).toUpperCase();
                acc.MiddleName = limpiarEspaciosExtra(acc.MiddleName).toUpperCase();
                acc.LastName = limpiarEspaciosExtra(acc.LastName).toUpperCase();
            } else {
                acc.Name = limpiarEspaciosExtra(acc.Name).toUpperCase();
            }

            acc.Cedula__c = String.isNotBlank(acc.Cedula__c)? acc.Cedula__c.toUpperCase() : '';
        }
    }

    public static void actualizarSecuencia(List<Account> cuentasLista) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        for (Account acc : cuentasLista) {
            if (acc.RecordTypeId == personAccountID) {
                if(acc.Secuencia_contactos__c == null) {
                    acc.Secuencia_contactos__c = 0;
                }
                acc.contactid__pc = '0';
            }
        }
    }
    
    public static void validarIDPersonal (List<Account> cuentasLista) {
        for (Account acc : cuentasLista) { 
            if (String.isNotBlank(acc.Cedula__c)) {
                if (acc.Tipo_de_Indentificaci_n__c == 'Cedula de Identidad') {
                    Boolean error = validarCedulaIdentidad(acc.Cedula__c);
                        
                    if (error) {
                        acc.Cedula__c.addError('La Cedula de Identidad debe seguir el siguiente patrón: 3 números, '+
                                            '1 guión medio, la fecha de nacimiento, 1 guión medio, 4 números y 1 letra.');
                    }
                } else if (acc.Tipo_de_Indentificaci_n__c == 'RUC') {
                    Boolean error = validarCedulaIdentidad(acc.Cedula__c);

                    if (error && !Pattern.matches('^[A-Z]{1}-[0-9]{2}-[0-9]{1}-[0-9]{9}-[0-9]{1}$', acc.Cedula__c)) {
                        acc.Cedula__c.addError('El RUC debe seguir el alguno de los siguientes patrones: 1 letra, 2 números, 1 número, 9 números y 1 número, '+
                                                'en todos los casos separados por guión,' + '\n' +
                                                'ó, 3 números, 1 guión medio, la fecha de nacimiento, 1 guión medio, 4 números y 1 letra.');
                    }
                }
            }
        }
    }

    public static Boolean validarCedulaIdentidad (String cedula) {
        Boolean error = false;
        List<String> cedulaDividida = cedula.split('-');
        String year = '' + Date.today().year();
        year = year.substring(2);
                
        if (cedulaDividida.size() != 3) {
            error = true;
        } else {
            if (!Pattern.matches('^[0-9]{3}$', cedulaDividida[0])) {
                error = true;
            } 
            
            if (cedulaDividida[1].length() != 6) {
                error = true;
            } else {
                Integer anio = Integer.valueOf(cedulaDividida[1].substring(4,6));
                Integer mes = Integer.valueOf(cedulaDividida[1].substring(2,4));
                Integer dia = Integer.valueOf(cedulaDividida[1].substring(0,2));
                    
                if (dia > 31) {
                    error = true;
                }
                
                if (mes > 12) {
                    error = true;
                }
                    
                if (anio > (Integer.valueOf(year) - 16) &&  anio < Integer.valueOf(year)) {
                    error = true;
                }
            }
                    
            if (!Pattern.matches('^[0-9]{4}[A-Z]{1}$', cedulaDividida[2])) {
                error = true;
            }             
        }

        return error;
    }
    
    public static void setearPersonFields(List<Account> cuentasLista) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        for (Account acc : cuentasLista) {
            if(acc.RecordTypeId == personAccountID) {
                acc.PersonEmail = String.isNotBlank(acc.Email__c)? acc.Email__c : '';
                acc.Tipo_de_Identificaci_n__pc = String.isNotBlank(acc.Tipo_de_Indentificaci_n__c)? acc.Tipo_de_Indentificaci_n__c : '';
                acc.Numero_de_documento__pc = String.isNotBlank(acc.Cedula__c)? acc.Cedula__c.toUpperCase() : '';
            }
        }
    }
    
    public static void cambiarGenero (List<Account> cuentasLista, Map<ID, String> campoPorID) {
        for (Account acc : cuentasLista) {
            if (campoPorID.get(acc.ID) == 'Contacto') {
                acc.Genero_UDC__c = acc.Genero_UDC__pc;
            } else if (campoPorID.get(acc.ID) == 'Cuenta') {
                acc.Genero_UDC__pc = acc.Genero_UDC__c;
            }
            
        }
    }
    
    public static void cambiarLugarDeNacimiento (List<Account> cuentasLista, Map<ID, String> campoPorID) {
        for (Account acc : cuentasLista) {
            if (campoPorID.get(acc.ID) == 'Contacto') {
                acc.Lugar_de_nacimiento__c = acc.Lugar_de_nacimiento__pc;
            } else if (campoPorID.get(acc.ID) == 'Cuenta') {
                acc.Lugar_de_nacimiento__pc = acc.Lugar_de_nacimiento__c;
            }
        }
    }

    public static void actualizarOportunidades (List<Account> accList) {
        List<ID> accountsID = new List<ID>();
        Map<ID, String> nombrePorCuenta = new Map<ID, String>();

        for (Account acc : accList) {
            accountsID.add(acc.ID);
        }

        for (Account acc : [SELECT ID, Name FROM Account WHERE ID IN :accountsID]) {
            nombrePorCuenta.put(acc.ID, acc.Name);
        }

        List<Opportunity> oppList = 
            [SELECT ID, Name, AccountId, RecordType.DeveloperName,
                Marca_UDC__c, ModeloVehiculo__c, Marca_UDC__r.Name, ModeloVehiculo__r.Name
            FROM Opportunity
            WHERE AccountID IN :accountsID
            ];

        for (Opportunity opp : oppList) {
            List<String> nombreDescompuesto = opp.Name.split('/');

            String nombre = nombrePorCuenta.get(opp.AccountId);

            if (opp.RecordType.DeveloperName.contains('Principal')) {
                String marca = String.isNotBlank(opp.Marca_UDC__c)? opp.Marca_UDC__r.Name : '';
                String modelo = String.isNotBlank(opp.ModeloVehiculo__c)? opp.ModeloVehiculo__r.Name : '';

                opp.Name = nombre + '/' + marca + '/' + modelo;
            } else if (opp.RecordType.DeveloperName == 'Pre_Avaluo') {
                opp.Name = 'PREAVALUO/' + nombre;
            } else if (opp.RecordType.DeveloperName == 'Avaluo') {
                opp.Name = 'AVALUO/' + nombre;
            }
        }

        if (!oppList.isEmpty()) {
            update oppList;
        }
    }

    public static void eliminarDocumentos (List<Account> accList) {
        List<ContentDocumentLink> docLinkToDelete = new List<ContentDocumentLink>();
        List<ID> accID = new List<ID>(); 
        Set<String> idDocList = new Set<String>();

        for (Account acc : accList) {
            if(String.isNotBlank(acc.Imagen_Identificacion_1_URL__c)) {
            	String id1 = acc.Imagen_Identificacion_1_URL__c.split('=')[2];
            	idDocList.add(id1);    
            }

            if (String.isNotBlank(acc.Imagen_Identificacion_2_URL__c)) {
                String id2 = acc.Imagen_Identificacion_2_URL__c.split('=')[2];   
                idDocList.add(id2);
            }

            acc.Imagen_Identificacion_1_URL__c = null;
            acc.Imagen_Identificacion_2_URL__c = null;
            
            accID.add(acc.ID);
        }

        if(!idDocList.isEmpty()) {
            List<ContentDocument> docToDelete = 
                [SELECT ID
                FROM ContentDocument 
                WHERE LatestPublishedVersionId IN :idDocList 
                ];

            for(ContentDocument cd : docToDelete) {
                ContentDocumentLink cdLink = 
                        [SELECT ID
                        FROM ContentDocumentLink
                        WHERE ContentDocumentId =: cd.ID
                              AND LinkedEntityId IN :accID
                        ];
    
                    docLinkToDelete.add(cdLink);
            }

            if(!docLinkToDelete.isEmpty()){
                delete docLinkToDelete;
            }
    
            if(!docToDelete.isEmpty()){
                delete docToDelete;
            } 
        }
    }
    
    public static void cambiarNombreCedula (List<Account> accList) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        for (Account acc : accList) {
            Boolean validacion = false;
            String estado = '';

            if (acc.Campo_auxiliar_para_cambios__c.contains('true')) {
                List<String> cambios = acc.Campo_auxiliar_para_cambios__c.split(';');
                validacion = true;
                estado = 'Aprobado';

                if(cambios[0] != '--') {
                    if (acc.RecordTypeId == personAccountID) {
                        List<String> nombre = cambios[0].split('-');
                        if(String.isNotBlank(nombre[0])) {
                            acc.FirstName = nombre[0].toUppercase();
                        }
                                             
                        if(String.isNotBlank(nombre[1])) {
                            acc.MiddleName = nombre[1].toUppercase();
                        } else {
                            acc.MiddleName = null;
                        }
                        
                        if(nombre.size() > 2 && String.isNotBlank(nombre[2])) {
                            acc.LastName = nombre[2].toUppercase();
                        }
                    } else {
                        acc.Name = cambios[0].toUppercase();    
                    }
                }
                
                if(String.isNotBlank(cambios[1])) {
                    acc.Tipo_de_Indentificaci_n__c = cambios[1];
                }
                                             
                 if(String.isNotBlank(cambios[2])) {
                    acc.Cedula__c = cambios[2].toUppercase();
                }
            } else if(acc.Campo_auxiliar_para_cambios__c.contains('false')) {
                validacion = true;
                estado = 'Rechazado';
            }
            
            if (validacion) {
                acc.Campo_auxiliar_para_cambios__c = estado;
            }
        }
    }

    public static void validarTelefono(List<Account> accList) {
        List<String> codigosDeAreaList = new List<String>();

        for (Codigo_de_Area_Valido__mdt cda :  
                            [SELECT Codigo_Pais__c, Numero__c
                            FROM Codigo_de_Area_Valido__mdt
                            ]) {
            if(String.isNotBlank(cda.Numero__c)) {
                codigosDeAreaList.add(cda.Codigo_Pais__c + cda.Numero__c);
            } else {
                codigosDeAreaList.add(cda.Codigo_Pais__c);
            }
        }

        for(Account acc : accList) {
            Boolean codigoValido = false;

            for (String cod : codigosDeAreaList) {
                if(String.isNotBlank(acc.Phone)) {
                    if (acc.Phone.startsWith(cod)) {
                        codigoValido = true;
                    }
                }
            }

            if (!codigoValido && !Test.isRunningTest()) {
                acc.Phone.addError('El telefono debe comenzar con un código de area válido.');
            }
        }
    }

    public static void setearEdad(List<Account> accList) {
        for (Account acc : accList) {
            List<String> cedulaDividida = acc.Cedula__c.split('-');
            if (cedulaDividida.size() == 3 && cedulaDividida[1].length() == 8) {
                Integer anio = Integer.valueOf(cedulaDividida[1].substring(4,6));
                Integer mes = Integer.valueOf(cedulaDividida[1].substring(2,4));
                Integer dia = Integer.valueOf(cedulaDividida[1].substring(0,2));
    
                Integer anioActual = Integer.valueOf(('' + Date.today().year()).substring(2));
    
                if (anio >= 0 && anio <= anioActual) {
                    anio += 2000;
                } else {
                    anio += 1900;
                }
    
                acc.PersonBirthdate = Date.newInstance(anio, mes, dia);
            }
        }
    }

    public static void actualizarDatosPorOmision(List<Account> cuentasLista, String tipo) {
        
                List<Map<String, Catalogo_UDC__c>> listaMapUDC = crearMapaDeUDCTelEmail();

    if (tipo =='Telefono')
    {      
        for (Account acc : cuentasLista) {            
             if (listaMapUDC[0].containsKey('Car or Mobile'))    
            {     
                 acc.Tipo_de_t_lefono__c = listaMapUDC[0].get('Car or Mobile').ID;  
            }       
        }
    }
    else{       
        for (Account acc : cuentasLista) {            
            if (listaMapUDC[1].containsKey('Email address'))    
            {        
                acc.Tipo_de_email__c = listaMapUDC[1].get('Email address').ID;
            }           
        }
    }
    
}

    private static List<Map<String, Catalogo_UDC__c>> crearMapaDeUDCTelEmail() {	
        List<Map<String, Catalogo_UDC__c>> listaMapUDC = new List<Map<String, Catalogo_UDC__c>>();
        Map<String, Catalogo_UDC__c> mapaDeTipoTelefono = new Map<String,Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeTipoEmail = new Map<String, Catalogo_UDC__c>();
        
        for (Catalogo_UDC__c cat : [SELECT ID, Name, ProductCode__c, RecordType.DeveloperName
                                   FROM Catalogo_UDC__c
                                   WHERE  RecordType.DeveloperName = 'Tipo_de_Telefono'
                                           OR RecordType.DeveloperName = 'Tipos_de_eMail']) {            
                              
            if (cat.RecordType.DeveloperName == 'Tipo_de_Telefono') {
                mapaDeTipoTelefono.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Tipos_de_eMail') {
                mapaDeTipoEmail.put(cat.Name, cat);
            }
        }
        
        listaMapUDC.add(mapaDeTipoTelefono);
        listaMapUDC.add(mapaDeTipoEmail);
        
        return listaMapUDC;
    }


   
}