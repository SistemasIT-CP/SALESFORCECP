public class InsertarPersonasListaNegra {
    public static void insertRecords () {
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        List<String> aliasList = readXML();      
        System.debug('alias en XML: ' + aliasList.size());
        
        List<Personas_en_lista_negra__mdt> registrosCreados = [
            SELECT Id, Alias__c, Identificador__c 
            FROM Personas_en_lista_negra__mdt
            ORDER BY Identificador__c DESC
        ];
        
        List<String> developerMetadata = new List<String>();
        
        for(Personas_en_lista_negra__mdt persona: registrosCreados){
            developerMetadata.add(persona.Alias__c);
        }
        
        System.debug('cantidad existente: ' + developerMetadata.size());
        
        Integer i = 1;
        
        if (!registrosCreados.isEmpty()) {
        	i = Integer.valueOf(registrosCreados[0].Identificador__c) + 1;
        }
       
        for (String alias : aliasList) {
			if(!developerMetadata.contains(alias)) {
                Metadata.CustomMetadata record = createRecord(alias, i);
                mdContainer.addMetadata(record);
                i++;
            }
        }
        
        if(!mdContainer.getMetadata().isEmpty()) {
			CustomMetadataCallback callback = new CustomMetadataCallback();
            String jobId = Test.isRunningTest() ? '7073k0000AatPhx' : Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }
    }
    
    public static List<String> readXML () {
        List<String> aliasList = new List<String>();
        StaticResource sr = 
            [SELECT Id, Body 
             FROM StaticResource 
             WHERE Name = 'Lista_Negra' 
             LIMIT 1];
        
        String xml = sr.Body.toString();
        Dom.Document doc = new Dom.Document();  
        doc.load( xml );  
        Dom.XMLNode rootElement = doc.getRootElement();  
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ) { 
                String unformattedName = '';
                for (Dom.XMLNode secondChild : detailElement.getChildElements()) {
                    if (secondChild.getName().contains('NAME') && secondChild.getName() != 'NAME_ORIGINAL_SCRIPT') {
                        unformattedName += secondChild.getText().toUpperCase() + ' ';
                    }
                }
                String name = '';
                for (String str : unformattedName.trim().split('\\s+')) {
                	name += str + ' ';    
                }
                aliasList.add(name.trim());  
            }
        }
        
        return aliasList;
    }
    
    public static Metadata.CustomMetadata createRecord(String alias, Integer valor) {
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        
        customMetadata.fullName = 'Personas_en_lista_negra__mdt.a' + valor;
        customMetadata.label = '' + valor;
        
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Alias__c';
        customField.value = alias;
        customMetadata.values.add(customField);
        
        customField = new Metadata.CustomMetadataValue();
        customField.field = 'Identificador__c';
        customField.value = '' + valor;
        customMetadata.values.add(customField);
        
        return customMetadata;
    }
    
    public static MetadataService.MetadataPort createService(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        
        return service;
    }
}