@Istest
public class Test_WSGetFacturasMaestroDia {
    
    @istest
    public static void ejecutaWSgetVehiculosList(){
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        
        SchedulableContext sc = null;
        CallWS_GetFacturasMaestroDia x = new CallWS_GetFacturasMaestroDia();
        x.execute(sc);
        
        
    }
}