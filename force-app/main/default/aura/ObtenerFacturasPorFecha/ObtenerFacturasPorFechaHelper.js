({
    controlarVentanas : function(component, element, orden) {
        if (orden == "abrir") {
            component.set(element, true);
        } else {
            component.set(element, false);
        }
    },

    consumirWSfacturas : function(component) {
        var action = component.get("c.procesaFacturasAutomaticasPorFecha");
        var fecha = component.get("v.fecha");

        console.log(component.get("v.fecha"));

        component.set("v.loaded", true);
        component.set("v.disabled", true);

        action.setParams({
            "fecha" : fecha
        });

        action.setCallback(this, function(response) {
            component.set("v.loaded", false);
            component.set("v.disabled", false);
            var state = response.getState();                
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                this.controlarVentanas(component, "v.elegirFecha", "cerrar");
            } else {
                console.log('Algo ha salido mal');
            }
        });
        
        $A.enqueueAction(action); 
    },

    consumirWSdevoluciones : function(component) {
        var action = component.get("c.procesaDevoluciones");

        action.setCallback(this, function(response) {
            var state = response.getState();                
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            } else {
                console.log('Algo ha salido mal');
            }
        });
        
        $A.enqueueAction(action); 
    }
})