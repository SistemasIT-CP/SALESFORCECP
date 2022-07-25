({
    handleClick: function(cmp, event, helper) {
        var tipoCuenta = cmp.get("c.tipoDeCuenta");
        tipoCuenta.setParams ({
            "cuentaID": cmp.get("v.recordId")
        });
    
        tipoCuenta.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS"){
                var tipo = response.getReturnValue();
                console.log(tipo);
                if(tipo == "Personal") {
                    var opciones = [{'label': 'Cedula de Identidad', 'value': 'Cedula de Identidad'},
                                   {'label': 'Cedula de Residente', 'value': 'Cedula de Residente'},
                                   {'label': 'Pasaporte', 'value': 'Pasaporte'},
                                   {'label': 'DUI', 'value': 'DUI'},
                                   {'label': 'Otros', 'value': 'Otros'}];
                    cmp.set("v.options", opciones);
                }
                
                if (tipo == "Error") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "Error",
                        "title": "Error.",
                        "message": "Hubo algún error, por favor consulte con un administrador."
                    });
                    toastEvent.fire();
                } else {
                    cmp.set("v.button", false);
                    cmp.set("v.tipoCuenta", tipo);
                }
            }
        });
        
        $A.enqueueAction(tipoCuenta);     
    },
    
    aprobar: function(cmp, event, helper) {
        var aprobar = cmp.get("c.enviarAprobacion");
        var archivos = cmp.get("v.archivos");
        var tipo = cmp.get("v.tipoCuenta");
        
        var name;
        
        if (tipo == 'Juridica') {
            name = cmp.find("name").get("v.value");

            if (name.length == 0) {
                name = '--';
            }
        } else {
            let primerNombre = cmp.find("firstName").get("v.value");
            let segundoNombre = cmp.find("middleName").get("v.value");
            let apellido = cmp.find("lastName").get("v.value");
            
            name = primerNombre + '-' + segundoNombre + '-' + apellido;
        }

        if (archivos != 0) {
            aprobar.setParams ({
                "cuentaID": cmp.get("v.recordId"),
                "name": name,
                "tipo": cmp.find("tipo").get("v.value"),
                "cedula": cmp.find("cedula").get("v.value"),
                "idArhivos": cmp.get("v.nombreArchivos")
            });
        
            aprobar.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS"){
                    var res = response.getReturnValue();
                    if (res == 'Ok') {
                        cmp.set("v.button", true);
                        helper.mostrarAviso("Envío exitoso.", 
                                             "Los cambios han sido enviado a aprobación con éxito.",
                                             "Success");
                        $A.get('e.force:refreshView').fire(); 
                    } else {
                        helper.mostrarAviso("Error.", 
                                             res,
                                             "Error");
                    }
                }
            });
            
            $A.enqueueAction(aprobar);  
        } else {
            console.log('no hay nada');
            helper.mostrarAviso("Error.", 
                                "Ingrese al menos un archivo para justificar el cambio.",
                                "Error");
        }
    },
    
    handleUploadFinished: function (cmp, event) {
        var cantidad = cmp.get("v.archivos");
        var idListado = '';

        var uploadedFiles = event.getParam("files");    

        cantidad += uploadedFiles.length;
        
        uploadedFiles.forEach(file => idListado = idListado + file.documentId + ';');
        
        if (cantidad > 2) {
            var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "type" : "Error",
                "title": "Error.",
                "message": "No es posible ingresar más de 2 archivos."
            });

            toastEvent.fire();

            var eliminar = cmp.get("c.eliminarDocumentos");

            console.log(eliminar != null);

            eliminar.setParams({
                "idArhivos" : idListado
            });

            eliminar.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
            });

            $A.enqueueAction(eliminar);  

        } else {
            console.log(idListado);
            
            cmp.set("v.archivos", cantidad);
            cmp.set("v.nombreArchivos", idListado);
        }
    }
})