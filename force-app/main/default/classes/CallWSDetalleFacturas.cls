global class CallWSDetalleFacturas implements schedulable {
    global void execute(SchedulableContext sc){
        Date dateProcess = Date.today();
        dateProcess = dateProcess.addDays(-1);
        
        ws_Clientes.wsClientesPort port = new ws_Clientes.wsClientesPort();
        port.timeout_x = 120000;
        ProcesaDetalleFacturas.procesaDetalleFact(port.GetFacturaDetalleDia(Label.strKey, 
                                                                            Label.strApp, 
                                                                            Label.strModulo,
                                                                            String.valueOf(dateProcess.year()),
                                                                            String.valueOf(dateProcess.month()),
                                                                            String.valueOf(dateProcess.day())
                                                                           )
                                                 );
    }
}