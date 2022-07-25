({
    init: function (cmp, event, helper) {
        var actions = [
            { label: 'Asignar Motor/Chasis', name: 'Asignar' },
            { label: 'Reservar Vehiculo sin Chasis', name: 'ReservarSinChasis', disabled: false},
            { label: 'Desasignar', name: 'Desasignar' },
            { label: 'Devolucion', name: 'Devolucion' },
            { label: 'Crear Informe de Negociación', name: 'InformeNegociacion'}
        ];
        
        cmp.set('v.columns', [
            { label: 'Producto', fieldName: 'Product2Name', type: 'text' },
            { label: 'Motor', fieldName: 'Motor__c', type: 'text' },
            { label: 'Chasis', fieldName: 'Chasis__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.ObtenerDatos(cmp);
        helper.ObtenerTipoOportunidad(cmp);
    },
    
    
    closeAsignar : function(cmp, event, helper){
        cmp.set("v.OpenAsignar", false);      
    },
    
    Asignar : function(cmp, event, helper){
        if (cmp.get("v.Motor") == ""){
            helper.showToast("Warning",
                            "Asignar Motor/Chasis", 
                            "Debe de seleccionar un Motor/Chasis"
                            );
            return;
        }        
        
        var action = cmp.get("c.AsignarMotorChasis");
        action.setParams ({
            "idOppProd": cmp.get("v.Producto_Id"),
            "Motor": cmp.get("v.Motor"),
            "Chasis": cmp.get("v.Chasis"),
            "Color": cmp.get("v.Color")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var data = response.getReturnValue();

                if(data == 'ok') {
                    try{
                        helper.ObtenerDatos(cmp);
                    }
                    catch (e) {
                        alert (e);
                    }
                    cmp.set("v.OpenAsignar", false); 
                } else if (data == 'nada') {
                    cmp.set("v.OpenAsignar", false); 
                } else {
                    helper.showToast(
                        "Error",
                        "Asignar Motor/Chasis", 
                        data
                        );
                }
            }
        });
        
        $A.enqueueAction(action);      
    },
    
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'Asignar':
                cmp.set("v.F_Compania", row.Opportunity.Compa_a__r.productCode__c);
                cmp.set("v.F_Linea", row.Opportunity.L_neas_de_Negocio__r.productCode__c);
                cmp.set("v.F_Marca", row.Product2.codigomarca__c);
                cmp.set("v.Producto_Id",row.Id);
                cmp.set("v.Producto_Nombre",row.Product2Name);
                if(cmp.get("v.tipoOportunidad").includes("Principal_Motos")) {
                    cmp.set("v.F_Modelo", row.Product2.Codigomodelofabrica__c);
                    console.log('Modelo: ' + cmp.get("v.F_Modelo"));
                }
                cmp.set("v.Motor",row.Motor__c);
                cmp.set("v.Chasis",row.Chasis__c);
                cmp.set("v.OpenAsignar", true);
                break;
            case 'ReservarSinChasis':
                var action = cmp.get("c.AsignarMotorChasis");
                var color = prompt("Elija el color del vehículo:");
                action.setParams ({
                    "idOppProd": row.Id,
                    "Motor": '',
                    "Chasis": 'SIN CHASIS',
                    "Color": color
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var data = response.getReturnValue();

                        if(data == 'ok') {
                            try{
                                helper.ObtenerDatos(cmp);
                            }
                            catch (e) {
                                alert (e);
                            }  
                        } else if (data == 'nada') {
                            try{
                                helper.ObtenerDatos(cmp);
                            }
                            catch (e) {
                                alert (e);
                            }  
                        } else {
                            helper.showToast(
                                "Error",
                                "Asignar Motor/Chasis", 
                                data
                                );
                        }
                    }
                });
                
                $A.enqueueAction(action);      
                break;
            case 'Desasignar':
                var motivo = prompt("Ingrese un comentario:");
                helper.LlamarDevolucion(cmp, row.Id, motivo, 'Deasignar');
                break;
            case 'Devolucion':
                var motivo = prompt("Ingrese un comentario:");
                helper.LlamarDevolucion(cmp, row.Id, motivo, 'Devolucion');
                break;
            case 'InformeNegociacion':
                var action = cmp.get("c.CrearInformeNegociacion");
                action.setParams ({
                    "idOppProd": row.Id
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var data = response.getReturnValue();
                        console.log(response.getReturnValue());
                        if(data == "InformeYaCreado"){
                            helper.showToast( 
                                "Error",
                                "Informe de Negociacion",
                                "Ya ha sido creado con anterioridad un Informe de Negociación para el producto " + row.Product2Name
                                );
                            return;
                        }
                        if(data == "MotorChasisNoAsignado"){
                           helper.showToast( 
                                "Error",
                                "Informe de Negociacion", 
                                "Para poder crear un Informe de Negociación primero debe de asignar el motor/chasis"
                                );
                            return;
                         }
                        
                         helper.showToast( 
                                "Success",
                                "Informe de Negociacion", 
                                "El Informe de Negociación ha sido creado para el producto " + row.Product2Name
                                );
                         $A.get('e.force:refreshView').fire();
                    } else {
                        console.log('Error');
                    }
                });
                 $A.enqueueAction(action); 
                break;
        }
    },
    
    actualizar : function (cmp, event, helper) {
    	let changeType = event.getParams().changeType;
        if (changeType === "CHANGED") {
            var campoCambia = JSON.stringify(event.getParams().changedFields);
            if (campoCambia.includes('Cantidad_de_Veh_culos__c')) {
                helper.ObtenerDatos(cmp);
            }
        }
    },

    verificarPerfil : function (cmp, event, helper) {
        var perfil = cmp.get('v.CurrentUser')['Profile'].Name;
        
        // if (perfil.toUpperCase().includes('ADMIN') || perfil.toUpperCase().includes('GERENTE')) {
        //     var columnas = cmp.get('v.columns');
        //     columnas[3].typeAttributes.rowActions[1].disabled = false;
        //     cmp.set('v.columns', columnas);
        // }
    }
});