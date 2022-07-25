@isTest
public class CallWSDetalleFacturasTest {
	@isTest
    public static void pruebaCallWSDetalleFacturas() {

        SchedulableContext sc = null;
        CallWSDetalleFacturas x = new CallWSDetalleFacturas();
		Test.setMock(WebServiceMock.class, new Test_MockDetalleFacturas());
        
        Test.startTest();
        x.execute(sc);
        Test.stopTest();     
    }
}