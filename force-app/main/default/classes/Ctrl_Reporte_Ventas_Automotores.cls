public class Ctrl_Reporte_Ventas_Automotores {
  
    public string fechatext {get;set;}
    public string fechatext2 {get;set;}
    public String lineasDeNegocio {get;set;}
    public String compania {get;set;}
    public string monto {get;set;}
    public string tipoPago {get;set;}
    public List<Vtas_inf> reportesList{get;set;}

    public class Vtas_inf {
        public Informe_de_Negociaci_n__c informeP {get;set;}
        public Informe_de_Negociaci_n__c informeJ {get;set;}
        public boolean isBreak {get;set;}
        public Date fechaContra {get;set;}
        public Account comprador {get;set;}
        public String genero {get;set;}
        public String segundoApellido {get;set;}
        public String primerApellido {get;set;}
        public String tipoVehiculo {get;set;}
        public String codigoUAF {get;set;}
        public String nombreCompania {get;set;}
        public String deptoSucursal {get;set;}
        public String muniSucursal {get;set;}
        public String factura {get;set;}
        public String chasis {get;set;}
        public String motor {get;set;}
        public String anio {get;set;}
        public String marca {get;set;}
        public String totalNegociado {get;set;}
        public String moneda {get;set;}
    }
        
    public Ctrl_Reporte_Ventas_Automotores() {
        fechatext = ApexPages.currentPage().getParameters().get('fechaInicial');
        fechatext2 = ApexPages.currentPage().getParameters().get('fechaFinal');
        compania = ApexPages.currentPage().getParameters().get('compania');
        lineasDeNegocio = ApexPages.currentPage().getParameters().get('lineasDeNegocio');
        monto = ApexPages.currentPage().getParameters().get('montoMaximo');
        tipoPago = ApexPages.currentPage().getParameters().get('tiposDePago');
         
        Datetime Fecha_filter = Datetime.valueOf(fechatext + ' 00:00:00'); 
        Datetime Fecha_filter2 = Datetime.valueOf(fechatext2 + ' 00:00:00');

        Map<ID, String> generoNameByID = new Map<ID, String>();
        for (Catalogo_UDC__c cat : [SELECT ID, Name FROM Catalogo_UDC__c
                                    WHERE RecordType.DeveloperName = 'Genero']) {
            generoNameByID.put(cat.ID, cat.Name);
        }

        String fields = 'Id, Cuenta__c, Cuenta__r.RecordType.DeveloperName, total_negociado__c, Contacto_Comprador__c, Contacto_Comprador__r.AccountID, C_Modelo__c, Oportunidad__r.Comprador__c, Oportunidad__r.Comprador__r.AccountID';
        String conditions =  'fechafactura__c >= ' + Fecha_filter.format('yyyy-MM-dd') + ' AND fechafactura__c <= ' + Fecha_filter2.format('yyyy-MM-dd') + ' AND Oportunidad__r.Forma_de_Pago_Multiple__c != \'Go Leasing\'';

        if (String.isNotBlank(lineasDeNegocio) && !lineasDeNegocio.contains('None')) {
            conditions += ' AND Oportunidad__r.L_neas_de_Negocio__r.Name IN ' + lineasDeNegocio;
        }

        if (String.isNotBlank(compania)) {
            conditions += ' AND Oportunidad__r.Compa_a__r.name = \'' + compania + '\'';
        }

        String query = 'SELECT ' + fields + ' FROM Informe_de_Negociaci_n__c WHERE ' + conditions + ' ORDER BY fechafactura__c ASC';

        List<Informe_de_Negociaci_n__c> infList = (List<Informe_de_Negociaci_n__c>) Database.query(query);
        
        System.debug(infList);
        System.debug(monto);
        System.debug(tipoPago);
        
        if(String.isNotBlank(monto) || (String.isNotBlank(tipoPago))) {
            infList = filtrado(infList);
        }
        
        reportesList = new List<Vtas_inf>(); 
              
        Integer contador = 1;

        List<ID> compradoresID = new List<ID>();
        List<ID> informesID = new List<ID>();
        List<String> modelosList = new List<String>();

        for (Informe_de_Negociaci_n__c inf : infList) {
            informesID.add(inf.ID);

            if (String.isNotBlank(inf.Oportunidad__r.Comprador__c)) {
                compradoresID.add(inf.Oportunidad__r.Comprador__r.AccountID);
            } else if (String.isNotBlank(inf.Contacto_Comprador__c)) {
                compradoresID.add(inf.Contacto_Comprador__r.AccountID);
            }

            modelosList.add(inf.C_Modelo__c);
        }

        Map<String, String> tipoVehiculoPorModelo = new Map<String, String>();

        for (Modelos_de_Motos_y_Camiones__mdt mod : [SELECT Tipo_de_vehiculo__c, MasterLabel
                                                    FROM Modelos_de_Motos_y_Camiones__mdt
                                                    WHERE MasterLabel IN :modelosList
                                                    ]) {
            tipoVehiculoPorModelo.put(mod.MasterLabel, mod.Tipo_de_vehiculo__c);
        }

        Map<ID, Account> compradoresPorID = new Map<ID, Account>(
            [SELECT ID, Tipo_de_Indentificaci_n__c , Cedula__c, Ocupacion_UDC__r.Name,
                    Profesion_UDC__r.Name, Name
            FROM Account 
            WHERE ID IN :compradoresID
            ]);

        Map<ID, Informe_de_Negociaci_n__c> informesPersonalesPorID = new Map<ID, Informe_de_Negociaci_n__c>();
        Map<ID, Informe_de_Negociaci_n__c> informesJuridicosPorID = new Map<ID, Informe_de_Negociaci_n__c>();

        for (Informe_de_Negociaci_n__c inf : [SELECT ID, fechafactura__c, Oportunidad__r.Compa_a__r.Name, Oportunidad__r.Departamento_Sucursal__c,
                                                     Oportunidad__r.Municipio_Sucursal__c, factura__c, Chasis__c, Motor__c, A_o__c, Marca_Oportunidad__c, 
                                                     total_negociado__c, Exchange_Rate_By_Date__r.CurrencyIsoCode, Cuenta__r.FirstName, Cuenta__r.MiddleName, 
                                                     Cuenta__r.LastName, Cuenta__r.Genero_UDC__pc, Cuenta__r.Nacionalidad_UDC__r.Name, Cuenta__r.Tipo_de_Indentificaci_n__c, 
                                                     Cuenta__r.Cedula__c, Cuenta__r.Profesion_UDC__r.Name, Cuenta__r.Ocupacion_UDC__r.Name, Cuenta__r.Departamento__r.Name,
                                                     Cuenta__r.Municipio__r.Name, Cuenta__r.Direccion__c, Cuenta__r.Actividad_economica_UDC__r.Name, 
                                                     Cuenta__r.Phone, C_Modelo__c, Oportunidad__r.Codigo_Asignado_UAF__c, Contacto_Comprador__c, Contacto_Comprador__r.AccountID,
                                                     Oportunidad__r.Comprador__c, Oportunidad__r.Comprador__r.AccountID
                                              FROM Informe_de_Negociaci_n__c
                                              WHERE ID IN: informesID  AND Cuenta__r.RecordType.DeveloperName = 'PersonAccount'
                                              ]) {
            informesPersonalesPorID.put(inf.ID, inf);
        }

        for (Informe_de_Negociaci_n__c inf : [SELECT ID, fechafactura__c, Oportunidad__r.Compa_a__r.Name, Oportunidad__r.Departamento_Sucursal__c,
                                                     Oportunidad__r.Municipio_Sucursal__c, factura__c, Chasis__c, Motor__c, A_o__c, Marca_Oportunidad__c, 
                                                     total_negociado__c, Exchange_Rate_By_Date__r.CurrencyIsoCode, Nombre_del_cliente__c, Cuenta__r.Cedula__c,
                                                     Cuenta__r.Departamento__r.Name, Cuenta__r.Municipio__r.Name, Cuenta__r.Direccion__c, Cuenta__r.Actividad_economica_UDC__r.Name,
                                                     C_Modelo__c, Oportunidad__r.Codigo_Asignado_UAF__c, Contacto_Comprador__c, Contacto_Comprador__r.AccountID,
                                                     Oportunidad__r.Comprador__c, Oportunidad__r.Comprador__r.AccountID
                                              FROM Informe_de_Negociaci_n__c
                                              WHERE ID IN: informesID  AND Cuenta__r.RecordType.DeveloperName != 'PersonAccount'
                                              ]) {
            informesPersonalesPorID.put(inf.ID, inf);
        }

        for (Informe_de_Negociaci_n__c informe : infList) {
            if(String.isNotBlank(informe.Cuenta__c)) {
                Vtas_inf venta_obje = new Vtas_inf(); 
                Informe_de_Negociaci_n__c inf;
    
                if (informe.Cuenta__r.RecordType.DeveloperName == 'PersonAccount') {
                    inf = informesPersonalesPorID.get(informe.ID);
    
                    venta_obje.genero = generoNameByID.get(inf.Cuenta__r.Genero_UDC__pc);
                    List<String> splitApellido = inf.Cuenta__r.LastName.split(' ');
                    if (splitApellido.size() > 1) {
                        venta_obje.primerApellido = splitApellido[0];
                        venta_obje.segundoApellido = '';
                        for (Integer i = 1; i < splitApellido.size(); i++) {
                            venta_obje.segundoApellido += splitApellido[i];
                        }
                    } else {
                        venta_obje.primerApellido = inf.Cuenta__r.LastName;
                        venta_obje.segundoApellido = '-- --'; 
                    }
                    
                    venta_obje.informeP = inf;
                } else {
                    inf = informesPersonalesPorID.get(informe.ID);
    
                    if (String.isNotBlank(inf.Oportunidad__r.Comprador__c)) {
                        venta_obje.comprador = compradoresPorID.get(inf.Oportunidad__r.Comprador__r.AccountID);
                    } else if (String.isNotBlank(inf.Contacto_Comprador__c)) {
                        venta_obje.comprador = compradoresPorID.get(inf.Contacto_Comprador__r.AccountID);
                    }
    
                    venta_obje.informeJ = inf;
                }
    
                venta_obje.fechaContra = inf.fechafactura__c;
                venta_obje.codigoUAF = inf.Oportunidad__r.Codigo_Asignado_UAF__c;
                venta_obje.nombreCompania = inf.Oportunidad__r.Compa_a__r.Name;
                venta_obje.deptoSucursal = inf.Oportunidad__r.Departamento_Sucursal__c;
                venta_obje.muniSucursal = inf.Oportunidad__r.Municipio_Sucursal__c;
                venta_obje.factura = inf.factura__c;
                venta_obje.chasis = inf.Chasis__c;
                venta_obje.motor = inf.Motor__c;
                venta_obje.anio = inf.A_o__c;
                venta_obje.marca = inf.Marca_Oportunidad__c;
                venta_obje.totalNegociado = '$' + inf.total_negociado__c.format();
                venta_obje.moneda = inf.Exchange_Rate_By_Date__r.CurrencyIsoCode;
    
                if(String.isNotBlank(inf.C_Modelo__c)) {
                    if(tipoVehiculoPorModelo.containsKey(inf.C_Modelo__c)) {
                        venta_obje.tipoVehiculo = tipoVehiculoPorModelo.get(inf.C_Modelo__c);
                    } else {
                        venta_obje.tipoVehiculo = 'Automovil';
                    }
                }
                
                if (contador == infList.size()) {
                    venta_obje.isBreak = false;
                } else {
                    venta_obje.isBreak = true;
                }
                
                reportesList.add(venta_obje);
                contador++;
            }
        }
    }

    public List<Informe_de_Negociaci_n__c> filtrado(List<Informe_de_Negociaci_n__c> infList) {
        Map<ID, Map<String, Decimal>> montosDePagosPorIDInforme = new Map<ID, Map<String, Decimal>>();
        List<ID> informesIDList = new List<ID>();
        Set<Informe_de_Negociaci_n__c> listResult = new Set<Informe_de_Negociaci_n__c>();

        for (Informe_de_Negociaci_n__c inf : infList) {
            informesIDList.add(inf.ID);
        }

        List<Recibos_de_la_negociaci_n__c > recNegList = 
            [SELECT Recibos__r.CodigoInstrumentoPago__c, Informe_de_Negociaci_n__c, Monto_aplicado_a_la_negociaci_n__c
            FROM Recibos_de_la_negociaci_n__c 
            WHERE Informe_de_Negociaci_n__c IN :informesIDList
                  AND Recibos__r.CodigoInstrumentoPago__c != null
            ];

        for (Recibos_de_la_negociaci_n__c recNeg : recNegList) {
            if (String.isNotBlank(recNeg.Recibos__r.CodigoInstrumentoPago__c)) {
                Map<String, Decimal> montoPorTipoPago;
    
                if (montosDePagosPorIDInforme.containsKey(recNeg.Informe_de_Negociaci_n__c)) {
                    montoPorTipoPago =  montosDePagosPorIDInforme.get(recNeg.Informe_de_Negociaci_n__c);

                    Decimal monto;

                    if (montoPorTipoPago.containsKey(recNeg.Recibos__r.CodigoInstrumentoPago__c)) {
                        monto = montoPorTipoPago.get(recNeg.Recibos__r.CodigoInstrumentoPago__c);
                    } else {
                        monto = 0;
                    }

                    monto += recNeg.Monto_aplicado_a_la_negociaci_n__c;

                    montoPorTipoPago.put(recNeg.Recibos__r.CodigoInstrumentoPago__c,
                                        monto);
    
                } else {
                    montoPorTipoPago = new Map<String, Decimal>();
                    montoPorTipoPago.put(recNeg.Recibos__r.CodigoInstrumentoPago__c,
                                         recNeg.Monto_aplicado_a_la_negociaci_n__c);
                }
    
                montosDePagosPorIDInforme.put(recNeg.Informe_de_Negociaci_n__c, montoPorTipoPago);
            }
        }

        List<String> pagos = new List<String>();

        if(String.isNotBlank(this.tipoPago)) {
            List<String> tipoPago = this.tipoPago.removeStart('(').removeEnd(')').split(',');
            for (String str : tipoPago) {
                if (str.contains('Cheques')) {
                    pagos.add('!');
                } 
                
                if (str.contains('Efectivo')) {
                    pagos.add('.');
                } 
                
                if (str.contains('Tarjeta')) {
                    pagos.add('?');
                } 
                
                if (str.contains('Banco')) {
                    pagos.add('N');
                } 
                
                if (str.contains('Transferencia')) {
                    pagos.add('T');
                }
            }
        }

        Decimal montoFinal = 0;

        if(String.isNotBlank(this.monto)) {
            montoFinal = Decimal.valueOf(this.monto);
        }

        System.debug(montoFinal);
        System.debug(pagos);
        System.debug(montosDePagosPorIDInforme);

        for (Informe_de_Negociaci_n__c inf : infList) {
            if(montosDePagosPorIDInforme.containsKey(inf.ID)) {
                Map<String, Decimal> montoPorPagos = montosDePagosPorIDInforme.get(inf.ID);
    
                System.debug(inf.ID);
                System.debug(montoPorPagos);
    
                Decimal montoInf = 0;

                for (String pago : pagos) {
                    if (montoPorPagos.containsKey(pago)) {
                        montoInf += montoPorPagos.get(pago);
                    }
                }
                
                if (montoInf >= montoFinal) {
                    listResult.add(inf);
                }
            }
        }

        return new List<Informe_de_Negociaci_n__c>(listResult);
    }
}