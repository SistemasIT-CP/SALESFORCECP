global class CallWSFacturasMaestro implements schedulable {

    global void execute(SchedulableContext sc){
         date dateProcess = date.today();
        dateProcess = dateProcess.addDays(-1);
        
        ws_Clientes.wsClientesPort port = new ws_Clientes.wsClientesPort();
        port.timeout_x = 120000;
        ProcesaWSFacturas.procesaMaestroFactura(port.GetFacturasMaestroDia(Label.strKey, Label.strApp, Label.strModulo,string.valueOf(dateProcess.year()),string.valueOf(dateProcess.month()),string.valueOf(dateProcess.day())));
    }
    
}