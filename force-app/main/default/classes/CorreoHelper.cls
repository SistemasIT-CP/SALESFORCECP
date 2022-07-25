global with sharing class CorreoHelper {
    public static void setearIDExternoYSecuenciaEmail(List<Correo__c> correosList) {
        Map<ID, Decimal> contactoIDPorSecuenciaCorreo = contactoPorSecuenciaCorreo(correosList);
        List<ID> accountID = getAccountsIDList(correosList);
        Map<String, String> idExternoByRelacion = idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = mapaCuentas(accountID);

        for (Correo__c correo : correosList) {
            if (String.isBlank(correo.electronicaddresslinenumber__c)) {
                Decimal conteo;
                if (correo.Contacto__c != null) {
                    conteo = contactoIDPorSecuenciaCorreo.get(correo.Contacto__c); 
                } else {
                    conteo = accMap.get(correo.Cliente__c).SecuenciaEmail__c;
                }

                Decimal valor = conteo == null ? 2 : conteo + 1;

                correo.electronicaddresslinenumber__c = '' + valor;

                contactoIDPorSecuenciaCorreo.put(correo.Contacto__c, valor);
            }
            
            if (String.isBlank(correo.IdExterno_c__c)) {
                String idExterno;
                if (correo.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(correo.Cliente__c + '_' + correo.Contacto__c); 
                } else {
                    idExterno = accMap.get(correo.Cliente__c).CodigoCliente__c + '_0';
                }
                
                if (idExterno != null) {
                    correo.IdExterno_c__c = idExterno + '_' + correo.electronicaddresslinenumber__c;
                } else {
                    correo.addError('La cuenta debe enviarse correctamente al WS para asociar un correo');
                }
            }
        }
    }

    public static void modificarSecuenciaEnContacto(List<Correo__c> correosList) {
        ID personAccountID = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();
        
        Map<ID, Decimal> contactoIDPorSecuenciaCorreo = contactoPorSecuenciaCorreo(correosList);
        List<Contact> contactosToUpdate = new List<Contact>();
        List<ID> accountID = getAccountsIDList(correosList);
        Map<ID, Account> accMap = mapaCuentas(accountID);
        List<Account> accToUpdate = new List<Account>();
        
        for (Correo__c correo : correosList) {
            Decimal conteo;
            if (correo.Contacto__c != null) {
                conteo = contactoIDPorSecuenciaCorreo.get(correo.Contacto__c);
                Decimal valor = conteo == null ? 2 : conteo + 1;
                contactoIDPorSecuenciaCorreo.put(correo.Contacto__c, valor);
            } else {
                Account acc = accMap.get(correo.Cliente__c);
                conteo = acc.SecuenciaEmail__c;
                Decimal valor = conteo == null ? 2 : conteo + 1;
                acc.SecuenciaEmail__c = valor;

                accToUpdate.add(acc);
            }
        }

        for (Contact con : [SELECT ID, Secuencia_correo__c
                            FROM Contact 
                            WHERE ID IN :contactoIDPorSecuenciaCorreo.KeySet()
                            ]) {  
            con.Secuencia_correo__c = contactoIDPorSecuenciaCorreo.get(con.ID);
            contactosToUpdate.add(con);
        }

        update contactosToUpdate;
        update accToUpdate;
    }

    public static void modificarContactosEnServicio(List<Correo__c> correosList,
                                                    String actionTypeCorreo
    ) {
        List<ID> accountID = getAccountsIDList(correosList);
        Map<String, String> idExternoByRelacion = idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = mapaCuentas(accountID);

        for(Correo__c correo : correosList) {
            if(actionTypeCorreo != null){
                String idExterno;
                
                if(correo.Contacto__c != null) {
                    idExterno = idExternoByRelacion.get(correo.Cliente__c + '_' + correo.Contacto__c); 
                } else {
                    idExterno = accMap.get(correo.Cliente__c).CodigoCliente__c + '_0';
                }

                if (idExterno != null) {
                    CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                        												correo.ID, 
                                                                        '2', 
                                                                        actionTypeCorreo, 
                                                                        '0',
                                                                        '0', 
                                                                        'CORREO',
                                                                        new List<String> { 'Only relation', idExterno });
                } else {
                    correo.addError('La cuenta debe enviarse correctamente al WS para asociar un correo');
                }
            }
        }
    }
    
    public static void cambiarContacto(List<Correo__c> correosList, Map<ID, Correo__c> correosViejos) {
        List<ID> accountID = getAccountsIDList(correosList);
        Map<String, String> idExternoByRelacion = idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = mapaCuentas(accountID);
        List<ID> correoIDList = new List<ID>(); 

        for(Correo__c correo : correosList) {
            correoIDList.add(correo.ID);
            String idExterno;
            String idViejo;
            String idContactoViejo;
            String codigoCorreo = correo.electronicaddresslinenumber__c;
            
            if(correo.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(correo.Cliente__c + '_' + correo.Contacto__c); 
            } else {
                idExterno = accMap.get(correo.Cliente__c).CodigoCliente__c + '_0';
            }
            
            if(correosViejos.get(correo.ID).Contacto__c != null) {
                idViejo = idExternoByRelacion.get(correosViejos.get(correo.ID).Cliente__c + '_' + 
                                                  correosViejos.get(correo.ID).Contacto__c); 
                idContactoViejo = correosViejos.get(correo.ID).Contacto__c;
            } else {
                idViejo = accMap.get(correosViejos.get(correo.ID).Cliente__c).CodigoCliente__c + '_0';
                idContactoViejo = 'nada';
            }

            System.debug('idViejo: ' + idViejo);
            System.debug('idExterno: ' + idExterno);
            System.debug('idContactoViejo' + idContactoViejo);
            System.debug('codigoCorreo' + codigoCorreo);
            
            if (idViejo != null) {
                CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                    												correo.ID, 
                                                                    '2', 
                                                                    '3', 
                                                                    '0',
                                                                    '0', 
                                                                    'CORREO',
                                                                    new List<String> { 'Only relation', idViejo , 'Eliminar', idContactoViejo + '_' + codigoCorreo});
            } else {
                correo.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
            
            if (idExterno != null) {
				CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(
                    												correo.ID, 
                                                                    '2', 
                                                                    '1', 
                                                                    '0',
                                                                    '0', 
                                                                    'CORREO',
                                                                    new List<String> { 'Only relation', idExterno });
            } else {
                correo.addError('La cuenta debe enviarse correctamente al WS para modificar el contacto.');
            }
        }
        
        CorreoHelper.cambiarIdExterno(correoIDList);
    }
    
    public static void cambiarIdExterno(List<ID> correoIDList) {
        List<Correo__c> correosList = 
            [SELECT electronicaddresslinenumber__c, IdExterno_c__c, Contacto__c, Cliente__c
             FROM Correo__c
             WHERE ID IN :correoIDList
            ];
		Map<ID, Decimal> contactoIDPorSecuenciaDireccion = contactoPorSecuenciaCorreo(correosList);
        List<ID> accountID = getAccountsIDList(correosList);
        Map<String, String> idExternoByRelacion = idExternoPorRelacion(accountID);
        Map<ID, Account> accMap = mapaCuentas(accountID);
        List<Correo__c> correosToUpdate = new List<Correo__c>();

        for (Correo__c c : correosList) {
            Decimal conteo;
            if (c.Contacto__c != null) {
                conteo = contactoIDPorSecuenciaDireccion.get(c.Contacto__c); 
            } else {
                conteo = accMap.get(c.Cliente__c).SecuenciaDireccion__c;
            }
            Decimal valor = conteo == null ? 2 : conteo + 1;

            c.electronicaddresslinenumber__c = '' + valor;

            contactoIDPorSecuenciaDireccion.put(c.Contacto__c, valor);
            
            String idExterno;
            if (c.Contacto__c != null) {
                idExterno = idExternoByRelacion.get(c.Cliente__c + '_' + c.Contacto__c); 
            } else {
                idExterno = accMap.get(c.Cliente__c).CodigoCliente__c + '_0';
            }
            
            System.debug(idExterno);
            
            c.IdExterno_c__c = idExterno + '_' + c.electronicaddresslinenumber__c;
            
            correosToUpdate.add(c);
        }
        update correosToUpdate;
    }
    
    public static void verificarContacto(List<Correo__c> correosList) {
        List<ID> accountID = getAccountsIDList(correosList);

        Map<ID, Set<ID>> contactsRelatedByAccID = relatedContactsToAccount(accountID);

        for (Correo__c corr : correosList) {
            if(corr.Contacto__c != null) {
                if(contactsRelatedByAccID.isEmpty() || !contactsRelatedByAccID.get(corr.Cliente__c).contains(corr.Contacto__c)) {
                    corr.Contacto__c.addError('Debe elegir un contacto relacionado a la cuenta.');
                }
            }   
        }
    }

    private static List<ID> getAccountsIDList(List<Correo__c> correosList){
        List<ID> accountID = new List<ID>();

        for (Correo__c correo : correosList) {
            accountID.add(correo.Cliente__c);
        }

        return accountID;
    }

    private static Map<ID, Decimal> contactoPorSecuenciaCorreo(List<Correo__c> correosList) {
        Set<ID> contactosID = new Set<ID>();
        for (Correo__c correo : correosList) {
            contactosID.add(correo.Contacto__c);
        }

        Map<ID, Decimal> contactoByCorreoNum = new Map<ID, Decimal>(); 

       for(Contact con : [SELECT ID, Secuencia_correo__c, Numero_de_documento__c
                        FROM Contact 
                        WHERE ID IN :contactosID
                        ]) {
            Decimal conteo = con.Secuencia_correo__c == null? 1 : con.Secuencia_correo__c;
            contactoByCorreoNum.put(con.ID, conteo);
        }

        return contactoByCorreoNum;
    }

    global static Map<ID, Set<ID>> relatedContactsToAccount (List<ID> accountIDList) {
        ID personAccountID = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();

        Set<ID> personAccID = new Set<ID>();

        for (Account acc : [SELECT RecordTypeId
                            FROM Account 
                            WHERE ID IN :accountIDList]) {
            if(acc.RecordTypeId == personAccountID) {
                personAccID.add(acc.ID);
            }
        }

        Map<ID, Set<ID>> contactsRelatedByAccID = new  Map<ID, Set<ID>>();

        for (AccountContactRelation acr : [SELECT AccountID, ContactID 
                                            FROM AccountContactRelation
                                            WHERE AccountID IN :accountIDList]) {
            Set<ID> contID;
            if(!contactsRelatedByAccID.containsKey(acr.AccountID)) {
                contID = new Set<ID> { acr.ContactID };
            } else {
                contID = contactsRelatedByAccID.get(acr.AccountID);
                contID.add(acr.ContactID);
            }
            contactsRelatedByAccID.put(acr.AccountID, contID);
        }

        for(Contact con : [SELECT ID, AccountID
                            FROM Contact 
                            WHERE AccountID IN :personAccID]) {
            Set<ID> auxSet;
            if (contactsRelatedByAccID.get(con.AccountID) != null) {
                auxSet = contactsRelatedByAccID.get(con.AccountID);                    
            } else {
                auxSet = new Set<ID>();
            }
			auxSet.add(con.ID);
            contactsRelatedByAccID.put(con.AccountID, auxSet);
        }

        return contactsRelatedByAccID;
    }

    global static Map<String, String> idExternoPorRelacion(List<ID> accountIDList) {
        ID personAccountID = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();

        Set<ID> personAccID = new Set<ID>();

        for (Account acc : [SELECT RecordTypeId, CodigoCliente__c
                            FROM Account 
                            WHERE ID IN :accountIDList]) {
            if(acc.RecordTypeId == personAccountID) {
                personAccID.add(acc.ID);
            }
        }

        Map<String, String> idExternoByRelacion = new  Map<String, String>();

        for (AccountContactRelation acr : [SELECT AccountID, ContactID, IdExterno__c 
                                            FROM AccountContactRelation
                                            WHERE AccountID IN :accountIDList]) {
            idExternoByRelacion.put(acr.AccountID + '_' + acr.ContactID, acr.IdExterno__c);
        }

        for(Contact con : [SELECT ID, AccountID, Account.CodigoCliente__c
                            FROM Contact 
                            WHERE AccountID IN :personAccID]) {
            if(String.isBlank(con.Account.CodigoCliente__c)) {
                idExternoByRelacion.put(con.AccountID + '_' + con.ID, null);
            } else {
                idExternoByRelacion.put(con.AccountID + '_' + con.ID, con.Account.CodigoCliente__c + '_0');
            }
        }

        return idExternoByRelacion;
    }

    global static Map<ID, Account> mapaCuentas(List<ID> accountIDList) {
        Map<ID, Account> accMap = new Map<ID, Account>(
                                            [SELECT CodigoCliente__c, SecuenciaEmail__c, 
                                                    SecuenciaTelefono__c, SecuenciaDireccion__c
                                            FROM Account 
                                            WHERE ID IN :accountIDList
                                            ]);

        return accMap;
    }
}