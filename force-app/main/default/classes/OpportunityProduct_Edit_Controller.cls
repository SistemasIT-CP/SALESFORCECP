public without sharing class OpportunityProduct_Edit_Controller {

    @AuraEnabled
    public static List<OpportunityLineItem> getProductos(String idOpp) {

        List<OpportunityLineItem> lprodOpp = 
            [SELECT Id, Name, Product2.Name, Motor__c, Chasis__c, 
                    Opportunity.Compa_a__r.productCode__c,
                    Opportunity.Marca_UDC__r.productCode__c, 
                    Opportunity.L_neas_de_Negocio__r.productCode__c,
                    Product2.codigomarca__c, product2.Codigomodelofabrica__c 
            FROM OpportunityLineItem 
            WHERE OpportunityId = :idOpp
            ORDER BY CreatedDate
            ];
        
        return lprodOpp;
    }
    
    @AuraEnabled
    public static String AsignarMotorChasis(String idOppProd, 
                                            String Motor, 
                                            String Chasis, 
                                            String Color
    ) { 
        List<OpportunityLineItem> oppProd = [
            SELECT ID, Motor__c, Chasis__c, IdInformeNegociacion__c, Quantity, Tipo_de_reserva__c
            FROM OpportunityLineItem 
            WHERE Id = :idOppProd
            ];

        if (oppProd[0].Quantity > 1) {
            return 'Para asignar chasis debe haber 1 solo producto asignado.';   
        }

        if (String.isNotBlank(oppProd[0].IdInformeNegociacion__c)) {
            List<Informe_de_Negociaci_n__c> InfNeg = [
                SELECT ID 
                FROM Informe_de_Negociaci_n__c 
                WHERE ID = :oppProd[0].IdInformeNegociacion__c
                ];
            
            if (!InfNeg.isEmpty()) {
                return 'Para modificar el chasis no debe haber informe de negociación asignado.';    
            }
        }

        if (String.isNotBlank(Chasis)) {
            List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();

            if (chasis != 'SIN CHASIS') {
                oppProdList = [
                    SELECT ID, Opportunity.Name, Chasis__c, Opportunity.Owner.Name
                    FROM OpportunityLineItem
                    WHERE Chasis__c =: Chasis
                        AND Opportunity.StageName != 'Cerrada perdida' 
                    ];
            }
    
            if (oppProdList.isEmpty()) {
                if (String.isBlank(oppProd[0].Chasis__c)) {
                    oppProd[0].Motor__c = Motor;
                    oppProd[0].Chasis__c = Chasis;
                    oppProd[0].Color__c = Color;
                    oppProd[0].IdInformeNegociacion__c = '';

                    if (String.isBlank(oppProd[0].Tipo_de_reserva__c)) {
                        oppProd[0].Tipo_de_reserva__c = 'Nueva';
                    } else {
                        oppProd[0].Tipo_de_reserva__c = 'Cambio';
                    }
            
                    update oppProd;
            
                    return 'ok';    
                } else {
                    return 'Para asignar un chasis debe deasignar primero';
                }
            } else {
                return 'Ese chasis ya ha sido asignado por el vendedor ' + 
                        oppProdList[0].Opportunity.Owner.Name +
                        ', en la oportunidad ' +
                        oppProdList[0].Opportunity.Name + '.';
            }
        }
        
        return 'nada';
    }
    
    @AuraEnabled
    public static String Desasignar(String idOppProd, String motivo, String tipoDeasignacion) {
        OpportunityLineItem oppProd = 
            [SELECT ID, Motor__c, Chasis__c, IdInformeNegociacion__c, Product2.Marca_P__c,
                    Opportunity.Owner.Email, Opportunity.Account.Name, Opportunity.Owner.Name,
                    Opportunity.Name, Tipo_de_reserva__c
            FROM OpportunityLineItem 
            WHERE ID = :idOppProd
			];
        
        if (String.isBlank(oppProd.Chasis__c)) {
        	return 'ChasisNoAsignado';    
        } else if (String.isNotBlank(oppProd.IdInformeNegociacion__c)) {
            List<Informe_de_Negociaci_n__c> InfNeg = 
                [SELECT ID 
                FROM Informe_de_Negociaci_n__c 
                WHERE ID = :oppProd.IdInformeNegociacion__c
                ];
            
            if (!InfNeg.isEmpty()) {
                return 'InformeExistente';    
            }
        }
        
        List<EmailTemplate> etList = 
            [SELECT Id, HtmlValue 
            FROM EmailTemplate  
            WHERE Name LIKE 'Deasignacion Chasis' 
            ];

        List<Messaging.Email> emailList = new List<Messaging.Email>();
        Map<String, List<String>> emailPorMarca = new Map<String, List<String>>();
        Map<String, String> aprobadorPorEmail = new Map<String, String>();

        for (Email_para_enviar_reporte_de_chasis__mdt email :  
                [SELECT Marca__c, Email__c, Nombre__c
                    FROM Email_para_enviar_reporte_de_chasis__mdt
        ]) {

            List<String> listadoMails;

            if (emailPorMarca.containsKey(email.Marca__c)) {
                listadoMails = emailPorMarca.get(email.Marca__c);
            } else {
                listadoMails = new List<String>();
            }

            listadoMails.add(email.Email__c);
            emailPorMarca.put(email.Marca__c, listadoMails);
            aprobadorPorEmail.put(email.Email__c, email.Nombre__c);
        }
        
        if(emailPorMarca.containsKey(oppProd.Product2.Marca_P__c.toUpperCase())) {
            for (String destinatario : emailPorMarca.get(oppProd.Product2.Marca_P__c.toUpperCase())) {
                String nombreReceptor = aprobadorPorEmail.get(destinatario);
                String bodyHtml;
                if (!Test.isRunningTest()) {
                    bodyHtml =  etList[0].HtmlValue.replace('$aprobador', nombreReceptor)
                                        .replace('$vendedor', oppProd.Opportunity.Owner.Name)
                                        .replace('$nombreCliente', oppProd.Opportunity.Account.Name)
                                        .replace('$nombreOportunidad', oppProd.Opportunity.Name)
                                        .replace('$numeroChasis', oppProd.Chasis__c)
                                        .replace('$motivo', motivo);
                
                } else {
                    bodyHtml =  'Test HTML';
                }

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{destinatario});
                mail.setReplyTo(oppProd.Opportunity.Owner.Email);
                mail.setSenderDisplayName(oppProd.Opportunity.Owner.Name);
                mail.setSubject('Se ha deasignado un chasis');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setHtmlBody(bodyHtml);
                emailList.add(mail);
            } 
        }

        if(!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);    
        }

        oppProd.Motor__c = '';
        oppProd.Chasis__c = '';
        oppProd.Color__c = '';
        oppProd.IdInformeNegociacion__c = null;

        if (tipoDeasignacion == 'Devolucion') {
            oppProd.Tipo_de_reserva__c = 'Devolucion';
        }
        
        update oppProd;               

        return 'ok';
    }

    @AuraEnabled
    public static String obtenerRecordTypeOpp(String recordID){  
        List<Opportunity> oppList = 
            [SELECT RecordType.DeveloperName
            FROM Opportunity
            WHERE ID =: recordID 
            ];

        if (oppList.isEmpty()) {
            return null;
        } else {
            return oppList[0].RecordType.DeveloperName;
        }
    }
    
    @AuraEnabled
    public static String CrearInformeNegociacion(String idOppProd) {
        OpportunityLineItem oppProd = 
            [SELECT ID, Motor__c, Chasis__c, Color__c, Subtotal__c,
                    OpportunityId, Product2Id, IdInformeNegociacion__c,
             		X15_I_V_A__c, Prima__c, Opportunity.AccountId
            FROM OpportunityLineItem 
            WHERE Id = :idOppProd
            ];
        
        List<Opportunity> opp = 
            [SELECT Forma_de_Pago_Multiple__c
            FROM Opportunity
            WHERE ID =: oppProd.OpportunityId
            ];

        if (oppProd.IdInformeNegociacion__c != null) {
            List<Informe_de_Negociaci_n__c> inf = 
                [SELECT ID FROM Informe_de_Negociaci_n__c WHERE ID =: oppProd.IdInformeNegociacion__c];
            
            if (!inf.isEmpty()) {
            	return 'InformeYaCreado';    
            }
        }
        
        if (oppProd.Motor__c == null) {
            return 'MotorChasisNoAsignado';
        }
        
        Informe_de_Negociaci_n__c infoNeg = new Informe_de_Negociaci_n__c();
        infoNeg.Producto__c = oppProd.Product2Id;
        infoNeg.Oportunidad__c = oppProd.OpportunityId;
        infoNeg.X15_I_V__c = oppProd.X15_I_V_A__c;
        infoNeg.Motor__c = oppProd.Motor__c;
        infoNeg.Prima_USD__c = oppProd.Prima__c;
        infoNeg.Chasis__c = oppProd.Chasis__c;
        infoNeg.Color_Externo__c = oppProd.Color__c;
        infoNeg.Precio_de_Lista_sin_IMP__c = oppProd.Subtotal__c;
        infoNeg.Forma_de_Pago_Informe__c = opp[0].Forma_de_Pago_Multiple__c;
        infoNeg.Cuenta__c = oppProd.Opportunity.AccountId;
        infoNeg.Facturar_a_nombre_de__c = oppProd.Opportunity.AccountId;
        infoNeg.OrdenAbierta__c='1';    
        
        insert infoNeg;

        oppProd.IdInformeNegociacion__c = infoNeg.id;
        
        update oppProd;
        
        return 'ok';
    }
}