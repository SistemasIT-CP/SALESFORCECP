trigger RecibosTrigger on AllRecibidos__c (before insert, before update) {
    if (Trigger.isBefore) {
        Id gravamenId = Schema.SObjectType.AllRecibidos__c
                            .getRecordTypeInfosByDeveloperName()
                            .get('Gravamen')
                            .getRecordTypeId();

        List<AllRecibidos__c> actPagoPickList = new List<AllRecibidos__c>();
        List<AllRecibidos__c> actPagoCodeList = new List<AllRecibidos__c>();
        List<AllRecibidos__c> recibosGravamen = new List<AllRecibidos__c>();
        List<AllRecibidos__c> recibosDeVehiculo = new List<AllRecibidos__c>();
        List<AllRecibidos__c> recibosActualizarNumero = new List<AllRecibidos__c>();

        if (Trigger.isInsert) {
            for (AllRecibidos__c rec : Trigger.new) {
                if (String.isNotBlank(rec.CodigoInstrumentoPago__c) && String.isBlank(rec.Instrumento_de_pago__c)) {
                    actPagoPickList.add(rec);
                }

                if (String.isBlank(rec.CodigoInstrumentoPago__c) && String.isNotBlank(rec.Instrumento_de_pago__c)) {
                    actPagoCodeList.add(rec);
                }

                if (rec.RecordTypeId == gravamenId && String.isNotBlank(rec.Vehiculo__c)) {
                    recibosGravamen.add(rec);
                }

                if (rec.RecordTypeId != gravamenId && String.isNotBlank(rec.Vehiculo__c)) {
                    recibosDeVehiculo.add(rec);
                }
                // ACTUALIZAR ULTIMO NUMERO CUANDO NO SE INGRESA MANUALMENTE
                if(rec.NumeroRecibido__c == null){
                    recibosActualizarNumero.add(rec);
                }

            }
        }

        if (Trigger.isUpdate) {
            for (AllRecibidos__c rec : Trigger.new) {
                if (rec.CodigoInstrumentoPago__c != Trigger.oldMap.get(rec.ID).CodigoInstrumentoPago__c) {
                    actPagoPickList.add(rec);
                }

                if (rec.Instrumento_de_pago__c != Trigger.oldMap.get(rec.ID).Instrumento_de_pago__c) {
                    actPagoCodeList.add(rec);
                }

                if (rec.RecordTypeId == gravamenId && String.isNotBlank(rec.Vehiculo__c)) {
                    if (rec.Saldo__c != Trigger.oldMap.get(rec.Id).Saldo__c) {
                        recibosGravamen.add(rec);
                    }
                }

                
                if (rec.RecordTypeId != gravamenId && String.isNotBlank(rec.Vehiculo__c)) {
                    if (rec.Saldo__c != Trigger.oldMap.get(rec.Id).Saldo__c) {
                        recibosDeVehiculo.add(rec);
                    }
                }
            }
        }

        if (!actPagoCodeList.isEmpty()) {
            RecibosHelper.actualizarInstrumentoPagoCodigo(actPagoCodeList);
        }

        if (!actPagoPickList.isEmpty()) {
            RecibosHelper.actualizarInstrumentoPagoPick(actPagoPickList);
        }

        if (!recibosGravamen.isEmpty()) {
            RecibosHelper.validarSaldoGravamen(recibosGravamen);
        }

        if (!recibosDeVehiculo.isEmpty()) {
            RecibosHelper.validarSaldoARecibosDeVehiculos(recibosDeVehiculo);
        }
        if(!recibosActualizarNumero.isEmpty()){
           RecibosHelper.actualizarNum(recibosActualizarNumero);
        }
    }
}