@isTest 
public class Test_ProcesoAccesorios {
    @TestSetup
    public static void crearInforme() {
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
        
        Accesorios__c acc = new Accesorios__c();
        acc.Descripcion__c = 'Test';
        acc.CodigoParte__c = '10BBLD616DYXX';
        acc.CodParteEquivalente__c = '70D1985077010';
        acc.CantidadMinima__c = 1;
        acc.DescripcionAmplia__c = 'Test';
        acc.Compa_a_UDC__c = companiasTest.ID;
        insert acc;
        
        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.Estado__c = 'Solicitado';
        accInf.InformeNegociacion__c = inf.ID;
        accInf.Accesorio__c = acc.ID;
        accInf.Solicitar_Accesorio_Equivalente__c = true;
        insert accInf;    
    }

    @isTest
    public static void testGetAccesoriosChasis() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        ProcesaGetAccesoriosChasis.getAccesoriosChasis('CHASIS', '' + infList[0].ID);
    }
    
    @isTest
    public static void consultaAccesorios_DisponibilidadAccesorios(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];
        
        PageReference pageRef = Page.ConsultaDisponibilidadAccesorios;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', '' + infList[0].ID);
        
        CtrlConsultaDisponibilidadAccesorios cda = new CtrlConsultaDisponibilidadAccesorios ();
        
        Test.startTest();
        cda.validaDisponibilidad();
        CtrlConsultaDisponibilidadAccesorios.solicitaAccesorioInformeAprobado('TEST');
        Test.stopTest();
        
    }
    
    @isTest
    public static void consultaAccesoriosDespachadosTest(){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
   		List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];
        
        List<Accesorios_del_informe__c> accInfList = 
            [SELECT Id, Estado__c
          	FROM Accesorios_del_informe__c 
          	WHERE InformeNegociacion__c =: infList[0].ID
            ];
        
        for (Accesorios_del_informe__c a : accInfList) {
            a.Estado__c = 'Solicitado';
        }
        
        update accInfList;
        
        PageReference pageRef2 = Page.ConsultaAccesoriosDespachados;
        Test.setCurrentPage(pageRef2);
        ApexPages.currentPage().getParameters().put('Id', '' + infList[0].ID);
        CtrlConsultaAccesoriosDespachados accDesp = new CtrlConsultaAccesoriosDespachados();
        
        Test.startTest();
        accDesp.validaAccesoriosDespachados();
        Test.stopTest();
    }
    
    @isTest
    public static void eliminaSolicitud (){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        List<ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud> eliminaSolicitudInfNegList = new List<ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud>();
        
        ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud wInforme = new ProcesaWSEliminarSolicitud.WrapperEliminaSolicitud();
        wInforme.chasis 	= 'TESTCHASIS';
        wInforme.informeNeg	= '000000000000283';
        
        eliminaSolicitudInfNegList.add(wInforme);
        
        test.startTest();
        ProcesaWSEliminarSolicitud.eliminarSolicitud(ProcesaWSEliminarSolicitud.generaXMLRequest(eliminaSolicitudInfNegList));
        test.stopTest();
    }   
}