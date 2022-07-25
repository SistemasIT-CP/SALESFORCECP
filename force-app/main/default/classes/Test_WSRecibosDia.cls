@Istest
public class Test_WSRecibosDia {
    
    @istest
    public static void ejecutaScheduleRecibosDia(){
        
        Test.setMock(WebServiceMock.class, new Test_MockRecibosDia());
        
        SchedulableContext sc = null;
        CallWSRecibosDia x = new CallWSRecibosDia();
        x.execute(sc);
        
    }

}