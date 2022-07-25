public class WS_InventorySearchList {
    @AuraEnabled
    public static List<Inventory> getInventario(String compania, String linea, String marca, String modelo, String inbond) {
        List<Inventory> inventoryList = new List<Inventory>();
        List<String> modeloList = new List<String>();

        if (String.isNotBlank(modelo) && modelo.contains(',')) {
            modeloList.addAll(modelo.split(','));
        } else {
            modeloList.add(modelo);
        }

        for (String str : modeloList) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(Label.URL_WS_ConsultaDisponibilidad);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('key', Label.strKey);
            request.setHeader('app', Label.strApp);
            request.setHeader('mod', Label.strModulo);
            request.setHeader('compania',compania);
            request.setHeader('linea', linea);
            request.setHeader('marca', marca);
            request.setHeader('modelo', str);
            request.setHeader('isInbond', inbond);
            request.setTimeout(120000);

            inventoryList.addAll((List<Inventory>)JSON.deserialize(new Http().send(request).getBody(), List<Inventory>.class));
        }
        
        return inventoryList;
    }
    
    @AuraEnabled
    public static List<Inventory> getInventarioByString(String searchKey, List<Inventory> inventoryList) {
        
       List<Inventory> ReturnInventarioByString = new List<Inventory>();
        
        if (searchKey == ''){
            return inventoryList;
        }
        
        for(Inventory a : inventoryList ) {
            
            if(a.chasis !=null && a.chasis.containsIgnoreCase(searchKey)){
                ReturnInventarioByString.add(a);
                continue;
            }
            if(a.descripcion !=null && a.descripcion.containsIgnoreCase(searchKey)){
                ReturnInventarioByString.add(a);
                continue;   
            }
            if(a.codigomotor !=null && a.codigomotor.containsIgnoreCase(searchKey)){
                ReturnInventarioByString.add(a);
                continue;
            }
            if(string.valueOf(a.numerocorto).containsIgnoreCase(searchKey)){
                ReturnInventarioByString.add(a);
                continue;
            }
            
        }
                
        return ReturnInventarioByString;

    }
    
    /** Carga los combos */
    @AuraEnabled
    public static List<List<Catalogo_UDC__c>> cargaPickList() {
        
        Id userId = UserInfo.getUserId();

        User u = [
            SELECT Marca__c
            FROM User 
            WHERE Id =: userId
        ];

        List<String> marcas = String.isNotBlank(u.Marca__c)? u.Marca__c.split(';') : new List<String>();

        List<Catalogo_UDC__c> companias = new List<Catalogo_UDC__c>();
        List<Catalogo_UDC__c> lineaNegocio = new List<Catalogo_UDC__c>();
        
        List<List<Catalogo_UDC__c>> catalogoUDC = new List<List<Catalogo_UDC__c>>();

        for (Catalogo_UDC__c pLineaNegocio : [SELECT Id, Name, description1__c, description2__c, productCode__c, Marca_relacionada__c  
                                        FROM Catalogo_UDC__c 
                                        WHERE RecordType.Name = 'Lineas de negocio' 
                                        ORDER BY description1__c]) {
            if (String.isNotBlank(pLineaNegocio.Marca_relacionada__c)) {
                for (String marca : pLineaNegocio.Marca_relacionada__c.split(';')) {
                    if (marcas.contains(marca) && !lineaNegocio.contains(pLineaNegocio)) {
                        lineaNegocio.add(pLineaNegocio);
                    }
                }
            }
        }

        catalogoUDC.add(lineaNegocio);

        for (Catalogo_UDC__c pCompania : [SELECT Id, Name, description1__c, description2__c, productCode__c, Marca_relacionada__c  
                                        FROM Catalogo_UDC__c 
                                        WHERE RecordType.Name = 'Companias' 
                                        AND productCode__c LIKE 'E%' 
                                        ORDER BY description1__c]) {
            if (String.isNotBlank(pCompania.Marca_relacionada__c)) {
                for (String marca : pCompania.Marca_relacionada__c.split(';')) {
                    if (marcas.contains(marca) &&  !companias.contains(pCompania)) {
                        companias.add(pCompania);
                    }
                }
            }
        }

        catalogoUDC.add(companias);

      	List<Catalogo_UDC__c> pMarca = 
            [SELECT Id,Name, description1__c, description2__c, productCode__c 
            FROM Catalogo_UDC__c 
            WHERE RecordType.Name = 'Marcas' 
            ORDER BY description1__c
            ];

        catalogoUDC.add(pMarca);

        return catalogoUDC;
    }

    @AuraEnabled
    public static List<modeloData> modelosPorMarca(String marca){
        List<Product2> prodList =
            [SELECT Codigomodelofabrica__c, modelofabrica__c, modelogenerico__c
            FROM Product2 
            WHERE Marca_P__c =: marca
             	  AND (NOT modelogenerico__c LIKE 'MOTORES MARINOS%')
            ];

        List<modeloData> modList = new List<modeloData>();
        List<String> modPresentes = new List<String>();

        for (Product2 p : prodList) {
            if(!modPresentes.contains(p.modelofabrica__c)) {
                modeloData m = new modeloData();
                m.nombre = p.modelofabrica__c;
                m.codigo = p.Codigomodelofabrica__c;
    
                modList.add(m);
            }
        }

        return modList;
    }

    @AuraEnabled
    public static Boolean getCurrentPermission(){
        List<PermissionSetAssignment> permissionAssignment = [
            SELECT Id 
            FROM PermissionSetAssignment 
            WHERE AssigneeId =: UserInfo.getUserId()
                AND PermissionSet.Name = 'Deshabilitar_busqueda_de_vehiculos_inbound'
        ];

        return permissionAssignment.isEmpty();
    }
    
    ///////////////////////
   
    public class modeloData{
        @AuraEnabled public String nombre {get;set;}
        @AuraEnabled public String codigo {get;set;}
    }

    public class Inventory{
        // ============== Campos ============== //
        @AuraEnabled public Integer numerocorto {get;set;}
        @AuraEnabled public String chasis {get;set;}
        @AuraEnabled public String codigomotor  {get;set;}
        @AuraEnabled public String descripcion {get;set;}
        @AuraEnabled public String codigovehiculo{get;set;}
        @AuraEnabled public String codigocolorexterno {get;set;}
        @AuraEnabled public String colorexterno {get;set;}
        @AuraEnabled public String codigocolorinterno {get;set;}
        @AuraEnabled public String colorinterno {get;set;}
        @AuraEnabled public String anovehiculo {get;set;}
        @AuraEnabled public String codigomodelogenerico {get;set;}
        @AuraEnabled public String modelogenerico {get;set;}
        @AuraEnabled public String codigomarca {get;set;}
        @AuraEnabled public String marca {get;set;}
        @AuraEnabled public String codigomodelofabrica {get;set;}
        @AuraEnabled public String modelofabrica {get;set;}
        @AuraEnabled public String codigounidadnegocio {get;set;}
        @AuraEnabled public String unidadnegocio {get;set;}
        @AuraEnabled public String codigobodega {get;set;}
        @AuraEnabled public String nacionalizado {get;set;}
        @AuraEnabled public String produccion {get;set;}
        @AuraEnabled public Integer cantidadexistencia {get;set;}
        @AuraEnabled public Integer cantidadtransito {get;set;}
        @AuraEnabled public Integer cantidadreservadaubicacion {get;set;}
        @AuraEnabled public Integer cantidadreservadaflexible {get;set;}
        @AuraEnabled public String estado {get;set;}
        @AuraEnabled public String codigolinea {get;set;}
        @AuraEnabled public String linea {get;set;}
        @AuraEnabled public String codigocompania {get;set;}
        @AuraEnabled public String compania {get;set;}
        @AuraEnabled public String codigosucursal {get;set;}
        @AuraEnabled public String sucursal {get;set;}
        @AuraEnabled public Integer numeroorden {get;set;}
        @AuraEnabled public Integer codigocliente {get;set;}
        @AuraEnabled public String notasordenventa {get;set;}
        @AuraEnabled public String nombrecliente {get;set;}
        @AuraEnabled public Integer codigovendedor {get;set;}
        @AuraEnabled public String nombrevendedor {get;set;}
        @AuraEnabled public Integer pedido {get;set;}
        @AuraEnabled public Integer cantidad {get;set;}
        @AuraEnabled public String tipo {get;set;}
        @AuraEnabled public String fechaEntrega {get;set;}
        @AuraEnabled public String promesaEntrega {get;set;}
        @AuraEnabled public String fechaarribo {get;set;}
        @AuraEnabled public String ubicacion {get;set;}
        @AuraEnabled public String transmision {get;set;}
        @AuraEnabled public Decimal precio {get;set;}
        @AuraEnabled public String placa {get;set;}
        @AuraEnabled public String comentarioschasis {get;set;}
        @AuraEnabled public String codigoubicacion {get;set;}  
        @AuraEnabled public String bl {get;set;}  
    }
}