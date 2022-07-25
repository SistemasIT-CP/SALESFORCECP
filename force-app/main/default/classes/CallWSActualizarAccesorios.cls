global class CallWSActualizarAccesorios implements schedulable, Database.AllowsCallouts{
    global void execute(SchedulableContext sc) {
        ActualizarAccesoriosDespachados.ActualizarAccesoriosDespachados('Todos');        
        ActualizarAccesoriosSolicitados.ActualizarAccesoriosSolicitados('Todos');        
    }
}