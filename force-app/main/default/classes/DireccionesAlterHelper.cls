public with sharing class DireccionesAlterHelper {
    public static void setearIDExternoYSecuenciaDireccion(List<DireccionesAlter__c> direccionesAlterList) {
        Map<ID, Decimal> contactoIDPorSecuenciaDireccion = contactoPorSecuenciaDireccion(direccionesAlterList);
        List<ID> accountID = getAccountsIDList(direccionesAlterList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);

        for (DireccionesAlter__c dir : direccionesAlterList) {
            if (String.isBlank(dir.SEQUENCEADDRESS__c)) {
                Decimal conteo;
                if (dir.Contacto__c != null) {
                    conteo = contactoIDPorSecuenciaDireccion.get(dir.Contacto__c); 
                } else {
                    conteo = accMap.get(dir.Cliente__c).SecuenciaDireccion__c;
                }
                Decimal valor = conteo == null ? 2 : conteo + 1;

                dir.SEQUENCEADDRESS__c = '' + valor;

                contactoIDPorSecuenciaDireccion.put(dir.Contacto__c, valor);
            }
            
            if(String.isBlank(dir.Id_Externo__c)) {
                String idExterno;
                if (dir.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(dir.Cliente__c + '_' + dir.Contacto__c); 
                } else {
                    idExterno = accMap.get(dir.Cliente__c).CodigoCliente__c + '_0';
                }
                
                if (idExterno != null) {
                    dir.Id_Externo__c = idExterno + '_' + dir.SEQUENCEADDRESS__c;
                } else {
                    dir.addError('La cuenta debe enviarse correctamente al WS para asociar una direccion alterna');
                }
            }
        }
    }

    public static void modificarSecuenciaEnContacto(List<DireccionesAlter__c> direccionesAlterList) {
        Map<ID, Decimal> contactoIDPorSecuenciaDireccion = contactoPorSecuenciaDireccion(direccionesAlterList);
        List<Contact> contactosToUpdate = new List<Contact>();
        List<ID> accountID = getAccountsIDList(direccionesAlterList);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
        List<Account> accToUpdate = new List<Account>();

        for (DireccionesAlter__c dir : direccionesAlterList) {
            Decimal conteo;
            if (dir.Contacto__c != null) {
                conteo = contactoIDPorSecuenciaDireccion.get(dir.Contacto__c);
                Decimal valor = conteo == null ? 2 : conteo + 1;
                contactoIDPorSecuenciaDireccion.put(dir.Contacto__c, valor);
            } else {
                Account acc = accMap.get(dir.Cliente__c);
                conteo = acc.SecuenciaDireccion__c;
                Decimal valor = conteo == null ? 2 : conteo + 1;
                acc.SecuenciaDireccion__c = valor;
                
                accToUpdate.add(acc);
            }
        }

        for (Contact con : [SELECT ID, Secuencia_direccion__c
                            FROM Contact 
                            WHERE ID IN :contactoIDPorSecuenciaDireccion.KeySet()
                            ]) {
            con.Secuencia_direccion__c = contactoIDPorSecuenciaDireccion.get(con.ID);
            contactosToUpdate.add(con);
        }

        update contactosToUpdate;
        update accToUpdate;
    }

    public static void modificarContactosEnServicio(List<DireccionesAlter__c> direccionesAlterList,
                                                    String actionTypeDireccion
    ) {
        List<ID> accountID = getAccountsIDList(direccionesAlterList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);

        for(DireccionesAlter__c dir : direccionesAlterList) {
            if(actionTypeDireccion != null){
                String idExterno;
                
                if(dir.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(dir.Cliente__c + '_' + dir.Contacto__c); 
                } else {
                    idExterno = accMap.get(dir.Cliente__c).CodigoCliente__c + '_0';
                }

                if (idExterno != null) {
                    CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                        												dir.ID, 
                                                                        '2',
                                                                        '0', 
                                                                        '0', 
                                                                        actionTypeDireccion, 
                                                                        'DIRECCION',
                                                                        new List<String> { 'Only relation', idExterno });
                } else {
                    dir.addError('La cuenta debe enviarse correctamente al WS para asociar una direccion alterna');
                }
            }
        }
    }

    public static void cambiarContacto(List<DireccionesAlter__c> direccionesAlterList, 
                                       Map<ID, DireccionesAlter__c> direccionesViejas) {
        List<ID> accountID = getAccountsIDList(direccionesAlterList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
        List<ID> direccionIDList = new List<ID>(); 

        for(DireccionesAlter__c d : direccionesAlterList) {
            direccionIDList.add(d.ID);
            String idExterno;
            String idViejo;
            String idContactoViejo;
            String codigoCorreo = d.SEQUENCEADDRESS__c;
            
            if(d.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(d.Cliente__c + '_' + d.Contacto__c); 
            } else {
                idExterno = accMap.get(d.Cliente__c).CodigoCliente__c + '_0';
            }
            
            if(direccionesViejas.get(d.ID).Contacto__c != null) {
                idViejo = idExternoByRelacion.get(direccionesViejas.get(d.ID).Cliente__c + '_' + 
                                                  direccionesViejas.get(d.ID).Contacto__c); 
                idContactoViejo = direccionesViejas.get(d.ID).Contacto__c;
            } else {
                idViejo = accMap.get(direccionesViejas.get(d.ID).Cliente__c).CodigoCliente__c + '_0';
                idContactoViejo = 'nada';
            }

            System.debug('idViejo: ' + idViejo);
            System.debug('idExterno: ' + idExterno);
            System.debug('idContactoViejo ' + idContactoViejo);
            System.debug('codigoCorreo ' + codigoCorreo);
            
            if (idViejo != null) {
                CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                    										d.ID, 
                                                            '2',
                                                            '0', 
                                                            '0', 
                                                            '3', 
                                                            'DIRECCION',
                                                            new List<String> { 'Only relation', idViejo , 'Eliminar', idContactoViejo + '_' + codigoCorreo });
            } else {
                d.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
            
            if (idExterno != null) {
				CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                    										d.ID, 
                                                            '2',
                                                            '0', 
                                                            '0', 
                                                            '1', 
                                                            'DIRECCION',
                                                            new List<String> { 'Only relation', idExterno });
            } else {
                d.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
        }
                                           
       DireccionesAlterHelper.cambiarIdExterno(direccionIDList);
    }
    
    public static void cambiarIdExterno(List<ID> direccionIDList) {
        List<DireccionesAlter__c> direccionesAlterList = 
            [SELECT SEQUENCEADDRESS__c, Id_Externo__c, Contacto__c, Cliente__c
             FROM DireccionesAlter__c
             WHERE ID IN :direccionIDList
            ];
		Map<ID, Decimal> contactoIDPorSecuenciaDireccion = contactoPorSecuenciaDireccion(direccionesAlterList);
        List<ID> accountID = getAccountsIDList(direccionesAlterList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
        List<DireccionesAlter__c> direccionesToUpdate = new List<DireccionesAlter__c>();

        for (DireccionesAlter__c dir : direccionesAlterList) {
            Decimal conteo;
            if (dir.Contacto__c != null) {
                conteo = contactoIDPorSecuenciaDireccion.get(dir.Contacto__c); 
            } else {
                conteo = accMap.get(dir.Cliente__c).SecuenciaDireccion__c;
            }
            Decimal valor = conteo == null ? 2 : conteo + 1;

            dir.SEQUENCEADDRESS__c = '' + valor;

            contactoIDPorSecuenciaDireccion.put(dir.Contacto__c, valor);
            
            String idExterno;
            if (dir.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(dir.Cliente__c + '_' + dir.Contacto__c); 
            } else {
                idExterno = accMap.get(dir.Cliente__c).CodigoCliente__c + '_0';
            }
            
            if (idExterno != null) {
                dir.Id_Externo__c = idExterno + '_' + dir.SEQUENCEADDRESS__c;
            } else {
                dir.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
            
            direccionesToUpdate.add(dir);
        }
        
        Database.SaveResult[] sr = Database.Update(direccionesToUpdate, false);
    }
    
    public static void verificarContacto(List<DireccionesAlter__c> direccionesAlterList) {
        
        List<ID> accountID = getAccountsIDList(direccionesAlterList);

        Map<ID, Set<ID>> contactsRelatedByAccID = CorreoHelper.relatedContactsToAccount(accountID);

        for (DireccionesAlter__c dir : direccionesAlterList) {
            if(dir.Contacto__c != null) {
                if(contactsRelatedByAccID.isEmpty() || !contactsRelatedByAccID.get(dir.Cliente__c).contains(dir.Contacto__c)) {
                    dir.Contacto__c.addError('Debe elegir un contacto relacionado a la cuenta.');
                }
            }
        }
    }
    
    public static void validarTipos(List<DireccionesAlter__c> direccionesAlterList, Map<ID, DireccionesAlter__c> mapaDireccionesViejas) {
        if (!direccionesAlterList.isEmpty()) {

            List<ID> contactID = new List<ID>();
            for (DireccionesAlter__c d : direccionesAlterList) {
                contactID.add(d.Contacto__c);
            }
            
            DireccionesAlter__c dir = direccionesAlterList.get(0);
            
            System.debug(dir);
            
            Map<String, Decimal> numDireccionesPorTipo = numDireccionesPorTipo(dir.Cliente__c, contactID);
    
            System.debug(numDireccionesPorTipo);
            
            for (DireccionesAlter__c d : direccionesAlterList) {
                String key = d.Contacto__c + '_' + d.Tipo_de_direcci_n__c;
                
                System.debug(numDireccionesPorTipo.get(key));
                
                if (numDireccionesPorTipo.keySet().contains(key)) {
                    if (mapaDireccionesViejas != null && d.Contacto__c != mapaDireccionesViejas.get(d.ID).Contacto__c) {
                        d.Contacto__c.addError('El nuevo contacto ya tiene una dirección de este tipo.');	   
                    } else {
                        d.Tipo_de_direcci_n__c.addError('No puede haber más de una direccion del mismo tipo.');
                    }
                }                   
            }
                        
        }
    }

    private static Map<String, Integer> numDireccionesPorTipo(ID accID, List<ID> contIDList) {
        Map<String, Integer> dirPorTipo = new Map<String, Integer>();
        for (DireccionesAlter__c d : [SELECT Tipo_de_direcci_n__c, Contacto__c, Contacto__r.Name
                                     FROM DireccionesAlter__c
                                     WHERE Cliente__c =: accID
                                      AND Contacto__c IN :contIDList]) {
			String tipo = d.Tipo_de_direcci_n__c;
			String clave = d.Contacto__c + '_' + tipo;
			Integer value = 1;
			System.debug(d);
        	if(!dirPorTipo.keySet().contains(clave)) {
                dirPorTipo.put(clave, value);
            } else {
                value = dirPorTipo.get(clave) + 1;
                dirPorTipo.put(clave, value);
            }
		}
        
        return dirPorTipo;
    }    
        
    private static Map<ID, Decimal> contactoPorSecuenciaDireccion(List<DireccionesAlter__c> direccionesAlterList) {
        Set<ID> contactosID = new Set<ID>();
        for (DireccionesAlter__c dir : direccionesAlterList) {
            contactosID.add(dir.Contacto__c);
        }

        Map<ID, Decimal> contactoByDirNum = new Map<ID, Decimal>(); 

       for(Contact con : [SELECT ID, Secuencia_direccion__c
                        FROM Contact 
                        WHERE ID IN :contactosID
                        ]) {
            Decimal conteo = con.Secuencia_direccion__c == null? 1 : con.Secuencia_direccion__c;
            contactoByDirNum.put(con.ID, conteo);
        }

        return contactoByDirNum;
    }

    private static List<ID> getAccountsIDList(List<DireccionesAlter__c> direccionesAlterList){
        List<ID> accountID = new List<ID>();

        for (DireccionesAlter__c dir : direccionesAlterList) {
            accountID.add(dir.Cliente__c);
        }

        return accountID;
    }
}