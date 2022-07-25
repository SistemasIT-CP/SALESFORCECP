public class ProcesaWSGetFacturasAutomaticasPorFecha { 
    @AuraEnabled
    public static void procesaFacturasAutomaticasPorFecha(Date fecha){
        ws_Oportunidades.wsOportunidadesPort portObj = new ws_Oportunidades.wsOportunidadesPort();
        portObj.timeout_x = 120000;
        String fechaFormateada = fecha.year() + '-' + fecha.month() + '-' + fecha.day();

        String resp = portObj.GetFacturasAutomaticasPorPeriodo(Label.strKey, Label.strApp, Label.strModulo, fechaFormateada);

        ProcesaWSGetFacturasAutomaticas.actualizarData(resp);
	}

    @AuraEnabled
    public static void procesaDevoluciones(){
        ProcesaWSGetDevoluciones.procesaDevoluciones();
	}
}