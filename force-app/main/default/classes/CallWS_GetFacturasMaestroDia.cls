global class CallWS_GetFacturasMaestroDia implements schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc){
        ProcesaWS_GetFacturasMaestroDia.getFacturasMaestroDia();
    }
    
}