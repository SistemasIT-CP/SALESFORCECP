public class BatchToLead implements Database.Batchable<sObject>,  Database.AllowsCallouts{
    public String query;
    public List<String> accID;
    public List<String> conID;
    public Map<String, String> contactoIdPorCuentaId;
    public Map<String, String> cargoPorCuentaId;
    public Map<ID, String> mapaEmail;
    
    public BatchToLead(){
        
    }

    public BatchToLead (List<String> leadKeyCode, Map<ID, String> accMailByID) {
        List<String> cuentasID = new List<String>();
        List<String> contactosID = new List<String>();
        Map<String, String> mapaContactosCuentas = new Map<String, String>();
        Map<String, String> mapaCargosCuentas = new Map<String, String>();

        for (String keyLead : leadKeyCode) {
            List<String> idLeads = keyLead.split('_');
            
            cuentasID.add(idLeads[0]);
            contactosID.add(idLeads[1]);

            if (idLeads.size() == 3) {
                mapaCargosCuentas.put(idLeads[0], idLeads[2]);
            }

            mapaContactosCuentas.put(idLeads[0], idLeads[1]);
        }

        this.contactoIdPorCuentaId = mapaContactosCuentas;
        this.cargoPorCuentaId = mapaCargosCuentas;
        this.accID = cuentasID;
        this.conID = contactosID;
        this.query = 'SELECT ID, C_rdobas__c, Phone, Tipo_de_t_lefono__c, Cedula__c, Name, Email__c, Inactividad__c, CodigoCliente__c, Envio_correcto_a_WS__c, RecordTypeID, Genero_UDC__pc FROM Account WHERE ID IN :accID';
        this.mapaEmail = accMailByID;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }

    public void execute(Database.BatchableContext Bc, List<Account> scope){
        ID errorId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Error')
                                .getRecordTypeId();

        List<Account> cuentasNuevas = new List<Account>();
        Map<String, List<Debug_log__c>> debugListByID = new Map<String, List<Debug_log__c>>();
        Map<ID, List<String>> respWSByID = new Map<ID, List<String>>();
        List<Debug_log__c> debugToUpsert = new List<Debug_log__c>();
        List<Debug_log__c> debugToDelete = new List<Debug_log__c>();
        List<ID> idCuentasActualizables = new List<ID>();
        List<Account> cuentasActualizables = new List<Account>();

        Map<ID, Contact> contToDelete = new Map<Id, Contact>(
            [SELECT ID, LastName, Name
            FROM Contact
            WHERE ID IN :conID
            ]);

        for (Account acc : scope) {
            if (String.isBlank(acc.CodigoCliente__c)) {
                List<String> respListAcc = CallWS_ClientesBookManager.InsertarCliente(acc.ID, '1');
                respWSByID.put(acc.ID, respListAcc);

                if(respListAcc[0] == '500') {
                    List<Debug_log__c> debugLista = new List<Debug_log__c>();
                    debugListByID.put('' + acc.ID, debugLista);
                } else if(respListAcc[0] == '200') {
                    cuentasNuevas.add(acc);
                }
            }
        }
                
        for (Account acc : cuentasNuevas) {
            List<String> rp = respWSByID.get(acc.ID);
            String codigoCliente;
            if (rp.size() > 1) {
                codigoCliente = rp[1];
            }
            
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
        
        for (Debug_log__c dl : [SELECT Error__c, Horario__c, ID_Objeto__c, Objeto__c, XML__c 
                                FROM Debug_log__c 
                                WHERE ID_Objeto__c IN :debugListByID.keySet()]) {
            
                List<Debug_log__c> debugList = debugListByID.get(dl.ID_Objeto__c);
                debugList.add(dl);
                debugListByID.put(dl.ID_Objeto__c, debugList);
        }
        
        for (Account acc : cuentasNuevas) {
            List<String> rp = respWSByID.get(acc.ID);
             
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
                idCuentasActualizables.add(acc.ID);

                if (debugList != null && !debugList.isEmpty()) {
                    debugToDelete.addAll(debugList);
                }
            }
        }
        
        for (Account acc : [SELECT ID, Email__c, Envio_correcto_a_WS__c, CodigoCliente__c FROM Account WHERE ID IN :idCuentasActualizables]) {
            List<String> rp = respWSByID.get(acc.ID);
            acc.Envio_correcto_a_WS__c = true;
            acc.Email__c = mapaEmail.get(acc.ID);

            if (rp.size() > 1) {
                acc.CodigoCliente__c = rp[1];
            }
            
            cuentasActualizables.add(acc);
        }

        if (!debugToUpsert.isEmpty()) {
            upsert debugToUpsert;
        }

        if (!debugToDelete.isEmpty()) {
            delete debugToDelete;
        }

        if (!cuentasActualizables.isEmpty()) {
            update cuentasActualizables;
        }

        if (!contToDelete.keySet().isEmpty()) {
            System.debug('SE ELIMINARAN ' + contToDelete.keySet().size() + ' CONTACTOS CONVERTIDOS DE LEADS');
            delete new List<Contact>(contToDelete.values());
        }
    }
    
    public void finish(Database.BatchableContext Bc){
    }
}