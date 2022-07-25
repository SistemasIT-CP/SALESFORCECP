public with sharing class CotizacionAutoloteVacia {
    public String fechaCreacion {get;set;}
    public String validaPor {get;set;}
    public String nombreResponsable {get;set;}
    public User vendedor {get;set;}
    public Account cliente {get;set;}
    public Vehiculo vehiculo {get;set;}
    public String notasAdicionales {get;set;}
    public String numCotizacion {get;set;}

    public CotizacionAutoloteVacia() {
        Id opportunityId = ApexPages.currentPage().getParameters().get('id');
        Integer diasValidez = Integer.valueOf(ApexPages.currentPage().getParameters().get('diasValidez'));
        String atencionA = ApexPages.currentPage().getParameters().get('nombreResponsable');
        String marca = ApexPages.currentPage().getParameters().get('marca');
        String modelo = ApexPages.currentPage().getParameters().get('modelo');
        fechaCreacion = ApexPages.currentPage().getParameters().get('fechaCotizacion');
        String anio = ApexPages.currentPage().getParameters().get('anio');
        String descripcion = ApexPages.currentPage().getParameters().get('descripcion');
        Decimal precioEspecial = Decimal.valueOf(ApexPages.currentPage().getParameters().get('precioEspecial'));
        Decimal precioUnitario = Decimal.valueOf(ApexPages.currentPage().getParameters().get('precioUnitario'));
        Integer cantidad = Integer.valueOf(ApexPages.currentPage().getParameters().get('cantidad'));
        notasAdicionales = ApexPages.currentPage().getParameters().get('notasAdicionales');
        Boolean cobrarIva = Boolean.valueOf(ApexPages.currentPage().getParameters().get('iva'));
        numCotizacion = ApexPages.currentPage().getParameters().get('numCotizacion');

        validaPor = diasValidez + ' dias';

        Opportunity opportunity = [
            SELECT AccountId, CurrencyIsoCode, OwnerId 
            FROM Opportunity
            WHERE Id =: opportunityId
        ];

        cliente = [
            SELECT Name, Direccion__c
            FROM Account
            WHERE Id =: opportunity.AccountId
        ];

        vendedor = [
            SELECT Email, MobilePhone, Name 
            FROM User 
            WHERE Id =: opportunity.OwnerId
        ];

        nombreResponsable = String.isNotBlank(atencionA)? atencionA : cliente.Name;

        vehiculo = new Vehiculo();
        vehiculo.descripcion = marca + ', Modelo ' + modelo + ', Año ' + anio + ', ' + descripcion;
        vehiculo.cantidad = String.valueOf(cantidad);
        vehiculo.precioUnitario = opportunity.CurrencyIsoCode + ' ' + precioUnitario.setScale(2);
        vehiculo.precioTotal = opportunity.CurrencyIsoCode + ' ' + (precioUnitario * cantidad).setScale(2);
        vehiculo.precioEspecial = opportunity.CurrencyIsoCode + ' ' + precioEspecial.setScale(2);
        Decimal iva = cobrarIva? precioEspecial - (precioEspecial/1.15) : 0;
        vehiculo.iva = opportunity.CurrencyIsoCode + ' ' + iva.setScale(2);
        vehiculo.descuento = opportunity.CurrencyIsoCode + ' ' + (Math.abs(precioEspecial - (precioUnitario * cantidad) - iva)).setScale(2);
    }

    public class Vehiculo {
        public String descripcion {get;set;}
        public String cantidad {get;set;}
        public String precioUnitario {get;set;}
        public String precioTotal {get;set;}
        public String precioEspecial {get;set;}
        public String iva {get;set;}
        public String descuento {get;set;}
    }
}