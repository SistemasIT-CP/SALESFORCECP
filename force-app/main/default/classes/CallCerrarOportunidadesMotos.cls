global class CallCerrarOportunidadesMotos implements schedulable{
    global void execute(SchedulableContext sc){
        CerrarOportunidadesMotos.cerrarOppMotos();
    }
}