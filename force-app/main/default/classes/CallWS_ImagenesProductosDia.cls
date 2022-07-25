global class CallWS_ImagenesProductosDia implements schedulable {

    global void execute(SchedulableContext sc){
        
        date dateProcess = date.today();
        dateProcess = dateProcess.addDays(-1);
        ws_CatalogoProductos_ProcessData.getImagenesProductosDia(string.valueOf(dateProcess.year()), string.valueOf(dateProcess.month()), string.valueOf(dateProcess.day())); 
    }
    
}