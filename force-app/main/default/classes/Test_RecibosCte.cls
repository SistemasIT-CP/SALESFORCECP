@isTest()
public class Test_RecibosCte {
    @TestSetup
    public static void crearCuenta(){
        ID juridicaAccountID = Schema.SObjectType.Account
                                .getRecordTypeInfosByDeveloperName()
                                .get('Juridicos')
                                .getRecordTypeId();

        Account a = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 2,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '32132188');

        a.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        a.RecordTypeID = juridicaAccountID;
        a.CodigoCliente__c = '321321';
        insert a;
    }
    
    @isTest()
    public static void testRecibos (){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Exchange_Rate_By_Date__c tasa_cambio = new Exchange_Rate_By_Date__c () ;
        tasa_cambio.Name = 'USD';
        tasa_cambio.Tasa__c = 34.5;
        insert tasa_cambio;
        
        Date closeDt = Date.Today();
        Id pricebookId = Test.getStandardPricebookId();
        
        Account a = [
            SELECT Id
            FROM Account
            LIMIT 1
        ];

		opportunity opp = new opportunity(
            Name ='testing DIE 4/6/2015',  
            AccountId = a.Id,
            StageName = 'Contacto Exitoso', 
            CloseDate = closeDt, 
            Pricebook2Id = pricebookId, 
            Sucursal__c='Altamira'
        );
		insert opp;
        
        // ***** Crea Informe de Negociación **** ///
        Informe_de_Negociaci_n__c informe01 = new Informe_de_Negociaci_n__c();
        
        informe01.Facturar_a_nombre_de__c = a.Id; 					//Factura a nombre de Cuenta
        informe01.Exchange_Rate_By_Date__c = tasa_cambio.Id;		//Exhange Rate By Date
        informe01.Cuenta__c = a.Id;									//Cuenta 
        informe01.Oportunidad__c = opp.Id; 							//Oportunidad
        informe01.Reservar__c = false; 								//Reservar
        informe01.Chasis__c = '298388';								//Chasis
        informe01.Motor__c = '298388';								//Motor
        informe01.Color_Externo__c = 'Blanco Perla';
        informe01.Precio_de_Lista_sin_IMP__c = 38000;				//Precio de Lista sin IMP
        informe01.Precio_de_Venta__c = 43000;						//Precio de Venta
        informe01.total_negociado__C = informe01.Precio_de_Venta__c; 
        
        insert informe01;
        
        // **** Crea Recibos **** //
        AllRecibidos__c recibo1 				= new AllRecibidos__c () ;
        recibo1.Concepto__c  					= 'Reservación';
        recibo1.MontoAplicado__c 				= 50000;
        recibo1.Saldo__c						= 50000;
        recibo1.Saldo_aplicado__c				= 0;
        recibo1.Cuenta__c 						= a.Id;
        recibo1.NumeroRecibido__c				= 12345;
        recibo1.C_digo_tipo_de_recibo__c		= 'PR';
        recibo1.Instrumento_de_pago__c = 'Efectivo';
        insert recibo1;
        
        Recibos_de_la_negociaci_n__c rNeg 		= new Recibos_de_la_negociaci_n__c ();
        rNeg.Informe_de_Negociaci_n__c 			= informe01.Id;
        rNeg.Recibos__c 						= recibo1.Id;
        rNeg.Monto_aplicado_a_la_negociaci_n__c = 10;
        insert rNeg;
        
        test.startTest();
        PageReference pageRef = Page.RecibosCte;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', informe01.Id);
        
        Ctrl_Recibos pcc = new Ctrl_Recibos();
        pcc.validaSeleccionados();
        pcc.limpiaBusqueda();
        Test.setCurrentPage(pageRef);
        
        rNeg.Monto_aplicado_a_la_negociaci_n__c = 0;
        update rNeg;
        rNeg.Monto_aplicado_a_la_negociaci_n__c = 100;
        update rNeg;
        
        delete [SELECT ID FROM Recibos_de_la_negociaci_n__c];
        
        delete informe01;
        test.stopTest();
    }
}