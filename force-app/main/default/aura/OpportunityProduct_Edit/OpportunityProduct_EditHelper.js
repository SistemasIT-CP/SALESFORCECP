({
    ObtenerDatos: function (cmp) {
       var action = cmp.get("c.getProductos");
        action.setParams ({
             "idOpp": cmp.get("v.recordId")
         });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var data = response.getReturnValue();
                for (var i = 0; i < data.length; i++) {
                    var row = data[i];
                    if (row.Product2) row.Product2Name = row.Product2.Name;
            	}
                cmp.set("v.data", data);
            }
        });
        
        $A.enqueueAction(action);
    },

    ObtenerTipoOportunidad : function(cmp) {
        var recordID = cmp.get("v.recordId");

        var action = cmp.get("c.obtenerRecordTypeOpp");
        
        action.setParams({
            "recordID" : recordID
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                cmp.set("v.tipoOportunidad", response.getReturnValue());
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
    },

    LlamarDevolucion : function(cmp, idProd, motivo, tipo) {
        var action = cmp.get("c.Desasignar");
        action.setParams ({
            "idOppProd": idProd,
            "motivo": motivo,
            "tipoDeasignacion" : tipo
        });
        
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS"){
                var data = response.getReturnValue();
                if(data == "MotorChasisNoAsignado"){
                    this.showToast(
                        "Error",
                        "Deasignar", 
                        "Para poder deasignar primero debe haber un chasis asignado."
                    );
                    return;
                } else if (data == 'InformeExistente') {
                    this.showToast(
                        "Error",
                        "Deasignar", 
                        "Para poder deasignar primero elimine el informe de negociacion existente."
                    );
                } else  if (data == 'ok') {
                    this.showToast( 
                        "Success",
                        "Deasignar", 
                        "El motor y chasis fueron desasignados con exito."
                    );

                    try{
                        this.ObtenerDatos(cmp);
                    }

                    catch (e) {
                        alert (e);
                    }   

                } else {
                    this.showToast(
                        "Error",
                        "Deasignar", 
                        data
                    );
                }
            }
        });
        
        $A.enqueueAction(action); 
    }
});