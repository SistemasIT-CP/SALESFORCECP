@Istest
public class Test_WSAccesoriosDisponibles {
    
    @istest
    public static void ejecutaWSAccesoriosDisponibles(){
        
        Test.setMock(WebServiceMock.class, new Test_MockAccesoriosDisponibles());
        ProcesaWSAccesoriosDisponibles.procesaAccesorios(new List<String> {'Accesorio1', 'Accesorio2', 'Accesorio3', 'Accesorio4', 'Accesorio5'});        
        
    }

}