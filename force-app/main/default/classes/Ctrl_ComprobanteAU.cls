public class Ctrl_ComprobanteAU {
    public String porcentajeImpuesto {get;set;}
    public String nombreCliente {get;set;}
    public String codigoCliente {get;set;}
    public Vehiculo__c vehiculo {get;set;}
    public Decimal impuesto {get;set;}
    public List<String> listaAbogados {get;set;}
    public List<String> listaContables {get;set;}
    public List<AllRecibidos__c> recibos {get;set;}

    public Ctrl_ComprobanteAU() {
        Id idVehiculo = ApexPages.currentPage().getParameters().get('Id');

        vehiculo = [
            SELECT Id, Placa__c, Tipo__c, Marca__c, Marca__r.Name, Cliente__c, Circulacion__c,
                Modelo__c, Modelo__r.Name, Anio_opcion__c, Color__c, Cilindros__c,
                Motor__c, Chasis__c, Kilometraje__c, Equipado_con__c, Carta_de_venta__c,
                Precio_de_compra_aprobado_S_Autolote__c, Vendedor__c, Evaluador__c, AU__c,
                Capacidad__c, Combustible__c, VIN__c, Cliente__r.Name, Cliente__r.CodigoCliente__c
            FROM Vehiculo__c
            WHERE Id =: idVehiculo
        ];

        recibos = [
            SELECT Concepto__c, Saldo__c
            FROM AllRecibidos__c
            WHERE Vehiculo__c =: vehiculo.Id
        ];

        if (String.isNotBlank(vehiculo.Cliente__c)) {
            nombreCliente = vehiculo.Cliente__r.Name;
            codigoCliente = vehiculo.Cliente__r.CodigoCliente__c;
        }

        if (vehiculo.Precio_de_compra_aprobado_S_Autolote__c != null) {
            impuesto = vehiculo.Precio_de_compra_aprobado_S_Autolote__c> 50000? 0.015 : 0.01;
            porcentajeImpuesto = vehiculo.Precio_de_compra_aprobado_S_Autolote__c> 50000? '1.5%' : '1%';
        }

        listaContables = Label.AU_Contadores.split(',');
    }
}