@isTest
global class InventorySearchListMock implements HttpCalloutMock { 

    global HttpResponse respond(HttpRequest req){
        List<WS_InventorySearchList.Inventory> invList = new List<WS_InventorySearchList.Inventory>();
        
        for (Integer i = 0; i < 8; i++) {
            WS_InventorySearchList.Inventory inventario = new WS_InventorySearchList.Inventory();
            inventario.chasis = 'TestChasis123456' + i;
            inventario.descripcion = 'Descripcion' + i;
            inventario.codigomotor = 'CodMotor' + i;
            inventario.numerocorto = Integer.valueOf('123456' + i);
            inventario.codigovehiculo = '';
            inventario.codigocolorexterno = ''; 
            inventario.colorexterno = ''; 
            inventario.codigocolorinterno = ''; 
            inventario.colorinterno = ''; 
            inventario.anovehiculo = ''; 
            inventario.codigomodelogenerico = ''; 
            inventario.modelogenerico = ''; 
            inventario.codigomarca = ''; 
            inventario.marca = ''; 
            inventario.codigomodelofabrica = ''; 
            inventario.modelofabrica = ''; 
            inventario.codigounidadnegocio = ''; 
            inventario.unidadnegocio = ''; 
            inventario.codigobodega = ''; 
            inventario.nacionalizado = ''; 
            inventario.produccion = ''; 
            inventario.cantidadexistencia = i; 
            inventario.cantidadtransito = i; 
            inventario.cantidadreservadaubicacion = i; 
            inventario.cantidadreservadaflexible = i; 
            inventario.estado = ''; 
            inventario.codigolinea = ''; 
            inventario.linea = ''; 
            inventario.codigocompania = ''; 
            inventario.compania = ''; 
            inventario.codigosucursal = ''; 
            inventario.sucursal = ''; 
            inventario.numeroorden = i; 
            inventario.codigocliente = i; 
            inventario.notasordenventa = ''; 
            inventario.nombrecliente = ''; 
            inventario.codigovendedor = i; 
            inventario.nombrevendedor = ''; 
            inventario.pedido = i; 
            inventario.cantidad = i; 
            inventario.tipo = ''; 
            inventario.fechaEntrega = ''; 
            inventario.promesaEntrega = ''; 
            inventario.fechaarribo = ''; 
            inventario.ubicacion = ''; 
            inventario.transmision = ''; 
            inventario.precio = 1; 
            inventario.placa = ''; 
            inventario.comentarioschasis = ''; 
            inventario.codigoubicacion = '';
            invList.add(inventario);
        }
        
        String myJSON = JSON.serialize(invList);
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(201);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(myJSON);
                
        return response;
    } 
}