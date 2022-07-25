public with sharing class GenerarCotizacionVaciaController {
    @AuraEnabled
    public static Id savePdf(String argumentos) {
        Pagereference pg = Page.CotizacionAutoloteVacia;

        for (String argumento : argumentos.split(';')) {
            List<String> componentes = argumento.split('=');

            if (componentes.size() == 1) {
                pg.getParameters().put(componentes[0], '');
            } else {
                pg.getParameters().put(componentes[0], componentes[1]);
            }
        }

        Integer numCotizacion = generarCotizacionVaciaController.obtenerUltimoNumCotizacion();

        pg.getParameters().put('numCotizacion', String.valueOf(numCotizacion));

        Attachment objAttachment = new Attachment();
        objAttachment.Name = 'Cotizacion Autolote - ' + numCotizacion + '.pdf';
        objAttachment.ParentId = pg.getParameters().get('id');
        if(Test.isRunningTest()) { 
            objAttachment.Body = Blob.valueOf('Test');   
        } else {
            objAttachment.Body = pg.getContentAsPDF();   
        }
        objAttachment.IsPrivate = false;
        objAttachment.Description = 'Cotizacion de autolote';

        insert objAttachment;

        return objAttachment.Id;
    }

    public static Integer obtenerUltimoNumCotizacion() {
        try {
            Attachment ultimaCotizacion = [
            SELECT Name 
            FROM Attachment 
            WHERE Description = 'Cotizacion de autolote'
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];

            String nameSplited = ultimaCotizacion.Name.contains('-')? ultimaCotizacion.Name.split('-')[1].trim().replace('.pdf','') : '0';

            Integer lastNumber = Integer.valueOf(nameSplited);

            return lastNumber + 1;
        } catch (Exception e) {
            return 1;
        }
    }
}