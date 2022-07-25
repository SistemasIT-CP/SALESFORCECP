@isTest
public class InactivarTest {
    @isTest
    public static void probarInactividad() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new Test_MockWS());
        CallWSInactivarActivarCliente.inactivarActivarClientes('123456', 'true');
        Test.stopTest();
    }
}