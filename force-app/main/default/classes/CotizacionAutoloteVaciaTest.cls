@isTest
public with sharing class CotizacionAutoloteVaciaTest {
    @TestSetup
    public static void makeData(){
        Id autoloteRT = Schema.SObjectType.Opportunity
                        .getRecordTypeInfosByDeveloperName()
                        .get('Principal_Autolote')
                        .getRecordTypeId();

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Account acc = TestFactory.createPersonAccount();
        insert acc;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];
        User u = TestFactory.createUser(p.Id);
        insert u;

        Opportunity opp = TestFactory.createOpportunity(acc.Id, Test.getStandardPricebookId());
        opp.RecordTypeId = autoloteRT;
        opp.OwnerId = u.Id;
        insert opp;
    }

    @IsTest
    public static void testCotizacionAutoloteVacia(){
        Account acc = [
            SELECT Id, Name, Direccion__c
            FROM Account 
            LIMIT 1 
        ];

        Opportunity opp = [
            SELECT Id, OwnerId 
            FROM Opportunity
            LIMIT 1
        ];

        User u = [
            SELECT Id, Name, Email, MobilePhone 
            FROM User 
            WHERE Id =: opp.OwnerId
            LIMIT 1
        ];

        Test.startTest();
        PageReference pageRef = Page.CotizacionAutoloteVacia;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', opp.Id);
        pageRef.getParameters().put('diasValidez', '10');
        pageRef.getParameters().put('nombreResponsable','Responsable Test Name');
        pageRef.getParameters().put('marca','Kia');
        pageRef.getParameters().put('modelo','Picanto');
        pageRef.getParameters().put('fechaCotizacion','2020/01/01');
        pageRef.getParameters().put('anio','2020');
        pageRef.getParameters().put('descripcion','Auto rojo 3 puertas');
        pageRef.getParameters().put('precioEspecial','2500');
        pageRef.getParameters().put('precioUnitario','2800');
        pageRef.getParameters().put('cantidad','1');
        pageRef.getParameters().put('notasAdicionales','Nota adicional de prueba');
        pageRef.getParameters().put('iva','true');
        pageRef.getParameters().put('numCotizacion','5');

        CotizacionAutoloteVacia pdf = new CotizacionAutoloteVacia();
        Test.stopTest();

        System.assertEquals('2020/01/01', pdf.fechaCreacion, 'La fecha de creacion no es la esperada');
        System.assertEquals('10 dias', pdf.validaPor, 'La validez no es la esperada');
        System.assertEquals('Responsable Test Name', pdf.nombreResponsable, 'El nombre del responsable no es el esperado');
        System.assertEquals(u.Name, pdf.vendedor.Name, 'El nombre del vendedor no es el esperado');
        System.assertEquals(u.Email, pdf.vendedor.Email, 'El email del vendedor no es el esperado');
        System.assertEquals(u.MobilePhone, pdf.vendedor.MobilePhone, 'El telefono del vendedor no es el esperado');
        System.assertEquals(acc.Name, pdf.cliente.Name, 'El nombre del cliente no es el esperado');
        System.assertEquals(acc.Direccion__c, pdf.cliente.Direccion__c, 'La direccion del cliente no es la esperada');
        System.assertEquals('Kia, Modelo Picanto, Año 2020, Auto rojo 3 puertas', pdf.vehiculo.descripcion, 'La descripcion no es la esperada');
        System.assertEquals('1', pdf.vehiculo.cantidad, 'La cantidad no es la esperada');
        System.assertEquals('USD 2800.00', pdf.vehiculo.precioUnitario, 'El precio unitario no es el esperado');
        System.assertEquals('USD 2800.00', pdf.vehiculo.precioTotal, 'El precio total no es el esperado');
        System.assertEquals('USD 2500.00', pdf.vehiculo.precioEspecial, 'El precio especial no es el esperado');
        System.assertEquals('USD 326.09', pdf.vehiculo.iva, 'El iva no es el esperado');
        System.assertEquals('USD 626.09', pdf.vehiculo.descuento, 'El descuento no es el esperado');
        System.assertEquals('Nota adicional de prueba', pdf.notasAdicionales, 'La nota adicional no es la esperada');
        System.assertEquals('5', pdf.numCotizacion, 'El numero de cotizacion no es el esperado');
    }
}