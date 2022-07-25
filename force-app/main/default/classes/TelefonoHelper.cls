public with sharing class TelefonoHelper {
    public static void setearIDExternoYSecuenciaTelefono(List<Telefono__c> telefonoList) {
        Map<ID, Decimal> contactoIDPorSecuenciaTelefono = contactoPorSecuenciaTelefono(telefonoList);
        List<ID> accountID = getAccountsIDList(telefonoList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);

        for (Telefono__c tel : telefonoList) {
            if (String.isBlank(tel.phonelinenumber__c)) {
                Decimal conteo;
                if (tel.Contacto__c != null) {
                    conteo = contactoIDPorSecuenciaTelefono.get(tel.Contacto__c); 
                } else {
                    conteo = accMap.get(tel.Cliente__c).SecuenciaTelefono__c;
                }

                Decimal valor = conteo == null ? 2 : conteo + 1;

                tel.phonelinenumber__c = '' + valor;

                contactoIDPorSecuenciaTelefono.put(tel.Contacto__c, valor);
            }

            if(String.isBlank(tel.IdExterno__c)) {
                String idExterno;
                if (tel.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(tel.Cliente__c + '_' + tel.Contacto__c); 
                } else {
                    idExterno = accMap.get(tel.Cliente__c).CodigoCliente__c + '_0';
                }

                if (idExterno != null) {
                    tel.IdExterno__c = idExterno + '_' + tel.phonelinenumber__c;
                } else {
                    tel.addError('La cuenta debe enviarse correctamente al WS para asociar un telefono');
                }
            }
        }
    }

    public static void modificarSecuenciaEnContacto(List<Telefono__c> telefonoList) {
        Map<ID, Decimal> contactoIDPorSecuenciaTelefono = contactoPorSecuenciaTelefono(telefonoList);
        List<Contact> contactosToUpdate = new List<Contact>();
        List<ID> accountID = getAccountsIDList(telefonoList);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
        List<Account> accToUpdate = new List<Account>();

        for (Telefono__c tel : telefonoList) {
            Decimal conteo;
            if (tel.Contacto__c != null) {
                conteo = contactoIDPorSecuenciaTelefono.get(tel.Contacto__c);
                Decimal valor = conteo == null ? 2 : conteo + 1;
                contactoIDPorSecuenciaTelefono.put(tel.Contacto__c, valor);
            } else {
                Account acc = accMap.get(tel.Cliente__c);
                conteo = acc.SecuenciaTelefono__c;
                Decimal valor = conteo == null ? 2 : conteo + 1;
                acc.SecuenciaTelefono__c = valor;

                accToUpdate.add(acc);
            }
        }

        for (Contact con : [SELECT ID, Secuencia_telefono__c
                            FROM Contact 
                            WHERE ID IN :contactoIDPorSecuenciaTelefono.KeySet()
                            ]) {
            con.Secuencia_telefono__c = contactoIDPorSecuenciaTelefono.get(con.ID);
            contactosToUpdate.add(con);
        }

        update contactosToUpdate;
        update accToUpdate;
    }

    public static void modificarContactosEnServicio(List<Telefono__c> telefonoList,
                                                    String actionTypeTelefono
    ) {
        List<ID> accountID = getAccountsIDList(telefonoList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);

        for (Telefono__c tel : telefonoList) {
            if (actionTypeTelefono != null) {
                String idExterno;
                if (tel.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(tel.Cliente__c + '_' + tel.Contacto__c); 
                } else {
                    idExterno = accMap.get(tel.Cliente__c).CodigoCliente__c + '_0';
                }
                if (idExterno != null) {
                    CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                        												tel.ID, 
                                                                        '2',
                                                                        '0', 
                                                                        actionTypeTelefono, 
                                                                        '0', 
                                                                        'TELEFONO',
                                                                        new List<String> { 'Only relation', idExterno });
                } else {
                    tel.addError('La cuenta debe enviarse correctamente al WS para asociar un telefono');
                }
            }
        }
    }

    public static void cambiarContacto(List<Telefono__c> telefonoList, 
                                       Map<ID, Telefono__c> telefonosViejos) {
        List<ID> accountID = getAccountsIDList(telefonoList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
		List<ID> telefonoIDList = new List<ID>(); 

        for(Telefono__c d : telefonoList) {
            telefonoIDList.add(d.ID);
            String idExterno;
            String idViejo;
            String idContactoViejo;
            String codigoCorreo = d.phonelinenumber__c;
            
            if(d.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(d.Cliente__c + '_' + d.Contacto__c); 
            } else {
                idExterno = accMap.get(d.Cliente__c).CodigoCliente__c + '_0';
            }
            
            if(telefonosViejos.get(d.ID).Contacto__c != null) {
                idViejo = idExternoByRelacion.get(telefonosViejos.get(d.ID).Cliente__c + '_' + 
                                                  telefonosViejos.get(d.ID).Contacto__c); 
                idContactoViejo = telefonosViejos.get(d.ID).Contacto__c;
            } else {
                idViejo = accMap.get(telefonosViejos.get(d.ID).Cliente__c).CodigoCliente__c + '_0';
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
                                                            '3', 
                                                            '0', 
                                                            'TELEFONO',
                                                            new List<String> { 'Only relation', idViejo , 'Eliminar', idContactoViejo + '_' + codigoCorreo });
            } else {
                d.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
            
            if (idExterno != null) {
				CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                    										d.ID, 
                                                            '2',
                                                            '0', 
                                                            '1', 
                                                            '0', 
                                                            'TELEFONO',
                                                            new List<String> { 'Only relation', idExterno });
            } else {
                d.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
        }

		TelefonoHelper.cambiarIdExterno(telefonoIDList);
    }
    
    public static void cambiarIdExterno(List<ID> telefonoIDList) {
        List<Telefono__c> telefonoList = 
            [SELECT phonelinenumber__c, IdExterno__c, Contacto__c, Cliente__c
             FROM Telefono__c
             WHERE ID IN :telefonoIDList
            ];
		Map<ID, Decimal> contactoPorSecuenciaTelefono = contactoPorSecuenciaTelefono(telefonoList);
        List<ID> accountID = getAccountsIDList(telefonoList);
        Map<String, String> idExternoByRelacion = CorreoHelper.idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = CorreoHelper.mapaCuentas(accountID);
        List<Telefono__c> telefonoToUpdate = new List<Telefono__c>();

        System.debug(idExternoByRelacion);
        
        for (Telefono__c t : telefonoList) {
            Decimal conteo;
            if (t.Contacto__c != null) {
                conteo = contactoPorSecuenciaTelefono.get(t.Contacto__c); 
            } else {
                conteo = accMap.get(t.Cliente__c).SecuenciaDireccion__c;
            }
            Decimal valor = conteo == null ? 2 : conteo + 1;

            t.phonelinenumber__c = '' + valor;

            contactoPorSecuenciaTelefono.put(t.Contacto__c, valor);
            
            System.debug('Contacto: ' + t.Contacto__c);
            
            String idExterno;
            if (t.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(t.Cliente__c + '_' + t.Contacto__c); 
            } else {
                idExterno = accMap.get(t.Cliente__c).CodigoCliente__c + '_0';
            }
            
            System.debug(idExterno);
            
            t.IdExterno__c = idExterno + '_' + t.phonelinenumber__c;
            
            telefonoToUpdate.add(t);
        }
        
        update telefonoToUpdate;
    }
    
    public static void verificarContacto(List<Telefono__c> telefonoList) {
        
        List<ID> accountID = getAccountsIDList(telefonoList);

        Map<ID, Set<ID>> contactsRelatedByAccID = CorreoHelper.relatedContactsToAccount(accountID);

        for (Telefono__c tel : telefonoList) {
            if(tel.Contacto__c != null) {
                if(contactsRelatedByAccID.isEmpty() || !contactsRelatedByAccID.get(tel.Cliente__c).contains(tel.Contacto__c)) {
                    tel.Contacto__c.addError('Debe elegir un contacto relacionado a la cuenta.');
                }
            }
        }
    }
    
    private static Map<ID, Decimal> contactoPorSecuenciaTelefono(List<Telefono__c> telefonoList) {
        Set<ID> contactosID = new Set<ID>();
        for (Telefono__c tel : telefonoList) {
            contactosID.add(tel.Contacto__c);
        }

        Map<ID, Decimal> contactoByTelNum = new Map<ID, Decimal>(); 

       for(Contact con : [SELECT ID, Secuencia_telefono__c
                        FROM Contact 
                        WHERE ID IN :contactosID
                        ]) {
            Decimal conteo = con.Secuencia_telefono__c == null? 1 : con.Secuencia_telefono__c;
            contactoByTelNum.put(con.ID, conteo);
        }

        return contactoByTelNum;
    }
    
    private static List<ID> getAccountsIDList(List<Telefono__c> telefonoList){
        List<ID> accountID = new List<ID>();

        for (Telefono__c tel : telefonoList) {
            accountID.add(tel.Cliente__c);
        }

        return accountID;
    }
}