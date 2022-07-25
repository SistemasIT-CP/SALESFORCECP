@isTest
public class Test_ComprobanteAU {
    @isTest
    public static void testGenerarComprobanteAu(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        Account account = TestFactory.createPersonAccount();
		insert account;        
        
        Vehiculo__c vehiculo = TestFactory.createVehiculo();
        vehiculo.Cliente__c = account.Id;
        vehiculo.Precio_de_compra_aprobado_S_Autolote__c = 10000;
        insert vehiculo;
        
       	Test.startTest();
        PageReference pageRef = Page.comprobanteAU;
        Test.setCurrentPage(pageRef);
        Test.stopTest(); 
        
        Account insertedAccount = [
            SELECT Name, CodigoCliente__c
            FROM Account
            WHERE Id =: account.Id
            LIMIT 1
        ];
        
		pageRef.getParameters().put('Id', vehiculo.Id); 
        
        Ctrl_ComprobanteAU comprobanteController = new Ctrl_ComprobanteAU();
        
        System.assertEquals(vehiculo.Id, comprobanteController.vehiculo.Id, 'El vehiculo no es el esperado');
        System.assertEquals('1%', comprobanteController.porcentajeImpuesto, 'El porcentaje de impuestos no coincide con lo esperado');
        System.assertEquals(0.01, comprobanteController.impuesto, 'El valor del impuesto no coincide con lo esperado');
        System.assertEquals(insertedAccount.Name, comprobanteController.nombreCliente, 'El nombre de cliente no coincide con lo esperado');
        System.assertEquals(insertedAccount.CodigoCliente__c, comprobanteController.codigoCliente, 'El codigo de cliente no coincide con lo esperado');
    }
}