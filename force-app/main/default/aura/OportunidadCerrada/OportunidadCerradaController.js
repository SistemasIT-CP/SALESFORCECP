({
    changeStage: function(component, event, helper) {
        let changeType = event.getParams().changeType;
        let changedFields = event.getParams().changedFields;

        console.log(changeType);
        if (changedFields != null) {
            console.log(Object.keys(changedFields));
        }
        
        if (changeType === "CHANGED" && Object.keys(changedFields).includes("StageName") && Object.keys(changedFields).includes("SystemModstamp")) { 
            let estado = component.get('v.caseSimpleRecord').StageName;
            console.log(estado);
            
            if (estado == 'Cerrada perdida') {
                var action = component.get("c.obtenerPickList");

                action.setCallback(this, function(response) {
                    var state = response.getState();                
                    if (state === "SUCCESS") {
                        var respuesta = response.getReturnValue();
                        var listaRazones = [];

                        for(let i = 0; i < respuesta.length; i++) {
                            let aux = {
                                'label': respuesta[i], 
                                'value': respuesta[i]
                            }

                            listaRazones.push(aux);
                        }

                        component.set("v.razonElegida", listaRazones[0].value);
                        component.set("v.razonesList", listaRazones);
                        component.set("v.razonPerdida", true);
                    } else {
                        console.log("Fallo en el estado " + response.getError());
                    }
                });
        
                $A.enqueueAction(action); 
            }
        }
    },

    razonPerdida : function(component, event, helper) {
        var action = component.get("c.setearRazonPerdida");
        let razon = component.get("v.razonElegida");
        let detalle = component.get("v.detalleElegida");
        let marca = component.get("v.marcaElegida");
        let detalleRequerido = component.get("v.detalleElegidaRequired");
        let marcaRequerida = component.get("v.marcaElegidaRequired");

        if (razon == null || razon == '') {
            helper.mostrarMensaje("Error", "Campo requerido faltante", "La razón de pérdida es obligatoria.");
        } else  if (detalleRequerido && (detalle == null || detalle == '')) {
            helper.mostrarMensaje("Error", "Campo requerido faltante", "El detalle de la razón de pérdida es obligatorio.");
        } else if (marcaRequerida && (marca == null || marca == '')) {
            helper.mostrarMensaje("Error", "Campo requerido faltante", "La marca del detalle es obligatoria.");
        } else {
            action.setParams({
                "idOpp" : component.get("v.recordId"),
                "razon" : razon,
                "detalle" : detalle, 
                "marca" : marca
            });

            action.setCallback(this, function(response) {
                var state = response.getState();                
                if (state === "SUCCESS") {
                    var respuesta = response.getReturnValue();
                    
                    if (respuesta == 'Bien') {
                        helper.mostrarMensaje("Success", "Razón de pérdida seteada", "La razón de pérdida se ha seteado correctamente.");
                        
                        component.set("v.razonPerdida", false);
                    }
                } else {
                    console.log("Fallo en el estado " + response.getError());
                }
            });

            $A.enqueueAction(action);             
        }
    },

    cambiarRazon : function(component, event, helper) {
        var action = component.get("c.obtenerDetalle");
        let razon = component.get("v.razonElegida");

        action.setParams({
            "razon" : razon
        });

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();

                if (respuesta != null && respuesta.length > 0) {
                    var listaDetalles = [];

                    for(let i = 0; i < respuesta.length; i++) {
                        let aux = {
                            'label': respuesta[i], 
                            'value': respuesta[i]
                        }

                        listaDetalles.push(aux);
                    }

                    component.set("v.detallesList", listaDetalles);
                    component.set("v.detalleElegidaRequired", true);
                    component.set("v.detalleElegidaDisabled", false);
                } else {
                    component.set("v.detallesList", []);
                    component.set("v.marcasList", []);
                    component.set("v.detalleElegidaRequired", false);
                    component.set("v.detalleElegidaDisabled", true);
                    component.set("v.marcaElegidaRequired", false);
                    component.set("v.marcaElegidaDisabled", true);
                }
            } else {
                console.log("Fallo en el estado " + response.getError());
            }
        });

        $A.enqueueAction(action);             
    },

    cambiarDetalle : function(component, event, helper) {
        var action = component.get("c.obtenerMarcas");
        let detalle = component.get("v.detalleElegida");

        action.setParams({
            "detalle" : detalle
        });

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();

                if (respuesta != null && respuesta.length > 0) {
                    var listaMarcas = [];

                    for(let i = 0; i < respuesta.length; i++) {
                        let aux = {
                            'label': respuesta[i], 
                            'value': respuesta[i]
                        }

                        listaMarcas.push(aux);
                    }

                    component.set("v.marcasList", listaMarcas);
                    component.set("v.marcaElegidaRequired", true);
                    component.set("v.marcaElegidaDisabled", false);
                } else {
                    component.set("v.marcasList", []);
                    component.set("v.marcaElegidaRequired", false);
                    component.set("v.marcaElegidaDisabled", true);
                }
            } else {
                console.log("Fallo en el estado " + response.getError());
            }
        });

        $A.enqueueAction(action);             
    }
})