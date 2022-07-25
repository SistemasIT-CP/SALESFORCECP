global class BatchCallWSGetFacturasDetalleDiaList implements Database.Batchable<sObject>,  Database.AllowsCallouts, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext Bc){
        if(test.isRunningTest()){
            return Database.getQueryLocator(
                			[SELECT Name, productCode__c 
                             FROM Catalogo_UDC__c 
                             WHERE RecordTypeId in (SELECT Id 
                                                    FROM RecordType 
                                                    WHERE DeveloperName = 'Lineas_de_negocio') 
                             		AND productCode__c = '01' 
                             LIMIT 1 
                            ]);
        } else {
            return Database.getQueryLocator(
                			[SELECT Name, productCode__c 
                             FROM Catalogo_UDC__c 
                             WHERE RecordTypeId in (SELECT Id 
                                                    FROM RecordType 
                                                    WHERE DeveloperName = 'Lineas_de_negocio') 
                             		AND productCode__c != '' 
                             		AND productCode__c != null
                            ]);
        }
    }

    global void execute(Database.BatchableContext Bc, List<Catalogo_UDC__c> UDCList){
        System.debug('INICIA BATCH CON LINEA : ' + UDCList[0].productCode__c);
        ProcesaWSGetFacturasDetalleDiaList.GetFacturasDetalleDiaList(UDCList[0].productCode__c);
    }
    
    global void finish(Database.BatchableContext Bc){}
    
}