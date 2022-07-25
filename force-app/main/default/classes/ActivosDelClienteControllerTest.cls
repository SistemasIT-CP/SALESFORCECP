@isTest
public class ActivosDelClienteControllerTest {
    @TestSetup
    public static void crearCuenta(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.RecordTypeID = juridicaAccountID;
        acc.CodigoCliente__c = '321321';
        insert acc;
    }

    @IsTest
    public static void obtenerActivosTest(){
        List<Account> accList = [
            SELECT ID, CodigoCliente__c
            FROM Account
        ];
        
        accList[0].CodigoCliente__c = '123456';

        update accList; 
        
        Test.setMock(WebServiceMock.class, new ActivosDelClienteMock());

        Test.startTest();
        List<ActivosDelClienteController.ActivosCliente> activosList = ActivosDelClienteController.obtenerActivos('' + accList[0].Id);
        Test.stopTest();
        
        System.assertEquals(false, activosList.isEmpty(), 'El listado de activos esta vacio cuando no deberia.');

        for (ActivosDelClienteController.ActivosCliente act : activosList) {
            System.assertEquals('123456', act.chassis, 'El chasis no es el esperado');
            System.assertEquals('TEST', act.descripcionMarca, 'La descripcion DE Marca no es el esperado');
            System.assertEquals('TEST', act.descripcionModeloGenerico, 'La descripcion de Modelo Generico no es el esperado');
            System.assertEquals('123', act.kilometraje, 'El kilometraje no es el esperado');
            System.assertEquals('TEST', act.motor, 'El motor no es el esperado');
            System.assertEquals('123', act.numFactura, 'El numero de Factura no es el esperado');
            System.assertEquals('TEST', act.estado, 'El estado no es el esperado');
            System.assertEquals('true', act.MPP, 'El MPP no es el esperado');
            System.assertEquals('2021', act.anno, 'El año no es el esperado');
            System.assertEquals('123', act.placa, 'La placa no es la esperado');
            System.assertEquals('19-02-2015', act.fechaVenta, 'La fecha de venta no es la esperado');
        }
    }
}