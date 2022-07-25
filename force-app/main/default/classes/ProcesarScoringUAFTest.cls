@isTest
public class ProcesarScoringUAFTest {
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

        Catalogo_UDC__c argentina = new Catalogo_UDC__c();
        argentina.Name = 'Argentina';
        argentina.productcode__c = 'ARG';
        argentina.RecordTypeId = paisUDCID;

        Catalogo_UDC__c nicaragua = new Catalogo_UDC__c();
        nicaragua.Name = 'Nicaragua';
        nicaragua.productcode__c = 'NIC';
        nicaragua.RecordTypeId = paisUDCID;

        Catalogo_UDC__c comercio = new Catalogo_UDC__c();
        comercio.Name = 'Comercio';
        comercio.productcode__c = 'CMR';
        comercio.RecordTypeId = actEconomicaUDCID;

        Catalogo_UDC__c renta = new Catalogo_UDC__c();
        renta.Name = 'Renta de Vehículos';
        renta.productcode__c = 'REN';
        renta.RecordTypeId = actEconomicaUDCID;

        Catalogo_UDC__c ingeniero = new Catalogo_UDC__c();
        ingeniero.Name = 'Ingeniero en Sistemas';
        ingeniero.productcode__c = 'ING';
        ingeniero.RecordTypeId = profesionUDCID;

        Catalogo_UDC__c tecnico = new Catalogo_UDC__c();
        tecnico.Name = 'Técnico en Computación';
        tecnico.productcode__c = 'TEC';
        tecnico.RecordTypeId = ocupacionUDCID;

        List<Catalogo_UDC__c> catList = new List<Catalogo_UDC__c> {argentina,
                                                                  nicaragua,
                                                                  comercio,
                                                                  renta,
                                                                  ingeniero,
                                                                  tecnico
                                                                } ;

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
        acc.Actividad_economica_UDC__c = renta.ID;
        acc.Pa_s__c = argentina.ID;
        acc.Cedula__c = '123juridica';
        acc.Tipo_Cliente__c = 'Habitual';
        acc.Tipo_de_Indentificaci_n__c = 'Otros';
        acc.Tipo_de_cliente__c = 'Organizaciones sin fines de lucro';
        acc.Email__c = 'email@email.com';
        
        insert acc;
        
        Account pAcc = new Account();

       	pAcc.LastName = 'Account';
        pAcc.FirstName = 'Test N';
        pAcc.Nivel_organizacional__c = 'Asalariado';
        pAcc.Ocupacion_UDC__c = tecnico.ID;
        pAcc.Actividad_economica_UDC__c = comercio.ID;
        pAcc.Profesion_UDC__c = ingeniero.ID;
        pAcc.Cedula__c = '123natural';
        pAcc.Pa_s__c = nicaragua.ID;
        pAcc.Tipo_Cliente__c = 'Nuevo';
        pAcc.Tipo_de_Indentificaci_n__c = 'Otros';
        pAcc.Tipo_de_cliente__c = 'Sujeto Obligado';
        pAcc.Email__c = 'email@email.com';
        pAcc.RecordTypeId = personAccountID;
        
        insert pAcc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.Sucursal__c = 'Estelí';
        opp.Tipo_de_relaci_n_econ_mica__c = 'Contado';
        opp.AccountId = acc.ID;
        opp.Canal_Contrata__c = 'Distribuidor Autorizado';
        opp.Tipo_de_transacci_n__c = 'Compra de Contado';
        opp.Responsable_del_pago__c = 'Facturado';
        opp.Origen_de_los_fondos__c = 'Otros';
        opp.StageName = 'Contacto Exitoso';
        opp.Tipo_de_relaci_n_econ_mica__c = 'Contado';
        opp.CloseDate = Date.today() + 7;
        
        insert opp;
        
