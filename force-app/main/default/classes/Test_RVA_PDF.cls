@isTest
public class Test_RVA_PDF {
    @TestSetup
    public static void crearInforme() {
        ID modeloUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Modelo')
                                    .getRecordTypeId();

        ID marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Marcas')
                                    .getRecordTypeId();
        
        ID RTIdAcc = Schema.SObjectType.Account
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('PersonAccount')
                                    .getRecordTypeId();

        Catalogo_UDC__c Toyota = new Catalogo_UDC__c (
                                            Name = 'KIA',
                                            productcode__c = 'TOY',
                                            description1__c = 'Toyota',
                                            ExternalId__c = 'TEST_TOY',
                                            RecordTypeId = marcasUDCID
        								);
        
        Catalogo_UDC__c prius = new Catalogo_UDC__c (
                                            Name = 'Prius',
                                            productcode__c = 'PRI',
                                            description1__c = 'Prius',
                                            ExternalId__c = 'TEST_PRI',
                                            RecordTypeId = modeloUDCID
                                        );
        
        insert prius;
        insert Toyota;
        
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());

        Account acc = new Account(Name = 'Cuenta Test',
                                  CurrencyIsoCode = 'USD',
                                  Secuencia_contactos__c = 0,
                                  Email__c = 'correo@test.com',
                                  Cedula__c = '321321',
                                  Phone = '88888888');

        acc.Direccion__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ornare, ' +
                        'magna eget ultricies ultrices, massa lorem pretium sapien, et blandit tellus quam sit';
        acc.CodigoCliente__c = '321321';
        insert acc;

        Account acc2 = new Account ();
        acc2.RecordTypeId = RTIdAcc;											
        acc2.FirstName = 'jkrva12';
        acc2.LastName = 'Contact';
        acc2.Cedula__c = '123abc2';
        acc2.Email__c = 'prueba@industrias.com';
        acc2.Phone = '88888888';
        acc2.Direccion__c = 'calle 1';

        insert acc2;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        product2 p = new Product2();
        p.Name = 'test';
        p.Marca_P__c = 'Kia';
        p.ProductCode__c = 'TESTPCode';
        insert p;
        
        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = pricebookId;
        pbEntry.Product2Id = p.Id;
        pbEntry.UnitPrice = 100.00;
        pbEntry.IsActive = true;
        insert pbEntry;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TEST OPP CTE1';
        opp.AccountId = acc.ID;
        opp.StageName = 'Contacto Exitoso';
        opp.CloseDate = date.today();
        opp.C_digo_de_Oportunidad_Numerico__c = 12345566;
        opp.Marca__c = 'Kia';
        opp.Marca_UDC__c = Toyota.ID;
        opp.ModeloVehiculo__c = prius.ID;
        opp.Sucursal__c = 'Kia El Retiro'; 
        opp.Pricebook2Id = pricebookId;
        opp.Forma_de_Pago_Multiple__c = 'Contado';
        insert opp;
        
