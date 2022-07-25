({
    doInit : function (component, event, helper) {
        var id = component.get("v.recordId");
        var tipoCuenta = component.get("v.sObjectName");

        var erroresNotificados = component.get("c.erroresNotificados");
        erroresNotificados.setParams({ identificacion : id });
        erroresNotificados.setCallback(this, function(response){
            let state = response.getState();
            console.log('Respuesta de erroresNotificados: ' + response.getReturnValue());
            if (state == "SUCCESS") { 
                if (response.getReturnValue()) {
                    component.set("v.msjeError", response.getReturnValue());
                }
            } else {
                console.log('Algo a salido mal en ErroresNotificados: ' + state);
            }
        });

        $A.enqueueAction(erroresNotificados);

        var yaHaSidoEnviado = component.get("c.yaHaSidoEnviado");
        var msjeError = component.get("v.msjeError");
        yaHaSidoEnviado.setParams({ identificacion : id,
                                    tipoCuenta : tipoCuenta});
        yaHaSidoEnviado.setCallback(this, function(response){
            let state = response.getState();
            console.log('Respuesta de yaHaSidoEnviado: ' + response.getReturnValue());
            if (state == "SUCCESS") {
                if (response.getReturnValue() == true && msjeError == null) {
						$A.get('e.force:refreshView').fire();
                }
                component.set("v.yaHaSidoEnviado", response.getReturnValue());
            } else {
                console.log('Algo a salido mal en YaHaSidoEnviado: ' + state);
            }
		});

        $A.enqueueAction(yaHaSidoEnviado);
        
        setTimeout(function() {
            if (component.get("v.yaHaSidoEnviado") == false && component.get("v.msjeError") == null) {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info",
                        "message": "Esperando respuesta del servidor, aguarde un momento.",
                        "type" : "info"
                    });
                    toastEvent.fire();
            }
            
          	var yaHaSidoEnviado = component.get("c.yaHaSidoEnviado");
            var msjeError = component.get("v.msjeError");
            yaHaSidoEnviado.setParams({ identificacion : id,
                                        tipoCuenta : tipoCuenta});
            yaHaSidoEnviado.setCallback(this, function(response){
                let state = response.getState();
                console.log('Respuesta con Delay de yaHaSidoEnviado: ' + response.getReturnValue());
                if (state == "SUCCESS") {
                    if (response.getReturnValue() == true && msjeError == null) {
						$A.get('e.force:refreshView').fire(); 
                    }
                    component.set("v.yaHaSidoEnviado", response.getReturnValue());
                } else {
                    console.log('Algo a salido mal en YaHaSidoEnviado: ' + state);
                }
            });
    
            $A.enqueueAction(yaHaSidoEnviado);
            
            var erroresNotificados = component.get("c.erroresNotificados");
            erroresNotificados.setParams({ identificacion : id });
            erroresNotificados.setCallback(this, function(response){
                let state = response.getState();
                console.log('Respuesta de erroresNotificados: ' + response.getReturnValue());
                if (state == "SUCCESS") { 
                    if (response.getReturnValue()) {
                        component.set("v.msjeError", response.getReturnValue());
                    }
                } else {
                    console.log('Algo a salido mal en ErroresNotificados: ' + state);
                }
            });
    
            $A.enqueueAction(erroresNotificados);
        }, 5000);
        
        setTimeout(function() {
          	var yaHaSidoEnviado = component.get("c.yaHaSidoEnviado");
            var msjeError = component.get("v.msjeError");
            yaHaSidoEnviado.setParams({ identificacion : id,
                                        tipoCuenta : tipoCuenta});
            yaHaSidoEnviado.setCallback(this, function(response){
                let state = response.getState();
                console.log('Respuesta con Delay de yaHaSidoEnviado: ' + response.getReturnValue());
                if (state == "SUCCESS") {
                    if (response.getReturnValue() == true && msjeError == null) {
						$A.get('e.force:refreshView').fire(); 
                    }
                    component.set("v.yaHaSidoEnviado", response.getReturnValue());
                } else {
                    console.log('Algo a salido mal en YaHaSidoEnviado: ' + state);
                }
            });
    
            $A.enqueueAction(yaHaSidoEnviado);
            
            var erroresNotificados = component.get("c.erroresNotificados");
            erroresNotificados.setParams({ identificacion : id });
            erroresNotificados.setCallback(this, function(response){
                let state = response.getState();
                console.log('Respuesta de erroresNotificados: ' + response.getReturnValue());
                if (state == "SUCCESS") { 
                    if (response.getReturnValue()) {
                        component.set("v.msjeError", response.getReturnValue());
                    }
                } else {
                    console.log('Algo a salido mal en ErroresNotificados: ' + state);
                }
            });
    
            $A.enqueueAction(erroresNotificados);
        }, 10000);
        
        setTimeout(function() {
            if (component.get("v.yaHaSidoEnviado") == false && component.get("v.msjeError") == null) {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info",
                        "message": "El servidor está tardando mucho en responder, por favor actualice la página.",
                        "type" : "info"
                    });
                    toastEvent.fire();
            }
        }, 15000)
    },

    reenviarCliente : function(component, event, helper) {
        var recall = component.get("c.recall");
        var id = component.get("v.recordId");
        var tipoCuenta = component.get("v.sObjectName");
        recall.setParams({ identificacion : id,
                            tipoCuenta : tipoCuenta});
        recall.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Send",
                    "message": "Se ha enviado nuevamente al WS.",
                    "type" : "info"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "El reenvio ha fallado" + response.getError() + '.',
                    "type" : "error"
                });
                toastEvent.fire();
            }
            window.location.reload();
		});
        $A.enqueueAction(recall);
    }
})