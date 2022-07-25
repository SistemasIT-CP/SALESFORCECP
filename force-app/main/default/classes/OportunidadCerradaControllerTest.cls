@isTest
public class OportunidadCerradaControllerTest {
    @TestSetup
    public static void crearOpp(){
        Opportunity opp = new Opportunity();
        opp.CloseDate = Date.today();
        opp.StageName = 'Contacto Exitoso';

        insert opp;
    }

    @IsTest
    public static void obtenerPickListTest(){
        Schema.DescribeFieldResult field = Opportunity.Razon_perdida__c.getDescribe();
        
        Test.startTest();
        List<String> razonesList = OportunidadCerradaController.obtenerPickList();
        Test.stopTest();
        
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            if (f.getLabel() == 'Oportunidad Duplicada' || f.getLabel() == 'Cliente en Lista Negra') {
                System.AssertEquals(false, razonesList.contains(f.getLabel()), f.getLabel() + ' está incluido en la lista cuando no deberia estarlo');
            } else {
                System.AssertEquals(true, razonesList.contains(f.getLabel()), f.getLabel() + ' no está incluido en la lista cuando deberia estarlo');
            }
        }
    }
    
    @IsTest
    public static void obtenerDetalleTest(){
        List<String> picklistOptions = new List<String>();

        Schema.DescribeFieldResult F = Opportunity.Detalle_de_perdida__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();

        Map<String, List<String>> mapaDependencias = OportunidadCerradaController.getDependentPicklistValues(T);

        for (String key : mapaDependencias.keySet()) {
            if (key == 'Precio/Extras') {
                picklistOptions = mapaDependencias.get(key);
            }
        }
        
        Test.startTest();
        List<String> razonesList = OportunidadCerradaController.obtenerDetalle('Precio/Extras');
        Test.stopTest();
        
        for (String str : razonesList) {
            System.AssertEquals(true, picklistOptions.contains(str), str + ' no está incluido en la lista de detalles cuando deberia estarlo');
        }
    }
    
    @IsTest
    public static void obtenerMarcasTest(){
        List<String> picklistOptions = new List<String>();

        Schema.DescribeFieldResult F = Opportunity.Marca_detalle_de_perdida__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();

        Map<String, List<String>> mapaDependencias = OportunidadCerradaController.getDependentPicklistValues(T);

        for (String key : mapaDependencias.keySet()) {
            if (key == 'Compró otra marca (Ext)') {
                picklistOptions = mapaDependencias.get(key);
            }
        }
        
        Test.startTest();
        List<String> razonesList = OportunidadCerradaController.obtenerMarcas('Compró otra marca (Ext)');
        Test.stopTest();
        
        for (String str : razonesList) {
            System.AssertEquals(true, picklistOptions.contains(str), str + ' no está incluido en la lista de detalles cuando deberia estarlo');
        }
    }

    @IsTest
    public static void setearRazonPerdidaTest(){
        List<Opportunity> oppList = 
            [SELECT ID
            FROM Opportunity
            ];

        Test.startTest();
        OportunidadCerradaController.setearRazonPerdida(oppList[0].ID, 'Precio/Extras', 'Compró otra marca (Ext)', 'Nissan');
        Test.stopTest();

        Opportunity oppActualizada = 
            [SELECT Razon_perdida__c, Detalle_de_perdida__c, Marca_detalle_de_perdida__c 
            FROM Opportunity
            WHERE ID =: oppList[0].ID 
            LIMIT 1
            ];

        System.assertEquals('Precio/Extras', oppActualizada.Razon_perdida__c, 'La razón de perdida no se ha actualizado correctamente');
        System.assertEquals('Compró otra marca (Ext)', oppActualizada.Detalle_de_perdida__c, 'El detalle de perdida no se ha actualizado correctamente');
        System.assertEquals('Nissan', oppActualizada.Marca_detalle_de_perdida__c, 'La marca de detalle de perdida no se ha actualizado correctamente');
    }
}