public class ModificarDatosDeCuenta {
	@AuraEnabled
    public static String tipoDeCuenta(ID cuentaID) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        List<Account> accList = 
            [SELECT RecordTypeID
            FROM Account
            WHERE ID =: cuentaID
            ];
        
        if (accList.isEmpty()) {
            return 'Error';
        } else {
            if(accList[0].RecordTypeID == personAccountID){
                return 'Personal';
            } else {
                return 'Juridica';
            }
        }
    }

    @AuraEnabled
    public static String eliminarDocumentos(String idArhivos) {
        List<String> idArchivosList = idArhivos.split(';');
        List<ContentDocumentLink> segImgLinkList = new List<ContentDocumentLink>();
        
        List<ContentDocument> imgList = 
        [SELECT ID
        FROM ContentDocument
        WHERE ID IN :idArchivosList
        ];
        
        List<ContentDocumentLink> imgLinkList = 
            [SELECT ID
            FROM ContentDocumentLink
            WHERE ContentDocumentId =: ID.valueOf(imgList[0].ID)
            ];
            
        if (imgList.size() > 1) {
            segImgLinkList = 
                [SELECT ID
                FROM ContentDocumentLink
                WHERE ContentDocumentId =: ID.valueOf(imgList[1].ID)
                ];
        }

        List<Database.DeleteResult> drLinkList;
        List<Database.DeleteResult> segDrLinkList;
        List<Database.DeleteResult> drList;

        if(!imgLinkList.isEmpty()) {
            drLinkList = Database.delete(imgLinkList, false);
            for (Database.DeleteResult dr : drLinkList) {
                if (!dr.isSuccess()) {
                    return 'Error';
                }
            }
        }

        if(!segImgLinkList.isEmpty()) {
            segDrLinkList = Database.delete(segImgLinkList, false);
            for (Database.DeleteResult dr : segDrLinkList) {
                if (!dr.isSuccess()) {
                    return 'Error';
                }
            }
        }

        if(!imgList.isEmpty()) {
            drList = Database.delete(imgList, false);
            for (Database.DeleteResult dr : drList) {
                if (!dr.isSuccess()) {
                    return 'Error';
                }
            }
        }
        return 'Ok';
    }
    
    @AuraEnabled
    public static String enviarAprobacion(ID cuentaID, String name, String tipo, String cedula, String idArhivos) {
        ID personAccountID = Schema.SObjectType.Account
                .getRecordTypeInfosByDeveloperName()
                .get('PersonAccount')
                .getRecordTypeId();
        
        ID usuario = UserInfo.getUserId();

        List<Account> updateAccList = 
            [SELECT Campo_auxiliar_para_cambios__c, Imagen_Identificacion_1_URL__c
            FROM Account
            WHERE ID =: cuentaID
            ];
        
        List<Account> accList = 
            [SELECT Name, Cedula__c, Tipo_de_Indentificaci_n__c, RecordTypeID, FirstName, MiddleName, LastName
            FROM Account
            WHERE ID =: cuentaID
            ];
        
        List<String> idArchivosList = idArhivos.split(';');
        
        List<ContentDocument> imgList = 
            [SELECT LatestPublishedVersionId, Title
            FROM ContentDocument
            WHERE ID IN :idArchivosList
            ];

        List<Account> cedulaRepetida;
        
        if (accList.isEmpty()) {
            return 'No se han encontrado registros.';
        } else {
            
            if ((String.isBlank(name) || name == '--') && String.isBlank(tipo) && String.isBlank(cedula)) {
                return 'No se puede enviar a aprobación con campos vacios.';
            }

            if(String.isNotBlank(name)) {
                if(name.length() > 40) {
                    return 'El Nombre tiene un max. permitido de 40 caracteres.';
                }
				
                if (name != '--') {
                    List<String> nombreSeparado = name.split('-');
    
                    if ((accList[0].RecordTypeId == personAccountID && nombreSeparado.size() == 1) || String.isBlank(nombreSeparado[0])) {
                        return 'Si va a editar el nombre, debe indicarlo completo.';
                    }
                }
            }
            
            if (String.isBlank(tipo) && String.isNotBlank(cedula)) {
                return 'Debe indicar un tipo de Identificación.';
            }

            if (String.isNotBlank(cedula) && tipo == 'Cedula de Identidad') {
                if (AccountHelper.validarCedulaIdentidad(cedula)) {
                    return 'La cedula de identidad no tiene el formato correcto.';
                }
            }

            if (String.isNotBlank(cedula) && tipo == 'RUC') {
                if (!Pattern.matches('^[A-Z]{1}-[0-9]{2}-[0-9]{1}-[0-9]{9}-[0-9]{1}$', cedula)) {
                    return 'La identificacion RUC no tiene el formato correcto.';
                }
            }

            if (String.isNotBlank(cedula) && tipo == 'DUI') {
                if (!Pattern.matches('^[0-9]{8}-[0-9]{1}$', cedula)) {
                    return 'La identificacion DUI no tiene el formato correcto.';
                }
            }

            if (String.isNotBlank(cedula)) {
                cedulaRepetida = [SELECT ID FROM Account WHERE Cedula__c =: cedula LIMIT 1];

                if (!cedulaRepetida.isEmpty()) {
                    return 'Ya existe un registro con esa cedula.';
                }
            }

            updateAccList[0].Requiere_aprobacion__c = usuario;
            
            updateAccList[0].Campo_auxiliar_para_cambios__c = name + ';' + tipo + ';' + cedula + ';';
            
            updateAccList[0].Imagen_Identificacion_1_URL__c = 
                '/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=' + 
                String.valueOf(imgList[0].LatestPublishedVersionId).substring(0, 15);

            if (imgList.size() > 1) {
                updateAccList[0].Imagen_Identificacion_2_URL__c = 
                    '/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=' + 
                    String.valueOf(imgList[1].LatestPublishedVersionId).substring(0, 15);
            }            
            
            Database.SaveResult[] srList = Database.update(updateAccList, false);
            
            if(!srList[0].isSuccess()) {
                return 'El proceso de actualización ha fallado.' + srList[0].getErrors()[0].message;
            } else {
                System.debug('Se ha actualizado correctamente la cuenta: ');
                System.debug(updateAccList[0]);
            }
        }
        
        String comentario = 'Se solicita modificar la cuenta ' + accList[0].Name + ': ' + '\n';
        
        if (accList[0].RecordTypeID == personAccountID) {
            List<String> nombreDividido = name.split('-');
            
            if(!nombreDividido.isEmpty()) {
                if (String.isNotBlank(nombreDividido[0])) {
                    comentario = comentario + '- ' + accList[0].FirstName + ' -> ' + nombreDividido[0].toUpperCase() + '\n';
                }
                if (String.isNotBlank(nombreDividido[1])) {
                    comentario = comentario + '- ' + accList[0].MiddleName + ' -> ' + nombreDividido[1].toUpperCase() + '\n';
                }
                if (nombreDividido.size() > 2 && String.isNotBlank(nombreDividido[2])) {
                    comentario = comentario + '- ' + accList[0].LastName + ' -> ' + nombreDividido[2].toUpperCase() + '\n';
                }
            }

        } else {
            if (String.isNotBlank(name) && name != '--') {
                comentario = comentario + '- ' + accList[0].Name + ' -> ' + name.replaceAll('-', ' ').toUpperCase() + '\n';
            }    
        }
        
        if (String.isNotBlank(tipo)) {
            comentario = comentario + '- ' + accList[0].Tipo_de_Indentificaci_n__c + ' -> ' + tipo + '\n';
        }
        
        if (String.isNotBlank(cedula)) {
            comentario = comentario + '- ' + accList[0].Cedula__c + ' -> ' + cedula + '\n';
        }

        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
		req.setObjectId(cuentaID);
        req.setComments(comentario);
        Approval.ProcessResult processResult = Approval.process(req);
        
        if(processResult.isSuccess()) {
            return 'Ok';
        } else {
            return 'El envio de aprobación ha fallado.';
        }
    }
}