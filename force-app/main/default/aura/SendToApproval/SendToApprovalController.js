({
	enviarParaAprobacion : function(component, event, helper) {
		
	var action = component.get("c.enviarReporte");
    action.setParams ({
        "informeID": component.get("v.recordId")
    });

    action.setCallback(this, function(response){
        var state = response.getState();

        if (state === "SUCCESS"){
            
            var data = response.getReturnValue();
            var message;
            var info = "Error";
            var title = "Error en envío a aprobación.";
            
            if (data == "Pendiente") {
                message = "El saldo pendiente debe ser igual a 0.";
            } else if (data == "Aprobado") {
                message = "El informe ya se encuentra Aprobado.";
            } else if (data.includes("Error")){
                message = data;
            } else if (data == "Ok") {
                info = "Success";
                title = "Envío exitoso.";
                message = "El informe ha sido enviado a aprobación con éxito."
            }
                
                
            if (message != null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : info,
                    "title": title,
                    "message": message
                });
                toastEvent.fire();
            }
        }
    });
    
    $A.enqueueAction(action);      
    }
})