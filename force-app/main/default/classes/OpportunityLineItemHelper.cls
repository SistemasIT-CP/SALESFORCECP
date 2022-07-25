public class OpportunityLineItemHelper {
    public static void generarCotizaciones (List<OpportunityLineItem> oliList) {
        List<ID> pricebookIDList = new List<ID>();
        List<ID> oppIDList = new List<ID>();
        Map<String, OpportunityLineItem> oliByOppProd = new Map<String, OpportunityLineItem>();
        
        for(OpportunityLineItem oli : oliList){
            oppIDList.add(oli.OpportunityId);
            oliByOppProd.put(oli.OpportunityId + '_' + oli.Product2Id, oli);
        }
        
        Map<ID, Opportunity> oppList = new Map<ID, Opportunity>(
        	[SELECT ID, Pricebook2Id, Name
            FROM Opportunity
            WHERE ID IN :oppIDList
            ]);

        for (Opportunity opp : oppList.values()) {
            pricebookIDList.add(opp.Pricebook2Id);
        }
        
		List<Quote> quotesList = new List<Quote>();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        Map<ID, ID> quoteIDPorProductoID = new Map<ID, ID>();
        Map<String, PricebookEntry> pbEntryPorProductoPricebookID = new Map<String, PricebookEntry>();
        
        for (OpportunityLineItem oli : oliList) {
			Quote q = new Quote();
            q.OpportunityId = oli.OpportunityId;
            q.Name = oppList.get(oli.OpportunityId).Name;
            q.ExpirationDate = Date.today().addDays(7);
            q.Producto_Referencia__c = oli.Product2Id;
            quotesList.add(q);
        }
        
        if (!quotesList.isEmpty()) {
            Database.SaveResult[] srList = Database.Insert(quotesList, true);

            for (PricebookEntry pe : [SELECT ID, Pricebook2Id, UnitPrice, Product2Id
                                      FROM PricebookEntry 
                                      WHERE Pricebook2Id IN :pricebookIDList]) {
                pbEntryPorProductoPricebookID.put(pe.Pricebook2Id + '_' + pe.Product2Id, pe);
            }

            for (Quote q : quotesList) {
                OpportunityLineItem oli = oliByOppProd.get(q.OpportunityId + '_' + q.Producto_Referencia__c);
                Opportunity opp = oppList.get(q.OpportunityId);
                QuoteLineItem qli = new QuoteLineItem();
                PricebookEntry pbEntry = pbEntryPorProductoPricebookID.get(opp.Pricebook2Id + '_' + q.Producto_Referencia__c);
                
                qli.Product2Id = q.Producto_Referencia__c;
                qli.Quantity = oli.Quantity;
                qli.QuoteId = q.ID;
                qli.Aduanas__c = oli.Imp_Aduanas__c;
                qli.Exento__c = oli.X15_I_V_A__c;
                qli.PricebookEntryId = pbEntry.ID;
                qli.IVA__c = oli.IVA__c;
                qli.Descuento__c = oli.Descuento__c;
                qli.UnitPrice = oli.UnitPrice;
                qliList.add(qli);
            }
            
            if (!qliList.isEmpty()) {
                insert qliList;
            }   
        }
    }
    
    public static void actualizarPrecioUnitario (List<OpportunityLineItem> oliList) {
        List<ID> oppIDList = new List<ID>();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        List<Opportunity> oppList = new List<Opportunity>();
        Map<String, Decimal> precioUnitarioPorKey = new Map<String, Decimal>();
        
        for (OpportunityLineItem oli : oliList) {
			oppIDList.add(oli.OpportunityId);
            precioUnitarioPorKey.put(('' + oli.OpportunityId).substring(0, 15) + '_' + oli.Product2Id, oli.UnitPrice);
        }
        
        System.debug('map: ' + precioUnitarioPorKey);
        
        for (QuoteLineItem qli : [SELECT Id_Opp__c, Product2Id, UnitPrice
                                 FROM QuoteLineItem]) {
			Decimal precioUnitario = precioUnitarioPorKey.get(qli.Id_Opp__c + '_' + qli.Product2Id);
         	System.debug('key: ' + qli.Id_Opp__c + '_' + qli.Product2Id);
			if (precioUnitario != null) {
                qli.UnitPrice = precioUnitario;
                qliList.add(qli);
            }
		}
        
        if (!qliList.isEmpty()) {
            update qliList;
        }
    }
    
    public static void eliminarCotizaciones (List<OpportunityLineItem> oliList) {
        Map<String, Quote> cotizacionesPorClave = new Map<String, Quote>();
        List<ID> oppID = new List<ID>();
        List<ID> prodID = new List<ID>();
        List<Quote> cotizacionesParaEliminar = new List<Quote>();
        
        for (OpportunityLineItem oli : oliList) {
        	oppID.add(oli.OpportunityId);    
            prodID.add(oli.Product2Id);
        }
        
        for(Quote q : [SELECT OpportunityId, Producto_Referencia__c
                      FROM Quote
                      WHERE OpportunityId IN :oppID
                            AND Producto_Referencia__c IN :prodID]) {
                                
			cotizacionesPorClave.put(q.OpportunityId + '_' + q.Producto_Referencia__c, q);                  
        }
        
        for (OpportunityLineItem oli : oliList) {
            if (cotizacionesPorClave.containsKey(oli.OpportunityId + '_' + oli.Product2Id)) {
            	cotizacionesParaEliminar.add(cotizacionesPorClave.get(oli.OpportunityId + '_' + oli.Product2Id));    
            }
        }
        
        if(!cotizacionesParaEliminar.isEmpty()) {
            delete cotizacionesParaEliminar;
        }
    }

    public static void enviarReporte (List<ID> oliIDList) {
        Map<String, List<String>> emailPorMarca = new Map<String, List<String>>();
        Map<String, String> aprobadorPorEmail = new Map<String, String>();

        List<OpportunityLineItem> oliList = 
            [SELECT Product2.Marca_P__c, Opportunity.Owner.Name, Opportunity.Owner.Email,
                    Chasis__c, Product2.Codigovehiculo__c, Opportunity.Account.Name, 
                    Product2.Modelogenerico__c, Opportunity.Account.CodigoCliente__c, Opportunity.Compa_a__r.Name,
                    UnitPrice, Quantity, CurrencyIsoCode
            FROM OpportunityLineItem
            WHERE ID IN :oliIDList
            ];

        for (Email_para_enviar_reporte_de_chasis__mdt email :  [SELECT Marca__c, Email__c, Nombre__c
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

        System.debug(emailPorMarca);

        if (!emailPorMarca.keySet().isEmpty()) {
            List<Messaging.Email> emailList = new List<Messaging.Email>();
            Map<String, EmailTemplate> plantillaPorCompania = new Map<String, EmailTemplate>();
            for(EmailTemplate et : [SELECT Id, HtmlValue, Name 
                                    FROM EmailTemplate  
                                    WHERE Name LIKE 'Reserva de chasis%' 
                                    ]) {
                if (et.Name.contains('Casa Pellas')) {
                    plantillaPorCompania.put('CASA PELLAS, S.A', et);
                } else if (et.Name.contains('Kipesa')) {
                    plantillaPorCompania.put('KIPESA', et);
                } else if (et.Name.contains('Velosa')) {
                    plantillaPorCompania.put('V E L O S A', et);
                }
            }

            for (OpportunityLineItem oli : oliList) {
                EmailTemplate et = plantillaPorCompania.get(oli.Opportunity.Compa_a__r.Name);
                String bodyHtml;
                if(emailPorMarca.containsKey(oli.Product2.Marca_P__c.toUpperCase())) {

                    for (String destinatario : emailPorMarca.get(oli.Product2.Marca_P__c.toUpperCase())) {
                        String nombreReceptor = aprobadorPorEmail.get(destinatario);
                        if (!Test.isRunningTest()) {
                        	bodyHtml =  et.HtmlValue.replace('$nombreAprobador', nombreReceptor)
                                                .replace('$nombreVendedor', 'el vendedor ' + oli.Opportunity.Owner.Name)
                                                .replace('$nombreCliente', oli.Opportunity.Account.Name)
                                                .replace('$numeroIdentificacion', oli.Opportunity.Account.CodigoCliente__c)
                                                .replace('$nombreMarca', oli.Product2.Marca_P__c)
                                                .replace('$nombreModelo', oli.Product2.Modelogenerico__c)
                                                .replace('$codigoAuto', oli.Product2.Codigovehiculo__c)
                                                .replace('$numeroChasis', oli.Chasis__c)
                                                .replace('$precioUnitario', oli.CurrencyIsoCode + ' ' + (oli.UnitPrice / oli.Quantity));
                        
						} else {
                            bodyHtml =  'Test HTML';
                        }
        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new List<String>{destinatario});
                        mail.setReplyTo(oli.Opportunity.Owner.Email);
                        mail.setSenderDisplayName(oli.Opportunity.Owner.Name);
                        mail.setSubject('Se ha reservado un chasis');
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
                        mail.setHtmlBody(bodyHtml);
                        emailList.add(mail);
                    } 
					if (!Test.isRunningTest()) {
                        bodyHtml =  et.HtmlValue.replace('$nombreAprobador', oli.Opportunity.Owner.Name)
                                                .replace('$nombreVendedor', '')
                                                .replace('$nombreCliente', oli.Opportunity.Account.Name)
                                                .replace('$numeroIdentificacion', oli.Opportunity.Account.CodigoCliente__c)
                                                .replace('$nombreMarca', oli.Product2.Marca_P__c)
                                                .replace('$nombreModelo', oli.Product2.Modelogenerico__c)
                                                .replace('$codigoAuto', oli.Product2.Codigovehiculo__c)
                                                .replace('$numeroChasis', oli.Chasis__c)
                                                .replace('$precioUnitario', oli.CurrencyIsoCode + ' ' + (oli.UnitPrice / oli.Quantity));
                    } else {
                        bodyHtml =  'Test HTML';
                    }
    
                    Messaging.SingleEmailMessage mailVendedor = new Messaging.SingleEmailMessage();
                    mailVendedor.setToAddresses(new List<String>{oli.Opportunity.Owner.Email});
                    mailVendedor.setReplyTo(oli.Opportunity.Owner.Email);
                    mailVendedor.setSenderDisplayName(oli.Opportunity.Owner.Name);
                    mailVendedor.setSubject('Has reservado un chasis');
                    mailVendedor.setBccSender(false);
                    mailVendedor.setUseSignature(false);
                    mailVendedor.setHtmlBody(bodyHtml);
                    emailList.add(mailVendedor);
                                                            
                }
            } 
                
            if(!emailList.isEmpty()) {
                Messaging.sendEmail(emailList);    
            }
        }
    }

    public static void crearDetalleChasis (List<OpportunityLineItem> oliList) {
        ID reservasId = Schema.SObjectType.Debug_log__c
                                .getRecordTypeInfosByDeveloperName()
                                .get('Reservas')
                                .getRecordTypeId();

        List<Debug_log__c> detalleList = new List<Debug_log__c>();

        for (OpportunityLineItem oli : oliList) {
            Debug_log__c d = new Debug_log__c();
            d.Oportunidad__c = oli.OpportunityId;
            d.Producto_de_la_oportunidad__c = oli.Id;
            d.Chasis__c = oli.Chasis__c;
            d.Horario__c = Datetime.now().format('dd/MM/yyyy HH:mm:ss', 'America/El_Salvador');
            d.RecordTypeId = reservasId;
            d.ID_Objeto__c = oli.OpportunityId;

            if (oli.Tipo_de_reserva__c != 'Devolucion' && String.isBlank(oli.Chasis__c)) {
                d.Tipo_de_reserva__c = 'Deasignacion';
            } else {
                d.Tipo_de_reserva__c = oli.Tipo_de_reserva__c;
            }

            detalleList.add(d);
        }

        if (!detalleList.isEmpty()) {
            insert detalleList;
        }
    }

    public static void validarInformesExistentes (List<OpportunityLineItem> oliList) {
        List<String> informesID = new List<String>();

        for (OpportunityLineItem oli : oliList) {
            if (String.isNotBlank(oli.IdInformeNegociacion__c)) {
                informesID.add(oli.IdInformeNegociacion__c);
            }
        }

        Map<ID, Informe_de_negociaci_n__c> infMap = new Map<ID, informe_de_negociaci_n__c>([
            SELECT ID
            FROM informe_de_negociaci_n__c
            WHERE ID IN :informesID
        ]);

        for (OpportunityLineItem oli : oliList) {
            if (String.isNotBlank(oli.IdInformeNegociacion__c)) {
                if (infMap.containsKey(oli.IdInformeNegociacion__c)) {
                    oli.addError('Para eliminar el producto debe eliminar el informe de negociación primero.');
                }
            }
        }
    }

    /*public static void actualizarDatosEsquela (List<OpportunityLineItem> oliList) {
        List<Id> oppIdList = new List<Id>();

        for (OpportunityLineItem oli : oliList) {
            if (String.isNotBlank(oli.Chasis__c)) {
                oppIdList.add(oli.OpportunityId);
            }
        }

        List<Opportunity> oppList = [
            SELECT Id, Esquela__c
            FROM Opportunity
            WHERE Id IN :oppIdList 
                AND Id NOT IN (SELECT OpportunityId 
                                FROM OpportunityLineItem 
                                WHERE Chasis__c = null 
                                    AND OpportunityId IN :oppIdList)
        ];

        for (Opportunity opp : oppList) {
            if (String.isNotBlank(opp.Esquela__c)) {
                System.debug('Se actualiza los datos de la esquela');
                CallWSEsquelas.modificarEsquela(opp.Id);
            }
        }
    }*/

    public static void validarOrdenAbierta (List<OpportunityLineItem> oliList) {
        List<String> informesID = new List<String>();
        Boolean blntieneorden   = false;        

        for (OpportunityLineItem oli : oliList) {
            if (String.isNotBlank(oli.IdInformeNegociacion__c)) {
                informesID.add(oli.IdInformeNegociacion__c);
            }
        }

        Map<ID, Informe_de_negociaci_n__c> infMap = new Map<ID, informe_de_negociaci_n__c>([
            SELECT OrdenAbierta__c
            FROM informe_de_negociaci_n__c
            WHERE ID IN :informesID
        ]);

        for (OpportunityLineItem oli : oliList) {
            
            if (String.isNotBlank(oli.IdInformeNegociacion__c)) {
               if (infMap.get(oli.IdInformeNegociacion__c).OrdenAbierta__c =='1')
                {                  
                
                    blntieneorden= true;}else blntieneorden= false;                

                if (blntieneorden) {
                   
                    oli.addError('No se puede eliminar el producto porque el chasis esta en proceso de venta. De clic en Verificar Orden Abierta.');
                }
            }
        }
    }
}