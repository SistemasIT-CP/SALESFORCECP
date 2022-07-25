public without sharing class recordarTareasDiarias {
    public static void recordarTareasDiarias() {
        List<Task> tareasList = 
            [SELECT ID, Subject, OwnerId, What.Name, WhatId, What.Type 
            FROM Task
            WHERE ActivityDate =: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
            ];

        List<Task> tareasVencidasList = 
            [SELECT ID, Subject, OwnerId, What.Name, WhatId, What.Type
            FROM Task
            WHERE ActivityDate <: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
            ];

        List<Event> eventosList = 
            [SELECT ID, Subject, OwnerId, What.Name, WhatId, What.Type
            FROM Event 
            WHERE StartDateTime > :Date.today() AND StartDateTime < :Date.today().addDays(1)
            ];

        List<ID> oppList = new List<ID>();

        for (Task t : tareasList) {
            if (t.What.Type == 'Opportunity') {
                oppList.add(t.WhatId);
            }
        }

        for (Task t : tareasVencidasList) {
            if (t.What.Type == 'Opportunity') {
                oppList.add(t.WhatId);
            }
        }

        for (Event e : eventosList) {
            if (e.What.Type == 'Opportunity') {
                oppList.add(e.WhatId);
            }
        }

        Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([
            SELECT ID, StageName
            FROM Opportunity
            WHERE ID IN :oppList
        ]);

        if (!tareasList.isEmpty() || !tareasVencidasList.isEmpty() || !eventosList.isEmpty()) {
            Map<ID, String> tareasPendientesPorUsuario = new Map<ID, String>();
            Map<ID, String> tareasVencidasPorUsuario = new Map<ID, String>();
            Map<ID, String> eventosPorUsuario = new Map<ID, String>();

            String generalTareas = '';
            String listadoTareasPendientes = '';
            String listadoTareasVencidas = '';
            String listadoEventos = '';

            if (!tareasList.isEmpty() || !tareasVencidasList.isEmpty()) {
                generalTareas += '<tr style="text-align:center; padding:5px;"><td colspan="2"><strong>Las siguientes tareas:</strong></td></tr><br/>';
            }

            for (Task t: tareasVencidasList) {
                if (!oppMap.containsKey(t.WhatId) || (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega'))) {
                    if (tareasVencidasPorUsuario.containsKey(t.OwnerId)) {
                        listadoTareasVencidas = tareasVencidasPorUsuario.get(t.OwnerId);
                    } else {
                        listadoTareasVencidas = '<tr><td colspan="2" style="padding:5px;"><strong>Tareas vencidas:</strong></td></tr><br/>';
                    }
    
                    listadoTareasVencidas += '<tr><td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p>' + t.Subject + '</p></td>' + 
                                        '<td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p><i> Relacionado a: </i>' + t.What.Name +'</p></td></tr>' ;
        
                    tareasVencidasPorUsuario.put(t.OwnerId, listadoTareasVencidas);
                }
            }
            
            for (Task t : tareasList) {
                if (!oppMap.containsKey(t.WhatId) || (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega'))) {
                    if (tareasPendientesPorUsuario.containsKey(t.OwnerId)) {
                        listadoTareasPendientes = tareasPendientesPorUsuario.get(t.OwnerId);
                    } else {
                        listadoTareasPendientes = '<tr><td colspan="2" style="padding:5px;"><strong>Tareas pendientes:</strong></td></tr><br/>';
                    }
    
                    listadoTareasPendientes += '<tr><td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p>' + t.Subject + '</p></td>' + 
                                        '<td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p><i> Relacionado a: </i>' + t.What.Name +'</p></td></tr>' ;
        
                    tareasPendientesPorUsuario.put(t.OwnerId, listadoTareasPendientes);
                }
            }

            for (Event e : eventosList) {
                if (!oppMap.containsKey(e.WhatId) || (!oppMap.get(e.WhatId).StageName.contains('Cerrada') && !oppMap.get(e.WhatId).StageName.contains('Entrega'))) {
                    if (eventosPorUsuario.containsKey(e.OwnerId)) {
                        listadoEventos = eventosPorUsuario.get(e.OwnerId);
                    } else {
                        listadoEventos += '<br/><tr><td colspan="2" style="padding:5px;"><strong>Eventos:</strong></td></tr><br/>';
                    }
    
                    listadoEventos += '<tr><td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p>' + e.Subject + '</p></td>' + 
                                        '<td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p> <i>Relacionado a: </i>' + e.What.Name +'</p></td></tr>' ;
        
                    eventosPorUsuario.put(e.OwnerId, listadoEventos);
                }
            }
            

    
            List<Messaging.Email> emailList = new List<Messaging.Email>();

            List<EmailTemplate> plantilla = 
                [SELECT Id, HtmlValue, Name 
                FROM EmailTemplate  
                WHERE Name = 'Tareas del dia' 
                ];
    
            List<User> usuariosList = new List<User>( 
                [SELECT ID, Email, Name
                FROM User
                WHERE IsActive = true AND
                    (ID IN :tareasVencidasPorUsuario.KeySet()
                    OR ID IN :tareasPendientesPorUsuario.KeySet()
                    OR ID IN :eventosPorUsuario.KeySet())
                ]);
    
            for (User u : usuariosList) {
                String detalle = '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black;">';
                                   
                if (tareasVencidasPorUsuario.containsKey(u.ID)) {
                    detalle += tareasVencidasPorUsuario.get(u.ID);
                }
                                   
                if (tareasPendientesPorUsuario.containsKey(u.ID)) {
                    detalle += tareasPendientesPorUsuario.get(u.ID);
                }
                                   
                if (eventosPorUsuario.containsKey(u.ID)) {
                    detalle += eventosPorUsuario.get(u.ID);
                }

                detalle += '</table>';
                
                System.debug(u.Email + ' ' + detalle);

                String cuerpo = plantilla[0].HtmlValue
                                .replace('$vendedor', u.Name)
                                .replace('$detalleDeLasActividades', detalle);

                Messaging.SingleEmailMessage mailVendedor = new Messaging.SingleEmailMessage();
                mailVendedor.setToAddresses(new List<String>{u.Email});
                mailVendedor.setSenderDisplayName('Salesforce System');
                mailVendedor.setSubject('Tiene tareas pendientes para el día de hoy');
                mailVendedor.setBccSender(false);
                mailVendedor.setUseSignature(false);
                mailVendedor.setHtmlBody(cuerpo);
                emailList.add(mailVendedor);
            }
    
            if(!emailList.isEmpty()) {
                Messaging.sendEmail(emailList);    
            }
        }
    }
}