@isTest
public with sharing class ReciboDeNegociacionTriggerTest {
    @TestSetup
    static void crearRecibo() {
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

        AllRecibidos__c recibo = new AllRecibidos__c();
        recibo.Cuenta__c = acc.ID;
        recibo.Saldo__c = 10000;
        recibo.Instrumento_de_pago__c = 'Efectivo';
        insert recibo;

        Informe_de_Negociaci_n__c inf = new Informe_de_Negociaci_n__c();
        inf.total_negociado__C = 50000; 
        insert inf;
    }

    @IsTest
    public static void updatearMontoErroneo(){
        List<Informe_de_Negociaci_n__c> inf = 
            [SELECT ID
            FROM Informe_de_Negociaci_n__c
            ];

        List<AllRecibidos__c> rec = 
            [SELECT ID, Saldo_aplicado__c, Saldo_disponible__c
            FROM AllRecibidos__c
            ];

        Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
        recNeg.Recibos__c = rec[0].ID;
        recNeg.Informe_de_Negociaci_n__c = inf[0].ID;
        recNeg.Monto_aplicado_a_la_negociaci_n__c = 0;
        insert recNeg;

        recNeg.Monto_aplicado_a_la_negociaci_n__c = 50000;

        Test.startTest();
        Database.SaveResult sr = Database.update(recNeg, false);
        Test.stopTest();

        Decimal montoEx = recNeg.Monto_aplicado_a_la_negociaci_n__c - rec[0].Saldo_disponible__c;
        
        List<AllRecibidos__c> recibo = 
            [SELECT ID, Saldo_aplicado__c, Saldo_disponible__c
            FROM AllRecibidos__c
            ];
    }

    @isTest
    public static void asociarReciboDeVehiculoSinCerrar() {
        ID principalId = Schema.SObjectType.AllRecibidos__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Principal')
                                    .getRecordTypeId();

        Id avaluoOpp = Schema.SObjectType.Opportunity
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Avaluo')
                                    .getRecordTypeId();

        Account acc = [
            SELECT Id 
            FROM Account 
            LIMIT 1
        ];

        Informe_de_Negociaci_n__c infNeg = [
            SELECT Id 
            FROM Informe_de_Negociaci_n__c
            LIMIT 1
        ];

        Opportunity oppAvaluo = new Opportunity();
        oppAvaluo.RecordTypeId = avaluoOpp;
        oppAvaluo.CloseDate = Date.today().addDays(7);
        oppAvaluo.AccountId = acc.Id;
        oppAvaluo.StageName = 'Cliente en espera de avaluo';
        oppAvaluo.Name = 'AVALUO/CUENTA TEST';
        insert oppAvaluo;

        Vehiculo__c veh = new Vehiculo__c();
        veh.Placa__c = '123456';
        veh.Kilometraje__c = '1000';
        veh.Precio_de_compra_aprobado_S_Autolote__c = 1500;
        veh.Chasis__c = 'CHASIS21345678912';
        insert veh;

        Vehiculo_de_la_Oportunidad__c vehOpp = new Vehiculo_de_la_Oportunidad__c();
        vehOpp.Oportunidad__c = oppAvaluo.Id;
        vehOpp.Vehiculo__c = veh.Id;
        insert vehOpp;

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.RecordTypeId = principalId;
        rec.Saldo__c = 1500;
        rec.Cuenta__c = acc.Id;
        rec.Vehiculo__c = veh.Id;
        rec.Instrumento_de_pago__c = 'Intercambio Autolote';
        insert rec;

        Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
        recNeg.Recibos__c = rec.Id;
        recNeg.Informe_de_Negociaci_n__c = infNeg.Id;
        recNeg.Monto_aplicado_a_la_negociaci_n__c = 1500;

        Test.startTest();
        Database.SaveResult sr = Database.insert(recNeg, false);
        Test.stopTest();

        System.assertEquals(false, sr.isSuccess(), 'La insercion de un recibo para un vehiculo sin finalizar no esta fallando cuando deberia');
        System.assertEquals('No puede asociarse el recibo de un vehiculo que aun no está liberado', sr.getErrors()[0].getMessage(), 'La insercion de un recibo para un vehiculo sin finalizar no esta fallando cuando deberia');
    }
}