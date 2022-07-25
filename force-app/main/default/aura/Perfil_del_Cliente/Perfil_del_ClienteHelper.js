({
	EjecutarGetAccountID : function(component) {
		var action = component.get("c.getAccountId");
        action.setParams({
            recordId: component.get("v.recordId")  
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var array_cuenta = response.getReturnValue();
                component.set("v.cuentaId", array_cuenta[0]);
                component.set("v.nombre_cuenta", array_cuenta[1]);
                component.set("v.tipo_cuenta", array_cuenta[2]);
            }
		});
        $A.enqueueAction(action);
	},

    EjecutarGetComentario : function(component) {
        var action = component.get("c.getComentario");
        action.setParams({
            recordId: component.get("v.recordId")  
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var comentario = response.getReturnValue();
                component.set("v.comentarioPIC", comentario);
            }
		});
        $A.enqueueAction(action);
    },

    EjecutarSetComentario : function(component) {
        var action = component.get("c.setComentario");
        action.setParams({
            recordId: component.get("v.recordId"),
            comentario: component.get("v.comentarioPIC")  
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var resultado = response.getReturnValue();
                if (resultado != 'Error') {
                    component.set("v.modoLectura", true);
                } else {
                    console.log('Error:' + resultado);
                }
            } else {
                console.log('Error:' + response.getState());
            }
		});
        $A.enqueueAction(action);
    }
})