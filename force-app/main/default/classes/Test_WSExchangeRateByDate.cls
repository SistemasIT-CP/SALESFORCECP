@Istest
public class Test_WSExchangeRateByDate {
    
    @istest
    public static void ejecutaWSExchangeRateByDate(){
        Test.setMock(WebServiceMock.class, new Test_MockExchangeRateByDate());
        SchedulableContext sc = null;
        CallProcesaWS_ExchangedRateByDate x = new CallProcesaWS_ExchangedRateByDate();
        x.execute(sc);
                
    }
    
}