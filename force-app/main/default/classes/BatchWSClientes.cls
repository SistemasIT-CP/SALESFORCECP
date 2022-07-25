public class BatchWSClientes implements Database.Batchable<sObject>,  Database.AllowsCallouts{
    public String actionTypeAcc;
    public String query;
    public List<ID> idList;
    public Map<ID, Account> oldAccMap;
    
    public BatchWSClientes(){
        
    }

    public BatchWSClientes (String actionType, List<ID> idList, Map<ID, Account> oldAccMap) {
        this.actionTypeAcc = actionType;
        this.query = 'SELECT ID, C_rdobas__c, Phone, Tipo_de_t_lefono__c, Cedula__c, Name, Email__c, Inactividad__c, CodigoCliente__c, Envio_correcto_a_WS__c, RecordTypeID, Genero_UDC__pc FROM Account WHERE ID IN :idList';
        if (actionType == '3') {
            this.query += ' ALL ROWS';
        }
        this.idList = idList;
        this.oldAccMap = oldAccMap;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }

    public void execute(Database.BatchableContext Bc, List<Account> scope){
        if (actionTypeAcc != null) {
            ID personAccountID = Schema.SObjectType.Account
                            .getRecordTypeInfosByDeveloperName()
                            .get('PersonAccount')
                            .getRecordTypeId();

            ID errorId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Error')
                                .getRecordTypeId();
            
            Map<ID, Account> scopeMap = new Map<ID, Account>(scope);
            List<ID> ppAccID = new List<ID>();
            List<Account> accJur = new List<Account>();
            Map<String, List<Debug_log__c>> debugListByID = new Map<String, List<Debug_log__c>>();
            Map<String, List<Debug_log__c>> debugListByPadreID = new Map<String, List<Debug_log__c>>();
            List<Account> monedaAcc = new List<Account>();
            List<Account> inactivoAcc = new List<Account>();
            List<Account> creditoAcc = new List<Account>();
            Map<ID, List<String>> respWSByID = new Map<ID, List<String>>();
            List<Debug_log__c> debugToUpsert = new List<Debug_log__c>();
            List<Debug_log__c> debugToDelete = new List<Debug_log__c>();
            List<ID> accToUpdate = new List<ID>();
            List<Contact> contToUpdate = new List<Contact>();
            List<Account> acToUpdate = new List<Account>();
    
            for (Account acc : scope) {
                System.debug('LLAMO AL WS DE BOOK MANAGER');
                List<String> respListAcc;
                if(String.isNotBlank(actionTypeAcc)) {
                    respListAcc = CallWS_ClientesBookManager.InsertarCliente(acc.ID, 
                                                                            actionTypeAcc);
                    
                    respWSByID.put(acc.ID, respListAcc);
    
                    if(respListAcc[0] == '500') {
                        List<Debug_log__c> debugLista = new List<Debug_log__c>();
                        debugListByID.put('' + acc.ID, debugLista);
                    }
                
                    if(respListAcc[0] == '200') {
                        if (acc.RecordTypeId == personAccountID) {
                            if (actionTypeAcc == '1') {
                                ppAccID.add(acc.ID);
                            } else if (actionTypeAcc == '2') {
                                if (String.isNotBlank(acc.CodigoCliente__c) && acc.Envio_correcto_a_WS__c) {
                                    ppAccID.add(acc.ID);
                                }
                            }
                        } else {
                            if (actionTypeAcc == '1') {
                                accJur.add(acc);
                            } else if (actionTypeAcc == '2') {
                                if (String.isNotBlank(acc.CodigoCliente__c) && acc.Envio_correcto_a_WS__c) {
                                    accJur.add(acc);
                                }
                            }
                        } 
                    }
                }
            }
                    
            for (Account acc : accJur) {
                List<String> rp = respWSByID.get(acc.ID);
                String codigoCliente;
                if (actionTypeAcc == '1' && rp.size() > 1) {
                    codigoCliente = rp[1];
                } else {
                    codigoCliente = acc.CodigoCliente__c;
                }
                
                System.debug('LLAMO AL WS DE CONTACTO PARA LA CUENTA ' + codigoCliente);
                
                List<String> respListAcc = CallWS_ClientesBookManager.InsertarContacto(acc.ID, 
                                                            '2', 
                                                            '0', 
                                                            '0', 
                                                            '0', 
                                                            'CUENTA', 
                                                            new List<String> { 'Only relation', codigoCliente + '_0' });
    
                if(respListAcc[0] == '500') {
                    List<Debug_log__c> debugList = new List<Debug_log__c>();
                    debugListByID.put('' + acc.ID, debugList);
                }
            }
    
            for (Contact c : [SELECT ID, AccountID
                            FROM Contact 
                            WHERE IsPersonAccount = true 
                                    AND AccountID IN :ppAccID]) {
 
                List<String> rp = respWSByID.get(c.AccountID);
                String codigoCliente;
                if (actionTypeAcc == '1' && rp.size() > 1) {
                    codigoCliente = rp[1];
                } else {
                    codigoCliente = scopeMap.get(c.AccountID).CodigoCliente__c;
                }
    
                System.debug('LLAMO AL WS DE CONTACTO PARA LA CUENTA PERSONAL ' + codigoCliente);                                    
    			
				List<String> criterios = new List<String>{ 'Only relation', codigoCliente + '_0' };
                
                if (actionTypeAcc == '2') {
                    criterios.add('All relation');
                }
                                        
                List<String> respListCont = CallWS_ClientesBookManager.InsertarContacto(c.ID, 
                                                            '2', 
                                                            '0', 
                                                            '0', 
                                                            '0', 
                                                            'CONTACTO', 
                                                            criterios );
                                        
                respWSByID.put(c.ID, respListCont);
                
                if(respListCont[0] == '500') {
                    List<Debug_log__c> debugLista = new List<Debug_log__c>();
                    debugListByID.put('' + c.ID, debugLista);
                }
            }
            
            for (Debug_log__c dl : [SELECT Error__c, Horario__c, ID_Objeto__c, Objeto__c, XML__c 
                                    FROM Debug_log__c 
                                    WHERE ID_Objeto__c IN :debugListByID.keySet()]) {
                
                    List<Debug_log__c> debugList = debugListByID.get(dl.ID_Objeto__c);
                	debugList.add(dl);
                	debugListByID.put(dl.ID_Objeto__c, debugList);
            }
            
            if(String.isNotBlank(actionTypeAcc)) {
                for (Account acc : scope) {
                    List<String> rp = respWSByID.get(acc.ID);
                    //La respuesta si es erronea está compuesta por: codigo, error, horario, idObj, tipoObj y xml (si fuera error de ws)
                    
                    if(rp != null && actionTypeAcc != '3') {
                        List<Debug_log__c> debugList = debugListByID.get('' + acc.ID);
                        if(rp[0] == '500') {
                            Debug_log__c dl = new Debug_log__c();
                            dl.Error__c = rp[1];
                            dl.Horario__c = rp[2];
                            dl.ID_Objeto__c = rp[3];
                            dl.Objeto__c = rp[4];
                            dl.RecordTypeId = errorId;
                            if (rp.size() > 5) {
                                dl.XML__c = rp[5];   
                            }
                            
                            debugToUpsert.add(dl);
                        } else if(rp[0] == '200') {
                            accToUpdate.add(acc.ID);
        
                            if (debugList != null && !debugList.isEmpty()) {
                                debugToDelete.addAll(debugList);
                            }
                        }
                    }
                    
                    if (actionTypeAcc == '3') {
                        List<Debug_log__c> debugList = debugListByPadreID.get('' + acc.ID);
                        if (debugList != null && !debugList.isEmpty()) {
                            debugToDelete.addAll(debugList);
                        }
                    }
                }
            }
            
            for (Contact c : [SELECT ID, Envio_correcto_a_WS__c
                            FROM Contact 
                            WHERE IsPersonAccount = true 
                                    AND AccountID IN :ppAccID]) {
                List<String> rpCon = respWSByID.get(c.ID);
                if(rpCon != null) {
                    List<Debug_log__c> debugList = debugListByID.get('' + c.ID);
                    //La respuesta si es erronea está compuesta por: codigo, error, horario, idObj, tipoObj y xml (si fuera error de ws)
                    
                    if(rpCon[0] == '500') {
                        Debug_log__c dl = new Debug_log__c();
                        dl.Error__c = rpCon[1];
                        dl.Horario__c = rpCon[2];
                        dl.ID_Objeto__c = rpCon[3];
                        dl.Objeto__c = rpCon[4];
                        if (rpCon.size() > 5) {
                            dl.XML__c = rpCon[5];   
                        }
                        
                        debugToUpsert.add(dl);
                    } else if(rpCon[0] == '200') {
                        c.Envio_correcto_a_WS__c = true;
    
                        contToUpdate.add(c);
    
                        if (debugList != null && !debugList.isEmpty()) {
                            debugToDelete.addAll(debugList);
                        }
                    }
                }
            }
    
            for (Account acc : scope) {
                List<String> rp = respWSByID.get(acc.ID);
                if (rp[0] == '200') {
                    if (actionTypeAcc == '2') {
                        if (acc.C_rdobas__c != oldAccMap.get(acc.ID).C_rdobas__c) {
                            monedaAcc.add(acc);
                        }
    
                        if (acc.Inactividad__c != oldAccMap.get(acc.ID).Inactividad__c) {
                            inactivoAcc.add(acc);
                        }
                    }
                    
                    if (actionTypeAcc == '1') {
                        if (acc.C_rdobas__c) {
                            monedaAcc.add(acc);
                        }   
    
                        if (acc.Inactividad__c) {
                            inactivoAcc.add(acc);
                        }
                         creditoAcc.add(acc);
                    }
                    
                    
                }
            }
    
            for (Account acc : monedaAcc) {
                List<String> rp = respWSByID.get(acc.ID);
                String codigoCliente;
                if (actionTypeAcc == '1' && rp.size() > 1) {
                    codigoCliente = rp[1];
                } else {
                    codigoCliente = scopeMap.get(acc.ID).CodigoCliente__c;
                }
                System.debug('LLAMO AL WS DE MONEDA PARA LA CUENTA ' + codigoCliente);
                if (String.isNotBlank(codigoCliente)) {
                    CallWSGuardarMonedaCliente.guardaMonedaCliente(codigoCliente, '' + acc.C_rdobas__c);
                }
            }
    
            for (Account acc : inactivoAcc) {
                List<String> rp = respWSByID.get(acc.ID);
                String codigoCliente;
                if (actionTypeAcc == '1' && rp.size() > 1) {
                    codigoCliente = rp[1];
                } else {
                    codigoCliente = scopeMap.get(acc.ID).CodigoCliente__c;
                }
                System.debug('LLAMO AL WS DE INACTIVIDAD PARA LA CUENTA ' + codigoCliente);
                if (String.isNotBlank(codigoCliente)) {
                    CallWSInactivarActivarCliente.inactivarActivarClientes(codigoCliente, '' +  !acc.Inactividad__c);
                }
            }
            
             for (Account acc : creditoAcc) {
                List<String> rp = respWSByID.get(acc.ID);
                String codigoCliente;
                 
                if (actionTypeAcc == '1' && rp.size() > 1) {
                    codigoCliente = rp[1];
                } else {
                    codigoCliente = scopeMap.get(acc.ID).CodigoCliente__c;
                }
                System.debug('LLAMO AL WS DE INSERTAR CLIENTE PARA CREDITO PARA LA CUENTA ' + codigoCliente);
                if (String.isNotBlank(codigoCliente)) {
                    CallWSGuardarClienteCredito.guardarClienteCredito(codigoCliente);
                }
            }
            
            for (Account acc : [SELECT ID, Envio_correcto_a_WS__c, CodigoCliente__c FROM Account WHERE ID IN :accToUpdate]) {
                List<String> rp = respWSByID.get(acc.ID);
                acc.Envio_correcto_a_WS__c = true;
    
                if (rp.size() > 1) {
                    acc.CodigoCliente__c = rp[1];
                }
                
                acToUpdate.add(acc);
            }
    
            if (!debugToUpsert.isEmpty()) {
                upsert debugToUpsert;
            }
    
            if (!debugToDelete.isEmpty()) {
                delete debugToDelete;
            }
    
            if (!acToUpdate.isEmpty()) {
                update acToUpdate;
            }
    
            if (!contToUpdate.isEmpty()) {
                update contToUpdate;
            }
        }
    }
    
    public void finish(Database.BatchableContext Bc){
    }
}