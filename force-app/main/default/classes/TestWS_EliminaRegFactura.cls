@Istest
public class TestWS_EliminaRegFactura {
    
    @istest
    public static void getFacturasAutomaticas(){
        
        Test.setMock(WebServiceMock.class, new Test_MockWSEliminaRegistroFactura());
        String resp = new ws_Oportunidades.wsOportunidadesPort().EliminarRegistroFactura(Label.strKey, Label.strApp, Label.strModulo, 'testChasis', 'testCodCte','8877');    
        
    }

}