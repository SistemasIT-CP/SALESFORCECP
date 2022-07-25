public without sharing class mostrarOportunidadHijo {
    public static final String etapaInicialAvaluo = 'Esperando Contacto';

    @AuraEnabled
    public static List<Vehiculo_de_la_Oportunidad__c> obtenerHijoAvaluo(String opportunityId) {
        List<Id> oppAvaluosId = new List<Id>();

        for (Opportunity oppAvaluos : [SELECT Id
                                        FROM Opportunity
                                        WHERE Oportunidad_original__c =: opportunityId
                                            AND StageName != 'Cerrada perdida'
                                            AND RecordType.DeveloperName = 'Avaluo'
                                        ]) {
            oppAvaluosId.add(oppAvaluos.Id);
        }

        List<Vehiculo_de_la_Oportunidad__c> vehiculoList = new List<Vehiculo_de_la_Oportunidad__c>();

        if (!oppAvaluosId.isEmpty()) {
            vehiculoList = [
                SELECT Vehiculo__c, Vehiculo__r.Marca__c, Vehiculo__r.Marca__r.Name,
                    Vehiculo__r.Modelo__c, Vehiculo__r.Modelo__r.Name,
                    Vehiculo__r.Placa__c, Oportunidad__c, Oportunidad__r.OwnerId,
                    Oportunidad__r.Owner.Name, Oportunidad__r.StageName
                FROM Vehiculo_de_la_Oportunidad__c
                WHERE Oportunidad__c IN :oppAvaluosId
            ];
        }

        return vehiculoList;
    }

    @AuraEnabled
    public static Map<String, String> obtenerMapaEtapas(){
        Map<String, String> colorPorEtapa = new Map<String, String>();
        
        for (Orden_de_etapas_por_recordType__mdt orden : [SELECT Label, Codigo_de_color__c 
                                                        FROM Orden_de_etapas_por_recordType__mdt
                                                        WHERE RecordType__c = 'Avaluo']) {
            colorPorEtapa.put(orden.Label, orden.Codigo_de_color__c);
        }

        return colorPorEtapa;
    }

    @AuraEnabled
    public static List<Map<String, List<String>>> obtenerUdcs(){
        List<Catalogo_UDC__c> marcasList = [
            SELECT Name
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Marcas' 
                AND Permitido_para_autolote__c = true
        ];

        List<Map<String, List<String>>> listaMapaUdc = new List<Map<String, List<String>>>();
        Map<String, List<String>> modelosPorMarcaMap = new Map<String, List<String>>();
        Map<String, List<String>> submodeloPorModeloMap = new Map<String, List<String>>();

        List<Id> marcasIdList = new List<Id>();

        for (Catalogo_UDC__c marca : marcasList) {
            marcasIdList.add(marca.Id);
        }

        if (!marcasIdList.isEmpty()) {
            List<Catalogo_UDC__c> modelosList = [
                SELECT Name, udc_padre__r.Name 
                FROM Catalogo_UDC__c
                WHERE RecordType.DeveloperName = 'Modelo' 
                    AND udc_padre__c IN :marcasIdList
                    AND Permitido_para_autolote__c = true
            ];

            List<Id> modelosIdList = new List<Id>();

            for (Catalogo_UDC__c modelo : modelosList) {
                modelosIdList.add(modelo.Id);
            }

            if (!modelosIdList.isEmpty()) {
                List<Catalogo_UDC__c> submodelosList = [
                    SELECT Name, udc_padre__r.Name 
                    FROM Catalogo_UDC__c
                    WHERE RecordType.DeveloperName = 'Submodelo' 
                        AND udc_padre__c IN :modelosIdList
                        AND Permitido_para_autolote__c = true
                ];

                for (Catalogo_UDC__c modelo : modelosList) {
                    List<String> modelosPorMarca;

                    if (modelosPorMarcaMap.containsKey(modelo.udc_padre__r.Name)) {
                        modelosPorMarca = modelosPorMarcaMap.get(modelo.udc_padre__r.Name);
                    } else {
                        modelosPorMarca = new List<String>();
                    }

                    modelosPorMarca.add(modelo.Name);

                    modelosPorMarcaMap.put(modelo.udc_padre__r.Name, modelosPorMarca);
                }

                for (Catalogo_UDC__c submodelo : submodelosList) {
                    List<String> submodelosPorModelo;

                    if (submodeloPorModeloMap.containsKey(submodelo.udc_padre__r.Name)) {
                        submodelosPorModelo = submodeloPorModeloMap.get(submodelo.udc_padre__r.Name);
                    } else {
                        submodelosPorModelo = new List<String>();
                    }

                    submodelosPorModelo.add(submodelo.Name);

                    submodeloPorModeloMap.put(submodelo.udc_padre__r.Name, submodelosPorModelo);
                }

                listaMapaUdc.add(modelosPorMarcaMap);   
                listaMapaUdc.add(submodeloPorModeloMap);
            }
        }

        return listaMapaUdc;
    }

    @AuraEnabled
    public static List<String> obtenerListaAnios(){
        List<String> anios = new List<String>();

        Schema.DescribeFieldResult f = Vehiculo__c.Anio_opcion__c.getDescribe();
		List<Schema.PicklistEntry> pickL = f.getPicklistValues();
        
		for (Schema.PicklistEntry pickV : pickL) {
            anios.add(pickV.getLabel());
		}     

        return anios;
    }

    @AuraEnabled
    public static String crearAvaluo(String opportunityId, String placa, String marca, String modelo, String submodelo, String anio, String kilometraje) {
        List<Vehiculo__c> vehiculoExistente = [
            SELECT Id
            FROM Vehiculo__c
            WHERE Placa__c =: placa
        ];

        if (vehiculoExistente.isEmpty()) {
            ID avaluoId = Schema.SObjectType.Opportunity
                    .getRecordTypeInfosByDeveloperName()
                    .get('Avaluo')
                    .getRecordTypeId();

            List<Catalogo_UDC__c> marcaList = [
                SELECT Id 
                FROM Catalogo_UDC__c 
                WHERE Name =: marca AND RecordType.DeveloperName = 'Marcas'
            ];
    
            List<Catalogo_UDC__c> modeloList = [
                SELECT Id 
                FROM Catalogo_UDC__c 
                WHERE Name =: modelo AND RecordType.DeveloperName = 'Modelo'
            ];
    
            List<Catalogo_UDC__c> subModeloList = [
                SELECT Id 
                FROM Catalogo_UDC__c 
                WHERE Name =: submodelo AND RecordType.DeveloperName = 'Submodelo'
            ];

            Opportunity opportunity = [
                SELECT Id, CloseDate, AccountId, Name, Sucursal__c
                FROM Opportunity
                WHERE Id =: opportunityId
                LIMIT 1
            ];

            Vehiculo__c veh = new Vehiculo__c();
            veh.Marca__c = marcaList[0].Id;
            veh.Modelo__c = modeloList[0].Id;
            veh.Submodelo__c = subModeloList[0].Id;
            veh.Placa__c = placa;
            veh.Cliente__c = opportunity.AccountId;
            veh.Anio_opcion__c = anio;
            veh.Kilometraje__c = kilometraje;
            veh.Estado__c = 'Pendiente';

            Database.SaveResult vehSr = Database.insert(veh, false);
            if (!vehSr.isSuccess()) {
                return vehSr.getErrors()[0].getMessage();
            }

            Opportunity oppHijo = new Opportunity();
            oppHijo.CloseDate = opportunity.CloseDate;
            oppHijo.Sucursal__c = opportunity.Sucursal__c;
            oppHijo.RecordTypeId = avaluoId;
            oppHijo.StageName = mostrarOportunidadHijo.etapaInicialAvaluo;
            oppHijo.AccountId = opportunity.AccountId;
            oppHijo.Name = 'AVALUO/' + opportunity.Name.split('/')[0];
            oppHijo.Oportunidad_original__c = opportunity.Id;

            Database.SaveResult oppHijoSr = Database.insert(oppHijo, false);
            if (!oppHijoSr.isSuccess()) {
                return oppHijoSr.getErrors()[0].getMessage();
            }

            Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
            vehOpp.Vehiculo__c = veh.Id;
            vehOpp.Oportunidad__c = oppHijo.Id;

            Database.SaveResult vehOppSr = Database.insert(vehOpp, false);
            if (!vehOppSr.isSuccess()) {
                return vehOppSr.getErrors()[0].getMessage();
            }
            
            return 'Ok';

        } else {
            return 'Ya existe un vehiculo con esa placa';
        }
    }

    @AuraEnabled
    public static String asociarVehiculoExistente(String opportunityId, String placa){
        ID avaluoId = Schema.SObjectType.Opportunity
                    .getRecordTypeInfosByDeveloperName()
                    .get('Avaluo')
                    .getRecordTypeId();

        Opportunity opportunity = [
            SELECT Id, CloseDate, AccountId, Name, Sucursal__c
            FROM Opportunity
            WHERE Id =: opportunityId
        ];

        List<Vehiculo__c> vehList = [
            SELECT Id
            FROM Vehiculo__c
            WHERE Placa__c =: placa
                AND (Estado__c = 'Pendiente' OR Estado__c = 'Vendido')
        ];

        if (vehList.isEmpty()) {
            return 'No existe vehiculo disponible con la placa indicada';
        }

        List<Vehiculo_de_la_Oportunidad__c> avaluosAbiertos = [
            SELECT Id, Oportunidad__r.Owner.Name
            FROM Vehiculo_de_la_Oportunidad__c
            WHERE Vehiculo__c =: vehList[0].Id
                AND Oportunidad__r.RecordType.DeveloperName = 'Avaluo'
                AND Oportunidad__r.StageName != 'Cerrada ganada'
                AND Oportunidad__r.StageName != 'Cerrada perdida'
        ];

        if (!avaluosAbiertos.isEmpty()) {
            return 'Este vehiculo es parte de un proceso llevado por ' + avaluosAbiertos[0].Oportunidad__r.Owner.Name + ', con lo cual no puede ser asociado.';
        }

        Opportunity oppHijo = new Opportunity();
        oppHijo.CloseDate = opportunity.CloseDate;
        oppHijo.RecordTypeId = avaluoId;
        oppHijo.Sucursal__c = opportunity.Sucursal__c;
        oppHijo.StageName = mostrarOportunidadHijo.etapaInicialAvaluo;
        oppHijo.AccountId = opportunity.AccountId;
        oppHijo.Name = 'AVALUO/' + opportunity.Name.split('/')[0];
        oppHijo.Oportunidad_original__c = opportunity.Id;

        Database.SaveResult oppHijoSr = Database.insert(oppHijo, false);
        if (!oppHijoSr.isSuccess()) {
            return oppHijoSr.getErrors()[0].getMessage();
        }

        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Vehiculo__c = vehList[0].Id;
        vehOpp.Oportunidad__c = oppHijo.Id;

        Database.SaveResult vehOppSr = Database.insert(vehOpp, false);
        if (!vehOppSr.isSuccess()) {
            return vehOppSr.getErrors()[0].getMessage();
        }
        
        return 'Ok';
    }
}