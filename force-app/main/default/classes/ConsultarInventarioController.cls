public without sharing class ConsultarInventarioController {
    
    @AuraEnabled
    public static String consultarInventario(Id oppId) {
        List<Id> vehIdList = new List<Id>();
        List<String> chasisVehList = new List<String>();
        List<String> chasisList = new List<String>();

        String casaPellas = [
            SELECT productCode__c
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Companias'
                AND Name = 'CASA PELLAS, S.A'
        ].productCode__c;

        String autolote = [
            SELECT productCode__c
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Lineas_de_negocio'
                AND Name = 'Autos Usados'
        ].productCode__c;

        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Oportunidad__c, Vehiculo__r.Chasis__c
                                                    FROM Vehiculo_de_la_Oportunidad__c 
                                                    WHERE Oportunidad__c =: oppId]) {
            chasisVehList.add(vehOpp.Vehiculo__r.Chasis__c);
        }

        for (WS_InventorySearchList.Inventory inventory : WS_InventorySearchList.getInventario(casaPellas, autolote, '', '', 'true')) {
            chasisList.add(inventory.chasis.toUpperCase());
        }

        if (chasisVehList.isEmpty()) {
            return 'La oportunidad debe tener vehiculos asociados para hacer la consulta.';
        }

        String chasisNoIncluidos = '';
        for (String chasis : chasisVehList) {
            if (!chasisList.contains(chasis.toUpperCase())) {
                chasisNoIncluidos =+ chasis + ', ';
            }
        }

        if (String.isNotBlank(chasisNoIncluidos)) {
            chasisNoIncluidos = chasisNoIncluidos.removeEnd(', ');
            return 'Los siguientes chasis no estan ingresados en el inventario: ' + chasisNoIncluidos;
        }

        Opportunity opp = [
            SELECT Permite_ganar_oportunidad__c
            FROM Opportunity
            WHERE Id =: oppId
        ];

        opp.Permite_ganar_oportunidad__c = true;
        Database.SaveResult sr = Database.update(opp, false);

        if (!sr.isSuccess()) {
            return sr.getErrors()[0].getMessage();
        }

        return 'Ok. Todos los vehiculos se encuentran ingresados correctamente en el inventario, puede cerrar la oportunidad.';
    }
}