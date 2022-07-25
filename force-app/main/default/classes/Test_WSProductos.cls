@Istest
public class Test_WSProductos {
    
    @istest
    public static void ejecutaWSProductosDia(){
        Test.setMock(WebServiceMock.class, new Test_MockProductosDia());
        SchedulableContext sc = null;
        CallWS_ProductosDia x = new CallWS_ProductosDia();
        x.execute(sc);
    }
    
    @istest
    public static void ejecutaWSImagenesProductosDia(){
        Test.setMock(WebServiceMock.class, new Test_MockImagenesProducto());
        SchedulableContext sc = null;
        CallWS_ImagenesProductosDia x = new CallWS_ImagenesProductosDia();
        x.execute(sc); 
    }
    
    @isTest
    public static void getProductosTest() {
        Test.setMock(WebServiceMock.class, new MockGetProductos());
        ws_CatalogoProductos.wsProductosPort port = new ws_CatalogoProductos.wsProductosPort();
        
        Test.startTest();
        port.GetProductos(Label.strKey,Label.strApp,Label.strModulo);
        Test.stopTest();
    }
}