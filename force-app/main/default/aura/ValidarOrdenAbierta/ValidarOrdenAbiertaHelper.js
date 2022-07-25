({
    llamarWSOrdenAbierta: function(component) {
        var llamarWS = component.get("c.validaChasisOrdenAbierta");
        var idOportunidad = component.get("v.recordId");

        llamarWS.setParams({
            "opportunityId": idOportunidad
        });

        llamarWS.setCallback(this, function(response) {
            var state = response.getState();
            console.log('metodo para llamar ' + state);


            if (state === "SUCCESS") {
                if (response.getReturnValue().includes('Ok')) {
                    var mensaje = response.getReturnValue().split(':')[1];
                    console.log('metodo para llamar 2 ' + mensaje);
                    this.showToast('Success', 'Todo ha salido bien', mensaje);


                } else {
                    this.showToast('Error', 'Algo ha salido mal', response.getReturnValue());
                }
                $A.get('e.force:refreshView').fire();
            } else {
                this.showToast('Error', 'Algo ha salido mal', response.getReturnValue());
            }
        });

        $A.enqueueAction(llamarWS);
    },

    showToast: function(tipo, titulo, msj) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": tipo,
            "title": titulo,
            "message": msj
        });
        toastEvent.fire();
    }

})