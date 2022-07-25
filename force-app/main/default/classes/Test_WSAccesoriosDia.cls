@istest
public class Test_WSAccesoriosDia {

    @istest
    public static void ejecutaScheduleFacturas(){
        
        Test.setMock(WebServiceMock.class, new Test_MockAccesoriosDia());
        
        SchedulableContext sc = null; 
        CallWSAccesoriosDia x = new CallWSAccesoriosDia();
        x.execute(sc);
        
    }

}