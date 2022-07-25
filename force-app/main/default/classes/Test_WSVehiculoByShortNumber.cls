@Istest
public class Test_WSVehiculoByShortNumber {
    
    @istest
    public static void ejecutaWSVehiculoByShortNumber(){
        
        Test.setMock(WebServiceMock.class, new Test_MockVehiculoByShortNumber());
        ProcesaWSVehiculoByShortNumber.procesaVehiculoByShortNumber('CHASIS89789re7w89r78ew9');        
        
    }

}