@isTest 
public class NPSTriggerTest {
    @TestSetup
    public static void crearCuentaCasoYOpportunidad(){
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        insert acc;

        Case c = new Case();
        c.AccountID = acc.ID;
        insert c;

        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = acc.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opp.Marca__c = 'Kia';
        opp.Walk_Around__c = 'Si';
        opp.Prueba_de_manejo__c = 'Si';
        opp.Tour_CP__c = 'Si';
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.Procedencia_de_los_fondos__c = 'Instituciones financieras';
        opp.Origen_de_los_fondos__c= 'Financiamiento instituciones financieras';
        insert opp;
    }

    @isTest
    public static void insertarNPSCaso() {
        List<Case> caseList = 
            [SELECT ID 
            FROM Case 
            ];

        List<Account> accList = 
            [SELECT ID 
            FROM Account 
            ];

        NPS_Casa_Pellas__c nps = new NPS_Casa_Pellas__c();
        nps.Numero_de_caso__c = caseList[0].ID;

        Test.startTest();
        insert nps;
        Test.stopTest();

        List<NPS_Casa_Pellas__c> npsList = 
            [SELECT Cuenta__c 
            FROM NPS_Casa_Pellas__c
            ];

        System.assertEquals(accList[0].ID, 
                            npsList[0].Cuenta__c,
                            'El cliente no coincide cuando se crea un NPS desde un caso');
    }

    @isTest
    public static void insertarNPSOportunidad() {
        List<Opportunity> oppList = 
            [SELECT ID 
            FROM Opportunity 
            ];

        List<Account> accList = 
            [SELECT ID 
            FROM Account 
            ];

        NPS_Casa_Pellas__c nps = new NPS_Casa_Pellas__c();
        nps.Oportunidad__c = oppList[0].ID;

        Test.startTest();
        insert nps;
        Test.stopTest();

        List<NPS_Casa_Pellas__c> npsList = 
            [SELECT Cuenta__c 
            FROM NPS_Casa_Pellas__c
            ];

        System.assertEquals(accList[0].ID, 
                            npsList[0].Cuenta__c,
                            'El cliente no coincide cuando se crea un NPS desde una oportunidad');
    }
}