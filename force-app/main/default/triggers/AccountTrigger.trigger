trigger AccountTrigger on Account (after insert, after update, after delete, before insert, before update, before delete) {
    ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
    
   
    
    if (Trigger.isBefore) {
        List<Account> accountList = new List<Account>();
        List<ID> accountID = new List<ID>();
        Map<ID, String> cambioPorID = new Map<ID, String>();
        List<Account> actualizaCedula = new List<Account>();
        List<Account> actualizaCedulaIdentificacion = new List<Account>();
        List<Account> cambiaGenero = new List<Account>();
        List<Account> cambiaLugarNacimiento = new List<Account>();
        List<Account> actualizarNombreCedula = new List<Account>();
        List<Account> eliminarDocumentos = new List<Account>();
        List<Account> actualizacionTelefono = new List<Account>();
        List<Account> actualizacionTipoTelefono = new List<Account>();
         List<Account> actualizacionTipoEmail = new List<Account>();
        
        if (Trigger.isUpdate) {
            System.debug('Before update');
            for (Account acc : Trigger.new) {
                if (acc.Email__c != Trigger.oldMap.get(acc.ID).Email__c ||
                    acc.Tipo_de_Indentificaci_n__c != Trigger.oldMap.get(acc.ID).Tipo_de_Indentificaci_n__c ||
                    acc.Cedula__c != Trigger.oldMap.get(acc.ID).Cedula__c) {
              			accountList.add(acc);          
            	}
                
                if (acc.Phone != Trigger.oldMap.get(acc.ID).Phone) {
                    acc.MessagingPlatformKey__c = 'whatsapp:' + acc.phone;
                }
                
                if (acc.Tipo_de_Indentificaci_n__c != Trigger.oldMap.get(acc.ID).Tipo_de_Indentificaci_n__c ||
                    acc.Cedula__c != Trigger.oldMap.get(acc.ID).Cedula__c) {
                    	actualizaCedula.add(acc);
                        
                        if (acc.Tipo_de_Indentificaci_n__c == 'Cedula de Identidad' && String.isNotBlank(acc.Cedula__c)) {
                            actualizaCedulaIdentificacion.add(acc);
                        }
                }
                
                if (acc.Lugar_de_nacimiento__c != Trigger.oldMap.get(acc.ID).Lugar_de_nacimiento__c) {
					cambiaLugarNacimiento.add(acc);
                    cambioPorID.put(acc.ID, 'Cuenta');
                }
                
                if (acc.Lugar_de_nacimiento__pc != Trigger.oldMap.get(acc.ID).Lugar_de_nacimiento__c) {
					cambiaLugarNacimiento.add(acc);
                    cambioPorID.put(acc.ID, 'Contacto');                    
                }
                
                if (acc.Genero_UDC__c != Trigger.oldMap.get(acc.ID).Genero_UDC__c) {
					cambiaGenero.add(acc);
                    cambioPorID.put(acc.ID, 'Cuenta');
                }
                
                if (acc.Genero_UDC__pc != Trigger.oldMap.get(acc.ID).Genero_UDC__pc) {
					cambiaGenero.add(acc);
                    cambioPorID.put(acc.ID, 'Contacto');                    
                }

                if (acc.Campo_auxiliar_para_cambios__c != Trigger.oldMap.get(acc.ID).Campo_auxiliar_para_cambios__c) {
                    if (String.isNotBlank(acc.Campo_auxiliar_para_cambios__c)) {
                        actualizarNombreCedula.add(acc);    
                    } else if (Trigger.oldMap.get(acc.ID).Campo_auxiliar_para_cambios__c != null) {
                        eliminarDocumentos.add(acc);
                    }
                }

                if (acc.Phone != Trigger.oldMap.get(acc.ID).Phone) {
                    actualizacionTelefono.add(acc);
                }                
                 
                if (!String.isNotBlank(acc.Tipo_de_t_lefono__c))
                {
                    actualizacionTipoTelefono.add(acc);  
                }
                
                if (!String.isNotBlank(acc.Tipo_de_email__c))
                {
                    actualizacionTipoEmail.add(acc);  
                }
            }
            
            if (!actualizaCedula.isEmpty()) {
                AccountHelper.validarIDPersonal(actualizaCedula);
            }

            if (!actualizacionTelefono.isEmpty()) {
                AccountHelper.validarTelefono(actualizacionTelefono);
                
            }

            if (!actualizarNombreCedula.isEmpty()) {
                AccountHelper.cambiarNombreCedula(actualizarNombreCedula);
            }

            if (!accountList.isEmpty()) {
                AccountHelper.setearPersonFields(accountList);
            }

            if (!cambiaGenero.isEmpty() || !cambioPorID.isEmpty()) {
                AccountHelper.cambiarGenero(cambiaGenero, cambioPorID);
            }

            if (!cambiaLugarNacimiento.isEmpty() || !cambioPorID.isEmpty()) {
                AccountHelper.cambiarLugarDeNacimiento(cambiaLugarNacimiento, cambioPorID);
            }

            if (!eliminarDocumentos.isEmpty()) {
                AccountHelper.eliminarDocumentos(eliminarDocumentos);
            }
            
            if (!actualizaCedulaIdentificacion.isEmpty()) {
                AccountHelper.setearEdad(actualizaCedulaIdentificacion);
            }
            
            if (!actualizacionTipoTelefono.isEmpty()) {
                AccountHelper.actualizarDatosPorOmision(actualizacionTipoTelefono,'Telefono');
            }
             if (!actualizacionTipoEmail.isEmpty()) {
                AccountHelper.actualizarDatosPorOmision(actualizacionTipoEmail,'Email');
            }
        }
        
        if (Trigger.isInsert) {
            List<Account> personalesConIdentificacion = new List<Account>();

            for (Account acc : Trigger.new) {
                if (String.isNotBlank(acc.Phone)){
                    acc.MessagingPlatformKey__c = 'whatsapp:' + acc.phone;
                }
				if (String.isNotBlank(acc.Lugar_de_nacimiento__c)) {
					cambiaLugarNacimiento.add(acc);
                    cambioPorID.put(acc.ID, 'Cuenta');
                }
                
                if (String.isNotBlank(acc.Lugar_de_nacimiento__pc)) {
					cambiaLugarNacimiento.add(acc);
                    cambioPorID.put(acc.ID, 'Contacto');                    
                }
                
                if (String.isNotBlank(acc.Genero_UDC__c)) {
					cambiaGenero.add(acc);
                    cambioPorID.put(acc.ID, 'Cuenta');
                }
                
                if (String.isNotBlank(acc.Genero_UDC__pc)) {
					cambiaGenero.add(acc);
                    cambioPorID.put(acc.ID, 'Contacto');                    
                }

                if (acc.Tipo_de_Indentificaci_n__c == 'Cedula de Identidad' && String.isNotBlank(acc.Cedula__c)) {
                    personalesConIdentificacion.add(acc);
                }
            }
            
            AccountHelper.validarIDPersonal(Trigger.new);
            AccountHelper.validarTelefono(Trigger.new);
            AccountHelper.actualizarSecuencia(Trigger.new);
            AccountHelper.setearPersonFields(Trigger.new);

            if (!cambiaGenero.isEmpty() || !cambioPorID.isEmpty()) {
                AccountHelper.cambiarGenero(cambiaGenero, cambioPorID);
            }

            if (!cambiaLugarNacimiento.isEmpty() || !cambioPorID.isEmpty()) {
                AccountHelper.cambiarLugarDeNacimiento(cambiaLugarNacimiento, cambioPorID);
            }

            if (!personalesConIdentificacion.isEmpty()) {
                AccountHelper.setearEdad(personalesConIdentificacion);
            }
        }
        
        if (Trigger.isInsert || Trigger.isUpdate) {
            List<Account> cuentasConRepLegal = new List<Account>();
            
            for (Account acc : Trigger.new) {
                if (String.isNotBlank(acc.Representante_Legal__c)) {
                    cuentasConRepLegal.add(acc);
                }
                
                 if (!String.isNotBlank(acc.Tipo_de_t_lefono__c))
                {
                    actualizacionTipoTelefono.add(acc);  
                }
                
                if (!String.isNotBlank(acc.Tipo_de_email__c))
                {
                    actualizacionTipoEmail.add(acc);  
                }
            }
            
            AccountHelper.upperCaseName(Trigger.new);
            
            if (!cuentasConRepLegal.isEmpty()) {
            	AccountHelper.validarRepresentanteLegal(cuentasConRepLegal);    
            }  
            
             if (!actualizacionTipoTelefono.isEmpty()) {
                AccountHelper.actualizarDatosPorOmision(actualizacionTipoTelefono,'Telefono');
            }
             if (!actualizacionTipoEmail.isEmpty()) {
                AccountHelper.actualizarDatosPorOmision(actualizacionTipoEmail,'Email');
            }
            
        }
        
        if (Trigger.isDelete) {
            ID profileID = UserInfo.getProfileId();
            
            String profileName = [SELECT Name FROM Profile WHERE ID =: profileID][0].Name;
            
            for (Account ac : Trigger.old) {
                if (profileName == 'System Administrator' || profileName == 'Administrador del sistema') {
                    if (ac.RecordTypeID == personAccountID) {
						accountID.add(ac.ID);
                	}        
                } else {
                	ac.addError('No tienes permisos para eliminar este registro.');
                }
        	}
            
            if (!accountID.isEmpty()) {
            	AccountHelper.EliminarRelaciones(accountID);    
            }
        }
    }
    
    if (Trigger.isAfter) {
        if(!System.isFuture() && !System.isBatch()){
            String actionTypeAcc;
            Map<ID, Account> oldTriggerMap;
            List<Account> accList = new List<Account>();
            if (Trigger.isInsert) {
                for (Account acc : Trigger.new) {
                    if (!acc.Creado_desde_Sitio_Externo__c && !acc.Creado_desde_un_Lead__c) {
                    	accList.add(acc);    
                    }
                }

                actionTypeAcc = '1';
            }

            if (Trigger.isUpdate) {
                List<Account> nombresActualizados = new List<Account>();
                for (Account acc : Trigger.new) {
                    if (String.isNotBlank(acc.CodigoCliente__c) && 
                        acc.Secuencia_contactos__c == Trigger.oldMap.get(acc.ID).Secuencia_contactos__c && 
                        acc.Envio_correcto_a_WS__c == Trigger.oldMap.get(acc.ID).Envio_correcto_a_WS__c &&
                        acc.Envio_correcto_a_WS__pc == Trigger.oldMap.get(acc.ID).Envio_correcto_a_WS__pc &&
                        acc.Secuencia_correo__pc == Trigger.oldMap.get(acc.ID).Secuencia_correo__pc &&
                        acc.Campo_auxiliar_para_cambios__c == Trigger.oldMap.get(acc.ID).Campo_auxiliar_para_cambios__c &&
                        acc.Imagen_Identificacion_1_URL__c == Trigger.oldMap.get(acc.ID).Imagen_Identificacion_1_URL__c &&
                        acc.Imagen_Identificacion_2_URL__c == Trigger.oldMap.get(acc.ID).Imagen_Identificacion_2_URL__c &&
                        acc.Secuencia_direccion__pc == Trigger.oldMap.get(acc.ID).Secuencia_direccion__pc &&
                        acc.Secuencia_telefono__pc == Trigger.oldMap.get(acc.ID).Secuencia_telefono__pc &&
                        acc.SecuenciaEmail__c == Trigger.oldMap.get(acc.ID).SecuenciaEmail__c &&
                        //acc.MessagingPlatformKey__c == Trigger.oldMap.get(acc.ID).MessagingPlatformKey__c &&
                        acc.SecuenciaTelefono__c == Trigger.oldMap.get(acc.ID).SecuenciaTelefono__c &&
                        acc.SecuenciaDireccion__c == Trigger.oldMap.get(acc.ID).SecuenciaDireccion__c) {

                            actionTypeAcc = '2';
                    }

                    if (String.isBlank(acc.Campo_auxiliar_para_cambios__c)) {

                        if (String.isNotBlank(Trigger.oldMap.get(acc.ID).Campo_auxiliar_para_cambios__c) && 
                            Trigger.oldMap.get(acc.ID).Campo_auxiliar_para_cambios__c.contains('Aprobado')) {

                            actionTypeAcc = '2';
                        }
                    }

                    if ((acc.Name != Trigger.oldMap.get(acc.ID).Name) || 
                        (acc.FirstName != Trigger.oldMap.get(acc.ID).FirstName) || 
                        (acc.MiddleName != Trigger.oldMap.get(acc.ID).MiddleName) || 
                        (acc.LastName != Trigger.oldMap.get(acc.ID).LastName)) {

                        nombresActualizados.add(acc);
                    }

                    accList.add(acc);    

                    oldTriggerMap = Trigger.oldMap;
                }

                if(!nombresActualizados.isEmpty()) {
                    AccountHelper.actualizarOportunidades(nombresActualizados);
                }
            }

            if (Trigger.isDelete) {
                for (Account acc : Trigger.old) {
                    if (String.isNotBlank(acc.CodigoCliente__c)) {
                        accList.add(acc);
                    }
                }
                actionTypeAcc = '3';
            }
            
            
            
            AccountHelper.modificarCuentaEnServicio(accList, oldTriggerMap, actionTypeAcc);
        }
    }
}