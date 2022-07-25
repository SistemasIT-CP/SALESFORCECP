({
    mostrarMensaje : function(tipo, titulo, mensaje) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": mensaje
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
    }
})