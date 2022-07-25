@isTest
public class GenerarCotizacionVaciaTest {
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

        Attachment objAttachment = new Attachment();
        objAttachment.Name = 'Cotizacion Autolote - 8.pdf';
        objAttachment.ParentId = opp.Id;
        objAttachment.Body = Blob.valueof('Test');
        objAttachment.IsPrivate = false;
        objAttachment.Description = 'Cotizacion de autolote';
        insert objAttachment;
    }

    @IsTest
    public static void testObtenerUltimoNumCotizacion() {
        Test.startTest();
        Integer numResult = GenerarCotizacionVaciaController.obtenerUltimoNumCotizacion();
        Test.stopTest();

        System.assertEquals(9, numResult, 'El valor de la ultima cotizacion no es el correcto.');
    }


    @isTest
    public static void testSavePdf(){
        Opportunity opp = [
            SELECT Id 
            FROM Opportunity
            LIMIT 1
        ];

        String argumentos = 'id=' + opp.Id +';' +
            'diasValidez=10;' +
            'nombreResponsable=Test Nombre Responsable;' +
            'marca=Marca;' +
            'modelo=Modelo;' +
            'fechaCotizacion=2020/01/01;' +
            'anio=2020;' +
            'descripcion=;' +
            'precioEspecial=2500;' +
            'precioUnitario=2800;' +
            'cantidad=1;' +
            'notasAdicionales=Nota adicional de prueba;' +
            'iva=true;' +
            'numCotizacion=2';

        Test.startTest();
        Id attachmentGenerado = GenerarCotizacionVaciaController.savePdf(argumentos);
        Test.stopTest();

        System.assertEquals(true, String.isNotBlank(attachmentGenerado), 'No esta devolviendo ningun id como deberia.');

        Attachment att = [
            SELECT Id, ParentId, Description, Name
            FROM Attachment
            WHERE Id =: attachmentGenerado
        ];

        System.assertEquals(opp.Id, att.ParentId, 'El pdf no se esta asociado correctamente con la oportunidad.');
        System.assertEquals('Cotizacion de autolote', att.Description, 'La descripcion se ha seteado correctamente.');
        System.assertEquals('Cotizacion Autolote - 9.pdf', att.Name, 'El nombre se ha seteado correctamente.');
    }
}