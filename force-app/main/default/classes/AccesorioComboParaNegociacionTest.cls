@isTest
public class AccesorioComboParaNegociacionTest {
	@TestSetup
    public static void setup(){
        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf;
        
        Combo__c c = new Combo__c();
        insert c;
        
        CombosDeInformeDeNegociacion__c com = new CombosDeInformeDeNegociacion__c();
        com.Informe_de_Negociaci_n__c = inf.ID;
        com.Combo__c = c.ID;
        insert com;
    }
    
    @isTest
    public static void crearAccesoriosDelInformeTest() {
        List<CombosDeInformeDeNegociacion__c> comList = 
            [SELECT ID
            FROM CombosDeInformeDeNegociacion__c
            ];
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        AccesoriosComboParaNegociacion__c acc = new AccesoriosComboParaNegociacion__c();
        acc.Asociar_al_informe_Negociacion__c = false;
        acc.Combo_del_informe__c = comList[0].ID;
        acc.Descripcion__c = 'TEST';
        acc.Cantidad__c = 1;
        insert acc;
        
        acc.Asociar_al_informe_Negociacion__c = true;
        
        Test.startTest();
		update acc;        
        Test.stopTest();
    }
}