public without sharing class OpportunityHelper {
    public static void aprobacionListaNegra(List<Opportunity> oppList) {
        Map<ID, String> nombresMap = new Map<ID, String>();
        Set<ID> accountIDList = CasaPellasUtils.getFieldId(oppList, 'AccountId');

        for (Account acc : [SELECT ID, Name FROM Account WHERE ID IN :accountIDList]) {
            nombresMap.put(acc.ID, acc.Name);
        }

        for (Opportunity opp : oppList) {
            String nombre = nombresMap.get(opp.AccountID);

            if (opp.Oportunidad_inactiva__c == 'Aprobacion') {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('La cuenta ' + nombre + ' puede estar presente en la lista negra.' + 
                                '\n ¿Desea permitir la oportunidad?');
                req.setObjectId(opp.ID);
                Approval.ProcessResult processResult = Approval.process(req);
            }
        }
    }

    public static void setearCompaniaYLinea(List<Opportunity> oppList) {
        Id principalAutoloteId = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autolote')
                            .getRecordTypeId();

        Id principalAutosID = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Autos')
                            .getRecordTypeId();

        Id principalMotosID = Schema.SObjectType.Opportunity
                            .getRecordTypeInfosByDeveloperName()
                            .get('Principal_Motos')
                            .getRecordTypeId();

        Map<String, Catalogo_UDC__c> companiaPorMarca = new Map<String, Catalogo_UDC__c>();
        Map<String, Catalogo_UDC__c> lineaPorMarca = new Map<String, Catalogo_UDC__c>();
        Map<ID, Catalogo_UDC__c> mapaDeMarcas = new Map<ID, Catalogo_UDC__c>(
            [SELECT ID, Name
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Marcas'
            ]);

        Map<ID, Catalogo_UDC__c> mapaDeModelos = new Map<ID, Catalogo_UDC__c>(
            [SELECT ID, Name, description1__c, description2__c
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Modelo'
            ]);

        for (Catalogo_UDC__c cat : [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Companias']) {
            if (cat.Name == 'CASA PELLAS, S.A') {
                companiaPorMarca.put('HINO', cat);
                companiaPorMarca.put('TOYOTA', cat);
                companiaPorMarca.put('SUZUKI', cat);
                companiaPorMarca.put('YAMAHA', cat);
                companiaPorMarca.put('MOTORES MARINOS', cat);
                companiaPorMarca.put('AUTOLOTE', cat);
            }  else if (cat.Name == 'V E L O S A') {
                companiaPorMarca.put('GENESIS', cat);
                companiaPorMarca.put('JMC', cat);
                companiaPorMarca.put('HAOJUE', cat);
            }  else if (cat.Name == 'KIPESA') {
                companiaPorMarca.put('HERO', cat);
                companiaPorMarca.put('KIA', cat);
            }
        }

        for (Catalogo_UDC__c cat : [SELECT ID, Name FROM Catalogo_UDC__c WHERE RecordType.DeveloperName = 'Lineas_de_negocio']) {
            if (cat.Name == 'Camiones Hino') {
                lineaPorMarca.put('HINO', cat);
            }  else if (cat.Name == 'Autos Toyota') {
                lineaPorMarca.put('TOYOTA', cat);
            }  else if (cat.Name == 'Autos Suzuki') {
                lineaPorMarca.put('SUZUKI', cat);
            }  else if (cat.Name == 'Yamaha') {
                lineaPorMarca.put('YAMAHA', cat);
            }  else if (cat.Name == 'Motos Nuevas') {
                lineaPorMarca.put('GENESIS', cat);
                lineaPorMarca.put('HERO', cat);
                lineaPorMarca.put('HAOJUE', cat);
            }  else if (cat.Name == 'Camiones') {
                lineaPorMarca.put('JMC', cat);
            }  else if (cat.Name == 'Autos Nuevos') {
                lineaPorMarca.put('KIA', cat);
            }  else if (cat.Name == 'Motores Marinos') {
                lineaPorMarca.put('MOTORES MARINOS', cat);
            }  else if (cat.Name == 'Autos Usados') {
                lineaPorMarca.put('AUTOLOTE', cat);
            }
        }

        for (Opportunity opp : oppList) {
            String marca;

            if (opp.RecordTypeID == principalAutosID || opp.RecordTypeID == principalMotosID) {
                marca = mapaDeMarcas.get(opp.Marca_UDC__c).Name;
                
                if (mapaDeModelos.containsKey(opp.ModeloVehiculo__c)) {
                    if (String.isNotBlank(mapaDeModelos.get(opp.ModeloVehiculo__c).description1__c)) {
                        if (mapaDeModelos.get(opp.ModeloVehiculo__c).description1__c.contains('MOTORES MARINOS') || mapaDeModelos.get(opp.ModeloVehiculo__c).description1__c.contains('LANCHAS')) {
                            marca = 'MOTORES MARINOS';
                        }
                    }
                }
            } else if (opp.RecordTypeId == principalAutoloteId) {
                marca = 'AUTOLOTE';
            }

            if (String.isNotBlank(marca)) {
                if (companiaPorMarca.containsKey(marca)) {
                    opp.Compa_a__c = companiaPorMarca.get(marca).ID;
                }
    
                if (lineaPorMarca.containsKey(marca)) {
                    opp.L_neas_de_Negocio__c = lineaPorMarca.get(marca).ID;
                }
            }
        }
    }
    
    public static void validarPrecioAprobador(List<Opportunity> oppList) {
        Set<Id> oppListId = CasaPellasUtils.getFieldId(oppList, 'Id');
        List<Id> oportunidadesFaltantes = new List<Id>();
        
        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Id, Oportunidad__c
                                                    FROM Vehiculo_de_la_Oportunidad__c
                                                    WHERE Oportunidad__c IN :oppListId
                                                     	AND Vehiculo__r.Precio_de_compra_aprobado_S_Autolote__c = null]) {
			oportunidadesFaltantes.add(vehOpp.Oportunidad__c);
        }
        
        for (Opportunity opp : oppList) {
            if (oportunidadesFaltantes.contains(opp.Id)) {
                opp.addError('Para pasar a Negociacion, el Precio de compra aprobado S. Autolote debe estar completo.');
            }
        }
    }

    public static void validarAvaluosAbiertos(List<Opportunity> oppList) {
        Set<Id> oppListId = CasaPellasUtils.getFieldId(oppList, 'Id');

        Set<Id> oportunidadesConAvaluos = OpportunityHelper.obtenerOppConAvaluos(oppListId);

        for (Opportunity opp : oppList) {
            if (oportunidadesConAvaluos.contains(opp.Id)) {
                opp.addError('Primero debe cerrar los avaluos abiertos');
            }
        }
    }

    public static void setearOppInactiva(List<Opportunity> oppList) {
        Map<ID, String> nombresMap = new Map<ID, String>();
        Set<ID> accountIDList = CasaPellasUtils.getFieldId(oppList, 'AccountId');
        List<String> listaNegraList = new List<String>();

        for (Account acc : [SELECT ID, Name FROM Account WHERE ID IN :accountIDList]) {
            nombresMap.put(acc.ID, acc.Name);
        }

        for (Personas_en_lista_negra__mdt lis : [SELECT Alias__c 
                                                FROM Personas_en_lista_negra__mdt
                                                WHERE Alias__c IN :nombresMap.values()]) {
            listaNegraList.add(lis.Alias__c);
        }

        for (Opportunity opp : oppList) {
            String nombre = nombresMap.get(opp.AccountID);

            if (listaNegraList.contains(nombre)) {
                opp.Oportunidad_inactiva__c = 'Aprobacion';
            }        
        }
    }

    public static void validarRecibosExistentes(List<Opportunity> oppList) {
        Set<Id> oppListId = CasaPellasUtils.getFieldId(oppList, 'Id');
        List<Id> vehiculosIdList = new List<Id>();
        Map<Id, List<Id>> vehIdByOppId = new Map<Id, List<Id>>();
        Map<Id, Decimal> gravamenSumByVehId = new Map<Id, Decimal>();
        Map<Id, Decimal> recibosSumByVehId = new Map<Id, Decimal>();

        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Vehiculo__c, Oportunidad__c 
                                                    FROM Vehiculo_de_la_Oportunidad__c
                                                    WHERE Oportunidad__c IN :oppListId]) {
            vehiculosIdList.add(vehOpp.Vehiculo__c);

            List<Id> vehIdList;

            if (vehIdByOppId.containsKey(vehOpp.Oportunidad__c)) {
                vehIdList = vehIdByOppId.get(vehOpp.Oportunidad__c);
            } else {
                vehIdList = new List<Id>();
            }

            vehIdList.add(vehOpp.Vehiculo__c);

            vehIdByOppId.put(vehOpp.Oportunidad__c, vehIdList);
        }

        Map<Id, Vehiculo__c> vehMapById = new Map<Id, Vehiculo__c>([
            SELECT Id, Precio_de_compra_aprobado_S_Autolote__c
            FROM Vehiculo__c
            WHERE Id IN :vehiculosIdList
        ]);

        for (AllRecibidos__c rec : [SELECT Vehiculo__c, Saldo__c 
                                    FROM AllRecibidos__c
                                    WHERE Vehiculo__c IN :vehiculosIdList
                                        AND RecordType.DeveloperName = 'Gravamen']) {
            Decimal gravamen;

            if (gravamenSumByVehId.containsKey(rec.Vehiculo__c)) {
                gravamen = gravamenSumByVehId.get(rec.Vehiculo__c);
            } else {
                gravamen = 0;
            }

            gravamen += rec.Saldo__c;

            gravamenSumByVehId.put(rec.Vehiculo__c, gravamen);
        }

        for (AllRecibidos__c rec : [SELECT Vehiculo__c, Saldo__c 
                                    FROM AllRecibidos__c
                                    WHERE Vehiculo__c IN :vehiculosIdList
                                        AND RecordType.DeveloperName != 'Gravamen']) {
            Decimal suma;

            if (recibosSumByVehId.containsKey(rec.Vehiculo__c)) {
                suma = recibosSumByVehId.get(rec.Vehiculo__c);
            } else {
                suma = 0;
            }

            suma += rec.Saldo__c;

            recibosSumByVehId.put(rec.Vehiculo__c, suma);
        }

        for (Opportunity opp : oppList) {
            if (vehIdByOppId.containsKey(opp.Id)) {
                for (Id vehId : vehIdByOppId.get(opp.Id)) {
                    Decimal gravamen = gravamenSumByVehId.containsKey(vehId) ? gravamenSumByVehId.get(vehId) : 0;
                    Decimal precioAprobado = vehMapById.get(vehId).Precio_de_compra_aprobado_S_Autolote__c - gravamen;
                    Decimal recibosEntrega = recibosSumByVehId.containsKey(vehId) ? recibosSumByVehId.get(vehId) : 0;

                    if (precioAprobado != recibosEntrega) {
                        opp.addError('Para pasar a formalizacion debe haber creado los recibos de intercambio y gravamen correspondientes.');
                    }
                }
            }
        }
    }

    public static void setearNombreYTelefono(List<Opportunity> oppList) {
        Set<ID> accID = CasaPellasUtils.getFieldId(oppList, 'AccountId');
        Set<ID> catID = CasaPellasUtils.getFieldId(oppList, 'Marca_UDC__c');
        catId.addAll(CasaPellasUtils.getFieldId(oppList, 'ModeloVehiculo__c'));
        
        Map<ID, Account> accNameByID = new Map<ID, Account>(
        	[SELECT Name, Phone
             FROM Account
             WHERE ID IN :accID
            ]);
        
        Map<ID, Catalogo_UDC__c> catNameByID = new Map<ID, Catalogo_UDC__c>(
        	[SELECT Name
             FROM Catalogo_UDC__c
             WHERE ID IN :catID
            ]);
        
        for (Opportunity opp : oppList) {
            String accName = (accNameByID.containsKey(opp.AccountId))? accNameByID.get(opp.AccountId).Name : '';
            String marcaName = (catNameByID.containsKey(opp.Marca_UDC__c))? catNameByID.get(opp.Marca_UDC__c).Name : ''; 
            String modeloName = (catNameByID.containsKey(opp.ModeloVehiculo__c))? catNameByID.get(opp.ModeloVehiculo__c).Name : ''; 
            
         	opp.Name = accName + '/' + marcaName + '/' + modeloName;
        }
    }
    
    public static void insertarFacturaAutomatica(List<Opportunity> oppList) {
        for (Opportunity opp : oppList) {
            CallWSInsertaFacturaAutomatica.insertaFactura(opp.ID);
        }
    }

    public static void validarDatosVehiculo(List<Opportunity> oppList) {
        List<Id> oppConVehiculosIncompletos = new List<Id>();
        Set<Id> oppListId = CasaPellasUtils.getFieldId(oppList, 'Id');

        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Oportunidad__c
                                                    FROM Vehiculo_de_la_Oportunidad__c
                                                    WHERE Oportunidad__c IN :oppListId
                                                        AND (Vehiculo__r.Chasis__c = null 
                                                            OR Vehiculo__r.Motor__c = null)]) {
            oppConVehiculosIncompletos.add(vehOpp.Oportunidad__c);
        }

        for (Opportunity opp : oppList) {
            if (oppConVehiculosIncompletos.contains(opp.Id)) {
                opp.addError('Para pasar a Aprobación Autolote todos los campos requeridos del vehiculo deben estar completos.');
            }
        }
    }

    public static void actualizarFormaPago(List<Opportunity> oppList) {
        Map<ID, String> formaDePagoPorOppID = new Map<ID, String>();

        for (Opportunity opp : oppList) {
            formaDePagoPorOppID.put(opp.ID, opp.Forma_de_Pago_Multiple__c);
        }

        List<Informe_de_Negociaci_n__c> infNegList = 
            [SELECT ID, Forma_de_Pago_Informe__c, Oportunidad__c
            FROM Informe_de_Negociaci_n__c
            WHERE Oportunidad__c IN :formaDePagoPorOppID.keySet()
            ];

        for (Informe_de_Negociaci_n__c inf : infNegList) {
            String formaPago = formaDePagoPorOppID.get(inf.Oportunidad__c);

            inf.Forma_de_Pago_Informe__c = formaPago;
        }

        if (!infNegList.isEmpty()) {
            update infNegList;
        }
    }

    public static void eliminarFacturaAutomatica(List<Opportunity> oppList) {
        Map<ID, Boolean> chasisNoFacturadoByID = new Map<ID, Boolean>();
        for (Opportunity opp : oppList) {
            Boolean verif = CallWSEliminaRegistroFactura.validaChasisNoFacturados(opp.ID);
            chasisNoFacturadoByID.put(opp.ID, verif);
        }

        for (Opportunity opp : oppList) {
            if(chasisNoFacturadoByID.get(opp.ID)) {
                CallWSEliminaRegistroFactura.callEliminaRegistroFactura(opp.ID);
            }
        }
    }

    public static void oportunidadesPerdidas(List<Opportunity> oppList) {
        Set<Id> opportunityID = CasaPellasUtils.getFieldId(oppList, 'Id');
        Set<ID> informesID = CasaPellasUtils.getFieldId([SELECT Id FROM Informe_de_Negociaci_n__c WHERE Oportunidad__c IN :opportunityID], 'Id');

        List<OpportunityLineItem> oliList = 
            [SELECT Motor__c, Chasis__c, Color__c, IdInformeNegociacion__c
            FROM OpportunityLineItem 
            WHERE OpportunityID IN :opportunityID
            ];
            
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID, fechafactura__c, factura__c
            FROM Informe_de_Negociaci_n__c 
            WHERE Oportunidad__c IN :opportunityID
            ];

        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c IN :informesID
        ];

        List<Recibos_de_la_negociaci_n__c> recibosList = [
            SELECT ID
            FROM Recibos_de_la_negociaci_n__c
            WHERE Informe_de_Negociaci_n__c IN :informesID
        ];

        for (Informe_de_Negociaci_n__c infNeg : infList) {
            infNeg.fechafactura__c = null;
            infNeg.factura__c = '';
        }

        for (OpportunityLineItem oli : oliList) {
            oli.Motor__c = '';
            oli.Chasis__c = '';
            oli.Color__c = '';
            oli.IdInformeNegociacion__c = null;
        }

        if (!infList.isEmpty()) {
            update infList;
        }

        if (!oliList.isEmpty()) {
            update oliList;
        }

        if (!recibosList.isEmpty()) {
            delete recibosList;
        }

        if (!accInfList.isEmpty()) {
            delete accInfList;
        }

        if (!infList.isEmpty()) {
            delete infList;
        }
    }

    public static void validarDuplicados(List<Opportunity> oppList) {
        Set<ID> accountID = CasaPellasUtils.getFieldId(oppList, 'AccountId');
        Map<String, List<Opportunity>> oportunidadesPorCliente = new Map<String, List<Opportunity>>();
        Date hoy = Date.today();

        for (Opportunity oppDup : [SELECT ID, AccountID, Marca_UDC__c, OwnerID
                                    FROM Opportunity
                                    WHERE AccountID IN :accountID
                                          AND Stagename != 'Cerrada perdida' 
                                          AND Stagename != 'Cerrada ganada'
                                          AND (RecordType.DeveloperName = 'Principal_Autos' OR RecordType.DeveloperName = 'Principal_Motos')
                                    ]) {
            List<Opportunity> oppExistList;

            if (oportunidadesPorCliente.containsKey(oppDup.AccountID)) {
                oppExistList = oportunidadesPorCliente.get(oppDup.AccountID);
            } else {
                oppExistList = new List<Opportunity>();
            }

            oppExistList.add(oppDup);

            oportunidadesPorCliente.put(oppDup.AccountID, oppExistList);
        }

        for (Opportunity opp : oppList) {
            if(oportunidadesPorCliente.containsKey(opp.AccountID)) {
                for (Opportunity oppOr : oportunidadesPorCliente.get(opp.AccountID)) {
                    if (opp.Marca_UDC__c == oppOr.Marca_UDC__c) {
                        if (opp.OwnerID != oppOr.OwnerID) {
                            if (opp.ID != oppOr.ID) {
                                opp.Oportunidad_duplicada__c = true;
                            }
                        }
                    }
                }
            }
        }
    }

    public static void setearScoring(List<Opportunity> oppList) {
        List<ID> oppRiesgoAlto = new List<ID>();

        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();

        List<String> opcionesList = new List<String>();
        Set<ID> accIDList = CasaPellasUtils.getFieldId(oppList, 'AccountId');
        Set<Id> oppListId = CasaPellasUtils.getFieldId(oppList, 'Id');

        for (Opportunity opp : oppList) {
            if (String.isBlank(opp.Canal_Contrata__c)) {
                opp.addError('El campo Canal de Venta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(opp.Sucursal__c)) {
                opp.addError('El campo Sucursal es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(opp.Tipo_de_transacci_n__c)) {
                opp.addError('El campo Tipo de Transacción es requerido calcular para el Scoring UAF');
                return;
            }
            
            if (String.isBlank(opp.Responsable_del_pago__c)) {
                opp.addError('El campo Responsable del Pago es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(opp.Origen_de_los_fondos__c)) {
                opp.addError('El campo Origen de los Fondos es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(opp.Tipo_de_relaci_n_econ_mica__c)) {
                opp.addError('El campo Tipo de Relación Económica es requerido para calcular el Scoring UAF');
                return;
            }
        }

        Map<ID, Account> accMapPorId = new Map<ID, Account>([
            SELECT Pa_s__c, Pa_s__r.Name, Tipo_de_cliente__c, Tipo_Cliente__c, Tipo_de_Indentificaci_n__c,
                   Nivel_organizacional__c, Profesion_UDC__c, Profesion_UDC__r.Name, Ocupacion_UDC__c, Ocupacion_UDC__r.Name,
                   Actividad_economica_UDC__c, Actividad_economica_UDC__r.Name, PEP__c, RecordTypeId, Name
            FROM Account
            WHERE ID IN :accIDList
        ]);

        for (Opportunity opp : oppList) {
            Account acc = accMapPorId.get(opp.AccountID);

            if (String.isBlank(acc.Pa_s__c)) {
                opp.addError('El campo Pais en la cuenta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(acc.Tipo_de_cliente__c)) {
                opp.addError('El campo Tipo de Persona en la cuenta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(acc.Tipo_Cliente__c)) {
                opp.addError('El campo Tipo de Cliente en la cuenta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(acc.Tipo_de_Indentificaci_n__c)) {
                opp.addError('El campo Tipo de Identificación en la cuenta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (String.isBlank(acc.Nivel_organizacional__c)) {
                opp.addError('El campo Tipo de Contribuyente en la cuenta es requerido para calcular el Scoring UAF');
                return;
            }
            
            if (acc.RecordTypeId == personAccountID) {
                if (String.isBlank(acc.Profesion_UDC__c)) {
                    opp.addError('El campo Profesión en la cuenta es requerido para calcular el Scoring UAF');
                    return;
                }
                
                if (String.isBlank(acc.Ocupacion_UDC__c)) {
                    opp.addError('El campo Ocupación en la cuenta es requerido para calcular el Scoring UAF');
                    return;
                }
            } else {
                if (String.isBlank(acc.Actividad_economica_UDC__c)) {
                    opp.addError('El campo Actividad Económica en la cuenta es requerido para calcular el Scoring UAF');
                    return;
                }
            }
        }

        Map<ID, Integer> cantidadDeRecibosPorID = new Map<ID, Integer>();

        for (Recibos_de_la_negociaci_n__c recNeg : [SELECT Recibos__r.Instrumento_de_pago__c, Informe_de_Negociaci_n__r.Oportunidad__c
                                                    FROM Recibos_de_la_negociaci_n__c
                                                    WHERE Informe_de_Negociaci_n__r.Oportunidad__c IN: oppListId]) {
            Integer cantidad;
            if (cantidadDeRecibosPorID.containsKey(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c)) {
                cantidad = cantidadDeRecibosPorID.get(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c) + 1;
            } else {
                cantidad = 1;
            }

            cantidadDeRecibosPorID.put(recNeg.Informe_de_Negociaci_n__r.Oportunidad__c, cantidad);
        }
        
        for (Opportunity opp : oppList) {
            if (!cantidadDeRecibosPorID.containsKey(opp.ID)) {
                opp.addError('La oportunidad debe tener recibos asociados para calcular el Scoring UAF');
                return;
            }
        }

        Map<ID, String> scoringPorOppID = ProcesarScoringUAF.generarCalificacion(oppList);

        for (Opportunity opp : oppList) {
            List<String> calificacionPartida = scoringPorOppID.get(opp.ID).split('_');

            opp.Calificacion_Scoring_Cuenta__c = Decimal.valueOf(calificacionPartida[0]);
            opp.Calificacion_Scoring_Oportunidad__c = Decimal.valueOf(calificacionPartida[1]);

            Decimal calificacion = (opp.Calificacion_Scoring_Cuenta__c + opp.Calificacion_Scoring_Oportunidad__c) / 2;

            if (calificacion < 1.5) {
                opp.Riesgo__c = 'Bajo';
            } else if (calificacion < 2.5) {
                opp.Riesgo__c = 'Tolerante';
            } else if (calificacion < 3.5) {
                opp.Riesgo__c = 'Medio';
            } else {
                opp.Riesgo__c = 'Alto';
                oppRiesgoAlto.add(opp.ID);
            }   
        }

        List<User> uList = [
            SELECT ID, Email, Name
            FROM User
            WHERE Name LIKE '%Melba%Castillo%'
                AND IsActive = true
        ];

        List<EmailTemplate> emailTemplate = [
            SELECT Id, HtmlValue, Name 
            FROM EmailTemplate  
            WHERE Name LIKE 'Oportunidad riesgo alto' 
            ];

        if (!uList.isEmpty()) {
            List<Messaging.Email> emailList = new List<Messaging.Email>();

            for (Opportunity opp : [SELECT ID, Name, Owner.Email, Owner.Name, AccountID FROM Opportunity WHERE ID IN :oppRiesgoAlto]) {
                String body = emailTemplate[0].HtmlValue.replace('{{{Recipient.FirstName}}}', uList[0].Name)
                                                        .replace('{{{Opportunity.AccountId}}}', accMapPorId.get(opp.AccountID).Name)
                                                        .replace('{{{Opportunity.Name}}}', opp.Name)
                                                        .replace('{{{Opportunity.OwnerId}}}', opp.Owner.Name);

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{uList[0].Email});
                mail.setReplyTo(opp.Owner.Email);
                mail.setSenderDisplayName(opp.Owner.Name);
                mail.setSubject('Oportunidad a facturar con riesgo ALTO');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setHtmlBody(body);
                emailList.add(mail);
            }
    
            if(!emailList.isEmpty() && !Test.isRunningTest()) {
                Messaging.sendEmail(emailList);    
            }
        }
    }

    public static void liberarVehiculos(List<Opportunity> oppList) {
        Set<Id> oppIdList = CasaPellasUtils.getFieldId(oppList, 'Id');
        Map<Id, Id> avaluoPorVehiculo = new Map<Id, Id>();
        List<Id> oportunidadesOriginales = new List<Id>();
        Map<Id, String> vehiculoIdList = new Map<Id, String>(); 

        for (Vehiculo_de_la_Oportunidad__c vehOpp : [SELECT Vehiculo__c, Oportunidad__c, Oportunidad__r.StageName,
                                                        Oportunidad__r.Oportunidad_original__c
                                                    FROM Vehiculo_de_la_Oportunidad__c 
                                                    WHERE Oportunidad__c IN :oppIdList]) {
            String etapa = (vehOpp.Oportunidad__r.StageName.contains('ganada'))? 'Libre' : 'Pendiente';

            vehiculoIdList.put(vehOpp.Vehiculo__c, etapa);
            if (etapa == 'Libre') {
                avaluoPorVehiculo.put(vehOpp.Vehiculo__c, vehOpp.Oportunidad__c);
                oportunidadesOriginales.add(vehOpp.Oportunidad__c);

                if (String.isNotBlank(vehOpp.Oportunidad__r.Oportunidad_original__c)) {
                    oportunidadesOriginales.add(vehOpp.Oportunidad__r.Oportunidad_original__c);
                }
            }
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id, Owner.Name 
            FROM Opportunity
            WHERE Id IN :oportunidadesOriginales
        ]);

        List<Vehiculo__c> vehiculos = [
            SELECT Estado__c
            FROM Vehiculo__c
            WHERE Id IN :vehiculoIdList.keySet()
        ];

        for (Vehiculo__c v : vehiculos) {
            if (vehiculoIdList.containsKey(v.Id)) {
                v.Estado__c = vehiculoIdList.get(v.Id);

                if (v.Estado__c == 'Libre') {
                    if (avaluoPorVehiculo.containsKey(v.Id)) {
                        Id avaluoId = avaluoPorVehiculo.get(v.Id);
                        v.Evaluador__c = oppMap.get(avaluoId).Owner.Name;
                        v.Vendedor__c = oppMap.get(avaluoId).Owner.Name;
                    }
                }
            }
        }

        if (!vehiculos.isEmpty()) {
            update vehiculos;
        }
    }

    public static void setearAuEnVehiculos(List<Opportunity> oppList) {
        Set<Id> oppIdList = CasaPellasUtils.getFieldId(oppList, 'Id');
        Set<Id> vehIdList = CasaPellasUtils.getFieldId(
            [SELECT Vehiculo__c FROM Vehiculo_de_la_Oportunidad__c WHERE Oportunidad__c IN :oppIdList], 
            'Vehiculo__c'
        );

        List<Vehiculo__c> vehiculoList = [
            SELECT Id 
            FROM Vehiculo__c 
            WHERE Id IN :vehIdList
                AND AU__c = null
        ];

        List<Vehiculo__c> ultimoVeh = [
            SELECT AU__c 
            FROM Vehiculo__c
            WHERE AU__c != null
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        
        Integer ultimoAu = 0;
        String anio = String.valueOf(Date.today().year()).substring(2);

        if (!ultimoVeh.isEmpty()) {
            ultimoAu = Integer.valueOf(ultimoVeh[0].AU__c.split('-')[1]);
        }

        for (Vehiculo__c veh : vehiculoList) {
            String nuevoAu = String.valueOf(ultimoAu + 1);
            
            if (nuevoAu.length() == 1) {
                nuevoAu = '00' + nuevoAu;
            } else if (nuevoAu.length() == 2) {
                nuevoAu = '0' + nuevoAu;
            }

            veh.AU__c = 'AU-' + nuevoAu + '-' + anio;
        }

        update vehiculoList;
    }

    public static void setearFechaCompra(List<Opportunity> oppList) {
        System.debug('entra en fecha de compra');
        Set<Id> oppIdList = CasaPellasUtils.getFieldId(oppList, 'Id');
        Set<Id> vehIdList = CasaPellasUtils.getFieldId(
            [SELECT Vehiculo__c FROM Vehiculo_de_la_Oportunidad__c WHERE Oportunidad__c IN :oppIdList], 
            'Vehiculo__c'
        );

        Map<Id, Id> accountByVehiculoId = new Map<Id, Id>();

        List<Vehiculo__c> vehiculoList = [
            SELECT Id, Fecha_de_compra__c
            FROM Vehiculo__c 
            WHERE Id IN :vehIdList
                AND Fecha_de_compra__c = null
        ];

        for (Vehiculo__c veh : vehiculoList) {
            veh.Fecha_de_compra__c = Date.today();
        }

        List<Database.SaveResult> srList = Database.update(vehiculoList, false);

        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                System.debug(sr.getErrors()[0]);
            }
        }
    }

    public static void setearFechaVenta(List<Opportunity> oppList) {
        Set<Id> oppIdList = CasaPellasUtils.getFieldId(oppList, 'Id');
        Set<Id> vehIdList = CasaPellasUtils.getFieldId(
            [SELECT Vehiculo__c FROM Vehiculo_de_la_Oportunidad__c WHERE Oportunidad__c IN :oppIdList], 
            'Vehiculo__c'
        );

        Map<Id, Id> accountByVehiculoId = new Map<Id, Id>();

        List<Vehiculo__c> vehiculoList = [
            SELECT Id, Fecha_de_venta__c, Estado__c
            FROM Vehiculo__c 
            WHERE Id IN :vehIdList
                AND Fecha_de_venta__c = null
        ];

        for (Vehiculo__c veh : vehiculoList) {
            veh.Fecha_de_venta__c = Date.today();
            veh.Estado__c = 'Vendido';
        }

        List<Database.SaveResult> srList = Database.update(vehiculoList, false);

        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                System.debug(sr.getErrors()[0]);
            }
        }
    }

    public static void desactivarIntercambioEnPadres(Set<Id> parentOpportunitiesId) {
        Set<Id> oportunidadesConAvaluos = OpportunityHelper.obtenerOppConAvaluos(parentOpportunitiesId);

        List<Opportunity> parentOpportunities = [
            SELECT Id, Desea_realizar_intercambio__c
            FROM Opportunity
            WHERE Id IN :parentOpportunitiesId
                AND Id NOT IN :oportunidadesConAvaluos
        ];

        for (Opportunity parentOpp : parentOpportunities) {
            parentOpp.Desea_realizar_intercambio__c = 'NO';
        }

        if (!parentOpportunities.isEmpty()) {
            update parentOpportunities;
        }
    }

    public static Boolean validarOrdenAbierta (List<Opportunity> oppList) {
        List<String> informesID = new List<String>();
        Boolean blntieneorden   = false;   

        Set<Id> oppIdList = CasaPellasUtils.getFieldId(oppList, 'Id');
        Set<Id> vehIdList = CasaPellasUtils.getFieldId(
            [SELECT Vehiculo__c FROM Vehiculo_de_la_Oportunidad__c WHERE Oportunidad__c IN :oppIdList], 
            'Vehiculo__c'
        );

        List<Id> oportunidadesConOrdenActiva = new List<Id>();

        List<informe_de_negociaci_n__c> vehiculoList = [
            SELECT OrdenAbierta__c,Oportunidad__c
            FROM informe_de_negociaci_n__c
            WHERE ID IN :vehIdList
        ];

        for (informe_de_negociaci_n__c veh : vehiculoList) {
            system.debug('PRUEBA ' + veh.OrdenAbierta__c);
            if (veh.OrdenAbierta__c =='1'){                       
                blntieneorden= true;
            }
            else{
                blntieneorden= false;                
            }    
            if (blntieneorden) {    
                oportunidadesConOrdenActiva.add(veh.Oportunidad__c); 
            }
        }

        for (Opportunity opp : oppList) {
            if (oportunidadesConOrdenActiva.contains(opp.Id)) {
                opp.addError('No se puede marcar cerrada perdida la oportunidad porque el chasis esta en proceso de venta.');
            }      
        }

        return blntieneorden;
    }

    private static Set<Id> obtenerOppConAvaluos(Set<Id> opportunitiesId) {
        Set<Id> oportunidadesConAvaluos = new Set<Id>();

        for (Opportunity opp : [SELECT Id, Oportunidad_original__c
                                FROM Opportunity
                                WHERE RecordType.DeveloperName = 'Avaluo'
                                    AND Oportunidad_original__c IN :opportunitiesId
                                    AND StageName != 'Cerrada ganada'
                                    AND StageName != 'Cerrada perdida']) {
            oportunidadesConAvaluos.add(opp.Oportunidad_original__c);
        }

        return oportunidadesConAvaluos;
    }
}