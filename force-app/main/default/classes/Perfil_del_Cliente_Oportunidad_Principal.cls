public without sharing class Perfil_del_Cliente_Oportunidad_Principal {
    @AuraEnabled
    public static List<String> getAccountId(Id recordId) {
        
        List<String> retorno = new List<String>();
        Opportunity oportunidad = 
            [SELECT ID, AccountId  
			FROM Opportunity 
            WHERE ID =: recordId 
            LIMIT 1
            ];
                
        String cuentaId = String.valueOf(oportunidad.AccountId);
        
        Account acc = 
            [SELECT ID, Name, RecordType.Name 
            FROM Account 
            WHERE ID =: cuentaId 
            LIMIT 1
            ];
        
        String nombre_cuenta = acc.Name;
        String tipo_cuenta = acc.RecordType.Name;
        
		retorno.add(cuentaId);
        retorno.add(nombre_cuenta);
        retorno.add(tipo_cuenta);
        
        return retorno;
    }

    @AuraEnabled
    public static String getComentario(Id recordId) {
        
        Opportunity oportunidad = 
            [SELECT ID, Comentario_del_PIC__c  
			FROM Opportunity 
            WHERE ID =: recordId 
            LIMIT 1
            ];
        
        return oportunidad.Comentario_del_PIC__c;
    }

    @AuraEnabled
    public static String setComentario(Id recordId, String comentario) {
        
        Opportunity oportunidad = 
            [SELECT ID, Comentario_del_PIC__c  
			FROM Opportunity 
            WHERE ID =: recordId 
            LIMIT 1
            ];

        oportunidad.Comentario_del_PIC__c = comentario;

        Database.SaveResult sr = Database.update(oportunidad, false);

        if (sr.isSuccess()) {
            return 'Bien';
        } else {
            return sr.getErrors()[0].getMessage();
        }
    }
}