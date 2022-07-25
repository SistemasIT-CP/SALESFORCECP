@RestResource(urlMapping='/AccountManagement/*')
global class AccountManagement {
	@HttpPatch
    global static String editRecord(
        String codigoCliente, String genero, String direccion, String municipio, String ciudad, String departamento, String pais, 
        String telefono, String tipoDeTelefono, String email, String tipoDeEmail, String nacionalidad, String segmentacion) {
                                        
		ID personAccountID = Schema.SObjectType.Account
                    .getRecordTypeInfosByDeveloperName()
                    .get('PersonAccount')
                    .getRecordTypeId();
                                        
    	List<Account> accList = 
            [SELECT ID, RecordTypeID
            FROM Account
            WHERE CodigoCliente__c =: codigoCliente
            ];
                                        
		Account acc;

		if (!accList.isEmpty()) {
            List<Map<String, Catalogo_UDC__c>> listaMapUDC = crearMapaDeUDC();
            
            if (accList[0].RecordTypeID == personAccountID) {
				acc = 
                    [SELECT ID, Genero_UDC__pc, Direccion__c, Municipio__c, Ciudad_UDC__c, 
                            Departamento__c, Pa_s__c, Tipo_de_t_lefono__c, Phone, 
                            Email__c, Tipo_de_email__c, Nacionalidad_UDC__c
                    FROM Account
                    WHERE CodigoCliente__c =: codigoCliente 
                    LIMIT 1
                	];
                
                if (String.isNotBlank(genero)) {
                    if (listaMapUDC[0].containsKey(genero)) {
                        acc.Genero_UDC__pc = listaMapUDC[0].get(genero).ID;
                    } else {
                        return 'El género elegido no existe. Revise nuevamente el valor insertado.';
                    }
                }
                
                if (String.isNotBlank(nacionalidad)) {
                    if (listaMapUDC[5].containsKey(nacionalidad)) {
                        acc.Nacionalidad_UDC__c = listaMapUDC[5].get(nacionalidad).ID;
                    } else {
                        return 'La nacionalidad elegida no existe. Revise nuevamente el valor insertado.';
                    }
                }

            } else {
                acc = 
                    [SELECT ID, Direccion__c, Municipio__c, Ciudad_UDC__c, 
                            Departamento__c, Pa_s__c, Tipo_de_t_lefono__c, Phone, 
                            Email__c, Tipo_de_email__c, Segmentaci_n_por_linea__c
                    FROM Account
                    WHERE CodigoCliente__c =: codigoCliente 
                    LIMIT 1
                	];

                if (String.isNotBlank(segmentacion)) {
                    if (pickvalueValido('segmentacion', segmentacion)) {
                        acc.Segmentaci_n_por_linea__c = segmentacion;
                    } else {
                        return 'La segmentación escogida no es válida. Revise nuevamente el valor insertado.';
                    }
                }
            }
            
            if (String.isNotBlank(direccion)) {
                acc.Direccion__c = direccion;
            }
            
            if (String.isNotBlank(telefono)) {
                acc.Phone = telefono;
            }
            
            if (String.isNotBlank(email)) {
                if (Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', email)) {
            		acc.Email__c = email;
                } else {
                    return 'El email no tiene un formato valido en Salesforce.';
                }
            }
            
            if (String.isNotBlank(departamento)) {
                if (listaMapUDC[1].containsKey(departamento)) {
                    acc.Departamento__c = listaMapUDC[1].get(departamento).ID;
                } else {
                    return 'El departamento elegido no existe. Revise nuevamente el valor insertado.';
                }
            }
            
            if (String.isNotBlank(municipio)) {
                if (listaMapUDC[2].containsKey(municipio)) {
                    acc.Municipio__c = listaMapUDC[2].get(municipio).ID;
                } else {
                    return 'El municipio elegido no existe. Revise nuevamente el valor insertado.';
                }
            }
            
            if (String.isNotBlank(pais)) {
                if (listaMapUDC[3].containsKey(pais)) {
                    acc.Pa_s__c = listaMapUDC[3].get(pais).ID;
                } else {
                    return 'El país elegido no existe. Revise nuevamente el valor insertado.';
                }
            }
            
            if (String.isNotBlank(ciudad)) {
                if (listaMapUDC[4].containsKey(ciudad)) {
                    acc.Ciudad_UDC__c = listaMapUDC[4].get(ciudad).ID;
                } else {
                    return 'La ciudad elegida no existe. Revise nuevamente el valor insertado.';
                }
            }
          
            if (String.isNotBlank(tipoDeTelefono)) {
                if (listaMapUDC[6].containsKey(tipoDeTelefono)) {
                    acc.Tipo_de_t_lefono__c = listaMapUDC[6].get(tipoDeTelefono).ID;
                } else {
                    return 'El tipo de teléfono elegido no existe. Revise nuevamente el valor insertado.';
                }
            }
          
            if (String.isNotBlank(tipoDeEmail)) {
                if (listaMapUDC[7].containsKey(tipoDeEmail)) {
                    acc.Tipo_de_email__c = listaMapUDC[7].get(tipoDeEmail).ID;
                } else {
                    return 'El tipo de email elegido no existe. Revise nuevamente el valor insertado.';
                }
            }
            
        } else {
            return 'La cuenta con código de cliente ' + codigoCliente + ' no existe.';
        }
                                        
        Database.SaveResult sr = Database.update(acc, false);
        
        if (!sr.isSuccess()) {    
            return sr.getErrors()[0].getMessage();
        }
                                        
        return 'La modificacion de la cuenta ' + codigoCliente + ' ha sido un éxito!';
    }
    
    @HttpPost
    global static String createNewRecords(
        String tipoDeRegistro, String primerNombre, String segundoNombre, String apellido, String nombre, 
        String genero, String direccion, String municipio, String ciudad, String departamento, String pais, 
        String tipoDeIdentificacion, String identificacion, String telefono, String segmentacion, 
        String tipoDeTelefono, String email, String tipoDeEmail, String nacionalidad) {
                                        
		ID personAccountID = Schema.SObjectType.Account
                    .getRecordTypeInfosByDeveloperName()
                    .get('PersonAccount')
                    .getRecordTypeId();
                                        
		ID cuentaJuridicaID = Schema.SObjectType.Account
                    .getRecordTypeInfosByDeveloperName()
                    .get('Juridicos')
                    .getRecordTypeId();
                                        
    	Account acc = new Account();
		
		List<Map<String, Catalogo_UDC__c>> listaMapUDC = crearMapaDeUDC();
                                        
		List<Account> accList =
            [SELECT ID, Name
            FROM Account
            WHERE Cedula__c =: identificacion
            ];

        if (tipoDeRegistro == 'Natural') {
            
            if (!accList.isEmpty()) {
                return 'Ya existe una cuenta personal con esa identificación.';
            }
            
            acc.RecordTypeId = personAccountID;
                            
            if (String.isNotBlank(apellido)) {
                acc.LastName = apellido.toUpperCase();
            } else {
                return 'El campo apellido es obligatorio.';
            }

            if (String.isNotBlank(nacionalidad)) {
                if (listaMapUDC[5].containsKey(nacionalidad)) {
                    acc.Nacionalidad_UDC__c = listaMapUDC[5].get(nacionalidad).ID;
                } else {
                    return 'La nacionalidad elegida no existe. Revise nuevamente el valor insertado.';
                }
            } else {
                return 'El campo nacionalidad es obligatorio';
            }
            
            if (String.isNotBlank(genero)) {
                if (listaMapUDC[0].containsKey(genero)) {
                    acc.Genero_UDC__pc = listaMapUDC[0].get(genero).ID;
                } else {
                    return 'El género elegido no existe. Revise nuevamente el valor insertado.';
                }
            } else {
                return 'El campo género es obligatorio.';
            }

            if (String.isNotBlank(nacionalidad)) { 
                if (listaMapUDC[5].containsKey(nacionalidad)) {
                    acc.Nacionalidad_UDC__c = listaMapUDC[5].get(nacionalidad).ID;
                } else {
                    return 'La nacionalidad elegida no existe. Revise nuevamente el valor insertado.';
                }
            } else {
                return 'La nacionalidad es obligatoria.';
            }
            
            if (String.isNotBlank(primerNombre)) {
                acc.FirstName = primerNombre.toUpperCase();
            } else {
                return 'El campo primer nombre es obligatorio.';
            }
            
            if (String.isNotBlank(segundoNombre)) {
                acc.MiddleName = segundoNombre.toUpperCase();
            }

        } else if (tipoDeRegistro == 'Juridico') {
            acc.RecordTypeId = cuentaJuridicaID;
            
            if (!accList.isEmpty()) {
                for (Account a : accList) {
                    if (a.Name == nombre) {
                        return 'Esta cuenta jurídica ya existe en Salesforce.';
                    }
                }
            }
            
            if (String.isNotBlank(nombre)) {
                acc.Name = nombre.toUpperCase();
            } else {
                return 'El campo nombre es obligatorio.';
            }
            
            if (String.isNotBlank(segmentacion)) {
                if (pickvalueValido('segmentacion', segmentacion)) {
                    acc.Segmentaci_n_por_linea__c = segmentacion;
                } else {
                    return 'La segmentación escogida no es válida. Revise nuevamente el valor insertado.';
                }
            } else {
                return 'El campo segmentacion es obligatorio.';
            }

        } else {
            return 'El tipo de cuenta seleccionado no existe.';
        }
        
        if (String.isNotBlank(direccion)) {
            acc.Direccion__c = direccion;
        } else {
            return 'El campo dirección es obligatorio.';
        }
        
        if (String.isNotBlank(telefono)) {
            acc.Phone = telefono;
        } else {
            return 'El campo teléfono es obligatorio.';
        }

        if (String.isNotBlank(tipoDeIdentificacion)) {
            if (pickvalueValido('tipoDeIdentificacion', tipoDeIdentificacion)) {
                acc.Tipo_de_Indentificaci_n__c = tipoDeIdentificacion;
            } else {
                return 'El tipo de identificación escogido no es válida. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El tipo de identificación es obligatorio.';
        }
        
        if (String.isNotBlank(identificacion)) {
            acc.Cedula__c = identificacion;
        } else {
            return 'La cédula es obligatoria';
        }
        
        if (String.isNotBlank(email)) {
            if (Pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', email)) {
                acc.Email__c = email;
            } else {
                return 'El email no tiene un formato válido en Salesforce.';
            }
        } else {
            return 'El campo email es obligatorio.';
        }
            
        if (String.isNotBlank(departamento)) { 
            if (listaMapUDC[1].containsKey(departamento)) {
                acc.Departamento__c = listaMapUDC[1].get(departamento).ID;
            } else {
                return 'El departamento elegido no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El campo departamento es obligatorio.';
        }
        
        if (String.isNotBlank(municipio)) { 
            if (listaMapUDC[2].containsKey(municipio)) {
                acc.Municipio__c = listaMapUDC[2].get(municipio).ID;
            } else {
                return 'El municipio elegido no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El campo municipio es obligatorio.';
        }
        
        if (String.isNotBlank(pais)) { 
            if (listaMapUDC[3].containsKey(pais)) {
                acc.Pa_s__c = listaMapUDC[3].get(pais).ID;
            } else {
                return 'El país elegido no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El campo pais es obligatorio.';
        }
        
        if (String.isNotBlank(ciudad)) { 
            if (listaMapUDC[4].containsKey(ciudad)) {
                acc.Ciudad_UDC__c = listaMapUDC[4].get(ciudad).ID;
            } else {
                return 'La ciudad elegida no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El campo ciudad es obligatorio.';
        }
        
        if (String.isNotBlank(tipoDeTelefono)) { 
            if (listaMapUDC[6].containsKey(tipoDeTelefono)) {
                acc.Tipo_de_t_lefono__c = listaMapUDC[6].get(tipoDeTelefono).ID;
            } else {
                return 'El tipo de teléfono elegido no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El tipo de teléfono';
        }
        
        if (String.isNotBlank(tipoDeEmail)) {
            if (listaMapUDC[7].containsKey(tipoDeEmail)) {
                acc.Tipo_de_email__c = listaMapUDC[7].get(tipoDeEmail).ID;
            } else {
                return 'El tipo de email elegido no existe. Revise nuevamente el valor insertado.';
            }
        } else {
            return 'El tipo de email es obligatorio.';
        }
                                        
		acc.Creado_desde_Sitio_Externo__c = true;
                                        
		List<String> response = CallWS_ClientesBookManager.InsertarClienteDesdeCuenta(acc, '1');
        if (response[0] == '200') {
            acc.Envio_correcto_a_WS__c = true;
            acc.CodigoCliente__c = response[1];

            Database.SaveResult sr = Database.insert(acc, false);
            
            if (tipoDeRegistro == 'Natural') {
                List<Contact> cont =
                    [SELECT ID
                    FROM Contact
                    WHERE IsPersonAccount = true 
                            AND AccountID = :sr.getId()
                    ];
                
                Boolean contError = false;
                
                try {
                    CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                                                    cont[0].ID, 
                                                    '2', 
                                                    '0', 
                                                    '0', 
                                                    '0', 
                                                    'CONTACTO', 
                                                    new List<String> { 'Only relation', response[1] + '_0' } );
                } catch (Exception e) {
                    return 'Hubo un error de conexion con el servidor al actualizar datos de contacto.';
                }
            }
            
            if (!sr.isSuccess()) {
                return sr.getErrors()[0].getMessage();
            } else {
                return 'La cuenta se ha insertado con éxito. Código de cliente: ' + response[1];
            }
            
        } else {
            return 'Hubo un error de conexion con el servidor al crear el registro.';
        }
    }

    private static List<Map<String, Catalogo_UDC__c>> crearMapaDeUDC() {
		List<Map<String, Catalogo_UDC__c>> listaMapUDC = new List<Map<String, Catalogo_UDC__c>>();
        Map<String, Catalogo_UDC__c> mapaDeGenero = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeDepartamento = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeMunicipio = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDePais = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeCiudad = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeNacionalidad = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeTipoTelefono = new Map<String,Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> mapaDeTipoEmail = new Map<String, Catalogo_UDC__c>();
        
        for (Catalogo_UDC__c cat : [SELECT ID, Name, ProductCode__c, RecordType.DeveloperName
                                   FROM Catalogo_UDC__c
                                   WHERE RecordType.DeveloperName = 'Genero'
                                           OR RecordType.DeveloperName = 'Departamento'
                                           OR RecordType.DeveloperName = 'Municipio'
                                           OR RecordType.DeveloperName = 'Pais'
                                           OR RecordType.DeveloperName = 'Nacionalidad'
                                           OR RecordType.DeveloperName = 'Tipo_de_Telefono'
                                           OR RecordType.DeveloperName = 'Tipos_de_eMail']) {
            
            if (cat.RecordType.DeveloperName == 'Genero') {
            	mapaDeGenero.put(cat.Name, cat);    
            }
                                               
            if (cat.RecordType.DeveloperName == 'Departamento') {
                mapaDeCiudad.put(cat.Name, cat);
                mapaDeDepartamento.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Municipio') {
                mapaDeMunicipio.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Pais') {
                mapaDePais.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Nacionalidad') {
                mapaDeNacionalidad.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Tipo_de_Telefono') {
                mapaDeTipoTelefono.put(cat.Name, cat);
            }
                                               
            if (cat.RecordType.DeveloperName == 'Tipos_de_eMail') {
                mapaDeTipoEmail.put(cat.Name, cat);
            }
        }
        
        listaMapUDC.add(mapaDeGenero);
        listaMapUDC.add(mapaDeDepartamento);
        listaMapUDC.add(mapaDeMunicipio);
        listaMapUDC.add(mapaDePais);
        listaMapUDC.add(mapaDeCiudad);
        listaMapUDC.add(mapaDeNacionalidad);
        listaMapUDC.add(mapaDeTipoTelefono);
        listaMapUDC.add(mapaDeTipoEmail);
        
        return listaMapUDC;
    }

    private static Boolean pickvalueValido(String pickList, String valor) {
        Boolean pertenece = false;

        Schema.DescribeFieldResult f;
        
        if (pickList == 'tipoDeIdentificacion') {
            f = Account.Tipo_de_Indentificaci_n__c.getDescribe();
        } else if (pickList == 'segmentacion') {
            f = Account.Segmentaci_n_por_linea__c.getDescribe();
        }

		List<Schema.PicklistEntry> pickL = f.getPicklistValues();
        
		for (Schema.PicklistEntry pickV : pickL) {
            if (pickV.getLabel() == valor) {
                pertenece = true;
            }
		}     

		return pertenece;
    }
}