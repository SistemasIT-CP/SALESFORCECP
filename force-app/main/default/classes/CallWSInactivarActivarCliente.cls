public class CallWSInactivarActivarCliente {
    public static void inactivarActivarClientes (String numCliente, String inactivo){
            ClientesWS.wsClientesPort portObj = new ClientesWS.wsClientesPort(); 
            portObj.timeout_x = 120000; 
            String resp = portObj.InactivarActivarCliente(Label.strKey, 
                                                        Label.strApp, 
                                                        Label.strModulo, 
                                                        numCliente, 
                                                        inactivo
                                                        );
            System.debug('respuesta:'+ resp);
    }

}