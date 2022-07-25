@Istest
public class Test_WSUDC {
	@IsTest
    public static void getUDCTest(){
        SchedulableContext sc = null;
        CallWS_UDCs x = new CallWS_UDCs();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_UDC_Mock());
        
        Test.startTest();
        x.execute(sc);
        Test.stopTest();
    }
}