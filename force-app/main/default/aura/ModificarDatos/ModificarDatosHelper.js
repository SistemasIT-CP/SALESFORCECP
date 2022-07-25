({
    mostrarAviso : function (titulo, mensaje, tipo) {
        console.log('mostrar aviso');
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "type" : tipo,
            "title": titulo,
            "message": mensaje
        });

        toastEvent.fire();
    }
})