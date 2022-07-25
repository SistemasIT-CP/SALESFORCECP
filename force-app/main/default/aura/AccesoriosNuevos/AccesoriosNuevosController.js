({
    doInit : function(component, event, helper) {    
        var actions = [
            { label: 'Modificar', name: 'modificar' },
            { label: 'Eliminar', name: 'eliminar' }
        ];

        var columns = [
                { label: 'Código del accesorio', fieldName: 'Codigo_de_parte__c', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Descripción larga', fieldName: 'Descripci_n_del_accesorio__c', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Estado', fieldName: 'Estado__c', type: 'text', sortable:false, hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Cantidad', fieldName: 'Cantidad__c', type: 'number', sortable:false, hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Precio unitario', fieldName: 'Precio__c', type: 'currency', sortable:false, hideDefaultActions:true, cellAttributes: { alignment: 'left'}},
                { type: 'action', typeAttributes: { rowActions: actions }}
        ];        

        var columnasCantidad = [
                { label: 'Descripción', fieldName: 'Descripcion__c', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Codigo de parte', fieldName: 'CodigoParte__c', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Cantidad', fieldName: 'cantidad', sortable:false, editable:true, type: 'number', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
                { label: 'Precio unitario', fieldName: 'Precio__c', sortable:false, type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'left'}}
        ];
        
        component.set('v.columnas', columns);
        component.set('v.columnasDeCantidades', columnasCantidad);

        helper.consultarAccesorios(component);
    }, 

    abrirAgregarAccesorios : function(component, event, helper) {
        helper.controlarVentanas(component, "v.agregarAccesorios", "abrir");
    },

    abrirAgregarCombos : function(component, event, helper) {
        helper.controlarVentanas(component, "v.agregarCombos", "abrir");
    },

    abrirSeleccionarCantidades : function(component, event, helper) {
        var listaTotales = component.get("v.listaAccesoriosSeleccionados");
        var listaSeleccionados = [];


        for (let i = 0; i < listaTotales.length; i++) {
            let aux = listaTotales[i];

            if (aux.Seleccionado) {
                listaSeleccionados.push(aux);
            }
        }

        if (listaSeleccionados.length == 0) {
            component.set("v.mostrarError", true);
            setTimeout(() => component.set("v.mostrarError", false), 3500 );
        } else {
            component.set("v.mostrarError", false);

            var mapaAuxiliar = component.get("v.mapaAuxiliar");

            if (Object.keys(mapaAuxiliar).length === 0) {
                mapaAuxiliar = new Map();
            }
            
			var listaAccesoriosSeleccionados = [];
            
            for (let i = 0; i < listaSeleccionados.length ; i++) {
                var cantidad = 1;

                if (listaSeleccionados[i].CantidadMinima__c != null && listaSeleccionados[i].CantidadMinima__c != 0) {
                    cantidad = listaSeleccionados[i].CantidadMinima__c;
                }

                let aux = {
                    'Id' : listaSeleccionados[i].id,
                    'Descripcion__c': listaSeleccionados[i].Descripcion__c,
                    'CodigoParte__c': listaSeleccionados[i].CodigoParte__c,
                    'cantidad': cantidad,
                    'Seleccionado' : listaSeleccionados[i].Seleccionado,
                    'Precio__c': listaSeleccionados[i].Precio__c
                };
                
				listaAccesoriosSeleccionados.push(aux);

                mapaAuxiliar.set(listaSeleccionados[i].CodigoParte__c, cantidad);
            }

            component.set("v.mapaAuxiliar", mapaAuxiliar);
            component.set("v.listaAccesoriosSeleccionados", listaAccesoriosSeleccionados);
            helper.controlarVentanas(component, "v.asignarCantidades", "abrir");
        }
    },

    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set("v.accesorioSeleccionado", row);

        if (action.name == "eliminar") {
            helper.controlarVentanas(component,"v.eliminarAccesorios", "abrir");
        } else if (action.name == "modificar") {
            helper.controlarVentanas(component,"v.editarAccesorios", "abrir");
        }
    },

    eliminarAccesorios : function(component, event, helper) {
        var codigo = component.get("v.accesorioSeleccionado").Id;

        var action = component.get("c.eliminarAccesorio");
        action.setParams({
            "idAccesorio" : codigo
        });

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                
                if (respuesta == 'Bien') {
                    $A.get('e.force:refreshView').fire();

                    helper.showToast('Success', 'Accesorios Eliminados', 'Se han eliminado correctamente los accesorios.');
                    helper.consultarAccesorios(component);
                    helper.controlarVentanas(component,"v.eliminarAccesorios", "cerrar");

                } else {
                    helper.showToast('Error', 'Algo ha salido mal', respuesta);
                }
            } else {
                console.log("Fallo en el estado " + response.getError());
            }
        });
        
        $A.enqueueAction(action); 
    },

    cerrarEliminarAccesorios : function(component, event, helper) {
        helper.controlarVentanas(component,"v.eliminarAccesorios", "cerrar");
    },

    cerrarEditarAccesorios : function(component, event, helper) {
        helper.controlarVentanas(component,"v.editarAccesorios", "cerrar");
    },

    cerrarAgregarCombos : function(component, event, helper) {
        helper.controlarVentanas(component,"v.agregarCombos", "cerrar");
    },

    cerrarAgregarAccesorios : function(component, event, helper) {
        helper.controlarVentanas(component,"v.agregarAccesorios", "cerrar");
        helper.controlarVentanas(component,"v.asignarCantidades", "cerrar");

        component.set("v.listaAccesoriosSeleccionados", []);
    },

    cerrarSeleccionarCantidades : function(component, event, helper) {
        helper.controlarVentanas(component,"v.asignarCantidades", "cerrar");
        component.set("v.mapaAuxiliar", []);

        var lista = component.get("v.listaAccesoriosOriginal");
        var data = [];

        for (let i = 0; i < 10; i++) {
            var elem = lista[i];
            data.push(elem);
        }

        component.set("v.listaAccesoriosVista", data);
        component.set("v.final", 10);
    },

    buscarCombos : function(component, event, helper) {
        component.set("v.cargaCompleta", false);
        var obtenerCombos = component.get("c.obtenerCombos");
        var descripcionCombos = component.get("c.descripcionCombos");
        var idInforme = component.get("v.recordId");

        obtenerCombos.setParams({
            "idInforme" : idInforme
        });

        obtenerCombos.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                if (response.getReturnValue() != null && response.getReturnValue().length != 0) {
                    var resultado = response.getReturnValue();
                    
                    var resultadoAux = [];

                    var maximo = 10;
                    var data = [];
                    
                    for (let i = 0; i < resultado.length; i++) {
                        let registro = response.getReturnValue()[i];
                        var aux = {
                            "Id" : registro.Id, 
                            "Name" : registro.Name,
                            "Id_Externo__c" : registro.Id_Externo__c,
                            "Seleccionado" : false
                        }; 

                        resultadoAux.push(aux);
                    }

                    if (resultado.length < maximo) {
                        maximo = response.getReturnValue().length;
                        component.set("v.adelanteDisable", true);
                        component.set("v.final", maximo);
                    }

                    for (let i = 0; i < maximo; i++) {
                        data.push(resultadoAux[i]);
                    }
                    
                    component.set("v.listaCombosVista", data);
                    component.set("v.listaCombos", resultadoAux);
                    component.set("v.listaCombosOriginal", resultadoAux);

                    descripcionCombos.setParams({
                        "idInforme" : idInforme
                    });


                    descripcionCombos.setCallback(this, function(response) {
                        var state = response.getState();
    
                        if (state === "SUCCESS") {
                            var mapaCombos = new Map();
    
                            for (let [key, value] of Object.entries(response.getReturnValue())) {
                                mapaCombos.set(key, value);
                            }
    
                            component.set("v.mapaCombos", mapaCombos);
                        }
                    });
                    
                    $A.enqueueAction(descripcionCombos); 
                }

                component.set("v.cargaCompleta", true);
            } else {
                console.log("Fallo en el estado " + state);
                console.log(response.getError());
            }
        });
        
        $A.enqueueAction(obtenerCombos); 
    },

    buscarAccesorios : function(component, event, helper) {
        component.set("v.cargaCompleta", false);
        var obtenerAccesorios = component.get("c.obtenerAccesorios");

        obtenerAccesorios.setCallback(this, function(response) {
            var state = response.getState();        
            
            if (state === "SUCCESS") {
                if (response.getReturnValue() != null && response.getReturnValue().length != 0) {
                    var respuesta = response.getReturnValue();

                    var respuestaAux = [];

                    for (let i = 0; i < respuesta.length; i++) {
                        let aux = {
                            'Id' : respuesta[i].id,
                            'Descripcion__c': respuesta[i].Descripcion__c,
                            'CodigoParte__c': respuesta[i].CodigoParte__c,
                            'Precio__c': respuesta[i].Precio__c,
                            'CantidadMinima__c' : respuesta[i].CantidadMinima__c,
                            'Seleccionado' : false
                        };

                        respuestaAux.push(aux);
                    }

                    component.set("v.listaAccesoriosTotales", respuestaAux);     
                    component.set("v.listaAccesoriosOriginal", respuestaAux);
                    
                    var maximo = 10;
                    var data = [];
                    
                    if (respuesta.length < maximo) {
                        maximo = respuesta.length;
                        component.set("v.adelanteDisable", true);
                        component.set("v.final", maximo);
                    }
                    
                    for (let i = 0; i < maximo; i++) {
                        data.push(respuestaAux[i]);
                    }
                    
                    component.set("v.listaAccesoriosVista", data);
                }
                
                component.set("v.cargaCompleta", true);
            } else {
                console.log("Fallo en el estado " + state);
            }
        });
        
        $A.enqueueAction(obtenerAccesorios); 
    },

    agregarCombos : function(component, event, helper) {
        var dataOriginal = component.get("v.listaCombosOriginal");

        var result = [];

        if (dataOriginal.length != null) {
            for (var i = 0; i < dataOriginal.length; i++) {
                if (dataOriginal[i].Seleccionado) {
                    result.push(dataOriginal[i].Id_Externo__c);
                }
            }
        }

        if (result.length == 0) {
            component.set("v.mostrarError", true);
            setTimeout(() => component.set("v.mostrarError", false), 3500 );
        } else {
            var action = component.get("c.guardarCombos");
            var informeID = component.get("v.recordId");
    
            action.setParams({
                "idInforme" : informeID,
                "listaCombos": result
            });
    
            action.setCallback(this, function(response) {
                var state = response.getState();                
                if (state === "SUCCESS") {
                    var respuesta = response.getReturnValue();
                    
                    if (respuesta == 'Bien') {
                        $A.get('e.force:refreshView').fire();
    
                        helper.showToast('Success', 'Nuevos Accesorios', 'Se han insertado correctamente los combos.');
                        helper.consultarAccesorios(component);
                        helper.controlarVentanas(component,"v.agregarCombos", "cerrar");
    
                    } else {
                        helper.showToast('Error', 'Algo ha salido mal', respuesta);
                    }
                } else {
                    console.log("Fallo en el estado " + response.getError());
                }
            });
        
            $A.enqueueAction(action);
        }

        helper.controlarVentanas(component,"v.agregarCombos", "cerrar");
    },

    agregarAccesorios : function(component, event, helper) {
        var mapaResultado = component.get("v.mapaAuxiliar");
        var listaAux = [];

        for (var [key, value] of mapaResultado) {
            listaAux.push(key + "=" + value);
        }

        var action = component.get("c.guardarAccesorio");
        var informeID = component.get("v.recordId");

        action.setParams({
            "idInforme" : informeID,
            "listaAccesorios": listaAux
        });

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                
                if (respuesta == 'Bien') {
                    $A.get('e.force:refreshView').fire();

                    helper.showToast('Success', 'Nuevos Accesorios', 'Se han insertado correctamente los accesorios.');
                    helper.consultarAccesorios(component);

                } else {
                    helper.showToast('Error', 'Algo ha salido mal', respuesta);
                }
            } else {
                console.log("Fallo en el estado " + response.getError());
            }
        });
        
        $A.enqueueAction(action);

        component.set("v.listaAccesoriosSeleccionados", []);
        
        helper.controlarVentanas(component,"v.agregarAccesorios", "cerrar");
        helper.controlarVentanas(component,"v.asignarCantidades", "cerrar");
    },

    handleMouseHover: function(component, event, helper) {
        var my = event.srcElement.id;
        component.set("v.reId", my);

        var mapaCombos = component.get("v.mapaCombos").get(my);
        var detalleCombo = [];

        for (let [key, value] of Object.entries(mapaCombos)) {
            let partes = value.split('_');
            detalleCombo.push({codigo:key, detalle: partes[1], cantidad: partes[0], precio:'USD ' + partes[2]});
        }

        component.set("v.detalleCombo", detalleCombo);

        helper.getMiniLayout(component, event, helper)
    },
    
    handleMouseOut: function(component, event, helper) {
        component.set("v.hoverRow",-1);
        component.set("v.togglehover",false);
    },

    edicionCeldas : function (component, event, helper) {
        var mapaDraft = event.getParam("draftValues");
        var mapaActual = component.get("v.mapaAuxiliar");
        
        for (let i = 0; i < mapaDraft.length; i++) {
            mapaActual.set(mapaDraft[i].CodigoParte__c, mapaDraft[i].cantidad);
        }

        component.set("v.mapaAuxiliar", mapaActual);
    },
    
    seleccionarAccesorio : function (component, event, helper) {
        var codigo = event.getSource().get("v.name");
        var listaVista = component.get("v.listaAccesoriosVista");
        var listaAccesoriosSeleccionados = component.get("v.listaAccesoriosSeleccionados");
        
        for (let i = 0; i < listaVista.length; i++) {
            let elem = listaVista[i];
            
            if (elem.CodigoParte__c == codigo && elem.Seleccionado) {
                if (!listaAccesoriosSeleccionados.includes(elem)) {
                    listaAccesoriosSeleccionados.push(elem);
                }
            }
        }

        component.set("v.listaAccesoriosSeleccionados", listaAccesoriosSeleccionados);
    },

    queryCombos: function (component, event, helper) {
        var queryTerm = component.find("buscarCombos").get("v.value");
        component.set("v.issearching", true);

        helper.filtrado(component, "combos", queryTerm.toUpperCase());
        component.set("v.issearching", false);
    },

    queryAccesorios: function (component, event, helper) {
        var queryTerm = component.find("buscarAccesorios").get("v.value");
		
        if(queryTerm.length > 3) {
            component.set("v.issearching", true);
        	helper.filtrado(component, "accesorios", queryTerm.toUpperCase());
        	component.set("v.issearching", false);    
        }
    },

    editarAccesorios : function (component, event, helper) {
        var elem = component.get("v.accesorioSeleccionado");
        var idInforme = component.get("v.recordId");

        var actualizarCantidades = component.get("c.actualizarCantidades");

        actualizarCantidades.setParams({
            "codigoParte" : elem.Codigo_de_parte__c,
            "cantidadNueva" : elem.Cantidad__c,
            "idInforme" : idInforme
        });

        actualizarCantidades.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                
                if (respuesta == 'Bien') {
                    $A.get('e.force:refreshView').fire();

                    helper.showToast('Success', 'Accesorio Actualizado', 'Se ha actualizado correctamente el accesorio.');
                    helper.consultarAccesorios(component);
                    helper.controlarVentanas(component,"v.editarAccesorios", "cerrar");

                } else {
                    helper.showToast('Error', 'Algo ha salido mal', respuesta);
                }
            } else {
                console.log("Fallo en el estado " + response.getError());
            }
        });
        
        $A.enqueueAction(actualizarCantidades); 
    },
    
    paginar : function (component, event, helper) {
        var instruccion = event.getSource().get("v.title");
        var inicio = 0;
        var tamaño = 10;
        var data = [];
        var dataOriginal;
        var final;

        if (instruccion.includes("Accesorio")) {
            final = component.get("v.final");
            dataOriginal = component.get("v.listaAccesoriosTotales");
        } else {
            dataOriginal = component.get("v.listaCombosOriginal");
            final = component.get("v.finalCombos");
        }
        
        if ((dataOriginal.length - final) < tamaño && (dataOriginal.length - final) != 0) {
            tamaño = dataOriginal.length - final;
        }
        
        if (instruccion.includes("Adelante")) {
            inicio = final;
            final += tamaño;

            component.set("v.atrasDisable", false);
            
            if (final >= dataOriginal.length) {
                final = dataOriginal.length;
                component.set("v.adelanteDisable", true);
            }
        }
        
        if (instruccion.includes("Atras")) {
			inicio = final - 2 * tamaño;
            final -= tamaño;
            
            component.set("v.adelanteDisable", false);
            
            if (inicio <= 0) {
                inicio = 0;
                final = tamaño;
                component.set("v.atrasDisable", true);
            }
        }

        for (let i = inicio; i < final; i++) {
            data.push(dataOriginal[i]);
        }
        
        if (instruccion.includes("Accesorio")) {
            component.set("v.final", final);
            component.set("v.listaAccesoriosVista", data);
        } else {
            component.set("v.finalCombos", final);
            component.set("v.listaCombosVista", data);
        }
    }
})