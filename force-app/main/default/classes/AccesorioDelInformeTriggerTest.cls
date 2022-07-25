@isTest
public class AccesorioDelInformeTriggerTest {

    @TestSetup
    public static void crearCompania() {
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
        accInf.InformeNegociacion__c = inf.ID;
        accInf.Accesorio__c = acc.ID;
        accInf.Cantidad__c = 1;
        accInf.Solicitar_Accesorio_Equivalente__c = false;
        insert accInf;
    }
    
    @isTest 
    public static void insertarAccesorioEnInformeReservado() {
        List<Informe_de_Negociaci_n__c> infList = [
            SELECT ID, Reservar__c
            FROM Informe_de_Negociaci_n__c
        ];

        List<Accesorios__c> accList = [
            SELECT ID
            FROM Accesorios__c
        ];

        infList[0].Reservar__c = true;
        update infList;

        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = infList[0].ID;
        accInf.Accesorio__c = accList[0].ID;
        accInf.Cantidad__c = 1;

        Test.startTest();
        Database.SaveResult sr = Database.insert(accInf, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'La insercion con un informe reservado funciona cuando no deberia');

        System.assertEquals('El informe se encuentra Reservado, por lo que no es posible agregar los accesorios', 
                            sr.getErrors()[0].getMessage(),
                            'El error mostrado en pantalla no es el esperado');
    }

    @isTest
    public static void setearConsecutivoYEstadoTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = [
            SELECT ID
            FROM Informe_de_Negociaci_n__c
        ];

        List<Accesorios__c> accList = [
            SELECT ID
            FROM Accesorios__c
        ];

        Accesorios_del_informe__c accInf = new Accesorios_del_informe__c();
        accInf.InformeNegociacion__c = infList[0].ID;
        accInf.Accesorio__c = accList[0].ID;
        accInf.Cantidad__c = 1;

        Test.startTest();
        Database.SaveResult sr = Database.insert(accInf, false);
        Test.stopTest();

        System.debug([SELECT Consecutivo__c FROM Accesorios_del_informe__c]);

        List<Accesorios_del_informe__c> accInsertado = [
            SELECT Estado__c, Consecutivo__c
            FROM Accesorios_del_informe__c
            WHERE ID =: accInf.ID
        ];

        System.assertEquals(true, sr.isSuccess(), 'La insercion está fallando cuando no deberia');
        System.assertEquals(2, accInsertado[0].Consecutivo__c, 'El consecutivo no se ha seteado correctamente');
        System.assertEquals('No solicitado', accInsertado[0].Estado__c, 'El estado no se ha seteado correctamente');
    }

    @isTest
    public static void actualizarAccesorioDelInformeDespachado() {
    	Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID, Estado__c
            FROM Accesorios_del_informe__c
        ];
        
        accInfList[0].Estado__c = 'Despachado';
        
        update accInfList;
        
        accInfList[0].Cantidad__c = 2;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';
        
        System.runAs(u) {
            Test.startTest();
            List<Database.SaveResult> sr = Database.update(accInfList, false);
            Test.stopTest();

            System.assertEquals(false, sr[0].isSuccess(), 'La actualizacion no falla aunque deberia hacerlo');
            System.assertEquals('No puede modificar un accesorio ya despachado.', 
                                sr[0].getErrors()[0].getMessage(), 
                                'La eliminacion de un informe con accesorios despachado se realizo cuando no deberia.');
        }
    }

    @isTest
    public static void solicitarAccesorioEquivalenteNulo() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID, Solicitar_Accesorio_Equivalente__c, Accesorio__c
            FROM Accesorios_del_informe__c
        ];

        List<Accesorios__c> accList = [
            SELECT ID, CodParteEquivalente__c
            FROM Accesorios__c
        ];

        accList[0].CodParteEquivalente__c = '';
        update accList;

        accInfList[0].Solicitar_Accesorio_Equivalente__c = true;

        Test.startTest();
        List<Database.SaveResult> sr = Database.update(accInfList, false);
        Test.stopTest();

        System.assertEquals(false, sr[0].isSuccess(), 'La solicitud de un accesorio equivalente nulo no falla aunque deberia hacerlo');
        System.assertEquals('No puede solicitarse un accesorio equivalente si el accesorio no tiene codigo equivalente.', 
                            sr[0].getErrors()[0].getMessage(), 
                            'El mensaje de la solicitud de accesorio equivalente nulo no es el esperado.');
    }

    @isTest
    public static void eliminarAccesorioDelInformeDespachado() {
    	Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID, Estado__c
            FROM Accesorios_del_informe__c
        ];

        accInfList[0].Estado__c = 'Despachado';

        update accInfList;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Vendedor'];
        
        User u = new User();
        u.Alias = 'TestUser';
        u.Email = 'test@email.com';
        u.EmailEncodingKey = 'UTF-8';
        u.LastName = 'Testing'; 
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US'; 
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test@email.com.casapellas';
        
        System.runAs(u) {
            Test.startTest();
            List<Database.DeleteResult> dr = Database.delete(accInfList, false);
            Test.stopTest();

            System.assertEquals(false, dr[0].isSuccess(), 'La eliminacion de un accesorio despachado no falla aunque deberia hacerlo');
            System.assertEquals('No puede eliminar un accesorio ya despachado.', 
                                dr[0].getErrors()[0].getMessage(), 
                                'El mensaje de la eliminacion de un accesorio despachado no es el esperado.');
        }
    }

    @isTest
    public static void eliminarAccesorioDeUnInformeReservado() {
    	Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        List<Informe_de_Negociaci_n__c> infList = [
            SELECT ID, Reservar__c
            FROM Informe_de_Negociaci_n__c
        ];

        List<Accesorios_del_informe__c> accInfList = [
            SELECT ID
            FROM Accesorios_del_informe__c
        ];

        infList[0].Reservar__c = true;
        update infList;

        Test.startTest();
        List<Database.DeleteResult> dr = Database.delete(accInfList, false);
        Test.stopTest();

        System.assertEquals(false, dr[0].isSuccess(), 'La eliminacion no falla aunque deberia hacerlo');
        System.assertEquals('El informe se encuentra Reservado, por lo que no es posible eliminar los accesorios', 
                            dr[0].getErrors()[0].getMessage(), 
                            'La eliminacion de un informe con accesorios despachado se realizo cuando no deberia.');
    }
}