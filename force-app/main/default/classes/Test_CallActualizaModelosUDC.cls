@IsTest
public class Test_CallActualizaModelosUDC {

    @IsTest
    public static void ejecutaWSProductosDia(){
        ID RTId = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Modelo')
                .getRecordTypeId();

        Product2 p = new Product2();
        p.Name = 'AUTO KIA';
        p.Codigomodelogenerico__c = 'K09';
        p.ProductCode__c = 'K09';
        p.modelogenerico__c = 'RIO';
        p.Marca_P__c = 'Kia';
        insert p;
        
        SchedulableContext sc = null;
        Call_ActualizaModelosUDC x = new Call_ActualizaModelosUDC();

        Test.startTest();
        x.execute(sc);
        Test.stopTest();

        List<Catalogo_UDC__c> modelosUDC =
            [SELECT Name, productCode__c, description1__c, description2__c,
                    ExternalId__c
            FROM Catalogo_UDC__c
            WHERE RecordTypeId =: RTId
            ];

        System.assertEquals(false, modelosUDC.isEmpty(), 'La lista de catalogos esta vacia cuando no deberia estarlo.');
        System.assertEquals('RIO', modelosUDC[0].Name, 'El nombre no se ha seteado correctamente.');
        System.assertEquals('RIO', modelosUDC[0].description1__c, 'La descripcion no se ha seteado correctamente.');
        System.assertEquals('K09', modelosUDC[0].productCode__c, 'El codigo de producto no se ha seteado correctamente.');
        System.assertEquals('Kia', modelosUDC[0].description2__c, 'La segunda descripcion no se ha seteado correctamente.');
        System.assertEquals('Modelo_K09', modelosUDC[0].ExternalId__c, 'El id externo no se ha seteado correctamente.');
    }
}