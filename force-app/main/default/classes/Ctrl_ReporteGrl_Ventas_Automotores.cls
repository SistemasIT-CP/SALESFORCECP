public class Ctrl_ReporteGrl_Ventas_Automotores {

	public Date fecha {get;set;}
    public Date fecha2 {get;set;}
    public String montoMaxSeleccionado {get; set;}
    public List<SelectOption> tiposDePagoSeleccionados {get; set;}
    public List<SelectOption> tiposDePago {get; set;}
    public List<SelectOption> lineasDeNegocioSeleccionadas {get; set;}
    public List<SelectOption> lineasDeNegocio {get; set;}
    public String companiaSeleccionada {get; set;}
    public List<SelectOption> companias {get; set;}
    
    public Ctrl_ReporteGrl_Ventas_Automotores() {
        tiposDePago =  new List<SelectOption>();
        tiposDePagoSeleccionados =  new List<SelectOption>();

        tiposDePago.add(new SelectOption('Cheques', 'Cheques'));
        tiposDePago.add(new SelectOption('Efectivo', 'Efectivo'));
        tiposDePago.add(new SelectOption('Tarjeta', 'Tarjeta de credito'));
        tiposDePago.add(new SelectOption('Banco', 'Deposito bancario'));
        tiposDePago.add(new SelectOption('Transferencia', 'Transferencias'));

        lineasDeNegocio = new List<SelectOption>();
        lineasDeNegocioSeleccionadas =  new List<SelectOption>();

        for (Catalogo_UDC__c cat : [SELECT Name
                                    FROM Catalogo_UDC__c
                                    WHERE RecordType.DeveloperName = 'Lineas_de_negocio'
                                        AND Permitido_para_inventario__c = true
                                    ORDER BY Name ASC]) {
            lineasDeNegocio.add(new SelectOption(cat.Name, cat.Name));
        }

        if (lineasDeNegocio.isEmpty()) {
            lineasDeNegocio.add(new SelectOption('None', 'No hay registros'));
        }

        companias = new List<SelectOption>();

        companias.add(new SelectOption('', 'Todas'));

        for (Catalogo_UDC__c cat : [SELECT Name 
                                    FROM Catalogo_UDC__c
                                    WHERE RecordType.DeveloperName = 'Companias'
                                    ORDER BY Name ASC]) {
            companias.add(new SelectOption(cat.Name, cat.Name));
        }
    }
    
    public List<SelectOption> getMontoMaxList() {
    	List<SelectOption> montoMaxList = new List<SelectOption>();
	
        montoMaxList.add(new SelectOption('None', '--- Sin limites ---'));
        montoMaxList.add(new SelectOption('5000', 'Hasta $5000'));
        montoMaxList.add(new SelectOption('10000', 'Hasta $10000'));
        
        return montoMaxList;    
    }
 
    public PageReference generar() {        
        PageReference pg = new PageReference('/apex/Reporte_Ventas_Automotores');
        String myDtString = fecha.format();
        String[] values = myDtString.split('/');
        String valfecha = values[2] + '-' + values[1] + '-' + values[0];
        
        String myDtString2 = fecha2.format();
        String[] values2 = myDtString2.split('/');
        String valfecha2 = values2[2] + '-' + values2[1] + '-' + values2[0];
        
        List<String> lineaNegocio = new List<String>();
        List<String> tipoPago = new List<String>();

        for (SelectOption lineaNeg : lineasDeNegocioSeleccionadas) {
            lineaNegocio.add('\'' + lineaNeg.getValue() + '\'');
        }

        for (SelectOption tipoPag : tiposDePagoSeleccionados) {
            tipoPago.add(tipoPag.getValue());
        }

        pg.getParameters().put('fechaInicial', valfecha);
        pg.getParameters().put('fechaFinal', valfecha2);
        pg.getParameters().put('lineasDeNegocio', lineaNegocio.toString());
        pg.getParameters().put('compania', companiaSeleccionada);
        pg.getParameters().put('montoMaximo', montoMaxSeleccionado == 'None'? '' : montoMaxSeleccionado);
        pg.getParameters().put('tiposDePago', String.join(tipoPago,','));
        pg.setRedirect(false);
        
        System.debug(pg.getParameters());
        
        return pg;
    }
}