@isTest
public without sharing class VehiculoDeLaOportunidadTriggerTest {
    @TestSetup
    public static void crearOportunidad() {
        ID principalAutoloteId = Schema.SObjectType.Opportunity
                .getRecordTypeInfosByDeveloperName()
                .get('Principal_Autolote')
                .getRecordTypeId();

        ID avaluoId = Schema.SObjectType.Opportunity
                .getRecordTypeInfosByDeveloperName()
                .get('Avaluo')
                .getRecordTypeId();
        

        Opportunity oppAutolote = new Opportunity();
        oppAutolote.CloseDate = Date.today().addDays(7);
        oppAutolote.StageName = 'Contacto exitoso';
        oppAutolote.RecordTypeId = principalAutoloteId;
        oppAutolote.Name = 'TEST';
        insert oppAutolote;

        Opportunity avaluoOpp = new Opportunity();
        avaluoOpp.CloseDate = Date.today().addDays(7);
        avaluoOpp.StageName = 'Esperando contacto';
        avaluoOpp.RecordTypeId = avaluoId;
        avaluoOpp.Name = 'AVALUO/';
        insert avaluoOpp;
    }

    @isTest
    public static void crearPresupuestoAutolote(){
        Opportunity opp = [
            SELECT Id, Name
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Autolote'
        ];

        Vehiculo__c vehiculo = new Vehiculo__c();
        vehiculo.Anio_opcion__c = '2021';
        vehiculo.Chasis__c = '123456789abcdefgh';
        vehiculo.Estado__c = 'Libre';
        insert vehiculo;

        Vehiculo_de_la_Oportunidad__c vehiculoOpp = new Vehiculo_de_la_Oportunidad__c();
        vehiculoOpp.Oportunidad__c = opp.Id;
        vehiculoOpp.Vehiculo__c = vehiculo.Id;

        Test.startTest();
        Database.SaveResult sr = Database.insert(vehiculoOpp, false);
        Test.stopTest();

        Vehiculo__c vehiculoSeteado = [
            SELECT Name
            FROM Vehiculo__c
            WHERE Id =: vehiculo.Id
            LIMIT 1
        ];

        List<Quote> qList = [
            SELECT Id, Name, OpportunityId, ExpirationDate 
            FROM Quote
            WHERE Vehiculo__c =: vehiculo.Id
        ];

        System.assertEquals(true, sr.isSuccess(), 'La insercion del objeto junction esta fallando cuando no deberia');
        System.assertEquals(false, qList.isEmpty(), 'No se esta creando una cotizacion cuando deberia');
        System.assertEquals(opp.Name, qList[0].Name, 'El nombre no se setea correctamente');
        System.assertEquals(opp.Id, qList[0].OpportunityId, 'La oportunidad no se esta seteando correctamente');
        System.assertEquals(Date.today().addDays(7), qList[0].ExpirationDate, 'La fecha de expiracion no se esta seteando como deberia');
    }

    @isTest
    public static void noCrearPresupuestoUsado(){
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Avaluo'
        ];

        Vehiculo__c vehiculo = new Vehiculo__c();
        vehiculo.Anio_opcion__c = '2021';
        vehiculo.Chasis__c = '123456789abcdefgh';
        vehiculo.Estado__c = 'Libre';
        insert vehiculo;

        Vehiculo_de_la_Oportunidad__c vehiculoOpp = new Vehiculo_de_la_Oportunidad__c();
        vehiculoOpp.Oportunidad__c = opp.Id;
        vehiculoOpp.Vehiculo__c = vehiculo.Id;

        Test.startTest();
        Database.SaveResult sr = Database.insert(vehiculoOpp, false);
        Test.stopTest();

        List<Quote> qList = [
            SELECT Id 
            FROM Quote
            WHERE Vehiculo__c =: vehiculo.Id
        ];

        System.assertEquals(true, sr.isSuccess(), 'La insercion del objeto junction esta fallando cuando no deberia');
        System.assertEquals(true, qList.isEmpty(), 'Se esta creando una cotizacion cuando no deberia');
    }

    @isTest
    public static void eliminarVehiculoDeLaOportunidad() {

        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'Principal_Autolote'
        ];

        Vehiculo__c vehiculo = new Vehiculo__c();
        vehiculo.Anio_opcion__c = '2021';
        vehiculo.Chasis__c = '123456789abcdefgh';
        vehiculo.Estado__c = 'Libre';
        insert vehiculo;

        Vehiculo_de_la_Oportunidad__c vehiculoOpp = new Vehiculo_de_la_Oportunidad__c();
        vehiculoOpp.Oportunidad__c = opp.Id;
        vehiculoOpp.Vehiculo__c = vehiculo.Id;
        insert vehiculoOpp;

        Test.startTest();
        Database.DeleteResult dr = Database.delete(vehiculoOpp, false);
        Test.stopTest();

        Vehiculo__c vehiculoActualizado = [
            SELECT Estado__c
            FROM Vehiculo__c 
            WHERE Id =: vehiculo.Id 
        ];

        System.assertEquals(true, dr.isSuccess(), 'La eliminacion esta fallando cuando no deberia');
        System.assertEquals('Libre', vehiculoActualizado.Estado__c, 'El estado del vehiculo no se esta seteando correctamente');
    }
}