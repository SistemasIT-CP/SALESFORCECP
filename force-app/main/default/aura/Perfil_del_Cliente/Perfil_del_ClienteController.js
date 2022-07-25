({
	ObtenerDatos : function(component, event, helper) {
        helper.EjecutarGetComentario(component);
        helper.EjecutarGetAccountID(component);
	},

	Cliente: function(component, event, helper) {
        var accountId = component.get("v.cuentaId");
        var url = '/lightning/r/Account/' + accountId + '/view';
        window.open(url, '_blank');
	},
    
	PerfilCliente: function(component, event, helper) {
        var accountIdvf = component.get("v.cuentaId");
        var oppID = component.get("v.recordId");
        var tipoCuenta = component.get("v.tipo_cuenta");
        console.log('tipo: ' + tipoCuenta);
        if (tipoCuenta == "Jurídicos" ) {
            var url = '/apex/Perfil_del_Cliente_PJuridica_PDF?id=' + accountIdvf + '&idOpp=' + oppID;
            window.open(url, '_blank');
        } else {
			var url = '/apex/Perfil_del_Cliente_PDF?id=' + accountIdvf + '&idOpp=' + oppID;
            window.open(url, '_blank'); 
        }   
    },

    ChangeStage: function(component, event, helper) {
        let changeType = event.getParams().changeType;
        if (changeType === "CHANGED" || changeType === "LOADED") { 
            let estado = component.get('v.caseSimpleRecord').StageName;
            if (estado == 'Contacto Exitoso' || estado == 'Seleccionando Modelo' || estado == 'Negociacion') {
                component.set("v.boton", "true");
            } else {
                component.set("v.boton", "false");
            }
        }
    },

    ActivarModoEscritura : function(component, event, helper) {
        component.set("v.modoLectura", false);
    },

    CerrarModoEscritura : function(component, event, helper) {
        component.set("v.modoLectura", true);
    },

    GuardarComentarioNuevo : function(component, event, helper) {
        helper.EjecutarSetComentario(component);
    }
})