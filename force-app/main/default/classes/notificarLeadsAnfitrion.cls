global without sharing class notificarLeadsAnfitrion implements schedulable{

    global void execute(SchedulableContext sc){
        Datetime tiempoControl = Datetime.now().addHours(-4);

        List<Lead> ldList = [
            SELECT Name, Marca_a_cotizar__c, Owner.Email, Owner.Name 
            FROM Lead
            WHERE RecordType.DeveloperName = 'Anfitrion'
                AND Status != 'Convertido'
                AND Status != 'Lead perdido'
                AND CreatedDate <= :tiempoControl
        ];

        if (!ldList.isEmpty()) {
            Map<String, List<String>> nombresPorMarca = new Map<String, List<String>>();
            Map<Id, List<String>> leadsPorOwner = new Map<Id, List<String>>();
            String nombres = '';

            for (Lead ld : ldList) {
                String marca = String.isNotBlank(ld.Marca_a_cotizar__c)? ld.Marca_a_cotizar__c : 'Ninguna';
                List<String> listaNombre;
                List<String> listaNombrePorOwner;

                if (nombresPorMarca.containsKey(marca)) {
                    listaNombre = nombresPorMarca.get(marca);
                } else {
                    listaNombre = new List<String>();
                }

                if (leadsPorOwner.containsKey(ld.OwnerId)) {
                    listaNombrePorOwner = leadsPorOwner.get(ld.OwnerId);
                } else {
                    listaNombrePorOwner = new List<String>();
                }

                listaNombre.add(ld.Name);
                listaNombrePorOwner.add(ld.Name);

                nombresPorMarca.put(marca, listaNombre);
                leadsPorOwner.put(ld.OwnerId, listaNombrePorOwner);
            }
            
            Map<String, List<User>> aprobadoresPorMarca = new Map<String, List<User>>();
            Map<Id, User> userMap = new Map<Id, User>([
                SELECT Id, Name, Email
                FROM User 
                WHERE Id IN :leadsPorOwner.keySet()
            ]);

            for (User u : [SELECT UserRole.Name, Name, Email FROM User WHERE UserRole.Name LIKE 'Gerente%' OR UserRole.Name LIKE 'Jefe de Ventas%']) {
                List<User> aprobadores;
                String marca = u.UserRole.Name.contains('Gerente')? u.UserRole.Name.remove('Gerente ') : u.UserRole.Name.remove('Jefe de Ventas ');

                if (aprobadoresPorMarca.containsKey(marca)) {
                    aprobadores = aprobadoresPorMarca.get(marca);
                } else {
                    aprobadores = new List<User>();
                }

                aprobadores.add(u);

                aprobadoresPorMarca.put(marca, aprobadores);
            }

            List<User> anfitrionUser = [
                SELECT Id, Email, Name
                FROM User 
                WHERE Profile.Name = 'Anfitrion'
                    AND IsActive = true
            ];

            List<Messaging.Email> emailList = new List<Messaging.Email>();

            for (String marca : nombresPorMarca.keySet()) {
                String nombreMarcaActual = '';

                for (String nombre : nombresPorMarca.get(marca)) {
                    nombres += nombre + ', ';
                    nombreMarcaActual += nombre + ', ';
                }

                nombreMarcaActual = nombreMarcaActual.removeEnd(', ');

                if (aprobadoresPorMarca.containsKey(marca)) {
                    for (User u : aprobadoresPorMarca.get(marca)) {
                        emailList.add(generarMailLeads(u.Email, u.Name, nombreMarcaActual));
                    }
                }
            }

            for (Id userId : leadsPorOwner.keySet()) {
                String nombreOwnerActual = '';

                for (String nombre : leadsPorOwner.get(userId)) {
                    nombreOwnerActual += nombre + ', ';
                }

                nombreOwnerActual = nombreOwnerActual.removeEnd(', ');

                emailList.add(generarMailLeads(userMap.get(userId).Email, userMap.get(userId).Name, nombreOwnerActual));
            }

            nombres = nombres.removeEnd(', ');

            if (!anfitrionUser.isEmpty()) {
                emailList.add(generarMailLeads(anfitrionUser[0].Email, anfitrionUser[0].Name, nombres));
            }

            if(!emailList.isEmpty()) {
                Messaging.sendEmail(emailList);    
            }
        }
    }

    public static Messaging.SingleEmailMessage generarMailLeads(String email, String name, String nombres) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{email});
        mail.setReplyTo(email);
        mail.setSenderDisplayName(name);
        mail.setSubject('Lead sin convertir');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody('Los siguientes leads aun no se han convertido: ' + nombres);

        return mail;
    }
}