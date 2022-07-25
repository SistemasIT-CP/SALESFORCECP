global class CallWSAccesoriosDia implements schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc){
        Date dateProcess = date.today().addDays(-1);

        ProcesaWSAccesoriosDia.getAccesoriosDias(dateProcess);
    }
}