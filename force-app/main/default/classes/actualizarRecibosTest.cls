@isTest
public class actualizarRecibosTest {
    @TestSetup
    public static void crearRecibos() {
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

        AllRecibidos__c rec = new AllRecibidos__c();
        rec.Id_Externo__c = '48_3150_PR_2012-08-08_E03     _00080_!_null_100002_85_SISTEMAS CONTROLES E INGENIERIA SA_1094846';
        rec.Cuenta__c = acc.ID;
        rec.Instrumento_de_pago__c = 'Efectivo';

        insert rec;
    }

    @IsTest
    static void actualizarRecibosTest(){
        Test.startTest();
        actualizarRecibos.actualizarRecibos();
        Test.stopTest();
    }
}