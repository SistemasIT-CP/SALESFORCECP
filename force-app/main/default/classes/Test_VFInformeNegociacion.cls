@isTest
public class Test_VFInformeNegociacion {
    @TestSetup
    static void createCatalogosUDC(){
        ID modelosID = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Modelo')
                                .getRecordTypeId();

        ID companiasID = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Companias')
                                .getRecordTypeId();

        ID linNegID = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Lineas_de_negocio')
                                .getRecordTypeId();

        ID marcaID = Schema.SObjectType.Catalogo_UDC__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Marcas')
                                .getRecordTypeId();

        List<Catalogo_UDC__c> catalogoList = new List<Catalogo_UDC__c>();

        Catalogo_UDC__c fornuter = new Catalogo_UDC__c(Name = 'FORTUNER', RecordTypeId = modelosID);
        Catalogo_UDC__c casaPellas = new Catalogo_UDC__c(Name = 'CASA PELLAS, S.A', RecordTypeId = companiasID);
        Catalogo_UDC__c autosToyota = new Catalogo_UDC__c(Name = 'Autos Toyota', RecordTypeId = linNegID);
        Catalogo_UDC__c toyota = new Catalogo_UDC__c(Name = 'TOYOTA', RecordTypeId = marcaID);
        
        catalogoList.add(fornuter);
        catalogoList.add(casaPellas);
        catalogoList.add(autosToyota);
        catalogoList.add(toyota);

        insert catalogoList;
        
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID RTIdAcc = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();  
        
        Account acc = new Account ();
        acc.RecordTypeId = 	RTIdAcc;											
        acc.FirstName = 'Industrias ACME';
        acc.LastName = 'S.A de C.V';
        acc.Cedula__c = '123QWERTY';
        acc.Email__c = 'acme@industrias.com';
        acc.Phone = '12345678';
        acc.Direccion__c = 'En algún lugar, de un gran país';
        insert acc;
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            Codigovehiculo__c = 'Pro-X',
            Marca_P__c = 'Kia',
            ProductCode__c = 'sku_producto',
            isActive = true,
            modelogenerico__c = 'modelogenerico',
            modelofabrica__c = 'modelofabrica',
            CurrencyIsoCode = 'USD'
        );
        insert prod;
    }
    
    @isTest 
    public static void testInformeNegociacionConIntercambio() {        
        List<Catalogo_UDC__c> companiaList =
            [SELECT ID
            FROM Catalogo_UDC__c
            WHERE RecordType.DeveloperName = 'Companias'
            ];
        
        List<Account> accList =
            [SELECT ID
            FROM Account
            ];
        
        Product2 producto = [
            SELECT Id 
            FROM Product2
            LIMIT 1
        ];
        
        // ****** Crea Tasa de Cambio *** //
        
        Exchange_Rate_By_Date__c tasa_cambio = new Exchange_Rate_By_Date__c () ;
        
        tasa_cambio.Name = 'USD';
        tasa_cambio.Tasa__c = 34.5;
        
        insert tasa_cambio;
        
        // **** Crea cuenta *** //
        Test.setMock(WebServiceMock.class, new Test_MockWSAccesorios());
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        
        // **** Crea Oportunidad **** //
        
        Opportunity opp_casapellas = new Opportunity () ;
        
        Id RTIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Principal_Autos').getRecordTypeId();
        
        Catalogo_UDC__c modelo_vehiculo = [SELECT Id From Catalogo_UDC__c WHERE Name = 'FORTUNER' LIMIT 1];
        Catalogo_UDC__c compania = [SELECT Id From Catalogo_UDC__c WHERE Name = 'CASA PELLAS, S.A' LIMIT 1];
        Catalogo_UDC__c ln = [SELECT Id From Catalogo_UDC__c WHERE Name = 'Autos Toyota' LIMIT 1];
        Catalogo_UDC__c marca = [SELECT Id From Catalogo_UDC__c WHERE Name = 'TOYOTA' LIMIT 1];
        
        opp_casapellas.RecordTypeId = RTIdOpp;			
        opp_casapellas.AccountId = accList[0].Id;
        opp_casapellas.Name = 'OTestNDOC2020';
        opp_casapellas.ModeloVehiculo__c = 	modelo_vehiculo.Id;											//'a023K000000hKkwQAE';
        opp_casapellas.CloseDate = DATE.TODAY()+9;
        opp_casapellas.Sucursal__c = 'Altamira';
        opp_casapellas.Desea_realizar_intercambio__c = 'NO';
        opp_casapellas.StageName = 'Contacto Exitoso';
        opp_casapellas.Compa_a__c = 	compania.Id;													//'a023K000000hKKYQA2';				//Casa Pellas
        opp_casapellas.L_neas_de_Negocio__c = ln.Id;														//'a023K000000hKPsQAM';		//TOYOTA
        
        insert opp_casapellas;
        
        Task newTask = new Task(whatID = Opp_casapellas.Id, Subject='¿Algo Interesante qué poner?'); 
        insert newTask;
        
        opp_casapellas.Oportunidad_Interna_Generada__c = true;
        opp_casapellas.Marca_UDC__c = marca.Id;																		//'a023K000000hKOIQA2';
        
        opp_casapellas.Walk_Around__c = 'No';
        opp_casapellas.Prueba_de_manejo__c = 'No';
        opp_casapellas.Tour_CP__c = 'No';
        
        opp_casapellas.Reserva_Recibo__c = 'No';
        opp_casapellas.Forma_de_Pago_Multiple__c = 'Ciclo Casa Pellas';
        opp_casapellas.Banco__c= 'Lafise';
        opp_casapellas.StageName = 'Seleccionando Modelo';
        
        update opp_casapellas;
        
        // ***** Crea Accesorios *** //
        
        Accesorios__c accesorio1 = new Accesorios__c ();
        
        accesorio1.Name = 'a1234567';      					 			//Nombre de Accesorio
        accesorio1.CodigoCompania__c='E01'; 							//Código de la compañia
        accesorio1.NombreCompania__c = 'CASA PELLAS, S.A.'; 			//Nombre de la Compañia
        accesorio1.CodigoParte__c = '1234567890';						//Código de la parte  
        accesorio1.CodParteEquivalente__c = '1234567800';				//código de la parte equivalente
        accesorio1.Compa_a_UDC__c = companiaList[0].ID;
        accesorio1.CantidadMinima__c =22; 								//Cantidad mínima permitida
        accesorio1.Precio__c = 69.00;									//Precio del accesorio
        accesorio1.Descripcion__c = 'ALARMA OMEGA CP';					//Descripción del accesorip
        accesorio1.DescripcionAmplia__c = 'ALARMA OMEGA CASA PELLAS EXCAL 560 NSCP SIN BOCINA';
        //Divisa
        insert accesorio1;
        
        Accesorios__c accesorio2 = new Accesorios__c ();
        
        accesorio2.Name = 'a1234568';      					 			//Nombre de Accesorio
        accesorio2.CodigoCompania__c='E01'; 							//Código de la compañia
        accesorio2.NombreCompania__c = 'CASA PELLAS, S.A.'; 			//Nombre de la Compañia
        accesorio2.CodigoParte__c = '1234567891';						//Código de la parte  
        accesorio2.CodParteEquivalente__c = '1234567811';				//código de la parte equivalente
        accesorio2.Compa_a_UDC__c = companiaList[0].ID;
        accesorio2.CantidadMinima__c =34; 								//Cantidad mínima permitida
        accesorio2.Precio__c = 100.00;									//Precio del accesorio
        accesorio2.Descripcion__c = 'EMP.RET.PALANCA';					//Descripción del accesorip
        accesorio2.DescripcionAmplia__c = 'EMPAQUE RETENEDOR PALANCA CAMB';
        
        insert accesorio2;
        
        // ***** Crea Combo *** //
        
        Combo__c alarma = new Combo__c();
        
        alarma.Name = 'ALARMA';											//Nombre del Combo
        alarma.Descripci_n__c = 'ALARMA OMEGA CASA PELLAS';				//Descripción
        
        Combo__c alfombra = new Combo__c();
        
        alarma.Name = 'ALFOMBRA CAFE';//Nombre del Combo
        alarma.Descripci_n__c = 'ALFOMBRA CAFE DE CARGA FOURTUNER';		//Descripción
        
        insert alarma;
        insert alfombra;	
        
        // **** Crea Combo Accesorio **** ///
        
        Combo_Accesorio__c combo_accesorio1 = new Combo_Accesorio__c ();
        
        					//Nombre del accesorio
        combo_accesorio1.Combo__c = alarma.Id;							//Combo
        combo_accesorio1.Cantidad__c = 2;								//Cantidad
        combo_accesorio1.Accesorio__c = accesorio1.Id; 					//Accesorio
        
        insert combo_accesorio1;
        
        Combo_Accesorio__c combo_accesorio2 = new Combo_Accesorio__c ();
        
         					//Nombre del accesorio
        combo_accesorio2.Combo__c = alfombra.Id;						//Combo
        combo_accesorio2.Cantidad__c = 2;								//Cantidad
        combo_accesorio2.Accesorio__c = accesorio2.Id; 					//Accesorio
        
        insert combo_accesorio2;
        
        Combo_Accesorio__c combo_accesorio3 = new Combo_Accesorio__c ();
        
        					//Nombre del accesorio
        combo_accesorio3.Combo__c = alfombra.Id;						//Combo
        combo_accesorio3.Cantidad__c = 1;								//Cantidad
        combo_accesorio3.Accesorio__c = accesorio1.Id; 					//Accesorio
        
        insert combo_accesorio3;
        
        // ***** Crea Informe de Negociación **** ///
        
        Informe_de_Negociaci_n__c informe01 = new Informe_de_Negociaci_n__c();
        
        informe01.Facturar_a_nombre_de__c = accList[0].Id; 					//Factura a nombre de Cuenta
        informe01.Exchange_Rate_By_Date__c = tasa_cambio.Id;			//Exhange Rate By Date
        informe01.Cuenta__c = accList[0].Id;									//Cuenta 
        informe01.Oportunidad__c = opp_casapellas.Id; 					//Oportunidad
        informe01.Reservar__c = false; 									//Reservar
        informe01.Chasis__c = '298388';									//Chasis
        informe01.Motor__c = '298388';									//Motor
        informe01.Color_Externo__c = 'Blanco Perla';
        informe01.Precio_de_Lista_sin_IMP__c = 38000;					//Precio de Lista sin IMP
        informe01.Precio_de_Venta__c = 43000;							//Precio de Venta
        informe01.total_negociado__c = 40000;
        informe01.Producto__c = producto.Id;
        
        insert informe01;
        
        // **** Crea Recibos **** //
        
       	Id RTIdPrincipal = Schema.SObjectType.AllRecibidos__c.getRecordTypeInfosByName().get('Principal').getRecordTypeId();
        //Chequear si se usa este rt
        //Id RTIdIntercambio = Schema.SObjectType.AllRecibidos__c.getRecordTypeInfosByName().get('Intercambio').getRecordTypeId();
        
        AllRecibidos__c recibo1 = new AllRecibidos__c () ;
        recibo1.RecordTypeId = RTIdPrincipal;
        recibo1.Concepto__c  = 'Reservación';
        recibo1.MontoAplicado__c = 50000;
        recibo1.Saldo__c = 50000;
        recibo1.Cuenta__c =  accList[0].Id;
        recibo1.Incluir_Informe_Negociacion__c = true;
        recibo1.Informe_de_Negociaci_n__c = informe01.Id ;
        recibo1.Instrumento_de_pago__c = 'Efectivo'; 
        
        insert recibo1;
        
        Recibos_de_la_negociaci_n__c reciboNeg = new Recibos_de_la_negociaci_n__c ();
        reciboNeg.Recibos__c = recibo1.Id;
        reciboNeg.Monto_aplicado_a_la_negociaci_n__c = 10000;
        reciboNeg.Informe_de_Negociaci_n__c = informe01.Id;
        insert reciboNeg;
        
        Accesorios_del_informe__c accInforme = new Accesorios_del_informe__c ();
        accInforme.Accesorio__c = accesorio1.Id;
        accInforme.Cantidad__c = 1;
        accInforme.Estado__c = 'No solicitado';
        accInforme.InformeNegociacion__c = informe01.Id;
        
        insert accInforme;
        
        test.startTest();
        PageReference pageRef = Page.InformeDeNegociacion;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(informe01);
        CtrlInformeDeNegociacion pcc = new CtrlInformeDeNegociacion (sc);
        Test.setCurrentPage(pageRef);
        test.stopTest();
    } 
        
}