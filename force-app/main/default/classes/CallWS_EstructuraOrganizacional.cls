global class CallWS_EstructuraOrganizacional implements schedulable {

    global void execute(SchedulableContext sc){
        ProcesaWS_EstructuraOrganizacional.getEstructuras();
    }
    
}