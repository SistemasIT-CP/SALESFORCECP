@istest
public class Test_WSFacturas {

    @istest
    public static void ejecutaScheduleFacturas(){
        
        Test.setMock(WebServiceMock.class, new Test_MockFacturasMaestro());
        
        SchedulableContext sc = null; 
        CallWSFacturasMaestro x = new CallWSFacturasMaestro();
        x.execute(sc);
        
    }

}