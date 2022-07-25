public with sharing class ContactHelper {
    public static void actualizarContactID(List<Contact> contactosLista) {
        Map<ID, Decimal> cuentasIDPorSecuenciaContactos = obtenerMapaCuentasPorSecuenciaContacto(contactosLista);

        for (Contact contact : contactosLista) {
            Decimal conteo = cuentasIDPorSecuenciaContactos.get(contact.AccountID); 

            if (String.isBlank(contact.contactid__c)) {
                Decimal valor = conteo == null ? 1 : conteo + 1;

                contact.contactid__c = '' + valor;

                cuentasIDPorSecuenciaContactos.put(contact.AccountID, valor);
            }
        }
    }

    public static void checkContactCreation(List<Contact> contactosList) {
        Profile perfil = [
            SELECT Name
            FROM Profile
            WHERE Id =: UserInfo.getProfileId() 
            LIMIT 1
        ];

        Boolean isAdmin = perfil.Name.toUpperCase().contains('ADMIN');

        for (Contact contact : contactosList) {
            if (!isAdmin && !contact.Creado_desde_un_Lead__c) {
                contact.addError('No es posible crear contactos. Consulte con un administrador.');
            }
        }
    }

    public static void upperCaseName(List<Contact> contactoList) {
        for (Contact con : contactoList) {
            con.FirstName = String.isNotBlank(con.FirstName)? con.FirstName.toUpperCase() : '';
            con.MiddleName = String.isNotBlank(con.MiddleName)? con.MiddleName.toUpperCase() : '';
            con.LastName = String.isNotBlank(con.LastName)? con.LastName.toUpperCase() : '';
            con.Numero_de_documento__c = String.isNotBlank(con.Numero_de_documento__c)? con.Numero_de_documento__c.toUpperCase() : '';
        }
    }

    public static void modificarContactosEnServicio(List<Contact> contactosLista,
                                                    Map<ID, Contact> oldTriggerMap,
                                                    String actionTypeContact
    ) {
        if(!contactosLista.isEmpty()){
            List<ID> idList = new List<ID>();
            List<String> criterios = new List<String>{ 'Parent' };
                
            if (actionTypeContact == '2') {
                criterios.add('All relation');
            }
            
            for (Contact con : contactosLista) {
                idList.add(con.ID);
            }

            Integer size = 10;
            
            if(idList.size() < 10 || Test.isRunningTest()) {
                size = idList.size();
            }
            
            System.debug(size);
            System.debug(idList);
            System.debug(criterios);

            System.debug('SE ENVIAN ' + idList.size() + ' CONTACTOS AL BATCH CON ACTION ' + actionTypeContact);
            Database.executeBatch(new BatchWSContactos(actionTypeContact, criterios, idList, oldTriggerMap), size); 
        }
    }
    
    public static void eliminarRelaciones (Map<ID, Contact> contMap) {
        List<AccountContactRelation> acrList =
            [SELECT ContactID, IdExterno__c
            FROM AccountContactRelation 
            WHERE ContactID IN :contMap.keySet()
            ];
        
        System.debug('La cuenta tiene ' + acrList.size() + ' relaciones y se van a eliminar');
        
        if (!acrList.isEmpty()) {
            Database.DeleteResult[] dr = Database.delete(acrList, false);
        }
    }


    private static Map<ID, Decimal> obtenerMapaCuentasPorSecuenciaContacto (List<Contact> contactosLista) {
        Set<ID> cuentasID = new Set<ID>();
        
        for (Contact contact : contactosLista) {
            cuentasID.add(contact.AccountID);
        }

        Map<ID, Decimal> cuentasIDPorSecuenciaContactos = new Map<ID, Decimal>();

        for(Account acc : [SELECT ID, Secuencia_contactos__c
                            FROM Account 
                            WHERE ID IN :cuentasID
                            ]) {
            cuentasIDPorSecuenciaContactos.put(acc.ID, acc.Secuencia_contactos__c);
        }
        
        return cuentasIDPorSecuenciaContactos;
    }
}