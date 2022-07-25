({
	CargaDatos : function(component, compania, linea, marca, modelo, inbond) {
        component.set("v.loaded", true);
        var pageSize = component.get("v.pageSize");

        console.log(compania, linea, marca, modelo, inbond);

        var action = component.get("c.getInventario");
        action.setParams ({
             "compania": compania,
             "linea": linea,				
             "marca" : marca,
             "modelo" : modelo,
             "inbond": '' + inbond
         });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                if (response.getReturnValue().length != 0) {
                    var filtro = component.get("v.Producto_Nombre");   
                    
                    if (filtro != '') {
                        let listAux = [];
                        for (let i = 0; i < response.getReturnValue().length; i++) {
                            let elem = response.getReturnValue()[i];
        
                            if (elem.codigovehiculo.includes(filtro)) {
                                listAux.push(elem);
                            }
               		 	}
                        
                        component.set("v.OriginalinventoryList", listAux);

						this.FiltrarDatos(component);   
                    } else {
                        if(response.getReturnValue().length < pageSize) {
                            pageSize = response.getReturnValue().length;
                        }
    
                        component.set("v.OriginalinventoryList", response.getReturnValue());            
                        component.set("v.inventoryList", response.getReturnValue());            
                        component.set("v.totalSize", component.get("v.OriginalinventoryList").length);	// totalSize = cantidad de registros
                        component.set("v.end",pageSize);
                      
                        var paginationList = [];
        
                        for (var i = 0; i < pageSize; i++) {
                            paginationList.push(response.getReturnValue()[i]);
                        }
                        
                        component.set("v.paginationList", paginationList);
                    }

                    if (component.get("v.funcion") != "asignacion") {
                        component.set("v.hiddenClass", "hidden");
                    }
                } else {
                    component.set("v.OriginalinventoryList", []);
                    component.set("v.totalSize", 0);
                    component.set("v.end", 0);
                }
            } else {
                console.log("Fallo con el estado: " + state);
            }

            component.set("v.loaded", false);
        });
        
        $A.enqueueAction(action);
	},
    
    FiltrarDatos : function(component) {
        var pageSize = component.get("v.pageSize");
        var data = component.get("v.OriginalinventoryList");
        
        var results = [];
    
        const values = Array.from(document.querySelectorAll(".filter")).map(function(input) {
            var aux = {
                name: input.name,
                value: input.value
            };

            return aux;
        });

        try {
            for(var i = 0; i < data.length; i++){
                var row = data[i];
                let cumpleFiltros = true;

                for (let i = 0; i < values.length; i++) {
                    let elem = values[i];

                    if (elem.value != null && elem.value != '') {
                        if (row[elem.name] == null || row[elem.name] == '') {
                            cumpleFiltros = false;
                        } else if (!row[elem.name].toLowerCase().includes(elem.value.toLowerCase())) {
                            cumpleFiltros = false;
                        }
                    }
                }

                if (cumpleFiltros) {
                    results.push(row);
                }
            }
            
            var paginationList = [];

            if (results.length < pageSize) {
                pageSize = results.length;
            }

            if (results.length != 0) {
                for(let i = 0; i < pageSize; i++) {
                    paginationList.push(results[i]);    
                }
            }
            
            component.set("v.inventoryList", results);
            component.set("v.totalSize", results.length);		
            component.set("v.end",pageSize);
            component.set("v.paginationList", paginationList);
            
        } catch (e) {
            alert (e);
        }
    },

    Paginar : function(component, accion) {
        console.log("entra en paginar");

		var inventoryList = component.get("v.inventoryList");
 		var end = component.get("v.end");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var inicio = 0;

        if ((inventoryList.length - end) < pageSize && (inventoryList.length - end != 0)) {
            pageSize = inventoryList.length - end;
        } 
        
        if (accion == "previous") {
            inicio = end - 2*pageSize;
            end -= pageSize;
            
            if (inicio < 0) {
                inicio = 0;
                end = pageSize
            }
        } else if (accion == "next") {
            inicio = end;
            end += pageSize;
            
            if (end > inventoryList.length) {
                end = inventoryList.length;
            }
        }
        
        console.log(pageSize);
        console.log(inicio);
        console.log(end);
        
        for (var i = inicio; i < end; i++) {
            paginationList.push(inventoryList[i]);
        }
        
        component.set("v.end", end);
        component.set("v.paginationList", paginationList);
    },
    
    sortData : function(component, fieldName, sortDirection){
        var data = component.get("v.paginationList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'Estado'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.paginationList",data);
    },
    
    nulearFiltros : function() {
        var filters = document.querySelectorAll(".filter");
        filters.forEach(function(elem) {
            elem.value = '';
        });
    },
    
    loadMoreData: function (cmp, event, helper) {
        //Display a spinner to signal that data is being loaded
        event.getSource().set("v.isLoading", true);
        //Display "Loading" when more data is being loaded
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(cmp, cmp.get('v.rowsToLoad'))
            .then($A.getCallback(function (data) {
                if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.enableInfiniteLoading', false);
                    cmp.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = cmp.get('v.data');
                    //Appends new data to the end of the table
                    var newData = currentData.concat(data);
                    cmp.set('v.data', newData);
                    cmp.set('v.loadMoreStatus', '');
                }
               event.getSource().set("v.isLoading", false);
            }));
    },
  
    checkMoto : function (compania, linea) {
        return (compania == "E01" && linea == "37") || (compania == "E02" && linea == "16") || (compania == "E10" && linea == "16");
    }
})