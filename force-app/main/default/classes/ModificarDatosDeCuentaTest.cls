@isTest
public class ModificarDatosDeCuentaTest {

    @TestSetup
    public static void crearCuentasYArhivos() {
        Test.setMock(HttpCalloutMock.class, new Test_HTTP_Mock());
        Test.setMock(WebServiceMock.class, new Test_MockWSGuardarClienteCredito(true));
        
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        List<Account> accToInsert = new List<Account>();
        
        Account accJur = new Account();
        accJur.Name = 'Cuenta Juridica';
        accJur.Cedula__c = '123ABC';
        
        accToInsert.add(accJur);
        
        Account accPer = new Account();
        accPer.FirstName = 'Cuenta';
        accPer.LastName = 'Personal';
        accPer.RecordTypeId = personAccountID;
        accPer.Cedula__c = '321ABC';
        
        accToInsert.add(accPer);
        
        insert accToInsert;

        ContentVersion cv = new ContentVersion();
        cv.title = 'Title Test';      
        cv.PathOnClient ='Test';           
        cv.VersionData = Blob.valueOf('Unit Test Attachment Body');         
        insert cv;
        
        List<ContentDocument> documents = 
            [SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
            ];

        ContentDocumentLink cdlPersonal = New ContentDocumentLink();
        cdlPersonal.LinkedEntityId = accPer.ID;
        cdlPersonal.ContentDocumentId = documents[0].ID;
        cdlPersonal.shareType = 'V';
        insert cdlPersonal;

        ContentDocumentLink cdlJuridica = New ContentDocumentLink();
        cdlJuridica.LinkedEntityId = accJur.ID;
        cdlJuridica.ContentDocumentId = documents[0].ID;
        cdlJuridica.shareType = 'V';
        insert cdlJuridica;
    }
    
    @isTest
    public static void tipoDeCuentaJuridica() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Juridica%'
            ];
        
        Test.startTest();
        String tipo = ModificarDatosDeCuenta.tipoDeCuenta(accList[0].ID);
        Test.stopTest();
        
        System.assertEquals('Juridica', 
                            tipo, 
                            'El tipo retornado para cuentas juridicas no es el que corresponde.');
    }
    
    @isTest
    public static void tipoDeCuentaPersonal() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Personal%'
            ];
        
        Test.startTest();
        String tipo = ModificarDatosDeCuenta.tipoDeCuenta(accList[0].ID);
        Test.stopTest();
        
        System.assertEquals('Personal', 
                            tipo, 
                            'El tipo retornado para cuentas personales no es el que corresponde.');
    }
    
    @isTest
    public static void enviarAprobacionSinRegistros() {
        ID idErroneo = ID.valueOf('0012f00000cfKyCAAU');
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.enviarAprobacion(idErroneo, '', '', '', '');
        Test.stopTest();
        
        System.assertEquals('No se han encontrado registros.', 
                            mensaje, 
                            'El mensaje de error al no encontrar cuenta no es el esperado.');
    }
    
    @isTest
    public static void enviarAprobacionSinDatos() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Personal%'
            ];
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.enviarAprobacion(accList[0].ID, '', '', '', '');
        Test.stopTest();
        
        System.assertEquals('No se puede enviar a aprobación con campos vacios.', 
                            mensaje, 
                            'El mensaje de error al no enviar datos no es el esperado.');
    }
    
    @isTest
    public static void enviarAprobacionSinTipoCedula() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Personal%'
            ];
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.enviarAprobacion(accList[0].ID, '', '', '123123123', '');
        Test.stopTest();
        
        System.assertEquals('Debe indicar un tipo de Identificación.', 
                            mensaje, 
                            'El mensaje de error al no insertar tipo de identificacion no es el esperado.');
    }
    
    @isTest
    public static void enviarAprobacionSinError() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Juridica%'
            ];

        List<ContentDocument> documents = 
            [SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
            ];
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.enviarAprobacion(accList[0].ID, 
                                                                'Nuevo Nombre', 
                                                                'Otros', 
                                                                '123123123', 
                                                                documents[0].ID + ';');
        Test.stopTest();
        
        List<ProcessInstance> pi = 
            [SELECT TargetObjectId, CreatedDate 
            FROM ProcessInstance 
            WHERE TargetObjectId = :accList[0].ID
            ];
        
        System.assertEquals('Ok', 
                            mensaje, 
                            'El proceso de aprobación falla cuando no debería hacerlo.');
        
        System.assertNotEquals( true, 
                                pi.isEmpty(), 
                            	'La aprobación no se envía correctamente.');
    }
    
    @isTest
    public static void enviarAprobacionSinErrorPersonal() {
        List<Account> accList =
            [SELECT ID
            FROM Account
            WHERE Name LIKE '%Personal%'
            ];

        List<ContentDocument> documents = 
            [SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
            ];
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.enviarAprobacion(accList[0].ID, 
                                                                'Otro-Nombre-Distinto', 
                                                                'Otros', 
                                                                '123123123', 
                                                                documents[0].ID + ';');
        Test.stopTest();
        
        List<ProcessInstance> pi = 
            [SELECT TargetObjectId, CreatedDate 
            FROM ProcessInstance 
            WHERE TargetObjectId = :accList[0].ID
            ];

        List<Account> accListAux =
            [SELECT ID, Campo_auxiliar_para_cambios__c, Imagen_Identificacion_1_URL__c
            FROM Account
            WHERE Name LIKE '%Personal%'
            ];    
        
        System.assertEquals('Ok', 
                            mensaje, 
                            'El proceso de aprobación falla cuando no debería hacerlo.');
        
        System.assertNotEquals(true, 
                                pi.isEmpty(), 
                            	'La aprobación no se envía correctamente.');

        for (Account acc : accListAux) {
            System.assertEquals('Otro-Nombre-Distinto;Otros;123123123;', 
                                acc.Campo_auxiliar_para_cambios__c,
                                'El campo auxiliar no se esta mapeando correctamente.');

            System.assertEquals('Otro-Nombre-Distinto;Otros;123123123;', 
                                acc.Campo_auxiliar_para_cambios__c,
                                'El campo auxiliar no se esta mapeando correctamente.');
        }
    }

    @isTest
    public static void eliminarArchivos() {
        List<ContentDocument> documents = 
            [SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
            ];

        String valor = documents[0].ID;
        
        Test.startTest();
        String mensaje = ModificarDatosDeCuenta.eliminarDocumentos(valor + ';');
        Test.stopTest();

        List<ContentDocument> documentsAux = 
            [SELECT ID
            FROM ContentDocument
            WHERE ID =: valor
            ];

        List<ContentDocumentLink> cdLink = 
            [SELECT ID 
            FROM ContentDocumentLink 
            WHERE ContentDocumentId =: valor
            ];

        System.assertEquals(true, 
                            documentsAux.isEmpty(), 
                            'La documentos no se han eliminado correctamente.');

        System.assertEquals(true, 
                            cdLink.isEmpty(), 
                            'La link entre documento y registro no se han eliminado correctamente.');
    }
}