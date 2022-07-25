@isTest
public class CallWSActualizarAccesoriosTest {
    @TestSetup
    public static void crearInformes(){
    	Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        insert inf;

        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c();
        insert inf2;

        Accesorios__c acc = new Accesorios__c();
        acc.CodigoParte__c = '70D1985077010';
        acc.CantidadMinima__c = 1;
        acc.DescripcionAmplia__c = 'Test accesorio 1';
        acc.Descripcion__c = 'Test';
        insert acc;
        
        Accesorios__c acc2 = new Accesorios__c();
        acc2.CodigoParte__c = 'UNCODIGOINEXISTENTE';
        acc2.CantidadMinima__c = 1;
        acc2.DescripcionAmplia__c = 'Test accesorio 2';
        acc2.Descripcion__c = 'Test';
        insert acc2;
        
        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c(); 
        accInf.InformeNegociacion__c = inf.ID;
        accInf.Accesorio__c = acc.ID;
        
        insert accInf;
        
        Accesorios_del_informe__c accInf2 = new Accesorios_del_informe__c(); 
        accInf2.InformeNegociacion__c = inf2.ID;
        accInf2.Accesorio__c = acc2.ID;

        insert accInf2;
    }

    @IsTest
    public static void llamadaProgramadaTest(){
        List<Informe_de_Negociaci_n__c> consecutivosList = 
            [SELECT Consecutivo_del_Informe__c 
             FROM Informe_de_Negociaci_n__c
             ORDER BY Consecutivo_del_Informe__c ASC
            ];
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios(
            consecutivosList[0].Consecutivo_del_Informe__c.removeStart('0'), 
            consecutivosList[1].Consecutivo_del_Informe__c.removeStart('0'))
            );

        List<Accesorios_del_informe__c> accList =   
            [SELECT Estado__c, Accesorio__r.CodigoParte__c, InformeNegociacion__r.Consecutivo_del_Informe__c 
            FROM Accesorios_del_informe__c
            ];
        
        for (Accesorios_del_informe__c acc : accList) {
            if(acc.Accesorio__r.CodigoParte__c == '70D1985077010') {
                acc.Estado__c = 'Solicitado';
            } else {
                acc.Estado__c = 'Despachado';
            }
        }

        update accList;

        SchedulableContext sc = null;
        CallWSActualizarAccesorios x = new CallWSActualizarAccesorios();

        Test.startTest();
        x.execute(sc);
        Test.stopTest();

        List<Accesorios_del_informe__c> accListAct =   
            [SELECT Estado__c, Accesorio__r.CodigoParte__c, InformeNegociacion__r.Consecutivo_del_Informe__c 
            FROM Accesorios_del_informe__c
            ];

        for (Accesorios_del_informe__c acc : accListAct) {
            if(acc.Accesorio__r.CodigoParte__c == '70D1985077010') {
                System.assertEquals('Despachado', acc.Estado__c, 'El estado del accesorio ' + acc.Accesorio__r.CodigoParte__c + ' no se ha modificado como debería');
            } else {
                System.assertEquals('Solicitado', acc.Estado__c, 'El estado del accesorio ' + acc.Accesorio__r.CodigoParte__c + ' no se ha modificado como debería');
            }
        }
    }
    
    @isTest
    public static void actualizarAccesorioTest() {
        List<Informe_de_Negociaci_n__c> consecutivosList = 
            [SELECT Consecutivo_del_Informe__c 
             FROM Informe_de_Negociaci_n__c
             ORDER BY Consecutivo_del_Informe__c ASC
            ];
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios(
            consecutivosList[0].Consecutivo_del_Informe__c.removeStart('0'), 
            consecutivosList[1].Consecutivo_del_Informe__c.removeStart('0'))
            );

        List<Accesorios_del_informe__c> accList =   
            [SELECT Estado__c, Accesorio__r.CodigoParte__c 
            FROM Accesorios_del_informe__c
            ];

        for (Accesorios_del_informe__c acc : accList) {
            if(acc.Accesorio__r.CodigoParte__c == '70D1985077010') {
                acc.Estado__c = 'Solicitado';
            } else {
                acc.Estado__c = 'Despachado';
            }
        }

        update accList;
        
        List<Informe_de_Negociaci_n__c> infList =
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            LIMIT 1
            ];

        Test.startTest();
        ActualizarAccesoriosDespachados.ActualizarAccesoriosDespachados(infList[0].ID);
        Test.stopTest();

        List<Accesorios_del_informe__c> accListAct =   
            [SELECT Estado__c, Accesorio__r.CodigoParte__c, InformeNegociacion__c
            FROM Accesorios_del_informe__c
            ];

        for (Accesorios_del_informe__c acc : accListAct) {
            if(acc.InformeNegociacion__c == infList[0].ID) {
                System.assertEquals('Despachado', acc.Estado__c, 'El estado del accesorio ' + acc.Accesorio__r.CodigoParte__c + ' no se ha modificado como debería');
            } else {
                System.assertEquals('Despachado', acc.Estado__c, 'El estado del accesorio ' + acc.Accesorio__r.CodigoParte__c + ' se ha modificado cuando no deberia hacerlo');
            }
        }
    }
}