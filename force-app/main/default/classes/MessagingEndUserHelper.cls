public without sharing class MessagingEndUserHelper {
    public static void validarTelefono (List<MessagingEndUser> msjEList) {
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

        for(MessagingEndUser msjE : msjEList) {
            Boolean codigoValido = false;

            for (String cod : codigosDeAreaList) {
                if (msjE.MessagingPlatformKey.removeStart('whatsapp:').startsWith(cod)) {
                    codigoValido = true;
                }
            }

            if (!codigoValido) {
                msjE.addError('El telefono debe comenzar con un código de area válido.');
            }
        }
    }

    public static void validarCuentaPersonal (List<MessagingEndUser> msjEList) {
        List<ID> cuentasID = new List<ID>();

        for (MessagingEndUser msjE : msjEList) {
            cuentasID.add(msjE.AccountID);
        }

        Map<ID, Account> mapaCuentas = new Map<ID, Account>
            ([SELECT RecordType.DeveloperName
            FROM Account
            WHERE ID IN :cuentasID
            ]);

        for (MessagingEndUser msjE : msjEList) {
            if (String.isNotBlank(msjE.AccountID)) {
                if (mapaCuentas.get(msjE.AccountID).RecordType.DeveloperName != 'PersonAccount') {
                	msjE.addError('La cuenta asociada solo puede ser personal.');
            	}
            }
        }
    }

    public static void setearCuenta(List<MessagingEndUser> msjeList) {
        List<String> listadoNumeros = new List<String>();
        List<ID> cuentasID = new List<ID>();
        Map<String, List<Account>> cuentasPorNumTelefonico = new Map<String, List<Account>>();
        Map<ID, ID> contactoPorCuentaPersonal = new Map<ID, ID>();

        for (MessagingEndUser msjE : msjeList) {
            listadoNumeros.add(msjE.MessagingPlatformKey);
        }

        if (!listadoNumeros.isEmpty()) {
            for (Account acc : [SELECT ID, Phone 
                            FROM Account 
                            WHERE MessagingPlatformKey__c IN :listadoNumeros 
                                AND RecordType.DeveloperName = 'PersonAccount'
                            LIMIT 5000
                            ]){
                String telefono = acc.Phone;
                List<Account> accList;
                if(cuentasPorNumTelefonico.containsKey(telefono)) {
                    accList = cuentasPorNumTelefonico.get(telefono);
                } else {
                    accList = new List<Account>();
                }
    
                accList.add(acc);
                cuentasID.add(acc.Id);
                cuentasPorNumTelefonico.put(telefono, accList);
            }
        }


        for (Contact c : [SELECT ID, AccountID
                    FROM Contact 
                    WHERE IsPersonAccount = true 
                            AND AccountID IN :cuentasID]) {
            contactoPorCuentaPersonal.put(c.AccountID, c.ID);
        }

        for (MessagingEndUser msjE : msjeList) {
            String numero = msjE.MessagingPlatformKey.split('whatsapp:')[1];
                
            if (cuentasPorNumTelefonico.containsKey(numero)) {
                if(cuentasPorNumTelefonico.get(numero).size() == 1) {
                    msjE.AccountID = cuentasPorNumTelefonico.get(numero)[0].ID;
                    msje.ContactID = contactoPorCuentaPersonal.get(msjE.AccountID);
            	}    
            }
        }
    }
}