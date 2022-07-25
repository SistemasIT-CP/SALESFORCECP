@isTest
public class CtrlConsultaDisponibilidadAccesoriosTest {

    @TestSetup
    public static void crearInformeYAccesorios() {
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
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c();
        insert infNeg;
        
        Accesorios__c acc1 = new Accesorios__c();
        acc1.CodigoParte__c = '70KALFOMBRAJIMNY';
        acc1.CodParteEquivalente__c = '70KMOCHIM';
        acc1.Descripcion__c = 'Test';
        acc1.CantidadMinima__c = 1;
        acc1.DescripcionAmplia__c = 'Test';
        acc1.Compa_a_UDC__c = companiasTest.ID;
        insert acc1;
        
        Accesorios__c acc2 = new Accesorios__c();
        acc2.CodigoParte__c = '70KPOLARIZBRONZE';
        acc2.CodParteEquivalente__c = '70KMOCHIM';
        acc2.Descripcion__c = 'Test';
        acc2.CantidadMinima__c = 1;
        acc2.DescripcionAmplia__c = 'Test';
        acc2.Compa_a_UDC__c = companiasTest.ID;
        insert acc2;
        
        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = infNeg.ID;
        accInf.Accesorio__c = acc1.ID;
        accInf.Estado__c = 'No solicitado';
        insert accInf;
        
        Accesorios_del_informe__c accInf2 = new Accesorios_del_informe__c();
        accInf2.InformeNegociacion__c = infNeg.ID;
        accInf2.Accesorio__c = acc2.ID;
        accInf2.Estado__c = 'No solicitado';
        insert accInf2;
    }
    
    @isTest
    public static void validaDisponibilidadTest() {
        List<Informe_de_Negociaci_n__c> infNegList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];
        
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
    	PageReference pageRef = Page.ConsultaDisponibilidadAccesorios;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('id', '' + infNegList[0].Id);
        
        Test.startTest();
        CtrlConsultaDisponibilidadAccesorios cons = new CtrlConsultaDisponibilidadAccesorios();
        cons.validaDisponibilidad();
        Test.stopTest();
    }
    
    @isTest
    public static void solicitaAccesorioInformeAprobadoTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infNegList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];
        
        Test.startTest();
        CtrlConsultaDisponibilidadAccesorios.solicitaAccesorioInformeAprobado('' + infNegList[0].ID);
        Test.stopTest();
    }
}