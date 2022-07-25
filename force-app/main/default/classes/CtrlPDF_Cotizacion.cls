public class CtrlPDF_Cotizacion {
    public String modeloAMostrar    {get;set;}
    public String direccionSuc		{get;set;}
    public String telefonoSuc		{get;set;}
    public String  cotizacionNum	{get;set;}	
    public String  fechaCreacion	{get;set;}
    public String  validaPor		{get;set;}	    
    public String  estimadoCte		{get;set;}
    public String  atencionA		{get;set;}
    public String  direccion		{get;set;}
    public String  vendedor			{get;set;}
    public String  correo			{get;set;}
    public String  telefono			{get;set;}
    public String  modelo           {get;set;}
    public List<wQLI> wQLIList		{get;set;}
    public List<String> lstEsp1_Interior		{get;set;}
    public List<String> lstEsp2_motorYCaract	{get;set;}
    public List<String> lstEsp3_exterior		{get;set;}
    public List<String> lstEsp4_seguridad		{get;set;}
    public Set<String> keySetEspecificaciones  {get;set;}
    public Map<String, String> mapaEspecificaciones     {get;set;}
    public String  interior			{get;set;}
    public String  motorYCaract		{get;set;}
    public String  exterior			{get;set;}
    public String  seguridad		{get;set;}
    public String  notasAdicionales	{get;set;}
    public String  subtotal2		{get;set;}
    public String  descuento		{get;set;}
    public String  iva				{get;set;}
    public String  precioEspecial	{get;set;}
    public String  urlLogo	        {get;set;}
    public String  formaAdquisicion {get;set;}
    public Date    fechaEntrega     {get;set;}
    public String  precioLista      {get;set;}
    public String  cantidad         {get;set;}
    public String  precioSinDescuento           {get;set;}
    public String  descuentoHero                {get;set;}
    public String  precioConDescuento           {get;set;}
    public String  totalAntesDeIVA              {get;set;}
    public String  IVAHero                      {get;set;}
    public String  precioEspecialHero           {get;set;}
    public String  precioUnitario               {get;set;}
    public String  accesorioAdicional           {get;set;}
    public String  precioAccesorioAdicional     {get;set;}
    public Quote quote {get;set;}
    public User vendedorU {get;set;}
    public Vehiculo__c vehiculo {get;set;}
    public Vehiculo_de_la_Oportunidad__c vehOpp {get;set;}
    
    public CtrlPDF_Cotizacion(){
        wQLIList      	= new List<wQLI>();
        mapaEspecificaciones = new Map<String, String>();

        direccionSuc	= '';
        telefonoSuc		= '';
        
        Id idCot = ApexPages.currentPage().getParameters().get('Id');
        
        quote = [
            SELECT Id, Name, OpportunityId, QuoteNumber, CreatedDate, ExpirationDate, Account.Name, Account.Direccion__c, 
                   Notas_Adicionales__c, Accesorio_Adicional__c, Precio_del_accesorio_adicional__c, Account.CodigoCliente__c,
                   Vehiculo__c 
            FROM Quote 
            WHERE id =:idCot
            LIMIT 1
            ];

        List<Opportunity> opp = [
            SELECT Id, Marca_UDC__r.Name, OwnerId, Sucursal__c, RecordType.DeveloperName, CloseDate, Forma_de_Pago_Multiple__c,
                   L_neas_de_Negocio__r.Name 
            FROM Opportunity 
            WHERE id =: quote.OpportunityId
            ];

        if (String.isNotBlank(quote.Vehiculo__c)) {
            vehiculo = [
                SELECT Id, Marca__r.Name, Modelo__r.Name, Color__c, Placa__c, Chasis__c, Anio_opcion__c, Observaciones_generales__c,
                Precio_de_compra_aprobado_S_Autolote__c, Motor__c, Equipado_con__c, Precio_vendedor__c, Tipo_de_modelo__c
                FROM Vehiculo__c
                WHERE Id =: quote.Vehiculo__c
                LIMIT 1
            ];

            vehOpp = [
                SELECT Id, Precio_de_venta__c, CurrencyIsoCode
                FROM Vehiculo_de_la_Oportunidad__c 
                WHERE Vehiculo__c =: vehiculo.Id
                    AND Oportunidad__c =: opp[0].Id
                LIMIT 1
            ];
        }

        vendedorU = [
            SELECT Id, Name, email, MobilePhone 
            FROM User 
            WHERE Id =: opp[0].OwnerId
            LIMIT 1
            ];

        List<QuoteLineItem> qli = [
            SELECT Id, Product2.Name, Product2.Marca_P__c, Product2.modelogenerico__c, Product2.modelofabrica__c, Product2.AnioModelo__c, 
                   Product2.CurrencyIsoCode, Product2.Codigovehiculo__c, Quantity, Subtotal, totalPrice, Product2.Especificaci_n_1__c, 
                   Product2.Especificaci_n_2__c, Product2.Especificaci_n_3__c, Product2.DisplayUrl, Product2.Especificaci_n_4__c, ListPrice, 
                   UnitPrice, Precio_final__c, Rebaja__c,Valor_IVA__c, Precio_de_lista_sin_IVA__c, Subtotal__c
            FROM QuoteLineItem 
            WHERE QuoteId =: idCot
            ];

        List<Catalogo_Sucursales__c> infoSucursal = [
            SELECT Id, Name, Direccion__c, Telefono__c 
            FROM Catalogo_Sucursales__c 
            WHERE Name =: opp[0].Sucursal__c
            ];

        if(!infoSucursal.isEmpty()){
            direccionSuc 	= infoSucursal[0].Direccion__c;
            telefonoSuc 	= infoSucursal[0].Telefono__c;
        }

                
        if (String.isNotBlank(opp[0].RecordType.DeveloperName)) {
            if (opp[0].RecordType.DeveloperName.contains('Autolote')) {
                modeloAMostrar = 'Autolote';
            } else {
                if(String.isNotBlank(opp[0].Marca_UDC__r.Name)){
                    if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'HINO'){
                        modeloAMostrar = 'Camiones_Hino';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'TOYOTA'){
                        modeloAMostrar = 'Autos_Toyota';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'KIA'){
                        modeloAMostrar = 'Autos_Kia';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'SUZUKI'){
                        modeloAMostrar = 'Autos_Suzuki';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'JMC') {
                        modeloAMostrar = 'Camiones_JMC';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'HERO'){
                        modeloAMostrar = 'Motos_Hero';
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'YAMAHA') {
                        if (opp[0].L_neas_de_Negocio__r.Name == 'Motores Marinos') {
                            modeloAMostrar = 'MotoresMarinos_Yamaha';
                        } else {
                            modeloAMostrar = 'Motos_Yamaha';
                        }
                    } else if (opp[0].Marca_UDC__r.Name.toUpperCase() == 'GENESIS'  || opp[0].Marca_UDC__r.Name.toUpperCase() == 'HAOJUE') {
                        modeloAMostrar = 'Motos_Genesis';
                    }
                }
            }
        }
        
        if (!qli.isEmpty()) {
            if (!test.isRunningTest()) {
                for (QuoteLineItem li :qli) {
                    wQLIList.add(new wQLI(
                        li.Product2.Marca_P__c,
                        li.Product2.modelogenerico__c + ' ' + li.Product2.Codigovehiculo__c + ' (' + li.Product2.AnioModelo__c + ')',
                        ''+ Integer.valueOf(li.Quantity),
                        ''+li.Product2.CurrencyIsoCode+' $ '+String.valueOf(li.Subtotal__c.format()),
                        ''+li.Product2.CurrencyIsoCode+' $ '+String.valueOf((li.Subtotal__c * li.Quantity).format())));
                    
                }
            }
            Decimal accesorioAdicionalPrecioSinIva = 0;
            Decimal accesorioAdicionalPrecioConIva = 0;
    
            if (String.isNotBlank(quote.Accesorio_Adicional__c)) {
                accesorioAdicionalPrecioSinIva = (quote.Precio_del_accesorio_adicional__c/1.15) * qli[0].Quantity;
                accesorioAdicionalPrecioConIva = quote.Precio_del_accesorio_adicional__c * qli[0].Quantity;
    
                accesorioAdicional = quote.Accesorio_Adicional__c.toUpperCase();
                
                precioAccesorioAdicional = 'USD $ ' + agregarComa('' + (accesorioAdicionalPrecioSinIva).setScale(2));
            }
    
            modelo              = qli[0].Product2.modelofabrica__c;
            Date fCreated		= date.newinstance (quote.CreatedDate.Year(), quote.CreatedDate.Month(), quote.CreatedDate.Day());
            validaPor			= '' + fCreated.daysBetween(quote.ExpirationDate)+' Días';

            if(String.isNotBlank(qli[0].Product2.Especificaci_n_1__c)){
                String esp1 = qli[0].Product2.Especificaci_n_1__c.unescapeHtml4();
                lstEsp1_Interior = esp1.split(';');
            } else {
                String esp1 = '';
            }
            
            if(String.isNotBlank(qli[0].Product2.Especificaci_n_2__c)){
                String esp2 = qli[0].Product2.Especificaci_n_2__c.unescapeHtml4();
                lstEsp2_motorYCaract = esp2.split(';');
            } else {
                String esp2 = '';
            }
            
            if(String.isNotBlank(qli[0].Product2.Especificaci_n_3__c)){
                String esp3 = qli[0].Product2.Especificaci_n_3__c.unescapeHtml4();
                lstEsp3_exterior = esp3.split(';');
            } else {
                String esp3 = '';
            }
            
            if(String.isNotBlank(qli[0].Product2.Especificaci_n_4__c)){
                String esp4 = qli[0].Product2.Especificaci_n_4__c.unescapeHtml4();
                lstEsp4_seguridad = esp4.split(';');
            } else {
                String esp4 = '';
            }
    
            urlLogo = String.valueOf(qli[0].Product2.DisplayUrl);
    
            String moneda = qli[0].Product2.CurrencyIsoCode + ' $ ';
    
            if (opp[0].RecordType.DeveloperName.contains('Moto') || opp[0].L_neas_de_Negocio__r.Name == 'Motores Marinos'){
    
                if (String.isNotBlank(qli[0].Product2.Especificaci_n_1__c)) {
    
                    for (String esp : qli[0].Product2.Especificaci_n_1__c.split(';')) {
                        List<String> espList = esp.split('=');
    
                        if (espList.size() > 1) {
                            mapaEspecificaciones.put(espList[0], espList[1]);
                        } else {
                            mapaEspecificaciones.put(espList[0], ' ');
                        }
                    }
    
                    keySetEspecificaciones = mapaEspecificaciones.keySet();
                }
    
                formaAdquisicion = opp[0].Forma_de_Pago_Multiple__c;
                fechaEntrega = opp[0].CloseDate;
                cantidad = qli[0].Quantity == null? '0' : qli[0].Quantity.format();
    
                Decimal precioDeLista = qli[0].ListPrice == null? 0 : qli[0].ListPrice;
                Decimal precioDeVenta = qli[0].UnitPrice == null? 0 : qli[0].UnitPrice;
    
                precioUnitario = moneda + agregarComa('' + (precioDeLista).setScale(2));
                precioSinDescuento = moneda + agregarComa('' + (precioDeLista * qli[0].Quantity).setScale(2));
                precioConDescuento = moneda + agregarComa('' + (precioDeVenta * qli[0].Quantity).setScale(2));
    
                descuentoHero = moneda + agregarComa('' + (Math.abs(precioDeVenta - precioDeLista) * qli[0].Quantity).setScale(2));
                
                Boolean IVAOriginal = false;
                if (qli[0].Valor_IVA__c != null &&  qli[0].Valor_IVA__c != 0) {
                    IVAOriginal = true;
                }
                
                Decimal totalAntesDeIVANumerico = IVAOriginal? ((precioDeVenta * qli[0].Quantity)/1.15).setScale(2) : (precioDeVenta * qli[0].Quantity).setScale(2);
    
                Decimal IVAHeroNumerico = IVAOriginal? (totalAntesDeIVANumerico * 0.15).setScale(2) : 0;
                IVAHero = IVAHeroNumerico > 0? moneda + agregarComa('' + IVAHeroNumerico) : moneda + '0.00';
                precioEspecialHero = moneda  + agregarComa('' + (totalAntesDeIVANumerico + IVAHeroNumerico).setScale(2));
            }
    
            notasAdicionales = quote.Notas_Adicionales__c == null ? '' : quote.Notas_Adicionales__c;
                
            Decimal ivaDecimal = qli[0].Valor_IVA__c == 0? 0 : qli[0].Valor_IVA__c * qli[0].Quantity + (accesorioAdicionalPrecioConIva - accesorioAdicionalPrecioSinIva);            

            Decimal totalSinIva = (qli[0].UnitPrice * qli[0].Quantity) / 1.15;
            
            Decimal totalConIva = totalSinIva + ivaDecimal + accesorioAdicionalPrecioSinIva;
            
            Decimal subtotal = qli[0].Subtotal__c != null? qli[0].Subtotal__c * qli[0].Quantity : 0;

            Decimal descuentoDecimal = qli[0].Rebaja__c != null? qli[0].Rebaja__c : 0;

            descuento = moneda + agregarComa(String.valueOf(descuentoDecimal.setScale(2, System.RoundingMode.CEILING)));
            subtotal2 = moneda + agregarComa(String.valueOf(subtotal.setScale(2, System.RoundingMode.CEILING)));
            precioLista = moneda + agregarComa(String.valueOf((qli[0].ListPrice * qli[0].Quantity).setScale(2, System.RoundingMode.CEILING)));
            iva	= moneda + agregarComa((ivaDecimal > 0)? String.valueOf(ivaDecimal.setScale(2, System.RoundingMode.CEILING)) : '0.00');
            totalAntesDeIVA = moneda  + agregarComa('' + totalSinIva.setScale(2, System.RoundingMode.CEILING));
			precioEspecial = moneda + agregarComa('' + totalConIva.setScale(2, System.RoundingMode.CEILING));
	
            String modelo = qli[0].Product2.Codigovehiculo__c;
            modelo = modelo.replaceAll(' ', '_').replaceAll(',','_').replaceAll('\\.','_').replaceAll('/','_');
            
            String cuenta = quote.Account.Name;
            cuenta = cuenta.replaceAll(' ', '_').replaceAll(',','_').replaceAll('\\.','_').replaceAll('/','_');

            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=Cotizacion_' + modelo + '_' + cuenta + '.pdf');
        }
        
        fechaCreacion		= '' + quote.CreatedDate.Day() + ' ' + retornaMes(quote.CreatedDate.Month()) + ' ' + quote.CreatedDate.Year();
        cotizacionNum 		= quote.QuoteNumber;
        estimadoCte			= quote.Account.Name;
        atencionA			= quote.Account.Name;
        direccion			= quote.Account.Direccion__c;
        vendedor			= vendedorU.Name;
        correo				= vendedorU.Email;
        telefono			= vendedorU.MobilePhone == null ? '-------' : vendedorU.MobilePhone;

    }
    
    public String agregarComa(String precio){
        List<String> listString = new List<String>();
        String valor = precio.substring(0, precio.length() - 3);
        for (Integer i = valor.length(); i >= 0; i--) {
            if (i != valor.length() && math.MOD(valor.length()-i, 3) == 0) {
                listString.add(valor.substring(i,valor.length()));
                valor = valor.substring(0,i);        
            }
            
        }
        if (String.isNotBlank(valor)) {
            listString.add(valor);
        }
        valor = '';
        for (Integer i = listString.size() - 1; i>=0 ; i--) {
            if (String.isBlank(valor)) {
                valor = listString.get(i);
            } else{
                valor += ',' + listString.get(i);
            }
        }
        valor += precio.substring(precio.length() - 3, precio.length());
        
        return valor;
    }
    
    public class wQLI {
        public String  marca		    {get;set;}
        public String  descripcion		{get;set;}
        public String  cantidad			{get;set;}
        public String  precioUnitario	{get;set;}
        public String  subtotal			{get;set;}
        
        public wQLI (String m, String d, String c, String pu, String sub){
            this.marca 	        = m;
            this.descripcion 	= d;
            this.cantidad 		= c;
            this.precioUnitario = pu;
            this.subtotal 		= sub;
        }
    }
    
    public static String retornaMes (Integer Mes){
        
        String mesAcotado;
        
        if(Mes == 1) { mesAcotado = 'Ene';}
        if(Mes == 2) { mesAcotado = 'Feb';}
        if(Mes == 3) { mesAcotado = 'Mar';}
        if(Mes == 4) { mesAcotado = 'Abr';}
        if(Mes == 5) { mesAcotado = 'May';}
        if(Mes == 6) { mesAcotado = 'Jun';}
        if(Mes == 7) { mesAcotado = 'Jul';}
        if(Mes == 8) { mesAcotado = 'Ago';}
        if(Mes == 9) { mesAcotado = 'Sep';}
        if(Mes == 10){ mesAcotado = 'Oct';}
        if(Mes == 11){ mesAcotado = 'Nov';}
        if(Mes == 12){ mesAcotado = 'Dic';}
        
        return mesAcotado;
    }
}