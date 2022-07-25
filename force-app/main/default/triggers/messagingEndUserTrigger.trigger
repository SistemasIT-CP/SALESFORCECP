trigger messagingEndUserTrigger on MessagingEndUser (before insert, before update) {
    if (Trigger.isBefore) {
        List<MessagingEndUser> usuariosWpp = new List<MessagingEndUser>();
        List<MessagingEndUser> msjeConCuenta = new List<MessagingEndUser>();
        
        if (Trigger.isInsert) {
            List<MessagingEndUser> msjeWppSinCuenta = new List<MessagingEndUser>();

            for (MessagingEndUser msj : Trigger.new) {
                if (msj.MessagingPlatformKey.contains('whatsapp:')) {
                    if (String.isBlank(msj.AccountID)) {
                    	msjeWppSinCuenta.add(msj);
                	} else {
                        msjeConCuenta.add(msj);
                    }
                    
                    usuariosWpp.add(msj);
                }
            }
                                
            if (!usuariosWpp.isEmpty()) {
                MessagingEndUserHelper.validarTelefono(usuariosWpp);
            }
            
            if (!msjeConCuenta.isEmpty()) {
            	MessagingEndUserHelper.validarCuentaPersonal(msjeConCuenta);    
            }
            
            if (!msjeWppSinCuenta.isEmpty()) {
                MessagingEndUserHelper.setearCuenta(msjeWppSinCuenta);
            }
        }
        
        if (Trigger.isUpdate) {
            for (MessagingEndUser msj : Trigger.new) {
				if (msj.AccountId != Trigger.oldMap.get(msj.Id).AccountId) {
                    if (String.isNotBlank(msj.AccountId)) {
                        msjeConCuenta.add(msj);    
                    }
                }
            }
            
            if (!msjeConCuenta.isEmpty()) {
            	MessagingEndUserHelper.validarCuentaPersonal(msjeConCuenta);    
            }
        }
    }
}