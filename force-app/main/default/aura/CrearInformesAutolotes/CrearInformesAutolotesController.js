({
    init : function(cmp, event, helper) {
        var actions = [
            { label: 'Crear Informe de Negociación', name: 'InformeNegociacion'}
        ];
        
        cmp.set('v.columns', [
            { label: 'Marca', fieldName: 'marca', type: 'text' },
            { label: 'Modelo', fieldName: 'modelo', type: 'text' },
            { label: 'Chasis', fieldName: 'chasis', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
        
        helper.ObtenerDatos(cmp);
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

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        console.log(row.id);
        console.log(row.chasis);
        
        if (action.name == 'InformeNegociacion') {
            helper.GenerarInformeNegociacion(cmp, row);
        }
    }
})