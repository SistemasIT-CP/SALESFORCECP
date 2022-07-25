@Istest
public class TestWS_OppGetFacturasAutomaticas {
    @istest
    public static void getFacturasAutomaticas(){
        Test.setMock(WebServiceMock.class, new FacturasWSMock());
        SchedulableContext sc = null;
        CallWS_GetFacturasAutomaticas x = new CallWS_GetFacturasAutomaticas();
        x.execute(sc);
    }

}