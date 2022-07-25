({
    
    doInit : function(component, event, helper) {   
        
        component.set("v.loaded", true);

        var columns = [
                { label: 'Código Auto', fieldName: 'codigovehiculo', type: 'text', initialWidth: 140 },
                { label: 'Chasis', fieldName: 'chasis', type: 'text', initialWidth: 140 },
                { label: 'Motor', fieldName: 'codigomotor', type: 'text', initialWidth: 140 },
                { label: 'Estado', sortable: true, fieldName: 'estado', type: 'button', initialWidth: 140, typeAttributes: {
                    label: { fieldName: 'estado' },name: 'Estado'}},
                { label: 'Color Externo', sortable: true, fieldName: 'colorexterno', type: 'text', initialWidth: 140 },
                { label: 'Color Interno', fieldName: 'colorinterno', type: 'text', initialWidth: 140 },
                { label: 'Producción', fieldName: 'produccion', type: 'text', initialWidth: 140 },
            	{ label: 'B/L', fieldName: 'bl', type: 'text', initialWidth: 140 },
                { label: 'Código Vendedor', fieldName: 'codigovendedor', type: 'text', initialWidth: 140 },
                { label: 'Vendedor', fieldName: 'nombrevendedor', type: 'text', initialWidth: 140 },
                { label: 'Código Cliente', fieldName: 'codigocliente', type: 'text', initialWidth: 140 },
                { label: 'Nombre Cliente', fieldName: 'nombrecliente', type: 'text', initialWidth: 140 },
                { label: 'Modelo',sortable: true, fieldName: 'modelofabrica', type: 'text', initialWidth: 140 },
                { label: 'Año', fieldName: 'anovehiculo', type: 'text', initialWidth: 140 },
                { label: 'Ubicación', fieldName: 'nacionalizado', type: 'text', initialWidth: 140 },
                { label: 'Sucursal', fieldName: 'sucursal', type: 'text', initialWidth: 140 },
                { label: 'Fecha. Arribo', fieldName: 'fechaarribo', type: 'text', initialWidth: 140 },
                { label: 'Tipo', fieldName: 'tipo', type: 'text', initialWidth: 140},
                { label: 'Marca', fieldName: 'marca', type: 'text', initialWidth: 140 },
                { label: 'Descripción', fieldName: 'descripcion', type: 'text', initialWidth: 140 },
                { label: 'Coment. Chasis', fieldName: 'comentarioschasis', type: 'text', initialWidth: 140 },
                { label: 'Pedido', fieldName: 'pedido', type: 'text', initialWidth: 140 },
                { label: 'Ubic. Veh.', fieldName: 'codigoubicacion', type: 'text', initialWidth: 140 },
                { label: 'Notas de Reservación', fieldName: 'notasordenventa', type: 'text', initialWidth: 140 },
                { label: 'Orden de Venta', fieldName: 'numeroorden', type: 'text', initialWidth: 140 },
                { label: 'Fecha Orden', fieldName: 'fechaEntrega', type: 'text', initialWidth: 140 },
                { label: 'Prom.Entrega', fieldName: 'promesaEntrega', type: 'text', initialWidth: 140 },
                { label: 'Suc. Ubicacion', fieldName: 'codigosucursal', type: 'text', initialWidth: 140 },
                { label: 'Transmisión', fieldName: 'transmision', type: 'text', initialWidth: 140 },
                { label: 'Precio', fieldName: 'precio', type: 'text', initialWidth: 140 },
                { label: 'Placa', fieldName: 'placa', type: 'text', initialWidth: 140 },
                { label: 'Código Color Externo', fieldName: 'codigocolorexterno', type: 'text', initialWidth: 140 }
                
        ];

        component.set('v.columns', columns);

        var getPermission = component.get("c.getCurrentPermission");

        getPermission.setCallback(this, function(response) {
            
            var state = response.getState();                
            if (state === "SUCCESS") {
                component.set("v.showInboundButton", response.getReturnValue());
                component.set("v.Inbond", !response.getReturnValue());
                
                if (component.get("v.funcion") == "asignacion"){
                    helper.CargaDatos(component, component.get("v.F_Compania"), component.get("v.F_Linea"), component.get("v.F_Marca"), component.get("v.F_Modelo"), component.get("v.Inbond"));
                    return;
                }
            } else {
                console.log("Fallo en el estado " + state);
            }
        });
        
        $A.enqueueAction(getPermission); 
        
        if (component.get("v.funcion") != "asignacion"){
            var action = component.get("c.cargaPickList");
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();                
                if (state === "SUCCESS") {
                    var combo = response.getReturnValue();
                    
                    component.set("v.opcionLineaNegocio",combo[0]);
                    component.set("v.opcionCompania", combo[1]);
                    component.set("v.opcionMarca", combo[2]);                
                } else {
                    console.log("Fallo en el estado " + state);
                }
                
                component.set("v.loaded", false);
            });
            
            $A.enqueueAction(action); 
        }
    }, 

    cambiaCompania : function (component, event, helper) {
        var compania = component.find("datosCompania").get("v.value");
        console.log(compania);
        component.set("v.F_Compania", compania);
    },

    cambiaLinea : function (component, event, helper) {
        var linea = component.find("datosLinea").get("v.value");
        var compania = component.get("v.F_Compania");
        component.set("v.F_Linea", linea);
        component.find("datosMarca").set("v.value", "");
        component.find("datosModelo").set("v.value", "");
        component.set("v.F_Marca", "");
        component.set("v.F_Modelo", "");
        let inbond = component.find("inbond").get("v.checked");

        if (helper.checkMoto(compania, linea) && !inbond) {
            component.set("v.requiredMarca", true);
        } else {
            component.set("v.requiredMarca", false);
            component.set("v.disabledModelo", true);
        }
    },

    cambiaMarca : function (component, event, helper) {
        var marca = component.find("datosMarca").get("v.value");
        var requerido = component.get("v.requiredMarca");
        var nombreMarca;

        component.set("v.F_Marca", marca);
        if (requerido) {
            if (marca == "08") {
                nombreMarca = "Yamaha";
            } else if (marca == "75") {
                nombreMarca = "Genesis";
            } else if (marca == "HR") {
                nombreMarca = "Hero";
            } else if (marca == "19") {
                nombreMarca = "Haojue";
            }
        }

        if(nombreMarca != null) {
            var action = component.get("c.modelosPorMarca");

            action.setParams({
                "marca" : nombreMarca
            });
        
            action.setCallback(this, function(response) {
                
                var state = response.getState();                
                if (state === "SUCCESS") {
                    var combo = response.getReturnValue();
                    
                    console.log(combo);

                    component.set("v.opcionModelo", combo);
                    component.set("v.disabledModelo", false);
                    
                } else {
                    console.log("Fallo en el estado " + state);
                }
            });
            
            $A.enqueueAction(action);    
        } else {
            component.set("v.disabledModelo", true);
        }
    },

    cambiaModelo : function (component, event, helper) {
        var modelo = component.find("datosModelo").get("v.value");
        component.set("v.F_Modelo", modelo);

        console.log(modelo);
    },

    cambiaInbond : function(component, event, helper){
        let inbond = component.find("inbond").get("v.checked");
        component.set("v.Inbond", inbond);

        if (inbond) {
            component.set("v.requiredMarca", false);
        } else if (helper.checkMoto(component.get("v.F_Compania"), component.find("datosLinea").get("v.value"))) {
            component.set("v.requiredMarca", true);
        }
    },
    
    CargaDatos: function(component, event, helper){
        console.log("entra en carga de datos del controller");
        
        var searchCompania =  component.get("v.F_Compania");
        var searchLinea = component.get("v.F_Linea");
        var searchMarca = component.get("v.F_Marca");
        var searchModelo = component.get("v.F_Modelo");
        var inbond = component.get("v.Inbond");
        
        if (searchCompania == null){
            searchCompania = "E01";
        }
        
        if (searchMarca == null){
            searchMarca = " ";
        }

        if (searchModelo == null) {
            searchModelo = " ";
        }

        if (!component.get("v.requiredMarca") || (component.get("v.requiredMarca") && searchModelo != "")) {
            helper.CargaDatos(component, searchCompania, searchLinea, searchMarca, searchModelo, inbond);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : 'Error',
                "title": 'Campo requerido',
                "message": 'El campo modelo es requerido para motocicletas.'
            });
            toastEvent.fire();
        }
    },

    filtrarReservados : function(component, event, helper) {
        console.log("entra en filtrar reservados");

        component.set("v.checkFiltrado", component.find("reservados").get("v.checked"));

        helper.FiltrarDatos(component);
    },
    
    onSelectChange : function(component, event, helper) {
        console.log("entra en select change");

        var selected = component.find("records").get("v.value");
        var paginationList = [];
        var inventoryList = component.get("v.inventoryList");
        
            for(var i=0; i<selected; i++){
            paginationList.push(inventoryList[i]);
        }
        component.set("v.paginationList", paginationList);
        
        component.set("v.pageSize",parseInt(selected));	
        component.set("v.end",parseInt(selected));
    },
    
    searchKeyChange: function(component, event, helper) {
        component.set("v.loaded", true);

        helper.FiltrarDatos(component);

        component.set("v.loaded", false);
    },

    next : function(component, event, helper) {
       helper.Paginar(component, "next");
    },
    
    previous : function(component, event, helper) {
        helper.Paginar(component, "previous"); 
    },

    handleRowAction : function(component, event, helper) {
        var chasis = event.target.name;
        var action = event.target.title;

        let list =  component.get("v.paginationList");
        for (let i = 0; i < list.length; i++) {
            let row = list[i];
            
            if(row.chasis == chasis) {
                if (action == 'Seleccionar') {
                    component.set("v.Motor",row.codigomotor);
                    component.set("v.Chasis",row.chasis);
                    component.set("v.Color",row.colorexterno);
                } else if (action == 'Estado') {
                    component.set("v.Estado_NOrden",row.numeroorden);
                    component.set("v.Estado_Chasis",row.chasis);
                    component.set("v.Estado_Cliente",row.nombrecliente);
                    component.set("v.Estado_Vendedor",row.nombrevendedor);
                    component.set("v.Estado_Nota",row.notasordenventa);
                    component.set("v.OpenEstado", true);
                }
            }
        }
    },
        
    closeEstado: function (cmp, event, helper) {
        cmp.set("v.OpenEstado", false);
    },
    
    ExportarPDF: function(component, event, helper){
        var inventoryList = component.get("v.inventoryList");
        if (inventoryList.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "Warning",
                "title": "Consulta de Disponibilidad",
                "message": "Para poder realizar la exportación primero debe de cargar los datos"
            });
            toastEvent.fire();
            return;
        }
        
        var compania = component.find("datosCompania").get("v.value");  // Compañia
        var linea = component.find("datosLinea").get("v.value");	      // Linea
        var marca = component.find("datosMarca").get("v.value");	
        
        if (compania == null){
            compania = "E01";
        }
        
        if (marca == null){
            marca = "";
        }
        
        var filtroGeneral = component.find("filtroGeneral").get("v.value");
        
        console.log(filtroGeneral);
        
        var url = '/apex/ConsultaDisponibilidad_PDF?compania='+compania+'&linea='+linea+'&marca='+marca+'&filtroGeneral='+filtroGeneral;
        //Console.log("URL: "+ url);
        window.open(url, '_blank');
    },
    
    exportToCSV: function (cmp, event, helper) {  
     let columnHeader = ["Código Auto", "Chasis",  "Motor", "Estado", "Color Externo", "Color Interno", "Producción", "Código Vendedor", "B/L", "Vendedor","Código Cliente", "Nombre Cliente", "Modelo", "Año",  "Ubicación", "Sucursal", "Fecha. Arribo", "Tipo", "Marca", "Descripción", "Coment. Chasis", "Pedido", "Ubic. Veh.",  "Notas de Reservación", "Orden de Venta", "Fecha Orden", "Prom.Entrega", "Suc. Ubicacion", "Transmisión", "Precio", "Placa", "Código Color Externo"];  // This array holds the Column headers to be displayd
     let jsonKeys = ["codigovehiculo", "chasis", "codigomotor", "estado", "colorexterno", "colorinterno", "produccion", "codigovendedor","bl","nombrevendedor", "codigocliente","nombrecliente", "modelofabrica", "anovehiculo", "nacionalizado", "sucursal", "fechaarribo", "tipo", "marca", "descripcion", "comentarioschasis", "pedido","codigoubicacion","notasordenventa","numeroorden","fechaEntrega","promesaEntrega","codigosucursal","transmision","precio","placa","codigocolorexterno"]; // This array holds the keys in the json data  
     var jsonRecordsData = cmp.get("v.inventoryList");  
     let csvIterativeData = "";  
     let csvSeperator = ",";  
     let newLineCharacter = "\n";  
     csvIterativeData += columnHeader.join(csvSeperator);  
     csvIterativeData += newLineCharacter;  

     for (let i = 0; i < jsonRecordsData.length; i++) {  
        let counter = 0;  
        for (let iteratorObj in jsonKeys) {  
            let dataKey = jsonKeys[iteratorObj];  
            if (counter > 0) {  
                csvIterativeData += csvSeperator;  
            }

            if (jsonRecordsData[i][dataKey] !== null && jsonRecordsData[i][dataKey] !== undefined) {  
                csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';  
            } else {  
                csvIterativeData += '""';  
            }    
            counter++;  
        }

        csvIterativeData += newLineCharacter;  
     }  
     
     cmp.set("v.hrefExport", "data:text/csv;charset=utf-8," + encodeURI(csvIterativeData.replaceAll('#', '')));  
    },
  
    handleSort : function(cmp,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        cmp.set("v.sortBy",sortBy);
        cmp.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(cmp,sortBy,sortDirection);
    }
})