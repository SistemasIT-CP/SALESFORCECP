({
    ObtenerDatos : function(cmp) {
        var action = cmp.get("c.obtenerVehiculos");
        action.setParams ({
            "oppId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS"){
                var data = response.getReturnValue();

                var lista = []

                for (var i = 0; i < data.length; i++) {
                    var dato = data[i];

                    var aux = {};
                    aux['chasis'] = dato.Chasis__c;
                    aux['modelo'] = dato.Modelo__r.Name;
                    aux['marca'] = dato.Marca__r.Name;
                    aux['id'] = dato.Id;

                    lista.push(aux);
                }

                cmp.set("v.data", lista);
            } else {
                this.showToast( 
                    "Error",
                    "Error", 
                    "Algo ha salido mal"
                    );
            }
        });

        $A.enqueueAction(action); 
    },

    GenerarInformeNegociacion : function(cmp, row) {
        var action = cmp.get("c.CrearInformeNegociacion");

        action.setParams ({
            "vehId": row.id,
            "oppId": cmp.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var data = response.getReturnValue();

                if(data != "Bien"){
                    this.showToast( 
                        "Error",
                        "Informe de Negociacion",
                        data
                        );
                    return;
                } else {
                    this.showToast( 
                        "Success",
                        "Informe de Negociacion", 
                        "El Informe de Negociación ha sido creado con éxito"
                        );
                    $A.get('e.force:refreshView').fire();
                }
            } else {
                this.showToast( 
                    "Error",
                    "Error", 
                    "Algo ha salido mal"
                    );
            }
        });

        $A.enqueueAction(action); 
    },

    showToast : function(tipo, titulo, msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    }
})