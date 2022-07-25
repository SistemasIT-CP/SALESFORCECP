@Istest (SeeAllData = true)
public class Test_WSDetalleFactura {
    
    @istest
    public static void ejecutaScheduleDatalleFacturas(){
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock()); 
        
        SchedulableContext sc = null;
        CallBatchWSGetFacturasDetallesDiaList x = new CallBatchWSGetFacturasDetallesDiaList();
        x.execute(sc);
        
    }

}