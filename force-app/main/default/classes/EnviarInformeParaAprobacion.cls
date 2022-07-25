public class EnviarInformeParaAprobacion { 
    @AuraEnabled
    public static String enviarReporte(ID informeID) {
        List<Approval.ProcessSubmitRequest> aprobacionesList = new List<Approval.ProcessSubmitRequest>();

        Informe_de_Negociaci_n__c inf = 
            [SELECT Monto_total_del_informe__c, Estado__c, Marca_Oportunidad__c, Oportunidad__r.RecordType.DeveloperName,
                    Oportunidad__r.Owner.Sucursal__c, Oportunidad__r.OwnerId, Producto__c, total_negociado__c, Texto_Bandera__c,
                    Oportunidad__r.ModeloVehiculo__r.description1__c
            FROM Informe_de_Negociaci_n__c
            WHERE ID =: informeID
            LIMIT 1
            ];
                
        if (inf.Estado__c == 'Aprobado') {
            return 'Aprobado';
        }
        
        if (inf.Monto_total_del_informe__c != 0) {
            return 'Pendiente';
        }

        List<PricebookEntry> precioMinimo = [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2.Name = 'Precio mínimo' AND Product2Id =: inf.Producto__c
        ];

        Boolean actualizar = false;

        if (inf.Oportunidad__r.RecordType.DeveloperName == 'Principal_Motos') {
            String tipoVehiculo = '';

            if (inf.Oportunidad__r.ModeloVehiculo__r.description1__c.contains('MOTORES MARINOS')) {
                tipoVehiculo = 'Motores marinos';
            } else {
                tipoVehiculo = 'Motocicletas';
            }

            if (!precioMinimo.isEmpty() && inf.total_negociado__c < precioMinimo[0].UnitPrice) {
                inf.Texto_Bandera__c = 'Aprobacion - Precio invalido';
                update inf;

                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(informeID);
                aprobacionesList.add(req);
 
            } else {
                Set<String> aprobadoresName = new Set<String>();
                List<ID> aprobadoresList = new List<ID>();    
                User vendedor = [
                    SELECT ID, Aprobador_de_motos__r.Name, Aprobador_de_motos__c
                    FROM User 
                    WHERE ID =: inf.Oportunidad__r.OwnerId
                ];

                if (String.isNotBlank(vendedor.Aprobador_de_motos__c)) {
                    aprobadoresName.add(vendedor.Aprobador_de_motos__r.Name);
                }

                for (Aprobador_por_Sucursal__mdt apr : [SELECT Nombre_del_aprobador__c
                                                        FROM Aprobador_por_Sucursal__mdt 
                                                        WHERE Sucursal__c =: inf.Oportunidad__r.Owner.Sucursal__c 
                                                        	AND (Tipo_de_vehiculo__c =: tipoVehiculo 
                                                                 	OR Tipo_de_vehiculo__c = 'Todos')
                                                        ]) {
                    aprobadoresName.add(apr.Nombre_del_aprobador__c);
                }

                for (User u : [SELECT ID 
                                FROM User 
                                WHERE Name IN :aprobadoresName
                                ]) {
                    aprobadoresList.add(u.ID);
                }

                for (ID aproID : aprobadoresList) {
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setObjectId(informeID);
                    req.setNextApproverIds(new List<ID>{aproID});
                    
                    aprobacionesList.add(req);
                }
            }

        } else {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(informeID);
            aprobacionesList.add(req);
        }

        if (String.isBlank(inf.Texto_Bandera__c)) {
            inf.Texto_Bandera__c = 'Aprobacion';
            update inf;
        }

        Boolean error = false;
        String errList = 'Error: ';

        if(!aprobacionesList.isEmpty()) {
            try{
                List<Approval.ProcessResult> aprList = Approval.process(aprobacionesList);

                for (Approval.ProcessResult apr : aprList) {
                    if (!apr.isSuccess()) {
                        error = true;
                        errList += apr.getErrors()[0].getMessage();
                    }
                }
            } catch (DmlException e) {
                error = true;
                if (e.getMessage().contains('NO_APPLICABLE_PROCESS')) {
                    errList += 'No hay procesos de aprobación aplicables.';
                } else if (e.getMessage().contains('ALREADY_IN_PROCESS')) {
                    errList +='El registro ya está en un proceso de aprobación.';
                }
            }
        }
        
        if(!error) {
            return 'Ok';
        } else {
            inf.Texto_Bandera__c = '';
            update inf;

            return errList;
        }
    }
}