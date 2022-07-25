public class BatchWSContactos implements Database.Batchable<sObject>,  Database.AllowsCallouts{
	public String actionTypeAcc;
    public String query;
    public List<ID> idList;
    public Map<ID, Contact> oldConMap;
    public List<String> criterios;
    
    public BatchWSContactos (String actionType, List<String> criterios, List<ID> idList, Map<ID, Contact> oldConMap) {
        this.actionTypeAcc = actionType;
        this.criterios = criterios;
        this.query = 'SELECT ID, Envio_correcto_a_WS__c FROM Contact WHERE ID IN :idList';
        if (actionType == '3') {
            query += ' ALL ROWS';
        }
        this.idList = idList;
        this.oldConMap = oldConMap;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }

    public void execute(Database.BatchableContext Bc, List<Contact> scope){
        if (actionTypeAcc != null) {
            ID errorId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Error')
                                .getRecordTypeId();

            Map<ID, List<Debug_log__c>> debugListByID = new Map<ID, List<Debug_log__c>>();
            Map<ID, List<String>> respWSByID = new Map<ID, List<String>>();
            List<Debug_log__c> debugToUpsert = new List<Debug_log__c>();
            List<Debug_log__c> debugToDelete = new List<Debug_log__c>();
            List<Contact> contToUpdate = new List<Contact>();
    
            for (Contact con : scope) {
                System.debug('LLAMO AL WS DE BOOK MANAGER PARA CONTACTOS');
                List<String> response = CallWS_ClientesBookManager.InsertarContacto(
                                                                                con.ID, 
                                                                                actionTypeAcc, 
                                                                                '0', 
                                                                                '0', 
                                                                                '0', 
                                                                                'CONTACTO', 
                                                                                criterios);
                
                respWSByID.put(con.ID, response);
                
                if(response[0] == '500') {
                    List<Debug_log__c> debugLista = new List<Debug_log__c>();
                    debugListByID.put('' + con.ID, debugLista);
                }
            }
    
            for (Debug_log__c dl : [SELECT Error__c, Horario__c, ID_Objeto__c, Objeto__c, XML__c 
                                        FROM Debug_log__c 
                                        WHERE ID_Objeto__c IN: debugListByID.keySet()]) {
                List<Debug_log__c> debugList = debugListByID.get(dl.ID_Objeto__c);
                debugList.add(dl);
                debugListByID.put(dl.ID_Objeto__c, debugList);
            }
    
            for (Contact con : scope) {
                List<String> rp = respWSByID.get(con.ID);
                //La respuesta si es erronea está compuesta por: codigo, error, horario, idObj, tipoObj y xml (si fuera error de ws)
                
                if(rp != null && actionTypeAcc != '3') {
                    List<Debug_log__c> debugList = debugListByID.get(con.ID);
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
                        con.Envio_correcto_a_WS__c = true;
    
                        contToUpdate.add(con);
    
                        if (debugList != null && !debugList.isEmpty()) {
                            debugToDelete.addAll(debugList);
                        }
                    }
                }
            }
            
            if (!debugToUpsert.isEmpty()) {
                upsert debugToUpsert;
            }
    
            if (!debugToDelete.isEmpty()) {
                delete debugToDelete;
            }
    
            if (!contToUpdate.isEmpty()) {
                update contToUpdate;
            }
        }
    }
    
    public void finish(Database.BatchableContext Bc){
    }
}