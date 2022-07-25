public class CallWSGuardarMonedaCliente {
    public static void guardaMonedaCliente (String numCliente, String moneda){
            ClientesWS.wsClientesPort portObj = new ClientesWS.wsClientesPort(); 
            portObj.timeout_x = 120000; 
            String resp = portObj.GuardarMonedaCliente(Label.strKey, 
                                                       Label.strApp, 
                                                       Label.strModulo, 
                                                       numCliente, 
                                                       moneda
                                                       );
            System.debug('respuesta:'+ resp);
    }

}