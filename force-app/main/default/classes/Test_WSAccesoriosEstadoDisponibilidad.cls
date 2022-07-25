@Istest
public class Test_WSAccesoriosEstadoDisponibilidad {
    
    @istest
    public static void ejecutaWSAccesoriosEstadoDisponibilidad(){
        
        Test.setMock(WebServiceMock.class, new Test_MockAccesoriosDisponibilidad());
        ProcesaWSAccesoriosEstadoDisponibilidad.procesaAccesorios(new List<String>{'Accesorio1', 'Accesorio2', 'Accesorio3', 'Accesorio4', 'Accesorio5'});
            
        
    }

}