public without sharing class recordarTareasJefesSucursal {
    public static void recordarTareasDiarias() {
        List<Task> tareasList = 
            [SELECT ID, Subject, Owner.Name, Owner.UserRole.Name, What.Name, WhatId, What.Type  
            FROM Task
            WHERE ActivityDate =: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
                  AND Owner.UserRole.Name LIKE 'Vendedor%'
            ];

        List<Task> tareasVencidasList = 
            [SELECT ID, Subject, Owner.Name, Owner.UserRole.Name, What.Name, ActivityDate, WhatId, What.Type
            FROM Task
            WHERE ActivityDate <: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
                  AND Owner.UserRole.Name LIKE 'Vendedor%'
            ];

        List<Event> eventosList = 
            [SELECT ID, Subject, Owner.Name, Owner.UserRole.Name, What.Name, WhatId, What.Type
            FROM Event 
            WHERE StartDateTime > :Date.today() 
                    AND StartDateTime < :Date.today().addDays(1)
                    AND Owner.UserRole.Name LIKE 'Vendedor%'
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
            Map<String, String> tareasPendientesPorSucursal = new Map<String, String>();
            Map<String, String> tareasVencidasPorSucursal = new Map<String, String>();
            Map<String, String> eventosPorSucursal = new Map<String, String>();

            String listadoTareasPendientes = '';
            String listadoTareasVencidas = '';
            String listadoEventos = '';

            for (Task t: tareasVencidasList) {
                if (!oppMap.containsKey(t.WhatId) || (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega'))) {
                    String sucursal = t.Owner.UserRole.Name.removeStart('Vendedor Sucursal ');
                    
                    if (sucursal.contains('Vendedor')) {
                        sucursal = sucursal.removeStart('Vendedor Sucursa ');
                    }
    
                    if (tareasVencidasPorSucursal.containsKey(sucursal)) {
                        listadoTareasVencidas = tareasVencidasPorSucursal.get(sucursal);
                    } else {
                        listadoTareasVencidas = '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' +
                                '<tr><td colspan="2" style="padding:5px;"><strong>Tareas vencidas:</strong></td></tr><br/>';
                    }
                
                    listadoTareasVencidas += '<tr><td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p>' + t.Subject + '</p></td>' +
                            '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Asignado a: </i>' + t.Owner.Name + '</p></td>' + 
                            '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Vencida hace: </i>' + t.ActivityDate.daysBetween(Date.today()) + ' días</p></td>' + 
                            '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Relacionado a: </i>' + t.What.Name +'</p></td></tr>';
                
                    tareasVencidasPorSucursal.put(sucursal, listadoTareasVencidas);
                }
            }
 
            for (String suc : tareasVencidasPorSucursal.KeySet()) {
                tareasVencidasPorSucursal.put(suc, tareasVencidasPorSucursal.get(suc) + '</table></br>');
            }
            
            for (Task t : tareasList) {
                if (!oppMap.containsKey(t.WhatId) || (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega'))) {
                    String sucursal = t.Owner.UserRole.Name.removeStart('Vendedor Sucursal ');
                    
                    if (sucursal.contains('Vendedor')) {
                        sucursal = sucursal.removeStart('Vendedor Sucursa ');
                    }
    
                    if (tareasPendientesPorSucursal.containsKey(sucursal)) {
                        listadoTareasPendientes = tareasPendientesPorSucursal.get(sucursal);
                    } else {
                        listadoTareasPendientes = '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' +
                                '<tr><td colspan="2" style="padding:5px;"><strong>Tareas pendientes:</strong></td></tr><br/>';
                    }
    
                    listadoTareasPendientes += '<tr><td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p>' + t.Subject + '</p></td>' + 
                                        '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Asignado a: </i>' + t.Owner.Name + '</p></td>' + 
                                        '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Relacionado a: </i>' + t.What.Name +'</p></td></tr>';
        
                    tareasPendientesPorSucursal.put(sucursal, listadoTareasPendientes);
                }
            }

            for (String suc : tareasPendientesPorSucursal.KeySet()) {
                tareasPendientesPorSucursal.put(suc, tareasPendientesPorSucursal.get(suc) + '</table></br>');
            }

            for (Event e : eventosList) {
                if (!oppMap.containsKey(e.WhatId) || (!oppMap.get(e.WhatId).StageName.contains('Cerrada') && !oppMap.get(e.WhatId).StageName.contains('Entrega'))) {
                    String sucursal = e.Owner.UserRole.Name.removeStart('Vendedor Sucursal ');
                    
                    if (sucursal.contains('Vendedor')) {
                        sucursal = sucursal.removeStart('Vendedor Sucursa ');
                    }
    
                    if (eventosPorSucursal.containsKey(sucursal)) {
                        listadoEventos = eventosPorSucursal.get(sucursal);
                    } else {
                        listadoEventos += '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' + 
                                '<tr><td colspan="2" style="padding:5px;"><strong>Eventos:</strong></td></tr><br/>';
                    }
    
                    listadoEventos += '<tr><td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p>' + e.Subject + '</p></td>' + 
                                        '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p><i> Asignado a: </i>' + e.Owner.Name + '</p></td>' + 
                                        '<td align="left" style="padding:5px; border: 1px solid black; width: 25%;"><p> <i>Relacionado a: </i>' + e.What.Name +'</p></td></tr>';
        
                    eventosPorSucursal.put(sucursal, listadoEventos);
                }
            }

            for (String suc : eventosPorSucursal.KeySet()) {
                eventosPorSucursal.put(suc, eventosPorSucursal.get(suc) + '</table></br>');
            }
    
            List<Messaging.Email> emailList = new List<Messaging.Email>();

            List<EmailTemplate> plantilla = 
                [SELECT Id, HtmlValue, Name 
                FROM EmailTemplate  
                WHERE Name = 'Tareas supervisores' 
                ];
    
            List<User> userList = new List<User>( 
                [SELECT ID, Email, Name, UserRole.Name
                FROM User
                WHERE (UserRole.Name LIKE 'Jefe de Sucursal%' OR UserRole.Name LIKE 'Jefe Camiones%')
                AND IsActive = true
                ]);
    
            for (User u : userList) {
                String sucursal = u.UserRole.Name.removeStart('Jefe de Sucursal ').trim();

                if (sucursal == 'Kia El Retiro') {
                    sucursal = 'El Retiro';
                } else if (sucursal == 'León') {
                    sucursal = 'Leon';
                }
                
                String detalle = '';

                if (tareasVencidasPorSucursal.containsKey(sucursal)) {
                    detalle += tareasVencidasPorSucursal.get(sucursal);
                }
                                   
                if (tareasPendientesPorSucursal.containsKey(sucursal)) {
                    detalle += tareasPendientesPorSucursal.get(sucursal);
                }
                                   
                if (eventosPorSucursal.containsKey(sucursal)) {
                    detalle += eventosPorSucursal.get(sucursal);
                }

                String cuerpo = plantilla[0].HtmlValue
                                .replace('$vendedor', u.Name)
                                .replace('$detalleDeLasActividades', detalle);

                Messaging.SingleEmailMessage mailVendedor = new Messaging.SingleEmailMessage();
                mailVendedor.setToAddresses(new List<String>{u.Email});
                mailVendedor.setSenderDisplayName('Salesforce System');
                mailVendedor.setSubject('Tareas de su equipo');
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