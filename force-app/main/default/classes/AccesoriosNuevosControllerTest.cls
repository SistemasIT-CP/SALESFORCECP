@isTest
public class AccesoriosNuevosControllerTest {
	@TestSetup
    public static void crearAccesorios() {        
        Id modeloUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Modelo')
                                    .getRecordTypeId();
        
        Catalogo_UDC__c modeloTest = new Catalogo_UDC__c();
        modeloTest.Name = 'AGYA A4';
        modeloTest.productcode__c = 'AGYA A4';
        modeloTest.RecordTypeId = modeloUDCID;
        insert modeloTest;
        
        Accesorios__c acc = new Accesorios__c();
        acc.CantidadMinima__c = 1;
        acc.DescripcionAmplia__c = 'Accesorios Test';
        acc.Descripcion__c = 'Accesorios Test';
        acc.CodigoParte__c = '123';
        insert acc;
        
        Combo__c c = new Combo__c();
        c.Marca_habilitada__c = 'MULTIMARCA';
        c.Modelo__c = 'AGYA A4';
        c.Id_Externo__c = '123';
        insert c;
        
        Combo_Accesorio__c cAcc = new Combo_Accesorio__c();
        cAcc.Combo__c = c.ID;
        cAcc.Accesorio__c = acc.ID;
        cAcc.Cantidad__c = 1;
        insert cAcc;
        
        Product2 p = new Product2();
        p.Name = 'test';
        p.Marca_P__c = 'Kia';
        p.ProductCode__c = 'TESTPCode';
        p.Codigovehiculo__c = 'AGYA A4';
        insert p;
        
        Informe_de_negociaci_n__c inf = new Informe_de_negociaci_n__c();
        inf.Producto__c = p.ID;
        insert inf;
        
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = inf.ID;
        accInf.Accesorio__c = acc.ID;
        accInf.Cantidad__c = 1;
        insert accInf;
    }
    
    @isTest
    public static void consultarAccesoriosTest() {
        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_negociaci_n__c
            ];
        
        Test.startTest();
        List<Accesorios_del_informe__c> accListRes = AccesoriosNuevosController.consultarAccesorios(infList[0].ID);
        Test.stopTest();

        List<Accesorios_del_informe__c> accList = 
            [SELECT ID, Codigo_de_parte__c, Descripci_n_del_accesorio__c, Cantidad__c, Precio__c, Estado__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infList[0].ID
            ];

