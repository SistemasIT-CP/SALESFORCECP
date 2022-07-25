public with sharing class AccountContactRelationHelper {
    public static void setExternalID(List<AccountContactRelation> acrList) {
        Map<ID, Account> accountByID = getAccounts(acrList);

        for (AccountContactRelation acr : acrList) {
            Account acc = accountByID.get(acr.AccountID);
            acc.Secuencia_contactos__c = acc.Secuencia_contactos__c == null? 1 : 
                                                                            acc.Secuencia_contactos__c + 1;
            acr.IdExterno__c = acc.CodigoCliente__c + '_' + acc.Secuencia_contactos__c;
            
            update acc;
        }
    }
    
    public static void cargoCompleto(List<AccountContactRelation> acrList) {
        List<ID> accID = new List<ID>();
        List<ID> conID = new List<ID>();

        for (AccountContactRelation acr : acrList) {
            accID.add(acr.AccountId);
            conID.add(acr.ContactId);
        }
        
        Map<ID, Account> accMap = new Map<ID, Account>(
            [SELECT RecordType.DeveloperName, Creado_desde_un_Lead__c
             FROM Account
             WHERE ID IN :accID
        	]);

        Map<ID, Contact> contMap = new Map<ID, Contact>([
            SELECT ID, Title
            FROM Contact 
            WHERE ID IN :conID
        ]);
        
        for (AccountContactRelation acr : acrList) {
            if (accMap.containsKey(acr.AccountId) && !Test.isRunningTest()) {
                if (String.isBlank(acr.Cargo__c)) {
                    if (accMap.get(acr.AccountId).RecordType.DeveloperName != 'PersonAccount' && !accMap.get(acr.AccountId).Creado_desde_un_Lead__c && String.isBlank(contMap.get(acr.ContactId).Title)) {
                       acr.Cargo__c.addError('El campo Cargo debe estar completo para cuentas jurídicas');
                    } 
                }
            }
        }
    }

    public static void sendRelationToWS(List<AccountContactRelation> acrList) {
        List<AccountContactRelation> filteredAcrList = relacionesNoParentales(acrList);
        for (AccountContactRelation acr : filteredAcrList) {
                CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(acr.ContactID, 
                                                                        '1', 
                                                                        '0', 
                                                                        '0',
                                                                        '0', 
                                                                        'CONTACTO',
                                                                        new List<String> { 'Only relation', acr.IdExterno__c });
        }
    }

    public static void deleteRelationToWS(List<AccountContactRelation> acrList) {
        List<AccountContactRelation> filteredAcrList = relacionesNoParentales(acrList);
        for (AccountContactRelation acr : filteredAcrList) {
            CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(acr.ContactID, 
                                                                    '3', 
                                                                    '0', 
                                                                    '0',
                                                                    '0', 
                                                                    'CONTACTO',
                                                                    new List<String> { 'Only relation', acr.IdExterno__c });
        }
    }
    
    public static void actualizarCargo(List<AccountContactRelation> acrList) {
    	for (AccountContactRelation acr : acrList) {
                CallWS_ClientesBookManager.Inserta_Actualiza_Contacto(acr.ContactID, 
                                                                        '2', 
                                                                        '0', 
                                                                        '0',
                                                                        '0', 
                                                                        'CONTACTO',
                                                                        new List<String> { 'Only relation', acr.IdExterno__c, 'Cargo' });
        }    
    }
    
    private static List<AccountContactRelation> relacionesNoParentales (List<AccountContactRelation> acrList) {
        Set<ID> acrID = new Set<ID>();
        Set<ID> contactID = new Set<ID>();
        Map<ID, Contact> contByID = new Map<ID, Contact>();
        List<AccountContactRelation> relacionesNoParentales = new List<AccountContactRelation>();

        for (AccountContactRelation acr : acrList) {
            acrID.add(acr.ID);
        }

        List<AccountContactRelation> acrListFullData = new List<AccountContactRelation>();

        for (AccountContactRelation acr : [SELECT AccountID, ContactID, IdExterno__c FROM AccountContactRelation WHERE ID IN :acrID]) {
            contactID.add(acr.ContactID);
            acrListFullData.add(acr);
        }

        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        Map<ID, Account> accByID = getAccounts(acrListFullData);

        for (Contact c : [SELECT ID, AccountID FROM Contact WHERE ID IN :contactID]) {
            contByID.put(c.ID, c);
        }

        for (AccountContactRelation acr : acrListFullData) {
            if (accByID.get(acr.AccountID).RecordTypeId == personAccountID) {
                relacionesNoParentales.add(acr);
            } else {
                if (acr.AccountID != contByID.get(acr.ContactID).AccountID) {
                    relacionesNoParentales.add(acr);
                }
            }
        }

        return relacionesNoParentales;
    }
    
    public static void validacionObjetosRelacionados(List<AccountContactRelation> acrList) {
        List<ID> accIDList = new List<ID>();
        List<String> codigoRelacion = new List<String>();
        
        for (AccountContactRelation acr : acrList) {
            accIDList.add(acr.AccountId);
        }
        
        for (Correo__c c : [SELECT ID, Cliente__c, Contacto__c
                            FROM Correo__c
                            WHERE Cliente__c IN :accIDList
                           ]) {
        	if (c.Contacto__c != null) {
                codigoRelacion.add(c.Cliente__c + '_' + c.Contacto__c);
            }	                       
		}
        
        for (DireccionesAlter__c d : [SELECT ID, Cliente__c, Contacto__c
                                      FROM DireccionesAlter__c
                                      WHERE Cliente__c IN :accIDList
                                      ]) {
        	if (d.Contacto__c != null) {
                codigoRelacion.add(d.Cliente__c + '_' + d.Contacto__c);
            }	                       
		}
        
        for (Telefono__c t : [SELECT ID, Cliente__c, Contacto__c
                              FROM Telefono__c
                              WHERE Cliente__c IN :accIDList
                              ]) {
        	if (t.Contacto__c != null) {
                codigoRelacion.add(t.Cliente__c + '_' + t.Contacto__c);
            }	                       
		}
        
        for (AccountContactRelation acr : acrList) {
            String acrCode = acr.AccountId + '_' + acr.ContactId;
            if (codigoRelacion.contains(acrCode)) {
                acr.addError('Primero elimine correos, teléfonos o direcciones relacionadas a este contacto en esta cuenta.');
            }
        }
    }
    
    private static Map<ID, Account> getAccounts(List<AccountContactRelation> acrList) {
        Set<ID> accID = new Set<ID>();
        
        for (AccountContactRelation acr : acrList) {
            accID.add(acr.AccountID);
        }

        Map<ID, Account> accountByID = new Map<ID, Account>(
                    [SELECT ID, CodigoCliente__c, Secuencia_contactos__c, RecordTypeId
                    FROM Account 
                    WHERE ID IN :accID
                    ]);

        return accountByID;
    }
}