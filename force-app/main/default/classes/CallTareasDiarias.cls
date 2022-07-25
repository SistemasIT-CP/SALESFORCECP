global class CallTareasDiarias implements schedulable {
    global void execute(SchedulableContext sc) {
        recordarTareasDiarias.recordarTareasDiarias();        
        recordarTareasGerentes.recordarTareasDiarias();        
        recordarTareasJefesSucursal.recordarTareasDiarias();        
    }
}