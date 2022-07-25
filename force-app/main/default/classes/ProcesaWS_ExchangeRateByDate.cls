public class ProcesaWS_ExchangeRateByDate {
    @future (callout=true)
    public static void get_ExchangeRateByDate () {
        DateTime hoy = Datetime.now();
        
        Exchange_Rate_By_Date__c tc = new Exchange_Rate_By_Date__c();
        WS_InformeNegociaciones.wsInformeNegociacionPort port = new WS_InformeNegociaciones.wsInformeNegociacionPort();
        port.timeout_x = 120000;
        Decimal tipoDeCambio = port.GetExchangeRateByDate(Label.strKey, Label.strApp, Label.strModulo, hoy, 'USD');
        if(tipoDeCambio != null) {
            tc.Tasa__c = tipoDeCambio;
            tc.Name = 'USD - ' + Date.today();
            tc.CurrencyIsoCode = 'USD';
            
            System.debug(tc);
            
            insert tc;
        }
    }
}