        Informe_de_Negociaci_n__c infNeg = new Informe_de_Negociaci_n__c ();
        infNeg.total_negociado__c = 5800;
        infNeg.Oportunidad__c = opp.ID;
        infNeg.Cuenta__c = acc.ID;
        insert infNeg;
    }
    
    @isTest
    public static void testPDF (){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Exchange_Rate_By_Date__c tasa_cambio2 = new Exchange_Rate_By_Date__c () ;
        tasa_cambio2.Name = 'USD';
        tasa_cambio2.Tasa__c = 34.5;
        insert tasa_cambio2;

        Account accPersonal = [
            SELECT Id 
            FROM Account
            WHERE RecordType.DeveloperName = 'PersonAccount'
        ];
        
        List<Opportunity> opp_casapellas =
            [SELECT ID
            FROM Opportunity 
            ];
        
        Informe_de_Negociaci_n__c informetest2 = new Informe_de_Negociaci_n__c();
        informetest2.Facturar_a_nombre_de__c = accPersonal.Id; 					//Factura a nombre de Cuenta
        informetest2.Exchange_Rate_By_Date__c = tasa_cambio2.Id;			//Exhange Rate By Date
        informetest2.Cuenta__c = accPersonal.Id;									//Cuenta 
        informetest2.Oportunidad__c = opp_casapellas[0].Id; 					//Oportunidad
        informetest2.Reservar__c = true; 									//Reservar
        informetest2.Chasis__c = '298328';									//Chasis
        informetest2.Motor__c = '298383';									//Motor
        informetest2.Color_Externo__c = 'Blanco Perla';
        informetest2.Precio_de_Lista_sin_IMP__c = 380020;					//Precio de Lista sin IMP
        informetest2.Precio_de_Venta__c = 430030;							//Precio de Venta
        informetest2.total_negociado__c = 430030;							//Precio de Venta
        informetest2.fechafactura__c = Date.valueOf('2020-11-24');
        
        insert informetest2;
            
        test.startTest();
        PageReference pageRef = Page.Reporte_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('compania','');
        pageRef.getParameters().put('lineasDeNegocio','');
        pageRef.getParameters().put('montoMaximo','');
        pageRef.getParameters().put('tiposDePago','Todos');
        Ctrl_Reporte_Ventas_Automotores pdf = new Ctrl_Reporte_Ventas_Automotores();
    
        test.stopTest();
       
    }
    
     @isTest
    public static void testPDF2 (){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Exchange_Rate_By_Date__c tasa_cambio = new Exchange_Rate_By_Date__c () ;
        
        tasa_cambio.Name = 'USD';
        tasa_cambio.Tasa__c = 34.5;
        
        insert tasa_cambio;
        
		Account accPersonal = [
            SELECT Id 
            FROM Account
            WHERE RecordType.DeveloperName = 'PersonAccount'
        ];
        
        List<Opportunity> opp_casapellas =
            [SELECT ID
            FROM Opportunity 
            ];
        
        Informe_de_Negociaci_n__c informetest = new Informe_de_Negociaci_n__c();
        
        informetest.Facturar_a_nombre_de__c = accPersonal.Id; 					//Factura a nombre de Cuenta
        informetest.Exchange_Rate_By_Date__c = tasa_cambio.Id;			//Exhange Rate By Date
        informetest.Cuenta__c = accPersonal.Id;									//Cuenta 
        informetest.Oportunidad__c = opp_casapellas[0].Id; 					//Oportunidad
        informetest.Reservar__c = true; 									//Reservar
        informetest.Chasis__c = '298328';									//Chasis
        informetest.Motor__c = '298383';									//Motor
        informetest.Color_Externo__c = 'Blanco Perla';
        informetest.Precio_de_Lista_sin_IMP__c = 380020;					//Precio de Lista sin IMP
        informetest.Precio_de_Venta__c = 430030;							//Precio de Venta
        informetest.total_negociado__c = 430030;							//Precio de Venta
        informetest.fechafactura__c = Date.valueOf('2020-11-24');
        insert informetest;
        
        test.startTest();        
        
        PageReference pageRef = Page.Reporte_Ventas_Automotores;
        Test.setCurrentPage(pageRef);

        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('compania','');
        pageRef.getParameters().put('lineasDeNegocio','');
        pageRef.getParameters().put('montoMaximo','');
        pageRef.getParameters().put('tiposDePago','Todos');
        Ctrl_Reporte_Ventas_Automotores pdf = new Ctrl_Reporte_Ventas_Automotores();
    
        test.stopTest();
       
    }
    
      @isTest
    public static void testPDF3 (){
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Exchange_Rate_By_Date__c tasa_cambio = new Exchange_Rate_By_Date__c () ;
        tasa_cambio.Name = 'USD';
        tasa_cambio.Tasa__c = 34.5;
        
        insert tasa_cambio;

        Account accPersonal = [
            SELECT Id 
            FROM Account
            WHERE RecordType.DeveloperName = 'PersonAccount'
        ];
        
        Id RTIdUDC= Schema.SObjectType.Catalogo_UDC__c.getRecordTypeInfosByName().get('Companias').getRecordTypeId();

        Catalogo_UDC__c compania = new Catalogo_UDC__c();
        compania.Name='CASA PELLAS S.A';
        compania.ExternalId__c='0001';
        compania.RecordTypeId = RTIdUDC;
        insert compania;

        Id RTIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Principal_Autos').getRecordTypeId();
        
        Opportunity opp_casapellas = new Opportunity();
        opp_casapellas.RecordTypeId = RTIdOpp;
        opp_casapellas.Compa_a__c = compania.Id;
        opp_casapellas.AccountID = accPersonal.Id;
        opp_casapellas.Name = 'Name';
        opp_casapellas.StageName = 'Contacto Exitoso';
        opp_casapellas.CloseDate = Date.today() + 1;
        opp_casapellas.Sucursal__c = 'Altamira';
        insert opp_casapellas;
        
        Informe_de_Negociaci_n__c informetest = new Informe_de_Negociaci_n__c();
        informetest.Facturar_a_nombre_de__c = accPersonal.Id; 					//Factura a nombre de Cuenta
        informetest.Exchange_Rate_By_Date__c = tasa_cambio.Id;			//Exhange Rate By Date
        informetest.Cuenta__c = accPersonal.Id;							//Cuenta 
        informetest.Oportunidad__c = opp_casapellas.ID; 					//Oportunidad
        informetest.Reservar__c = true; 									//Reservar
        informetest.Chasis__c = '298328';									//Chasis
        informetest.Motor__c = '298383';									//Motor
        informetest.Color_Externo__c = 'Blanco Perla';
        informetest.Precio_de_Lista_sin_IMP__c = 380020;					//Precio de Lista sin IMP
        informetest.Precio_de_Venta__c = 430030;
        informetest.total_negociado__c = 430030;
        informetest.fechafactura__c = Date.valueOf('2020-11-24');
        //Precio de Venta
        
        insert informetest;
        
        test.startTest();
        
        PageReference pageRef = Page.Reporte_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('compania', compania.Name);
        pageRef.getParameters().put('lineasDeNegocio', '');
        pageRef.getParameters().put('montoMaximo','');
        pageRef.getParameters().put('tiposDePago','Todos');
        Ctrl_Reporte_Ventas_Automotores pdf = new Ctrl_Reporte_Ventas_Automotores();
    
        test.stopTest();
       
    }
    
    @isTest
	public static void filtradoTest() {
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        List<Informe_de_Negociaci_n__c> infList = 
            [SELECT ID, fechafactura__c
            FROM Informe_de_Negociaci_n__c
            ];
        
        List<Account> accList =
            [SELECT ID
            FROM Account 
            ];

        List<AllRecibidos__c> recibosContado = new List<AllRecibidos__c>();
        List<Recibos_de_la_negociaci_n__c> recNegList = new List<Recibos_de_la_negociaci_n__c>();

        for (Integer i = 0; i < 4; i++) {
            AllRecibidos__c rec = new AllRecibidos__c();
            rec.Saldo__c = 1450;
            rec.CodigoInstrumentoPago__c = '.';
            rec.Cuenta__c = accList[0].ID;

            recibosContado.add(rec);
        }

        insert recibosContado;

        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            recNeg.Recibos__c = recibosContado[i].ID;
            recNeg.Informe_de_Negociaci_n__c = infList[0].ID;
            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1450;

            recNegList.add(recNeg);
        }

        insert recNegList;

        for (Informe_de_Negociaci_n__c inf : infList) {
            inf.fechafactura__c = Date.valueOf('2020-11-24');
        }

        update infList;

        Test.startTest();
        PageReference pageRef = Page.Reporte_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('compania', '');
        pageRef.getParameters().put('lineasDeNegocio', '');
        pageRef.getParameters().put('montoMaximo','');
        pageRef.getParameters().put('tiposDePago','Efectivo');
        Ctrl_Reporte_Ventas_Automotores pdf = new Ctrl_Reporte_Ventas_Automotores();
        Test.stopTest();
    }

}