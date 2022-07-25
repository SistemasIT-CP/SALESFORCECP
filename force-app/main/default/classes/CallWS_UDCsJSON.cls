public class CallWS_UDCsJSON implements schedulable {

    public void execute(SchedulableContext sc){
        ProcesaWS_UDCsJSON.getUDCJSON();
    }
    
}