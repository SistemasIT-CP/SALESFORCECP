@Istest
public class Test_WSEstructuraOrganizacional {
    
    @istest
    public static void ejecutaWSEstructuraOrganizacional(){
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        SchedulableContext sc = null;
        CallWS_EstructuraOrganizacional x = new CallWS_EstructuraOrganizacional();
        x.execute(sc);
                
    }

}