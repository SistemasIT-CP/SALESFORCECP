public without sharing class recordarTareasGerentes {
    public static void recordarTareasDiarias() {
        List<Task> tareasList = 
            [SELECT ID, Subject, Owner.Name, What.Name, WhatId  
            FROM Task
            WHERE ActivityDate =: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
                  AND What.Type = 'Opportunity'
            ];

        List<Task> tareasVencidasList = 
            [SELECT ID, Subject, Owner.Name, What.Name, ActivityDate, WhatId 
            FROM Task
            WHERE ActivityDate <: Date.today()
                  AND Status != 'Completada'
                  AND Status != 'Completada fallida'
                  AND What.Type = 'Opportunity'
            ];

        List<Event> eventosList = 
            [SELECT ID, Subject, Owner.Name, What.Name, WhatId
            FROM Event 
            WHERE StartDateTime > :Date.today() 
                    AND StartDateTime < :Date.today().addDays(1)
                    AND What.Type = 'Opportunity'
            ];

        List<ID> oppList = new List<ID>();

        for (Task t : tareasList) {
            oppList.add(t.WhatId);
        }

        for (Task t : tareasVencidasList) {
            oppList.add(t.WhatId);
        }

        for (Event e : eventosList) {
            oppList.add(e.WhatId);
        }

        Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>([
            SELECT ID, StageName
            FROM Opportunity
            WHERE ID IN :oppList
        ]);

        if (!tareasList.isEmpty() || !tareasVencidasList.isEmpty() || !eventosList.isEmpty()) {
            Map<String, String> tareasPendientesPorMarca = new Map<String, String>();
            Map<String, String> tareasVencidasPorMarca = new Map<String, String>();
            Map<String, String> eventosPorMarca = new Map<String, String>();

            String generalTareas = '';
            String listadoTareasPendientes = '';
            String listadoTareasVencidas = '';
            String listadoEventos = '';

            if (!tareasList.isEmpty() || !tareasVencidasList.isEmpty()) {
                generalTareas += '<tr style="text-align:center; padding:5px;"><td colspan="4"><strong>Las siguientes tareas:</strong></td></tr><br/>';
            }

            for (Task t: tareasVencidasList) {
                if (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega')) {
                    List<String> nombreOpp = t.What.Name.split('/');
    
                    if (nombreOpp.size() > 1) {
                        if (tareasVencidasPorMarca.containsKey(nombreOpp[1])) {
                            listadoTareasVencidas = tareasVencidasPorMarca.get(nombreOpp[1]);
                        } else {
                            listadoTareasVencidas = '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' +
                                '<tr><td colspan="2" style="padding:5px;"><strong>Tareas vencidas:</strong></td></tr><br/>';
                        }
                    
                        listadoTareasVencidas += '<tr><td align="left" width="25%" style="padding:5px; border: 1px solid black;"><p>' + t.Subject + '</p></td>' +
                                '<td align="left" width="25%" style="padding:5px; border: 1px solid black;"><p><i> Asignado a: </i>' + t.Owner.Name + '</p></td>' + 
                                '<td align="left" width="25%" style="padding:5px; border: 1px solid black;"><p><i> Vencida hace: </i>' + t.ActivityDate.daysBetween(Date.today()) + ' días</p></td>' + 
                                '<td align="left" width="25%" style="padding:5px; border: 1px solid black;"><p><i> Relacionado a la oportunidad: </i>' + t.What.Name +'</p></td></tr>';
                    
                        tareasVencidasPorMarca.put(nombreOpp[1], listadoTareasVencidas);
                    }
                }
            }

            for (String suc : tareasVencidasPorMarca.KeySet()) {
                tareasVencidasPorMarca.put(suc, tareasVencidasPorMarca.get(suc) + '</table></br>');
            }
            
            for (Task t : tareasList) {
                if (!oppMap.get(t.WhatId).StageName.contains('Cerrada') && !oppMap.get(t.WhatId).StageName.contains('Entrega')) {
                    List<String> nombreOpp = t.What.Name.split('/');
    
                    if (nombreOpp.size() > 1) {
                        if (tareasPendientesPorMarca.containsKey(nombreOpp[1])) {
                            listadoTareasPendientes = tareasPendientesPorMarca.get(nombreOpp[1]);
                        } else {
                            listadoTareasPendientes = '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' +
                                '<tr><td colspan="2" style="padding:5px;"><strong>Tareas pendientes:</strong></td></tr><br/>';
                        }
    
                        listadoTareasPendientes += '<tr><td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p>' + t.Subject + '</p></td>' + 
                                            '<td align="left" width="33%" style="padding:5px; border: 1px solid black;"><p><i> Asignado a: </i>' + t.Owner.Name + '</p></td>' + 
                                            '<td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p><i> Relacionado a la oportunidad: </i>' + t.What.Name +'</p></td></tr>';
            
                        tareasPendientesPorMarca.put(nombreOpp[1], listadoTareasPendientes);
                    }
                }
            }

            for (String suc : tareasPendientesPorMarca.KeySet()) {
                tareasPendientesPorMarca.put(suc, tareasPendientesPorMarca.get(suc) + '</table></br>');
            }

            for (Event e : eventosList) {
                if (!oppMap.get(e.WhatId).StageName.contains('Cerrada') && !oppMap.get(e.WhatId).StageName.contains('Entrega')) {
                    List<String> nombreOpp = e.What.Name.split('/');
    
                    if (nombreOpp.size() > 1) {
                        if (eventosPorMarca.containsKey(nombreOpp[1])) {
                            listadoEventos = eventosPorMarca.get(nombreOpp[1]);
                        } else {
                            listadoEventos += '<table align="center" cellpadding="0" cellspacing="0" style="border: 1px solid black; width: 80%">' + 
                                '<tr><td colspan="2" style="padding:5px;"><strong>Eventos:</strong></td></tr><br/>';
                        }
    
                        listadoEventos += '<tr><td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p>' + e.Subject + '</p></td>' + 
                                            '<td align="left" width="33%" style="padding:5px; border: 1px solid black;"><p><i> Asignado a: </i>' + e.Owner.Name + '</p></td>' + 
                                            '<td align="left" width="50%" style="padding:5px; border: 1px solid black;"><p> <i>Relacionado a la oportunidad: </i>' + e.What.Name +'</p></td></tr>';
            
                        eventosPorMarca.put(nombreOpp[1], listadoEventos);
                    }
                }
            }

            for (String suc : eventosPorMarca.KeySet()) {
                eventosPorMarca.put(suc, eventosPorMarca.get(suc) + '</table></br>');
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
                WHERE IsActive = true AND
                (UserRole.Name LIKE 'Gerente%' OR UserRole.Name LIKE 'Jefe de Venta%')
                ]);
    
            for (User u : userList) {
                String detalle = '';
                String marca1;
                String marca2;

                if (u.UserRole.Name.contains('Velosa')) {
                    marca1 = 'GENESIS';
                } else if (u.UserRole.Name.contains('Yamaha')) {
                    marca1 = 'YAMAHA';
                } else if (u.UserRole.Name.contains('Kia')) {
                    marca1 = 'KIA';
                } else if (u.UserRole.Name.contains('Suzuki')) {
                    marca1 = 'SUZUKI';
                } else if (u.UserRole.Name.contains('Toyota')) {
                    marca1 = 'TOYOTA';
                } else if (u.UserRole.Name.contains('Camiones')) {
                    marca1 = 'JMC';
                    marca2 = 'HINO';
                }

                if (tareasVencidasPorMarca.containsKey(marca1)) {
                    detalle += tareasVencidasPorMarca.get(marca1);
                }

                if (String.isNotBlank(marca2)) {
                    if (tareasVencidasPorMarca.containsKey(marca2)) {
                        detalle += tareasVencidasPorMarca.get(marca2);
                    }
                }
                                   
                if (tareasPendientesPorMarca.containsKey(marca1)) {
                    detalle += tareasPendientesPorMarca.get(marca1);
                }

                if (String.isNotBlank(marca2)) {
                    if (tareasPendientesPorMarca.containsKey(marca2)) {
                        detalle += tareasPendientesPorMarca.get(marca2);
                    }
                }
                                   
                if (eventosPorMarca.containsKey(marca1)) {
                    detalle += eventosPorMarca.get(marca1);
                }

                if (String.isNotBlank(marca2)) {
                    if (eventosPorMarca.containsKey(marca2)) {
                        detalle += eventosPorMarca.get(marca2);
                    }
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