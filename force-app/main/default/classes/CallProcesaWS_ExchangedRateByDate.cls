global class CallProcesaWS_ExchangedRateByDate implements schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc){
        ProcesaWS_ExchangeRateByDate.get_ExchangeRateByDate();
    }
    
}