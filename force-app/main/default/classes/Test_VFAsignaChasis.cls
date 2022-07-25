@Istest
public class Test_VFAsignaChasis {
	
    @istest
    public static void testAsignaChasis(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        test.startTest();
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.Chasis__c = 'TESTCHASIS_89789798';
        infNeg.Reservar__c = true;
        insert infNeg;
        
        PageReference pageRef = Page.AsignaChasis; // Add your VF page Name here
        pageRef.getParameters().put('Id', infNeg.Id);
        Test.setCurrentPage(pageRef);
        
        
        CtrlAsignaChasis ctrlAC = new CtrlAsignaChasis();
        ctrlAC.recordId = infNeg.Id;
        CtrlAC.goToRecord();
        test.stopTest();
        
	}
    
    @istest
    public static void testAsignaChasis2(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        test.startTest();
        Informe_de_Negociaci_n__c infNeg2 = new Informe_de_Negociaci_n__c ();
        infNeg2.Chasis__c = 'TESTCHASIS_89789798';
        infNeg2.Reservar__c = false;
        insert infNeg2;
        
        PageReference pageRef2 = Page.AsignaChasis; // Add your VF page Name here
        pageRef2.getParameters().put('Id', infNeg2.Id);
        Test.setCurrentPage(pageRef2);
        test.stopTest();
	} 
    
}