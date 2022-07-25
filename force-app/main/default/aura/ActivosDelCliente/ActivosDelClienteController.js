({
    doInit : function(component, event, helper) {    
        var columnas = [
            { label: 'Modelo', fieldName: 'descripcionModeloGenerico', type: 'text', cellAttributes: { alignment: 'left'}},
            { label: 'Año', fieldName: 'anno', type: 'text', initialWidth: 80, cellAttributes: { alignment: 'center'}},
            { label: 'Placa', fieldName: 'placa', type: 'text', cellAttributes: { alignment: 'left'}},
            { label: 'Chasis', fieldName: 'chassis', type: 'text', cellAttributes: { alignment: 'left'}},
            { label: 'Recorrido', fieldName: 'kilometraje', type: 'number', cellAttributes: { alignment: 'right'}},
            { label: 'Fecha de Venta', fieldName: 'fechaVenta', type: 'text', cellAttributes: { alignment: 'left'}},
            { label: 'Estado', fieldName: 'estado', type: 'text', cellAttributes: { alignment: 'center'}}
        ];

        component.set("v.columnas", columnas);

        var action = component.get("c.obtenerActivos");
        var IDCliente = component.get("v.recordId");

        action.setParams({
            "IDCliente" : IDCliente 
        })

        action.setCallback(this, function(response) {
            component.set("v.spinner", true);
            var state = response.getState();                
            if (state === "SUCCESS") {
                var list = response.getReturnValue();

                component.set("v.cantidad", list.length);

                list.sort((a, b) => {
                    if (a.estado == 'A' && b.estado == 'A') {
                        return 0;
                    } else if (a.estado == 'A') {
                        return -1;
                    } else {
                        return 1;
                    }
                });

                component.set("v.activosList", list);

                console.log('Empieza a cargar');
            } else {
                console.log("Fallo en el estado " + state);
            }
        });
        
        $A.enqueueAction(action);
    }
})