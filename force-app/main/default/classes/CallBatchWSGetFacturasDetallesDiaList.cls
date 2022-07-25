global class CallBatchWSGetFacturasDetallesDiaList implements schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc){
        BatchCallWSGetFacturasDetalleDiaList b = new BatchCallWSGetFacturasDetalleDiaList();
      	Database.executeBatch(b, 1);
    }
    
}