@isTest
public class Test_RVA_vf {
 	@isTest
    public static void testPDF (){
        Id RTIdUDC= Schema.SObjectType.Catalogo_UDC__c
                        .getRecordTypeInfosByDeveloperName()
                        .get('Lineas_de_negocio')
                        .getRecordTypeId();
        
        Catalogo_UDC__c lineaNegPrincipal = new Catalogo_UDC__c();
        lineaNegPrincipal.Name='CASA PELLAS S.A';
        lineaNegPrincipal.ExternalId__c='0001';
        lineaNegPrincipal.RecordTypeId = RTIdUDC;
        lineaNegPrincipal.Permitido_para_inventario__c = true;
        insert lineaNegPrincipal;
        
        Catalogo_UDC__c lineaNegSecundaria = new Catalogo_UDC__c();
        lineaNegSecundaria.Name='CASA PELLAS S.A 2';
        lineaNegSecundaria.ExternalId__c='0002';
        lineaNegSecundaria.Permitido_para_inventario__c = true;
        insert lineaNegSecundaria;
        
        Test.startTest();
        PageReference pageRef = Page.ReporteGrl_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('lineasDeNegocio','(' + lineaNegPrincipal.Name + ')');
        pageRef.getParameters().put('montoMaximo', '5000');
        pageRef.getParameters().put('tiposDePago', '');
        
        Ctrl_ReporteGrl_Ventas_Automotores pdf = new Ctrl_ReporteGrl_Ventas_Automotores();
        pdf.fecha = DAte.today();
        pdf.fecha2 = date.today()+3;
        pdf.montoMaxSeleccionado = 'None';
        pdf.generar();
        Test.stopTest();
    }
    
    @isTest
    public static void testPDFSinCompania (){
        Test.startTest();
        PageReference pageRef = Page.ReporteGrl_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('lineasDeNegocio', '');
        pageRef.getParameters().put('montoMaximo', '5000');
        pageRef.getParameters().put('tiposDePago', '');
        
        Ctrl_ReporteGrl_Ventas_Automotores pdf = new Ctrl_ReporteGrl_Ventas_Automotores();
        pdf.fecha = DAte.today();
        pdf.fecha2 = date.today()+3;
        pdf.montoMaxSeleccionado = 'None';
        pdf.generar();
        Test.stopTest();
    }
    
    @isTest
    public static void getMontoMaximoTest() {
        PageReference pageRef = Page.ReporteGrl_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('lineasDeNegocio', '');
        pageRef.getParameters().put('montoMaximo', '5000');
        pageRef.getParameters().put('tiposDePago', '');
        
        Test.startTest();
        Ctrl_ReporteGrl_Ventas_Automotores pdf = new Ctrl_ReporteGrl_Ventas_Automotores();
        pdf.getMontoMaxList();
        Test.stopTest();
    }
    
    @isTest
    public static void getTipoDePagoTest() {
        PageReference pageRef = Page.ReporteGrl_Ventas_Automotores;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('fechaInicial','2020-11-20');
        pageRef.getParameters().put('fechaFinal','2020-11-30');
        pageRef.getParameters().put('lineasDeNegocio', '');
        pageRef.getParameters().put('montoMaximo', '5000');
        pageRef.getParameters().put('tiposDePago', '');
        
        Test.startTest();
        Ctrl_ReporteGrl_Ventas_Automotores pdf = new Ctrl_ReporteGrl_Ventas_Automotores();
        Test.stopTest();
    }
}