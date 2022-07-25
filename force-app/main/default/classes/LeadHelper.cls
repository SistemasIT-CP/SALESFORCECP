public without sharing class LeadHelper {
    public static void setearUDC(List<Lead> ldList) {
        ID paisUDCID = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Pais')
                .getRecordTypeId();

        ID modeloUDCID = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Modelo')
                .getRecordTypeId();

        ID marcasUDCID = Schema.SObjectType.Catalogo_UDC__c
                .getRecordTypeInfosByDeveloperName()
                .get('Marcas')
                .getRecordTypeId();

        ID ventasID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Ventas')
                                    .getRecordTypeId();
        
        ID ventasMotosID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Venta_motos')
                                    .getRecordTypeId();
                                    
        ID autoloteID = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Autolote')
                                    .getRecordTypeId();

        ID anfitrionId = Schema.SObjectType.Lead
                                    .getRecordTypeInfosByDeveloperName()
                                    .get('Anfitrion')
                                    .getRecordTypeId();
        
        List<ID> idUDCList = new List<ID>{paisUDCID, modeloUDCID, marcasUDCID};
        Map<String, ID> UDCIDByName = new Map<String, ID>(); 

        for (Catalogo_UDC__c cat : [SELECT ID, Name 
                                    FROM Catalogo_UDC__c
                                    WHERE RecordTypeID IN :idUDCList]) {
            UDCIDByName.put(cat.Name.toUpperCase(), cat.ID);
        }

        for (Lead ld : ldList) {
            if (ld.RecordTypeId == autoloteID) {
                ld.Marca_UDC__c = String.isNotBlank(ld.Marca_a_cotizar_autolote__c)? UDCIDByName.get(ld.Marca_a_cotizar_autolote__c.toUpperCase()) : null; 
                ld.Modelo_UDC__c = String.isNotBlank(ld.Modelo_a_cotizar_autolote__c)? UDCIDByName.get(ld.Modelo_a_cotizar_autolote__c.toUpperCase()) : null;
                if(String.isBlank(ld.Marca_a_cotizar_autolote__c)){
                    ld.Marca_UDC__c = String.isNotBlank(ld.Marca_a_cotizar__c)? UDCIDByName.get(ld.Marca_a_cotizar__c.toUpperCase()) : null; 
                }
                if(String.isBlank(ld.Modelo_a_cotizar_autolote__c)){
                    ld.Modelo_UDC__c = String.isNotBlank(ld.Modelo_a_cotizar__c)? UDCIDByName.get(ld.Modelo_a_cotizar__c.toUpperCase()) : null;
                }
                
            } else if (ld.RecordTypeId == ventasID || 
                            ld.RecordTypeId == ventasMotosID || 
                                ld.RecordTypeId == anfitrionId) {

                ld.Marca_UDC__c = String.isNotBlank(ld.Marca_a_cotizar__c)? UDCIDByName.get(ld.Marca_a_cotizar__c.toUpperCase()) : null; 
                ld.Modelo_UDC__c = String.isNotBlank(ld.Modelo_a_cotizar__c)? UDCIDByName.get(ld.Modelo_a_cotizar__c.toUpperCase()) : null;
            }

            ld.Pais_UDC__c = String.isNotBlank(ld.Pais_de_origen__c)? UDCIDByName.get(ld.Pais_de_origen__c.toUpperCase()) : null;
            ld.Title = 'Lead';
        }
    }

    public static void validarCamposRequeridosParaConversion(List<Lead> ldList) {
        List<Id> accIdList = new List<Id>();

        for (Lead ld : ldList) {
            accIdList.add(ld.ConvertedAccountId);
        }

        Map<Id, Account> accMap = new Map<Id, Account>([
            SELECT CreatedDate, LastName, FirstName, Direccion__c, Pa_s__c, IsPersonAccount,
                Tipo_de_t_lefono__c, Email__c, Tipo_de_Indentificaci_n__c, Cedula__c, Phone, 
                Tipo_de_email__c, Nacionalidad_UDC__c
            FROM Account
            WHERE Id IN : accIdList
        ]);

        for (Lead ld : ldList) {
            Account acc = accMap.get(ld.ConvertedAccountId);

            if (Date.valueOf(DateTime.now()).daysBetween(Date.valueOf(acc.CreatedDate)) == 0) {
                String mensaje = 'Para convertir debe completar los campos: ';
                Integer largoInicial = mensaje.length();
                
                mensaje += String.isBlank(ld.LastName)? 'Apellido, ' : '';
                mensaje += String.isBlank(ld.FirstName)? 'Nombre, ' : '';
                mensaje += String.isBlank(ld.Direccion__c)? 'Dirección, ' : '';
                mensaje += String.isBlank(ld.Pais_de_origen__c)? 'País, ' : '';
                mensaje += String.isBlank(ld.Tipo_de_telefono_UDC__c)? 'Tipo de teléfono, ' : '';
                mensaje += String.isBlank(ld.Email)? 'Email, ' : '';
                mensaje += String.isBlank(ld.Tipo_de_documento__c)? 'Tipo de identificación, ' : '';
                mensaje += String.isBlank(ld.Cedula_Nro__c)? 'Identificación, ' : '';
                mensaje += String.isBlank(ld.Phone)? 'Teléfono, ' : '';
                mensaje += String.isBlank(ld.Tipo_de_email_UDC__c)? 'Tipo de email, ' : '';

                if (String.isBlank(ld.Company)) {
                    mensaje += String.isBlank(ld.Nacionalidad__c)? 'Nacionalidad' : '';
                }

                if (mensaje.endsWith(', ')) {
                    mensaje = mensaje.removeEnd(', ');
                }

                if (mensaje.length() > largoInicial) {
                    ld.addError(mensaje);
                }

            } else {
                String mensaje = 'La cuenta que ha seleccionado tiene los siguientes campos requeridos vacios: ';
                Integer largoInicial = mensaje.length();
                
                mensaje += String.isBlank(acc.Direccion__c) && String.isBlank(ld.Direccion__c)? 'Dirección, ' : '';
                mensaje += String.isBlank(acc.Pa_s__c) && String.isBlank(ld.Pais_de_origen__c)? 'País, ' : '';
                mensaje += String.isBlank(acc.Tipo_de_t_lefono__c) && String.isBlank(ld.Tipo_de_telefono_UDC__c)? 'Tipo de teléfono, ' : '';
                mensaje += String.isBlank(acc.Email__c) && String.isBlank(ld.Email)? 'Email, ' : '';
                mensaje += String.isBlank(acc.Tipo_de_Indentificaci_n__c) && String.isBlank(ld.Tipo_de_documento__c)? 'Tipo de identificación, ' : '';
                mensaje += String.isBlank(acc.Cedula__c) && String.isBlank(ld.Cedula_Nro__c)? 'Identificación, ' : '';
                mensaje += String.isBlank(acc.Phone) && String.isBlank(ld.Phone)? 'Teléfono, ' : '';
                mensaje += String.isBlank(acc.Tipo_de_email__c) && String.isBlank(ld.Tipo_de_email_UDC__c)? 'Tipo de email, ' : '';
                
                if (String.isBlank(ld.Company)) {
                    mensaje += String.isBlank(acc.FirstName) && String.isBlank(ld.FirstName)? 'Nombre, ' : '';
                    mensaje += String.isBlank(acc.LastName) && String.isBlank(ld.LastName)? 'Apellido, ' : '';
                    mensaje += String.isBlank(acc.Nacionalidad_UDC__c) && String.isBlank(ld.Nacionalidad__c)? 'Nacionalidad' : '';
                }

                if (mensaje.endsWith(', ')) {
                    mensaje = mensaje.removeEnd(', ');
                }

                if (mensaje.length() > largoInicial) {
                    mensaje += '. Por favor rellenelos en el lead para convertir.';

                    ld.addError(mensaje);
                }
            }
        }
    }

    public static void uppercasearNombres(List<Lead> ldList) {
        for (Lead ld : ldList) {
            ld.FirstName = ld.FirstName != null? ld.FirstName.toUpperCase() : null;
            ld.MiddleName = ld.MiddleName != null? ld.MiddleName.toUpperCase() : null;
            ld.LastName = ld.LastName != null? ld.LastName.toUpperCase() : null;
            ld.Company = ld.Company != null? ld.Company.toUpperCase() : null;
        }
    }
    
    public static void administrarCuentasContactos(List<Lead> ldList) {
        List<String> listadoID = new List<String>();
        Map<ID, String> accMailByID = new Map<ID, String>();
        Integer size = 10;
        
        for (Lead ld : ldList) {
            if (String.isNotBlank(ld.Title)) {
                listadoID.add(ld.ConvertedAccountId + '_' + ld.ConvertedContactId);
            } else {
                listadoID.add(ld.ConvertedAccountId + '_' + ld.ConvertedContactId + '_' + ld.Title);
            }

            accMailByID.put(ld.ConvertedAccountId, ld.Email);
        }
        
        if (!listadoID.isEmpty()) {
        	if (listadoID.size() < 10 || Test.isRunningTest()) {
            	size = listadoID.size();
        	}
            
        	System.debug('Se envian ' + listadoID.size() + ' cuentas al Batch de Lead');
        	Database.executeBatch(new BatchToLead(listadoID, accMailByID), size);    
        }
    }
    
    public static void corregirEmail(List<Lead> ldList) {
        ID personAccountID = Schema.SObjectType.Account
                            .getRecordTypeInfosByDeveloperName()
                            .get('PersonAccount')
                            .getRecordTypeId();
        
        Map<ID, Lead> accountIDByLead = new Map<ID, Lead>();
        
        for (Lead ld : ldList) {
            accountIDByLead.put(ld.ConvertedAccountId, ld);
        }
        
        List<Account> accList = 
            [SELECT Email__c
            FROM Account
            WHERE ID IN :accountIDByLead.keySet() 
            	AND RecordTypeID =: personAccountID
            ];
        
        for (Account acc : accList) {
            if (String.isNotBlank(accountIDByLead.get(acc.ID).Email)) {
                acc.Email__c = accountIDByLead.get(acc.ID).Email;
            }
        }

        if (!accList.isEmpty()) {
            update accList;
        }
    }

    public static void setearCamposOportunidad(List<Lead> ldList) {
        ID ventaMotos = Schema.SObjectType.Lead
                            .getRecordTypeInfosByDeveloperName()
                            .get('Venta_motos')
                            .getRecordTypeId();
        
        Map<ID, Lead> leadsByOppID = new Map<ID, Lead>();

        for (Lead ld : ldList) {
            leadsByOppID.put(ld.ConvertedOpportunityId, ld);
        }

        List<Opportunity> oppList = 
            [SELECT ID, Forma_de_Pago_Multiple__c, Desea_realizar_intercambio__c
            FROM Opportunity 
            WHERE ID IN :leadsByOppID.keySet() 
            ];

        for (Opportunity opp : oppList) {
            Lead ld = leadsByOppID.get(opp.ID);
            	
            if (ld.RecordTypeId == ventaMotos) {
                if (ld.Como_desea_realizar_su_compra__c == 'Credex' || ld.Como_desea_realizar_su_compra__c == 'Credifacil' || 
                    ld.Como_desea_realizar_su_compra__c == 'FIDEM' || ld.Como_desea_realizar_su_compra__c == 'Instacredit') {
                	opp.Forma_de_Pago_Multiple__c = 'Financiamiento';
                    opp.Quien_concede__c = ld.Como_desea_realizar_su_compra__c.toUpperCase();
                } else {
                    opp.Forma_de_Pago_Multiple__c = ld.Como_desea_realizar_su_compra__c;
                }
            } else {
                if (ld.Como_desea_realizar_su_compra__c == 'Ciclo CP') {
                    opp.Forma_de_Pago_Multiple__c = 'Ciclo Casa Pellas';
                } else if (ld.Como_desea_realizar_su_compra__c == 'Aún no desea realizar su compra') {
                    opp.Forma_de_Pago_Multiple__c = 'Aun no desea realizar su compra';
                } else {
                    opp.Forma_de_Pago_Multiple__c = ld.Como_desea_realizar_su_compra__c;
                }
            }
            
            opp.Desea_realizar_intercambio__c = ld.Desea_realizar_intercambios__c? 'SI' : 'NO';
        }

        if (!oppList.isEmpty()) {
            update oppList;
        }
    }
}