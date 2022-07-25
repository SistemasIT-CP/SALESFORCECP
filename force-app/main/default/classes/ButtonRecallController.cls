public with sharing class ButtonRecallController {
    @AuraEnabled
	public static void recall(ID identificacion, String tipoCuenta) { 
        if(tipoCuenta == 'Account') {
            Account acc = 
                [SELECT ID, CodigoCliente__c, Envio_correcto_a_WS__c
                FROM Account
                WHERE ID =: identificacion
                ];
            if(!acc.Envio_correcto_a_WS__c) {
                System.debug('Se envia a InsertarCliente');
                Database.executeBatch(new BatchWSClientes('1', new List<ID>{acc.ID}, null), 1);
            }
        } else {
            Contact cont =
                [SELECT Envio_correcto_a_WS__c
                FROM Contact
                WHERE ID =: identificacion
                ];

            if(!cont.Envio_correcto_a_WS__c) {
                System.debug('Entra en la condicion de contactos');
                Database.executeBatch(new BatchWSContactos('1', new List<String>{'Parent', 'All relation'}, new List<ID>{cont.ID}, null), 1);
            }
        }
    }

    @AuraEnabled
    public static Boolean yaHaSidoEnviado(ID identificacion, String tipoCuenta){
        List<Debug_log__c> debugLista = 
            [SELECT ID
             FROM Debug_log__c
             WHERE ID_Objeto__c =: '' + identificacion
             ];

        Boolean envioCorrecto;

        if(tipoCuenta == 'Account') {
            Account acc = 
                [SELECT Envio_correcto_a_WS__c
                FROM Account
                WHERE ID =: identificacion
                ];
            envioCorrecto = acc.Envio_correcto_a_WS__c;
        } else {
            Contact cont =
                [SELECT Envio_correcto_a_WS__c
                FROM Contact
                WHERE ID =: identificacion
                ];
            envioCorrecto = cont.Envio_correcto_a_WS__c;
        }

        System.debug(debugLista.size());
        System.debug(envioCorrecto);
        
        if (debugLista.isEmpty() && !envioCorrecto) {
            return false;
        } else {
            return true;
        }
    }

    @AuraEnabled
    public static String erroresNotificados(ID identificacion){
        
        List<Debug_log__c> debugLista = 
            [SELECT ID, Error__c
             FROM Debug_log__c
             WHERE ID_Objeto__c =: '' + identificacion
             ];

        if (!debugLista.isEmpty()) {
            if (debugLista[0].Error__c.contains('500')) {
                return 'Error en la comunicacion con el WS';
            } else {
                return debugLista[0].Error__c;
            }
        } else {
            return null;
        }
    }
}