        Opportunity nOpp = new Opportunity();
        nOpp.Name = 'Test';
        nOpp.Sucursal__c = 'Kia El Retiro';
        nOpp.Tipo_de_relaci_n_econ_mica__c = 'Contado';
        nOpp.AccountId = pAcc.ID;
        nOpp.Canal_Contrata__c = 'Sucursales Propias - Detalle';
        nOpp.Forma_de_Pago_UAF__c = 'Efectivo';
        nOpp.Tipo_de_transacci_n__c = 'Anticipo o Prima';
        nOpp.Responsable_del_pago__c = 'Tercero Familiar';
        nOpp.Origen_de_los_fondos__c = 'Donaciones (Giro Negocio)';
        nOpp.StageName = 'Contacto Exitoso';
        nOpp.Tipo_de_relaci_n_econ_mica__c = 'Licitaciones';
        nOpp.CloseDate = Date.today() + 7;
        
        insert nOpp;

        Informe_de_Negociaci_n__c inf1 = new Informe_de_Negociaci_n__c();
        inf1.Oportunidad__c = opp.ID;
        inf1.total_negociado__c  = 2;
        
        insert inf1;
        
        Informe_de_Negociaci_n__c inf2 = new Informe_de_Negociaci_n__c();
        inf2.Oportunidad__c = nOpp.ID;
        inf2.total_negociado__c  = 2;

        insert inf2;

        List<AllRecibidos__c> recibosList = new List<AllRecibidos__c>();
        List<Recibos_de_la_negociaci_n__c> recibosNegList = new List<Recibos_de_la_negociaci_n__c>();

        for (Integer i = 0; i < 2; i++) {
            AllRecibidos__c rec = new AllRecibidos__c();
            if (i == 0) {
                rec.Instrumento_de_pago__c = 'Efectivo';
                rec.Cuenta__c = pAcc.ID;
            } else {
                rec.Instrumento_de_pago__c = 'Transferencia';
                rec.Cuenta__c = acc.ID;
            }

            rec.Saldo__c = 2;

            recibosList.add(rec);
        }

        insert recibosList;

        for (Integer i = 0; i < 4; i++) {
            Recibos_de_la_negociaci_n__c recNeg = new Recibos_de_la_negociaci_n__c();
            if (Math.mod(i, 4) == 0) {
                recNeg.Recibos__c = recibosList[0].ID;
                recNeg.Informe_de_Negociaci_n__c = inf1.ID;
            } else if (Math.mod(i, 4) == 1) {
                recNeg.Recibos__c = recibosList[0].ID;
                recNeg.Informe_de_Negociaci_n__c = inf2.ID;
            } else if (Math.mod(i, 4) == 2) {
                recNeg.Recibos__c = recibosList[1].ID;
                recNeg.Informe_de_Negociaci_n__c = inf1.ID;
            } else {
                recNeg.Recibos__c = recibosList[1].ID;
                recNeg.Informe_de_Negociaci_n__c = inf2.ID;
            }

            recNeg.Monto_aplicado_a_la_negociaci_n__c = 1;

            recibosNegList.add(recNeg);
        }

        insert recibosNegList;

    }
    
    @isTest
    public static void generarCalificacionTestJuridica() {        
        List<Opportunity> oppList = [
            SELECT ID, AccountID, Tipo_de_relaci_n_econ_mica__c,
                    Canal_Contrata__c, Sucursal__c, Tipo_de_transacci_n__c,
                    Responsable_del_pago__c, Origen_de_los_fondos__c
            FROM Opportunity
            WHERE Name LIKE '%Test J Account%'
            ];

        Test.startTest();
        Map<ID, String> calificacion = ProcesarScoringUAF.generarCalificacion(oppList);
        Test.stopTest();

        System.assertEquals('3.20_3.200', calificacion.get(oppList[0].ID), 'La calificación no coincide con lo esperado en cuentas juridicas.');
    }
    
    @isTest
    public static void generarCalificacionTestPersonal() {
        List<Opportunity> oppList = [
            SELECT ID, AccountID, Tipo_de_relaci_n_econ_mica__c,
                    Canal_Contrata__c, Sucursal__c, Tipo_de_transacci_n__c,
                    Responsable_del_pago__c, Origen_de_los_fondos__c
            FROM Opportunity
            WHERE Name LIKE '%Test N Account%'
            ];
        
        Test.startTest();
        Map<ID, String> calificacion = ProcesarScoringUAF.generarCalificacion(oppList);
        Test.stopTest();

        System.assertEquals('3.00_2.350', calificacion.get(oppList[0].ID), 'La calificación no coincide con lo esperado en cuentas personales.');
    }
}