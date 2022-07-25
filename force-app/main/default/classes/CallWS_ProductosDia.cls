global class CallWS_ProductosDia implements schedulable {

    global void execute(SchedulableContext sc) {
        Date dateProcess = Date.today().addDays(-1);
        ws_CatalogoProductos_ProcessData.procesaProductosDia(string.valueOf(dateProcess.year()), 
                                                             string.valueOf(dateProcess.month()), 
                                                             string.valueOf(dateProcess.day())); 
    }
}