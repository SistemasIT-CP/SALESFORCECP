@isTest
public class test_Informe_de_Negociacion {
    
    @isTest
    public static void perderAprobacion() {
        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.today() + 7;
        opp.StageName = 'Contacto Exitoso';
        opp.Fecha_de_entrega__c = Date.today() + 1;
        opp.Cantidad_de_informes_aprobados__c = 0;
        insert opp;
        
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Oportunidad__c = opp.ID;
        inf.Estado__c = 'Esperando aprobacion';
        insert inf;
        
        inf.Estado__c = 'Aprobado';
        update inf;
        
        inf.Imp_Aduanas__c = 10;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(inf, false);
        Test.stopTest();
    }
    
    @isTest
    public static void eliminarInforme() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Estado__c = 'Aprobado';
        inf.total_negociado__c = 1000;
        
        insert inf;
        
        Test.startTest();
        Database.DeleteResult sr = Database.delete(inf, false);
        Test.stopTest();
    }
    
    @isTest
    public static void mensajeError() {
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.Estado__c = 'Aprobado';
        inf.total_negociado__c = 1000;
        inf.factura__c = '123456';
        
        insert inf;
        
        inf.total_negociado__c = 999;
        
        Test.startTest();
        Database.SaveResult sr = Database.update(inf, false);
        Test.stopTest();
    }
}