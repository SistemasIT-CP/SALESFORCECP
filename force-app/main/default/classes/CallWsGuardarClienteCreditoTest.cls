@isTest
public class CallWsGuardarClienteCreditoTest {
    
	@isTest
    public static void ConsultarClienteCreditoError(){
        
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(false));
        Test.startTest();
        CallWsGuardarClienteCredito.guardarClienteCredito('1128701');
        Test.stopTest();

		List<Debug_log__c> log = [SELECT Error__c, XML__c, ID_Objeto__c FROM Debug_log__c];  
        
        System.assertEquals(false, log.isEmpty(), 'No se registraron los debugs');
        
        System.assertEquals('Cliente credito', log[0].Error__c, 'El campo errror no esta correcto');
        System.assertEquals('Incorrecto', log[0].XML__c, 'El campo XML no esta correcto');
        System.assertEquals('1128701', log[0].ID_Objeto__c, 'El campo Objeto no esta correcto');
    }
    
    @isTest
    public static void ConsultarClienteCreditoBien(){
        
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        Test.startTest();
        CallWsGuardarClienteCredito.guardarClienteCredito('1128701');
        Test.stopTest();

		List<Debug_log__c> log = [SELECT Error__c, XML__c, ID_Objeto__c FROM Debug_log__c];  
        
        System.assertEquals(true, log.isEmpty(), 'No se registraron los debugs');

    }
}