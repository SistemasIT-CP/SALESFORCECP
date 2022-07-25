global class CallWS_GetFacturasAutomaticas implements Schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc) { 
        ProcesaWSGetDevoluciones.procesaDevoluciones();
        ProcesaWSGetFacturasAutomaticas.procesaFacturasAutomaticas();
    }
    
}