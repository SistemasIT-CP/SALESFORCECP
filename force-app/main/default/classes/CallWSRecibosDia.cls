global class CallWSRecibosDia implements schedulable, Database.AllowsCallouts{

    global void execute(SchedulableContext sc){
	ProcesaRecibosDia.procesaRecibos() ;
    }
    
}