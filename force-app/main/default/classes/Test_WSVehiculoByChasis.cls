@Istest
public class Test_WSVehiculoByChasis {
    
    @istest
    public static void ejecutaWSVehiculoByChasis(){
        
        Test.setMock(WebServiceMock.class, new Test_MockVehiculoByChasis());
        ProcesaWSVehiculoByChasis.procesaVehiculoByChasis('TESTCHASIS9989789789');        
        
    }

}