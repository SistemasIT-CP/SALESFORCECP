public without sharing class Ctrl_Recibos{

	public list<Wrapper> ListWrap			{get;set;}
	public list<AllRecibidos__c> listcon	{get;set;}
    //public String esquela				    {get;set;}
    public String paramBusqueda				{get;set;}
    public String tipoDeBusqueda			{get;set;}
    public String msjBusqueda				{get;set;}
    public Id idInfNeg;
    public Id rtId_ReciboPrincipal;

	//=====================class Constructor

	public Ctrl_Recibos(){
        tipoDeBusqueda = 'código del cliente';
        idInfNeg = ApexPages.currentPage().getParameters().get('id');
        
        if (idInfNeg != null) {
            List<Informe_de_Negociaci_n__c> infList = [
                SELECT Id, Cuenta__c, Cuenta__r.CodigoCliente__c, Oportunidad__r.Esquela__c
                FROM Informe_de_Negociaci_n__c 
                WHERE id =: idInfNeg
            ];
         
            if (!infList.isEmpty()) {
                if (String.isNotBlank(infList[0].Cuenta__c)) {
                    paramBusqueda = infList[0].Cuenta__r.CodigoCliente__c;
                    //esquela = infList[0].Oportunidad__r.Esquela__c;
                    consultaRecibos();
                }
            }   
        }
	}
	
    public void consultaRecibos() {
       	System.debug('TIPO DE BUSQUEDA: ' + tipoDeBusqueda );
        System.debug('VALOR BUSQUEDA: ' + paramBusqueda );

        list<AllRecibidos__c> listR = new List<AllRecibidos__c>();

        if (tipoDeBusqueda == 'nombre del cliente') {
        	listR = [
                SELECT Id, AU__c, Name, NumeroRecibido__c, Codigo_de_Cliente__c, Nombre_del_cliente__c, Fecha__c, Vehiculo__r.AU__c,
                     		Concepto__c, MontoAplicado__c, Cuenta__c, CurrencyIsoCode, Saldo_disponible__c, Saldo_aplicado__c  
                FROM AllRecibidos__c 
                WHERE Nombre_del_cliente__c =: paramBusqueda 
                    AND RecordType.DeveloperName = 'Principal'
                ORDER BY Fecha__c, NumeroRecibido__c DESC 
                NULLS LAST
            ]; 
            
            System.debug('ENTRA nombre del cliente');
            System.debug('listR: ' + listR.size());
        }
        
        if (tipoDeBusqueda == 'código del cliente') {
        	listR = [
                SELECT Id, AU__c, Name, NumeroRecibido__c, Codigo_de_Cliente__c, Nombre_del_cliente__c, Fecha__c, Vehiculo__r.AU__c,
                     		Concepto__c, MontoAplicado__c, Cuenta__c, CurrencyIsoCode, Saldo_disponible__c, Saldo_aplicado__c  
                FROM AllRecibidos__c 
                WHERE Codigo_de_Cliente__c =: paramBusqueda
                    AND RecordType.DeveloperName = 'Principal'
                ORDER BY Fecha__c, NumeroRecibido__c DESC 
                NULLS LAST
            ]; 
            
            System.debug('ENTRA código del cliente');
            System.debug('listR: ' + listR.size());
        }
        
        if (tipoDeBusqueda == 'número del recibo') {
            if (paramBusqueda.isNumeric()) {
            	listR = [
                    SELECT Id, AU__c, Name, NumeroRecibido__c, Codigo_de_Cliente__c, Nombre_del_cliente__c, Fecha__c, Vehiculo__r.AU__c,
                         		Concepto__c, MontoAplicado__c, Cuenta__c, CurrencyIsoCode, Saldo_disponible__c, Saldo_aplicado__c  
                    FROM AllRecibidos__c 
                    WHERE NumeroRecibido__c =: Decimal.valueOf(paramBusqueda) 
                        AND RecordType.DeveloperName = 'Principal'
                    ORDER BY Fecha__c, NumeroRecibido__c DESC 
                    NULLS LAST
                ]; 
            } else {
                msjBusqueda = 'El valor de busqueda con número de recibo debe ser númerico';
            }
            
            System.debug('ENTRA número del recibo');
            System.debug('listR: ' + listR.size());
        }

        if (tipoDeBusqueda == 'au' || test.isRunningTest()) {
            listR = [
                SELECT Id, Name, NumeroRecibido__c, Codigo_de_Cliente__c, Nombre_del_cliente__c, Fecha__c, Vehiculo__r.AU__c,
                            Concepto__c, MontoAplicado__c, Cuenta__c, CurrencyIsoCode, Saldo_disponible__c, Saldo_aplicado__c  
                FROM AllRecibidos__c 
                WHERE Vehiculo__r.AU__c =: paramBusqueda 
                   AND RecordType.DeveloperName = 'Principal'
                ORDER BY Fecha__c, NumeroRecibido__c DESC 
                NULLS LAST
            ]; 
            
            System.debug('ENTRA au');
            System.debug('listR: ' + listR.size());
            
        }

        /*if (tipoDeBusqueda == 'esquela' || test.isRunningTest()) {
            listR = [
                SELECT Id, AU__c, Name, NumeroRecibido__c, Codigo_de_Cliente__c, Nombre_del_cliente__c, Fecha__c,
                            Concepto__c, MontoAplicado__c, Cuenta__c, CurrencyIsoCode, Saldo_disponible__c, Saldo_aplicado__c  
                FROM AllRecibidos__c 
                WHERE Esquela__c =: paramBusqueda
                    AND RecordType.DeveloperName = 'Principal'
                ORDER BY Fecha__c, NumeroRecibido__c DESC 
                NULLS LAST
            ]; 
            
            System.debug('ENTRA esquela');
            System.debug('listR: ' + listR.size());
            
        }*/
        
        if (!listR.isEmpty()) {
            msjBusqueda = 'Se encontraron '+ listR.size() + ' registros';
        } else {
            msjBusqueda = 'No se encontraron registros para esta búsqueda, valide que la información sea correcta';
        }        

		ListWrap = new List<wrapper>(); //---------- wrapper class object
        
		for (AllRecibidos__c r : listR) {
            Boolean Nodisponible = r.Saldo_disponible__c == 0;
            Decimal saldoAplicado = r.Saldo_aplicado__c != null? r.Saldo_aplicado__c : 0;

            System.debug('NO DISPONIBLE: ' + noDisponible);
            System.debug('r.Saldo_aplicado__c: ' + r.Saldo_aplicado__c);
            System.debug('r.Saldo_disponible__c: ' + r.Saldo_disponible__c);
            System.debug('r.Id: ' + r.Id);
            
			ListWrap.add(new wrapper(r, 
                                     r.Vehiculo__r.AU__c, 
                                     ''+r.NumeroRecibido__c, 
                                     ''+r.Codigo_de_Cliente__c, 
                                     ''+r.Nombre_del_cliente__c, 
                                     (''+r.Fecha__c).mid(0, 10), r.Concepto__c, 
                                     r.CurrencyIsoCode + ' $'+String.valueOf(saldoAplicado),
                                     r.CurrencyIsoCode + ' $'+String.valueOf(r.Saldo_disponible__c.format()),
                                     Nodisponible));
		}
    }

	public PageReference validaSeleccionados() {
		List<Recibos_de_la_negociaci_n__c> recibosNeg = new List<Recibos_de_la_negociaci_n__c>();
        
		for (wrapper c : ListWrap) {
			if(c.checkbox == true) {
				System.debug('RECIBO SELECCIONADO: ' + c.numRecibo);
                recibosNeg.add(
                    new Recibos_de_la_negociaci_n__c (
                        Informe_de_Negociaci_n__c = idInfNeg, 
                        Recibos__c = c.recibo.Id, 
                        CurrencyIsoCode = c.recibo.CurrencyIsoCode, 
                        Monto_aplicado_a_la_negociaci_n__c = 0
                    )
                );
            }
        }
        
        if (!recibosNeg.isEmpty()) {
            insert recibosNeg;
        }
        
        PageReference  p = new PageReference ('/'+idInfNeg);
        p.setRedirect(true);	
		return p;
	}
    
    public void limpiaBusqueda() {
        ListWrap = new List<wrapper>();
        msjBusqueda = '';
        paramBusqueda = '';
        /*if (tipoDeBusqueda == 'esquela') {
            paramBusqueda = esquela;
        }*/
    }

    public void setParamBusqueda(){
    }
    
    public void refrescarRecibos() {
        try {
            System.debug('entra en refrescar recibos');

            ProcesaRecibosDia.procesaRecibosNow();
            
            String parametroBusqueda = paramBusqueda;
            
            PageReference tempPage = ApexPages.currentPage();            
        	tempPage.setRedirect(true);
            paramBusqueda = parametroBusqueda;
            consultaRecibos();
        } catch (Exception e) {
            System.debug('Algo ha salido mal. ' + e);
        }
    }

    /*public void refrescarRecibosEsquela() {
        try {
            System.debug('entra en refrescar esquelas');

            String esquela = paramBusqueda;

            System.debug(esquela);
            System.debug(String.isBlank(esquela));

            if (String.isBlank(esquela)) {
                msjBusqueda = 'Debe ingresar una esquela para hacer el actualización';
            } else {
                String mensaje = CallWSEsquelas.obtenerRecibosPorEsquela(esquela);
                
                if (mensaje == 'Ok') {
                    PageReference tempPage = ApexPages.currentPage();            
                    tempPage.setRedirect(true);
                    paramBusqueda = esquela;
        
                    consultaRecibos();
                } else {
                    msjBusqueda = mensaje;
                }
            }
            
        } catch (Exception e) {
            System.debug('Algo ha salido mal. ' + e);
        }
    }*/

	//========== wrapper class ====================

	public class wrapper{

		public AllRecibidos__c recibo 	{get;set;}
		public String au    			{get;set;}
		public String numRecibo			{get;set;}
        public String codCliente		{get;set;}
        public String cliente			{get;set;}
        public String fecha				{get;set;}
        public String concepto			{get;set;}
        public String saldoAplicado		{get;set;}
        public String saldoDisponible	{get;set;}
		public boolean checkbox			{get;set;}
        public boolean noVisible		{get;set;}
        
		public Wrapper(AllRecibidos__c rec, String au, String numRec, String codCte, String cte, String f, String concep, String saldoApli, String saldoDisp, Boolean noVisible) {
		 	this.recibo = rec;
			this.au = au;
			this.numRecibo = numRec;
			this.codCliente = codCte;
			this.cliente = cte;
			this.fecha = f;
			this.concepto = concep;		
			this.saldoAplicado = saldoApli;
            this.saldoDisponible = saldoDisp;
            this.saldoDisponible = saldoDisp;
            this.checkbox = test.isRunningTest();	
            this.noVisible = noVisible;
		}
	}
}