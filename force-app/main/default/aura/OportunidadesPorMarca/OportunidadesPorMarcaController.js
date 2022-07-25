({
    doInit : function(component, event, helper) {  
        var columns = [
            { label: 'Nombre de la oportunidad', fieldName: 'Name', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
            { label: 'Etapa', fieldName: 'StageName', sortable:false, type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'left'}},
            { label: 'Vendedor', fieldName: 'Vendedor', type: 'text', sortable:false, hideDefaultActions: true, cellAttributes: { alignment: 'left'}}
        ];

        component.set("v.columnas", columns);

        var obtenerOportunidades = component.get("c.obtenerOportunidades");
        var recordId = component.get("v.recordId");

        obtenerOportunidades.setParams({
            "cuentaID" : recordId
        });

        obtenerOportunidades.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var listaRespuesta = response.getReturnValue();
                if(listaRespuesta != null && listaRespuesta.length != 0) {
                    component.set("v.cantidadOportunidades", listaRespuesta.length);
                    var listaAux = [];
    
                    for (let i = 0; i < listaRespuesta.length; i++) {
                        console.log(listaRespuesta[i].Name);
                        console.log(listaRespuesta[i].Owner.Name);
                        
                        let elemAux = {
                            "Name": response.getReturnValue()[i].Name,
                            "StageName": response.getReturnValue()[i].StageName,
                            "Vendedor": response.getReturnValue()[i].Owner.Name
                        };
    
                        listaAux.push(elemAux);
                    }
                }


                component.set("v.listadoOportunidades", listaAux);
            }
        });
        
        $A.enqueueAction(obtenerOportunidades); 
    }
})