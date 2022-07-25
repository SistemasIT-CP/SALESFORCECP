@isTest
public class CombosDeInformeDeNegociacionTriggerTest {
	@isTest
    public static void crearCombos() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Catalogo_UDC__c companiasTest = new Catalogo_UDC__c();
        companiasTest.Name = 'KIPESA';
        companiasTest.productcode__c = 'COMP';
        companiasTest.RecordTypeId = companiaID;
        
        insert companiasTest;
        
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf;
        
        Combo__c combo = new Combo__c();
        insert combo;
        
        Accesorios__c acc = new Accesorios__c();
        acc.CodigoParte__c = '70KALFOMBRAJIMNY';
        acc.CodParteEquivalente__c = '70KMOCHIM';
        acc.Descripcion__c = 'Test';
        acc.CantidadMinima__c = 1;
        acc.DescripcionAmplia__c = 'Test';
        acc.Compa_a_UDC__c = companiasTest.ID;
        insert acc;
        
        Combo_Accesorio__c comboAcc = new Combo_Accesorio__c();
        comboAcc.Accesorio__c = acc.ID;
        comboAcc.Combo__c = combo.ID;
        comboAcc.Cantidad__c = 1;
        insert comboAcc;
        
        CombosDeInformeDeNegociacion__c comboInf = new CombosDeInformeDeNegociacion__c();
        comboInf.Informe_de_Negociaci_n__c = inf.ID;
        comboInf.Combo__c = combo.ID;
        
        Test.startTest();
        insert comboInf;
        Test.stopTest();
    }
}