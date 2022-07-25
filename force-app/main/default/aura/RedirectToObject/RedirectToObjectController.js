({
    redireccionar : function(component, event, helper) {
        let urlString = window.location.href;
        let baseURL = urlString.substring(0, urlString.indexOf("Debug"));        
        var debugRecord = component.get("v.debugRecord");
        switch (debugRecord.Objeto__c) {
            case 'CONTACTO':
                var objeto = 'Contact';
                break;
            case 'CORREO':
                var objeto = 'Correo__c';
                break; 
            case 'TELEFONO':
                var objeto = 'Telefono__c';
                break; 
            case 'DIRECCION':
                var objeto = 'DireccionesAlter__c';
                break;
            case 'CUENTA':
                var objeto = 'Account';
                break;
            case 'CONTACTO 0 DE CUENTA JURIDICA':
                var objeto = 'Account';
                break;
        }
        
        var id = debugRecord.ID_Objeto__c;
        
        let vfUrl = baseURL + objeto + "/" + id + "/view";
        console.log(vfUrl);
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": vfUrl
        });
        urlEvent.fire();
    }
})