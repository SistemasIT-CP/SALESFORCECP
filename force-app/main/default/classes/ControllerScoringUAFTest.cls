@isTest
public class ControllerScoringUAFTest {
	@TestSetup
    public static void crearCuentasYOpp() {
        Id paisUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Pais')
                                    .getRecordTypeId();

        Id actEconomicaUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Actividad_Economica')
                                    .getRecordTypeId();

        Id profesionUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Profesion')
                                    .getRecordTypeId();

        Id ocupacionUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Ocupacion')
                                    .getRecordTypeId();

        Catalogo_UDC__c paisTest = new Catalogo_UDC__c();
        paisTest.Name = 'Argentina';
        paisTest.productcode__c = 'P';
        paisTest.RecordTypeId = paisUDCID;

        Catalogo_UDC__c actEconomicaTest = new Catalogo_UDC__c();
        actEconomicaTest.Name = 'Comercio';
        actEconomicaTest.productcode__c = 'A';
        actEconomicaTest.RecordTypeId = actEconomicaUDCID;

        Catalogo_UDC__c profesionTest = new Catalogo_UDC__c();
        profesionTest.Name = 'Comunicador';
        profesionTest.productcode__c = 'P';
        profesionTest.RecordTypeId = profesionUDCID;

        Catalogo_UDC__c ocupacionTest = new Catalogo_UDC__c();
        ocupacionTest.Name = 'Contador';
        ocupacionTest.productcode__c = 'O';
        ocupacionTest.RecordTypeId = ocupacionUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {paisTest,
                                                                  actEconomicaTest,
                                                                  profesionTest,
                                                                  ocupacionTest} ;

        insert catList;
        
        Id personAccountID = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();

        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = new Account();

       	acc.Name = 'Test J Account';
        acc.Nivel_organizacional__c = 'No trabaja';
        acc.Ocupacion_UDC__c = ocupacionTest.ID;
        acc.Actividad_economica_UDC__c = actEconomicaTest.ID;
        acc.Profesion_UDC__c = profesionTest.ID;
        acc.Pa_s__c = paisTest.ID;
        acc.Cedula__c = '123juridica';
        acc.Tipo_Cliente__c = 'Nuevo';
        acc.Tipo_de_Indentificaci_n__c = 'Otros';
        acc.Tipo_de_cliente__c = 'Organizaciones sin fines de lucro';
        acc.Email__c = 'email@email.com';
        
        insert acc;
        
        Account pAcc = new Account();

       	pAcc.LastName = 'Account';
        pAcc.FirstName = 'Test N';
        pAcc.Nivel_organizacional__c = 'No trabaja';
        pAcc.Ocupacion_UDC__c = ocupacionTest.ID;
        pAcc.Actividad_economica_UDC__c = actEconomicaTest.ID;
        pAcc.Profesion_UDC__c = profesionTest.ID;
        pAcc.Cedula__c = '123natural';
        pAcc.Pa_s__c = paisTest.ID;
        pAcc.Tipo_Cliente__c = 'Nuevo';
        pAcc.Tipo_de_Indentificaci_n__c = 'Otros';
        pAcc.Tipo_de_cliente__c = 'Natural';
        pAcc.Email__c = 'email@email.com';
        
        insert pAcc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Sucursal__c = 'Estelí';
        opp.Tipo_de_relaci_n_econ_mica__c = 'Contado';
        opp.AccountId = acc.ID;
        opp.Canal_Contrata__c = 'Distribuidor Autorizado';
        opp.Forma_de_Pago_UAF__c = 'Efectivo';
        opp.Tipo_de_transacci_n__c = 'Compra de Contado';
        opp.Responsable_del_pago__c = 'Facturado';
        opp.Origen_de_los_fondos__c = 'Otros';
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = Date.today() + 7;
        
        insert opp;
        
        Opportunity nOpp = new Opportunity();
        nOpp.Name = 'Test';
        nOpp.Sucursal__c = 'Estelí';
        nOpp.Tipo_de_relaci_n_econ_mica__c = 'Contado';
        nOpp.AccountId = pAcc.ID;
        nOpp.Canal_Contrata__c = 'Distribuidor Autorizado';
        nOpp.Forma_de_Pago_UAF__c = 'Efectivo';
        nOpp.Tipo_de_transacci_n__c = 'Compra de Contado';
        nOpp.Responsable_del_pago__c = 'Facturado';
        nOpp.Origen_de_los_fondos__c = 'Otros';
        nOpp.StageName = 'Contacto Exitoso';
        nOpp.CloseDate = Date.today() + 7;
        
        insert nOpp;
    }
    
    @isTest
    public static void getCalificacionOportunidadTest() {
        List<Opportunity> oppList = 
            [SELECT ID
            FROM Opportunity
            ];
        
        /*Test.startTest();
        ProcesarScoringUAF.generarCalificacion(new List<ID> {oppList[0].ID});
        CMP_ControllerScoringUAF.getCalificacionOportunidad(oppList[0].ID);
        Test.stopTest();*/
    }
    
    @isTest
    public static void getCalificacionClienteTest() {
        List<Opportunity> oppList = [
            SELECT ID
            FROM Opportunity
        ];
        
        /*Test.startTest();
        ProcesarScoringUAF.generarCalificacion(new List<ID> {oppList[0].ID});
        CMP_ControllerScoringUAF.getCalificacionCliente(oppList[0].ID);
        Test.stopTest();*/
    }
}