global class Call_ActualizaModelosUDC implements schedulable {

    global void execute(SchedulableContext sc){
        ActualizaModelosUDC.actualizaModelos ();
    }
    
}