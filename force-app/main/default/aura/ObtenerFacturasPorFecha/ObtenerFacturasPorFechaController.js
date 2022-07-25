({
    abrirElegirFecha : function(component, event, helper) {
        helper.controlarVentanas(component, "v.elegirFecha", "abrir");
    },

    cerrarElegirFecha : function(component, event, helper) {
        helper.controlarVentanas(component, "v.elegirFecha", "cerrar");
    },

    solicitarFacturas : function(component, event, helper) {
        helper.consumirWSfacturas(component);
    },

    consumirDevoluciones : function(component, event, helper) {
         helper.consumirWSdevoluciones(component);
     }
})