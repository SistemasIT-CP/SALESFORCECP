global class CallWS_UDCs implements schedulable {

    global void execute(SchedulableContext sc){
        ProcesaWS_UDCs.getUDCs();
    }
    
}