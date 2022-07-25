public class RecibosHelper {
    public static void actualizarInstrumentoPagoCodigo(List<AllRecibidos__c> recList) {
        for(AllRecibidos__c rec : recList) {
            String codigo;

            switch on rec.Instrumento_de_pago__c {
                when 'Efectivo' {
                    codigo = '.';
                }	
                when 'Cheque' {
                    codigo = '!';
                }
                when 'Tarjeta de credito' {
                    codigo = '?';
                }
                when 'Deposito bancario' {
                    codigo = 'N';
                }
                when 'Transferencia' {		  
                    codigo = 'T';
                }
                when 'Carta banco' {
                    codigo = null;
                }
            }

            if (String.isNotBlank(codigo)) {
                rec.CodigoInstrumentoPago__c = codigo;
            } else {
                rec.CodigoInstrumentoPago__c = null;
            }
        }
    }

    public static void actualizarInstrumentoPagoPick(List<AllRecibidos__c> recList) {
        for(AllRecibidos__c rec : recList) {
            String codigo;
        
            if (rec.CodigoInstrumentoPago__c == '.') {
                codigo = 'Efectivo';
            } else if (rec.CodigoInstrumentoPago__c == '!') {
                codigo = 'Cheque';
            } else if (rec.CodigoInstrumentoPago__c == '?') {
                codigo = 'Tarjeta de credito';
            } else if (rec.CodigoInstrumentoPago__c == 'N') {
                codigo = 'Deposito bancario';
            } else if (rec.CodigoInstrumentoPago__c == 'T') {
                codigo = 'Transferencia';
            }
            
            if (String.isNotBlank(codigo)) {
                rec.Instrumento_de_pago__c = codigo;
            } else {
                rec.Instrumento_de_pago__c = null;
            }
        }
    }

    public static void validarSaldoGravamen(List<AllRecibidos__c> recList) {
        List<Id> vehiculoIdList = new List<Id>();

        for (AllRecibidos__c rec : recList) {
            vehiculoIdList.add(rec.Vehiculo__c);
        }

        Map<Id, Vehiculo__c> vehMapById = new Map<Id, Vehiculo__c>([
            SELECT Precio_de_compra_aprobado_S_Autolote__c
            FROM Vehiculo__c
            WHERE Id IN :vehiculoIdList
        ]);

        for (AllRecibidos__c rec : recList) {
            if (rec.Saldo__c > vehMapById.get(rec.Vehiculo__c).Precio_de_compra_aprobado_S_Autolote__c) {
                rec.addError('El gravamen no puede ser mayor que el precio de compra aprobado.');
            }
        }
    }

    public static void validarSaldoARecibosDeVehiculos(List<AllRecibidos__c> recList) {
        List<Id> vehiculoIdList = new List<Id>();
        List<Id> reciboIdList = new List<Id>();
        Map<Id, Decimal> gravamenSumByVehId = new Map<Id, Decimal>();
        Map<Id, Decimal> recibosSumByVehId = new Map<Id, Decimal>();

        for (AllRecibidos__c rec : recList) {
            vehiculoIdList.add(rec.Vehiculo__c);
            reciboIdList.add(rec.Id);
        }

        Map<Id, Vehiculo__c> vehMapById = new Map<Id, Vehiculo__c>([
            SELECT Precio_de_compra_aprobado_S_Autolote__c
            FROM Vehiculo__c
            WHERE Id IN :vehiculoIdList
        ]);

        for (AllRecibidos__c rec : [SELECT Vehiculo__c, Saldo__c 
                                    FROM AllRecibidos__c
                                    WHERE Vehiculo__c IN :vehiculoIdList
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
                                    WHERE Vehiculo__c IN :vehiculoIdList
                                        AND RecordType.DeveloperName != 'Gravamen'
                                        AND Id NOT IN :reciboIdList]) {
            Decimal suma;

            if (recibosSumByVehId.containsKey(rec.Vehiculo__c)) {
                suma = recibosSumByVehId.get(rec.Vehiculo__c);
            } else {
                suma = 0;
            }

            suma += rec.Saldo__c;

            recibosSumByVehId.put(rec.Vehiculo__c, suma);
        }

        for (AllRecibidos__c rec : recList) {
            Decimal suma = recibosSumByVehId.containsKey(rec.Vehiculo__c)? recibosSumByVehId.get(rec.Vehiculo__c) : 0;
            Decimal gravamen = gravamenSumByVehId.containsKey(rec.Vehiculo__c)? gravamenSumByVehId.get(rec.Vehiculo__c) : 0;
            Decimal precioAprobado = vehMapById.get(rec.Vehiculo__c).Precio_de_compra_aprobado_S_Autolote__c - gravamen - suma;

            if (rec.Saldo__c > precioAprobado) {
                rec.addError('El saldo se excede ' + (rec.Saldo__c - precioAprobado) + ' del precio del vehiculo.');
            }
        }
    }
    // Metodo actualizar numero cuando es manual
    public static void actualizarNum(List<AllRecibidos__c> objReci) {
        List<AllRecibidos__c> lstRecUltimonum = [
            SELECT NumeroRecibido__c 
            FROM AllRecibidos__c
            WHERE NumeroRecibido__c >= 5000000
            AND CreatedDate >= THIS_WEEK 
            ORDER 
            BY NumeroRecibido__c DESC 
            LIMIT 1  
        ];
        Decimal Maximo = 5000000;
        if(!lstRecUltimonum.isEmpty() && lstRecUltimonum.get(0).NumeroRecibido__c>=Maximo){
            Maximo = lstRecUltimonum.get(0).NumeroRecibido__c;
        }
        
        for(AllRecibidos__c recibo : objReci){
            Maximo += 1;
            recibo.NumeroRecibido__c = Maximo;
        }
        /*	System.debug('*******'+ lstRecUltimonum);
Integer intNumrecibo = Integer.valueOf(lstRecUltimonum[0].NumeroRecibido__c);
objReci.NumeroRecibido__c = intNumrecibo+1;
System.debug('*******'+ objReci.NumeroRecibido__c);*/
        
    }
}