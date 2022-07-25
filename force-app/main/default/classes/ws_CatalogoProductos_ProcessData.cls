public class ws_CatalogoProductos_ProcessData {
    @future(callout=true)
    public static void procesaProductosDia(string ano, string mes, string dia) {
        ws_CatalogoProductos.wsProductosPort port = new ws_CatalogoProductos.wsProductosPort();
        String resp = port.GetProductosDia(Label.strKey,Label.strApp,Label.strModulo, ano, mes, dia);
        ID RTId = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Modelo')
                .getRecordTypeId();
        List<Catalogo_UDC__c> modelosToUpsert = new List<Catalogo_UDC__c>();
        Set<String> modelosList = new Set<String>();

        for (Catalogo_UDC__c mod : [SELECT ID, Name
                                    FROM Catalogo_UDC__c
                                    WHERE RecordType.DeveloperName = 'Modelo' 
                                    ]) {

            modelosList.add(mod.Name);
        }
        
        ID kiaProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Kia')
                                    .getRecordTypeId();
        
        ID hinoProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Hino')
                                    .getRecordTypeId();
        
        ID toyotaProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Toyota')
                                    .getRecordTypeId();
        
        ID suzukiProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Suzuki')
                                    .getRecordTypeId();
        
        ID heroProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Hero')
                                    .getRecordTypeId();
        
        ID genesisProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Genesis')
                                    .getRecordTypeId();
        
        ID yamahaProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Yamaha')
                                    .getRecordTypeId();
        
        ID generalProdID = Schema.SObjectType.Product2
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('General')
                                    .getRecordTypeId();
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  

        System.debug('rootElement.getChildElements(): ' + rootElement.getChildElements().size());
        List<Product2> productLst = new List<Product2>();
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            	Product2 p = new Product2();             
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'descripcion' { 
                        p.Description = detailElement.getText() != null ? detailElement.getText() : null;  
                    }
                    when 'idproducto' { 
                        p.ProductCode = detailElement.getText() != null ? detailElement.getText() : null; 
                        p.ProductCode__c = p.ProductCode; 
                    }
                    when 'codigocolorinterno' { 
                        p.Colorinterno__c = detailElement.getText() != null ? detailElement.getText() : null; 
                        p.Codigocolorinterno__c = p.Colorinterno__c;
                    }
                    when 'colorexterno' { 
                        p.Colorexterno__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'codigovehiculo'				{ 
                        p.Codigovehiculo__c	= detailElement.getText() != null ? detailElement.getText() : null;
                        p.Name = p.Codigovehiculo__c != null? p.Codigovehiculo__c : 'Generico';
                    }
                    when 'aniomodelo'				{ 
                        p.AnioModelo__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'aniovehiculo' { 
                        p.Aniovehiculo__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'codigocolorexterno' { 
                        p.Codigocolorexterno__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'codigomarca' { 
                        p.codigomarca__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'marca' { 
                        p.Marca_P__c = detailElement.getText() != null ? detailElement.getText().toLowerCase().capitalize() : null;
                        
                        switch on p.Marca_P__c {
                            when 'Kia' {
                                p.RecordTypeId = kiaProdID;
                            }	
                            when 'Toyota' {
                                p.RecordTypeId = toyotaProdID;
                            }
                            when 'Hino' {
                                p.RecordTypeId = hinoProdID;
                            }
                            when 'Suzuki' {
                                p.RecordTypeId = suzukiProdID;
                            }
                            when 'Yamaha' {
                                p.RecordTypeId = yamahaProdID;
                            }
                            when 'Hero' {
                                p.RecordTypeId = heroProdID;
                            }
                            when 'Genesis' {
                                p.RecordTypeId = genesisProdID;
                            }
                            when else {
                                p.RecordTypeId = generalProdID;
                            }
                        }
                    }
                    when 'codigomodelofabrica' { 
                        p.Codigomodelofabrica__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'codigomodelogenerico' { 
                        p.Codigomodelogenerico__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'especificaciones' { 
                        p.Especificaciones__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'modelofabrica' { 
                        p.modelofabrica__c = detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when 'modelogenerico' { 
                        p.modelogenerico__c	= detailElement.getText() != null ? detailElement.getText() : null; 
                    }
                    when else {}
                }
            }
        	
            if (p.ProductCode__c != null) {
                productLst.add(p);    
            }
    	}
        
        if (!productLst.isEmpty()) {
            Schema.SObjectField c = Product2.Fields.ProductCode__c;
			Database.UpsertResult [] srList = Database.upsert(productLst, c, false);
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                }
           } 
        }
        
        if (!productLst.isEmpty()) {
        	for (Product2 prod : productLst) {
                String modelo = '';
                String codigo = '';
                String tipoProducto = '';

                if (prod.Marca_P__c == 'Yamaha' ||
                    prod.Marca_P__c == 'Genesis' ||
                    prod.Marca_P__c == 'Hero') {

                    modelo = prod.modelofabrica__c;
                    codigo = prod.Codigomodelofabrica__c;
                    tipoProducto = prod.modelogenerico__c;
                } else {
                    modelo = prod.modelogenerico__c;
                    codigo = prod.codigomodelogenerico__c;
                }

                if (!modelosList.contains(modelo)) {
                    Catalogo_UDC__c modeloUDC = new Catalogo_UDC__c();
                    modeloUDC.RecordTypeId = RTId;
                    modeloUDC.productCode__c = codigo;
                    modeloUDC.name = modelo.toUpperCase();
                    if (String.isNotBlank(tipoProducto)) {
                        modeloUDC.description1__c = tipoProducto;
                    } else {
                        modeloUDC.description1__c = modelo.toUpperCase();
                    }
                    modeloUDC.description2__c = prod.Marca_P__c;
                    modeloUDC.ExternalId__c = 'Modelo_' + modeloUDC.productCode__c;

                    modelosToUpsert.add(modeloUDC);
                }
            }
        }

        if (!modelosToUpsert.isEmpty()) {
            Database.UpsertResult[] srList  = Database.upsert(modelosToUpsert, Catalogo_UDC__c.ExternalId__c, false);
            
            for (Database.UpsertResult sr : srList) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                    }
                }
            } 
        }
	}

    public static void getImagenesProductosDia(string ano, string mes, string dia) {
        String errors = 'Errores: \n\n';
        List<String> errorsList = new List<String>();
        List<ImagenProducto__c> imgproductLst = new List<ImagenProducto__c>();
        ws_CatalogoProductos.wsProductosPort port = new ws_CatalogoProductos.wsProductosPort();
        String resp = port.GetProductosImagenesDia(Label.strKey,Label.strApp,Label.strModulo,ano, mes, dia);
        
        Dom.Document doc = new Dom.Document();  
        doc.load(resp);  
        Dom.XMLNode rootElement = doc.getRootElement();  
        
        for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {  
            	ImagenProducto__c imgProd = new ImagenProducto__c ();             
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ){ 
                switch on detailElement.getName() {
                    when 'idproducto' { 
                        if (detailElement.getText() != null) {
                            imgProd.ProductCode__r = new Product2(ProductCode__c = detailElement.getText());
                        }
                    }
                    when 'codigovehiculo' 			{ 
                        imgProd.Name = detailElement.getText() != null ? detailElement.getText() : ''; 
                    }
                    when 'urlimagen' 		{ 
                        imgProd.urlimagen__c 	= detailElement.getText().trim() != '' ? detailElement.getText() : null; 
                    }
                    when else {}
                }
            }
        	
            if(imgProd.urlimagen__c != null){
                imgProd.IdExt__c = imgProd.Name + '_' + imgProd.urlimagen__c;
                imgproductLst.add(imgProd);    
            }
    	}
        
        if (!imgproductLst.isEmpty()) {
            Schema.SObjectField c = ImagenProducto__c.Fields.IdExt__c;
			Database.UpsertResult [] srList = Database.upsert(imgproductLst, c, false);
                for (Database.UpsertResult sr : srList) {
                    if (!sr.isSuccess()) {
                        for (Database.Error err : sr.getErrors()) {
                            System.debug('Ha ocurrido un error:' + err.getStatusCode() + ': ' + err.getMessage());                    
                            System.debug('Los campos que interfieren en el error son: ' + err.getFields());
                            errorsList.add('Ha ocurrido un error en el vehiculo:' + err.getStatusCode() + ': ' + 
                                            err.getMessage() + '\n' + 'Los campos que interfieren en el error son: ' + 
                                            err.getFields()+ '\n\n');
                        }
                    }
               } 
        }
    }
    
    public static void FormatearEspecificaciones() {
        List<Product2> lprod = 
            [SELECT ID, Especificaciones__c 
            FROM Product2 
            WHERE ProductCode = '306137'
            ];

        for (product2 p : lprod) {
            Blob blobValue = EncodingUtil.convertFromHex(p.Especificaciones__c);
            string espec = blobValue.toString();
            p.Especificaci_n_1__c = espec;
            update p;
        }
    }
}