        for (Accesorios_del_informe__c acc : accList) {
            System.assertEquals(true, accListRes.contains(acc), 'El accesorio ' + 
                                        acc.Descripci_n_del_accesorio__c + 
                                        ' no esta en el listado de accesorios del informe.');
        }
    }
    
    @isTest
    public static void obtenerAccesoriosTest() {
        Test.startTest();
        List<Accesorios__c> accListRes = AccesoriosNuevosController.obtenerAccesorios();
        Test.stopTest();

        List<Accesorios__c> accList = [
            SELECT ID, DescripcionAmplia__c, Descripcion__c, CodigoParte__c, Precio__c, CantidadMinima__c
            FROM Accesorios__c
        ];

        for (Accesorios__c acc : accList) {
            System.assertEquals(true, accListRes.contains(acc), 'El accesorio ' + 
                                        acc.Descripcion__c + 
                                        ' no esta en la lista de accesorios.');
        }
    }
        
    @isTest
    public static void obtenerCombosTest() {
        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_negociaci_n__c
            ];
        
        Test.startTest();
        List<Combo__c> comboListRes = AccesoriosNuevosController.obtenerCombos(infList[0].ID);
        Test.stopTest();

        List<Combo__c> comboList = [
            SELECT ID, Name, Id_Externo__c, Modelo__c
            FROM Combo__c
            WHERE Modelo__c = 'AGYA A4'
        ];

        for (Combo__c c : comboList) {
            System.assertEquals(true, comboListRes.contains(c), 'El combo ' + 
                                        c.Name + 
                                        ' no esta en la lista de combos.');
        }
    }
    
    @isTest
    public static void descripcionCombosTest() {
        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_negociaci_n__c
            ];
        
        Test.startTest();
        Map<String, Map<String, String>> detalleCombo = AccesoriosNuevosController.descripcionCombos(infList[0].ID);
        Test.stopTest();

        List<Combo_Accesorio__c> comboAccList = [
            SELECT ID, Combo__r.Id_Externo__c, Accesorio__r.CodigoParte__c, Accesorio__r.Descripcion__c, 
                    Accesorio__r.Precio__c, Combo__r.Name, Cantidad__c
            FROM Combo_Accesorio__c
        ];

        for (Combo_Accesorio__c cAcc : comboAccList) {
            System.assertEquals(true, 
                                detalleCombo.KeySet().contains(cAcc.Combo__r.Id_Externo__c), 
                                'El combo ' + cAcc.Combo__r.Name + ' no esta en la lista de detalles de combos.');

            Map<String, String> detalleAccesorios = detalleCombo.get(cAcc.Combo__r.Id_Externo__c);

            System.assertEquals(true, 
                                detalleAccesorios.KeySet().contains(cAcc.Accesorio__r.CodigoParte__c), 
                                'El accesorio ' + cAcc.Accesorio__r.Descripcion__c + ' no esta en la lista de detalles de combos.');

            String detalle = cAcc.Cantidad__c + '_' + 
                             cAcc.Accesorio__r.Descripcion__c + '_' + 
                             cAcc.Accesorio__r.Precio__c;

            System.assertEquals(true, 
                                detalleAccesorios.Values().contains(detalle), 
                                'Los detalles del accesorio' + cAcc.Accesorio__r.Descripcion__c + ' no esta en la lista de detalles de combos.');
        }
    }
    
    @isTest
    public static void guardarCombosTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        
        List<Object> comboList = new List<Object>();
        comboList.add('123');
        
        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_negociaci_n__c
            ];
        
        Test.startTest();
        String resultado = AccesoriosNuevosController.guardarCombos(infList[0].ID, comboList);
        Test.stopTest();

        List<Accesorios_del_informe__c> accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infList[0].ID
            ];

        System.assertEquals('Bien', resultado, 'El proceso ha fallado cuando no deberia.');

        for (Accesorios_del_informe__c accInf : accList) {
            System.assertEquals(2, accInf.Cantidad__c, 'El combo no ha agregado correctamente el accesorio.');
        }
    }
        
    @isTest
    public static void guardarAccesorioTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Object> comboList = new List<Object>();
        comboList.add('123=1');
        
        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
            FROM Informe_de_negociaci_n__c
            ];
        
        Test.startTest();
        String resultado = AccesoriosNuevosController.guardarAccesorio(infList[0].ID, comboList);
        Test.stopTest();

        List<Accesorios_del_informe__c> accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infList[0].ID
            ];

        System.assertEquals('Bien', resultado, 'El proceso ha fallado cuando no deberia.');

        for (Accesorios_del_informe__c accInf : accList) {
            System.assertEquals(2, accInf.Cantidad__c, 'El accesorio no se ha insertado correctamente.');
        }
    }
    
    @isTest
    public static void eliminarAccesorioTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Accesorios_del_informe__c> accInf = 
            [SELECT ID, InformeNegociacion__c
            FROM Accesorios_del_informe__c
            ];
        
        Test.startTest();
        String resultado = AccesoriosNuevosController.eliminarAccesorio('' + accInf[0].ID);
        Test.stopTest();

        System.assertEquals('Bien', resultado, 'El proceso ha fallado cuando no deberia.');

        List<Accesorios_del_informe__c> accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: accInf[0].InformeNegociacion__c
                  AND Codigo_de_parte__c = '123'
            ];

        System.assertEquals(true, accList.isEmpty(), 'El accesorio no se ha eliminado correctamente.');
    }
    
    @isTest
    public static void actualizarCantidadesTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Informe_de_negociaci_n__c> infList = 
            [SELECT ID
             FROM Informe_de_negociaci_n__c
            ];
        
         List<Accesorios_del_informe__c> accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infList[0].ID
                AND Codigo_de_parte__c ='123'
            ];
        
        Test.startTest();
        AccesoriosNuevosController.actualizarCantidades(infList[0].ID, '123', 6);
        Test.stopTest();
        
        accList = 
            [SELECT Cantidad__c
            FROM Accesorios_del_informe__c
            WHERE InformeNegociacion__c =: infList[0].ID
                AND Codigo_de_parte__c ='123'
            ];

        System.assertEquals(6, accList.get(0).Cantidad__c, 'La nueva cantidad asignada no es la esperada.');
    }
}