@IsTest
public class Test_WSUDCJSON {
    @IsTest
    public static void getUDCJSONTest(){
        SchedulableContext sc = null;
        CallWS_UDCsJSON x = new CallWS_UDCsJSON();
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_UDC_Mock());
        
        Test.startTest();
        x.execute(sc);
        Test.stopTest();     
    }
}