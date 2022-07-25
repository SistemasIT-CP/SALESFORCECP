@isTest
public class ConsumirCombosTest {
    @TestSetup
    public static void crearAccesorios () {
        List<Accesorios__c> accList = new List<Accesorios__c>();
        List<Combo__c> comboList = new List<Combo__c>();

        Id companiaID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Companias')
                                    .getRecordTypeId();
        
        Catalogo_UDC__c companiasTest = new Catalogo_UDC__c();
        companiasTest.Name = 'KIPESA';
        companiasTest.productcode__c = 'COMP';
        companiasTest.RecordTypeId = companiaID;
        
        insert companiasTest;
        
        Accesorios__c acc = new Accesorios__c();
        acc.Name = 'Accesorio de Prueba';
        acc.CodigoParte__c = '70Q42457';
        acc.CurrencyIsoCode = 'USD';
        acc.Precio__c = 10.0;
        acc.CantidadMinima__c = 1;
        acc.DescripcionAmplia__c = 'Test';
        acc.Descripcion__c = 'Test';
        acc.Compa_a_UDC__c = companiasTest.ID;

        accList.add(acc);

        Accesorios__c acc2 = new Accesorios__c();
        acc2.Name = 'Segundo accesorio de Prueba';
        acc2.CodigoParte__c = '70Q40883';
        acc2.CurrencyIsoCode = 'USD';
        acc2.Precio__c = 20.0;
        acc2.CantidadMinima__c = 1;
        acc2.DescripcionAmplia__c = 'Test';
        acc2.Descripcion__c = 'Test';
        acc2.Compa_a_UDC__c = companiasTest.ID;

        accList.add(acc2);

        insert accList;

        Combo__c c = new Combo__c();
        c.Id_Externo__c = '1143';
        c.Name = 'ALFOMBRA DE CARGA GRIS PRADO (2021)';

        comboList.add(c);

        Combo__c c2 = new Combo__c();
        c2.Id_Externo__c = '1147';
        c2.Name = 'ALFOMBRA DE CARGA RAV4 (2021)';

        comboList.add(c2);

        insert comboList;

        Combo_Accesorio__c comboAcc = new Combo_Accesorio__c();
        comboAcc.Combo__c = c2.ID;
        comboAcc.Accesorio__c = acc2.ID;
        comboAcc.Cantidad__c = 1;

        insert comboAcc;
    }

    @IsTest
    public static void consumirCombosTest(){
        List<String> combosNameList = new List<String>();
        combosNameList.add('ALFOMBRA DE CARGA GRIS PRADO (2021)');
        combosNameList.add('ALFOMBRA DE CARGA RAV4 (2021)');

        List<ID> combosIDList = new List<ID>();
        List<ID> accesoriosIDList = new List<ID>();

        Test.startTest();
        ConsumirCombos.consumirCombos();
        Test.stopTest();

        List<Combo__c> combosList = 
            [SELECT ID, Name
            FROM Combo__c 
            ];

        List<Combo_Accesorio__c> combosAccList = 
            [SELECT ID, Combo__c, Accesorio__c, Cantidad__c
            FROM Combo_Accesorio__c
            WHERE Cantidad__c > 1
            ];

        for (Accesorios__c acc : [SELECT ID 
                                  FROM Accesorios__c
                                  ]) {
            accesoriosIDList.add(acc.ID);
        }

        for (Combo__c c : combosList) {
            combosIDList.add(c.ID);
        }

        System.assertEquals(2, 
                            combosList.size(), 
                            'No se estan creando todos los combos');

        for (Combo__c c : combosList) {
            System.assertEquals(true, 
                                combosNameList.contains(c.Name), 
                                'El nombre del combo ' + c.Name + 'no coincide con lo esperado.');
        }

        System.assertEquals(1, 
                            combosAccList.size(), 
                            'Los accesorios no se estan anexando a los combos como corresponde.');
        
        System.assertEquals(true, 
                            combosIDList.contains(combosAccList[0].Combo__c), 
                            'El combo relacionado no es el esperado.');

        System.assertEquals(true, 
                            accesoriosIDList.contains(combosAccList[0].Accesorio__c), 
                            'El accesorio relacionado no es el esperado.');

        System.assertEquals(3, 
                            combosAccList[0].Cantidad__c, 
                            'La cantidad de la relacion no es la esperado.');
    }
}