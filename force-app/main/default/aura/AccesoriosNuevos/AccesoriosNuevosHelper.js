({
    controlarVentanas : function(component, element, orden) {
        if (orden == "abrir") {
            component.set(element, true);
        } else {
            component.set(element, false);
        }
        
        component.set("v.atrasDisable", true);
        component.set("v.adelanteDisable", false);
        component.set("v.final", 10);
        component.set("v.finalCombos", 10);
    },

    getMiniLayout:function(component, event, helper){
        component.set("v.hoverRow", parseInt(event.target.dataset.index));
        component.set("v.togglehover",true);    
    },

    showToast : function(tipo, titulo, msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    },

    consultarAccesorios : function(component) {
        var action = component.get("c.consultarAccesorios");
        var informeID = component.get("v.recordId");

        action.setParams({
            "informesID" : informeID
        });

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                if (response.getReturnValue() != null && response.getReturnValue().length != 0) {
                	component.set("v.listaAccesorios", response.getReturnValue());         
                	component.set("v.cantidadAccesorios", response.getReturnValue().length);         
                } else {
                    component.set("v.cantidadAccesorios", 0);
                }
            } else {
                console.log("Fallo en el estado " + state);
            }
        });
        
        $A.enqueueAction(action); 
    },

    filtrado : function(component, listado, parametro) {
        if (listado == 'combos') {
            let listadoFiltrar = component.get("v.listaCombosOriginal");
            console.log('entra en el filtrado');
            let listadoFinal = listadoFiltrar.filter(
                elem => ((elem.Id_Externo__c != null && elem.Id_Externo__c.toUpperCase().includes(parametro)) || 
                         (elem.Name != null && elem.Name.toUpperCase().includes(parametro))
                        )
            );
            
            var maximo = 10;
            var data = [];
            
            if (listadoFinal.length < maximo) {
                maximo = listadoFinal.length;
                component.set("v.adelanteDisable", true);
                component.set("v.final", maximo);
            } else {
                component.set("v.adelanteDisable", false);
            }
            
            for (let i = 0; i < maximo; i++) {
                data.push(listadoFinal[i]);
            }

            component.set("v.listaCombosVista", data);
            component.set("v.listaCombosTotales", listadoFinal);

        } else if (listado == 'accesorios') {
            let listadoFiltrar = component.get("v.listaAccesoriosOriginal");

			let listadoFinal = listadoFiltrar.filter(
                elem => ((elem.Descripcion__c != null && elem.Descripcion__c.toUpperCase().includes(parametro)) || 
                         (elem.CodigoParte__c != null && elem.CodigoParte__c.toUpperCase().includes(parametro))
                        )
            );
            
            var maximo = 10;
            var data = [];
            
            if (listadoFinal.length < maximo) {
                maximo = listadoFinal.length;
                component.set("v.adelanteDisable", true);
                component.set("v.final", maximo);
            } else {
                component.set("v.adelanteDisable", false);
            }
            
            for (let i = 0; i < maximo; i++) {
                data.push(listadoFinal[i]);
            }
            
            component.set("v.listaAccesoriosVista", data);
            component.set("v.listaAccesoriosTotales", listadoFinal);
        }
    }
})