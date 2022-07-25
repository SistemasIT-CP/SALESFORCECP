@isTest
public class RecibosTriggerTest {
    @TestSetup
    public static void crearCuentasYRecibos(){
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
    }

    @IsTest
    public static void crearRecibosTest(){
        List<AllRecibidos__c> recList = new List<AllRecibidos__c>();

        List<String> codigoInst = new List<String>{'.', '!', '?', 'N', 'T'};
        List<String> instList = new List<String>{'Efectivo', 
            									 'Cheque', 
            									 'Tarjeta de credito', 
            									 'Deposito bancario', 
            									 'Transferencia',
                                                 'Carta banco'};
        
        List<Account> accList = 
            [SELECT ID
            FROM Account 
            ];

        for (String str : codigoInst) {
	        AllRecibidos__c recibo1 = new AllRecibidos__c();
            recibo1.Cuenta__c = accList[0].ID;
            recibo1.CodigoInstrumentoPago__c = str;
    
            recList.add(recibo1);            
        }

		for (String str : instList) {
	        AllRecibidos__c recibo2 = new AllRecibidos__c();
            recibo2.Cuenta__c = accList[0].ID;
            recibo2.Instrumento_de_pago__c = str;
    
            recList.add(recibo2);            
        }

        Test.startTest();
        insert recList;
        Test.stopTest();
    }
    
    @IsTest
    public static void actualizarRecibosTest(){
        List<AllRecibidos__c> recList = new List<AllRecibidos__c>();

        List<Account> accList = 
            [SELECT ID
            FROM Account 
            ];

        AllRecibidos__c recibo1 = new AllRecibidos__c();
        recibo1.Cuenta__c = accList[0].ID;
        recibo1.CodigoInstrumentoPago__c = '.';

        recList.add(recibo1);

        AllRecibidos__c recibo2 = new AllRecibidos__c();
        recibo2.Cuenta__c = accList[0].ID;
        recibo2.Instrumento_de_pago__c = 'Cheque';

        recList.add(recibo2);

        insert recList;

        recList[0].CodigoInstrumentoPago__c = '!';
        recList[1].Instrumento_de_pago__c = 'Transferencia';

        Test.startTest();
        update recList;
        Test.stopTest();
    }
}