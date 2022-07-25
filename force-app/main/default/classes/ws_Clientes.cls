public class ws_Clientes {
    public class GetACVehiculos {
        public String arg0;
        public String arg1;
        public String arg2;
        public Integer arg3;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3'};
    }

    public class GetACVehiculosCliente {
        public String arg0;
        public String arg1;
        public String arg2;
        public Integer arg3;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3'};
    }

    public class GetFacturasMaestroDiaResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    
    public class GetFacturasMaestroDia {
        public String arg0;
        public String arg1;
        public String arg2;
        public String arg3;
        public String arg4;
        public String arg5;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg4_type_info = new String[]{'arg4','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg5_type_info = new String[]{'arg5','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3','arg4','arg5'};
    }

    public class GetFacturaDetalleDia {
        public String arg0;
        public String arg1;
        public String arg2;
        public String arg3;
        public String arg4;
        public String arg5;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg4_type_info = new String[]{'arg4','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg5_type_info = new String[]{'arg5','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3','arg4','arg5'};
    }

    public class GetACVehiculosResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class GetACVehiculosClienteResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class GetFacturaDetalleDiaResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class wsClientesPort {
        public String endpoint_x = Label.URL_WS_Cliente_CP;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://ws.salesforce.casapellas.com/', 'ws_Clientes'};
        
        public String GetFacturaDetalleDia(String arg0,String arg1,String arg2,String arg3,String arg4,String arg5) {
            ws_Clientes.GetFacturaDetalleDia request_x = new ws_Clientes.GetFacturaDetalleDia();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            request_x.arg5 = arg5;
            ws_Clientes.GetFacturaDetalleDiaResponse response_x;
            Map<String, ws_Clientes.GetFacturaDetalleDiaResponse> response_map_x = new Map<String, ws_Clientes.GetFacturaDetalleDiaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetFacturaDetalleDia',
              'http://ws.salesforce.casapellas.com/',
              'GetFacturaDetalleDiaResponse',
              'ws_Clientes.GetFacturaDetalleDiaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }    
        
        public String GetFacturasMaestroDia(String arg0,String arg1,String arg2,String arg3,String arg4,String arg5) {
            ws_Clientes.GetFacturasMaestroDia request_x = new ws_Clientes.GetFacturasMaestroDia();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            request_x.arg5 = arg5;
            ws_Clientes.GetFacturasMaestroDiaResponse response_x;
            Map<String, ws_Clientes.GetFacturasMaestroDiaResponse> response_map_x = new Map<String, ws_Clientes.GetFacturasMaestroDiaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetFacturasMaestroDia',
              'http://ws.salesforce.casapellas.com/',
              'GetFacturasMaestroDiaResponse',
              'ws_Clientes.GetFacturasMaestroDiaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        public String GetACVehiculos(String arg0,String arg1,String arg2,Integer arg3) {
            ws_Clientes.GetACVehiculos request_x = new ws_Clientes.GetACVehiculos();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            ws_Clientes.GetACVehiculosResponse response_x;
            Map<String, ws_Clientes.GetACVehiculosResponse> response_map_x = new Map<String, ws_Clientes.GetACVehiculosResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetACVehiculos',
              'http://ws.salesforce.casapellas.com/',
              'GetACVehiculosResponse',
              'ws_Clientes.GetACVehiculosResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        public String GetACVehiculosCliente(String arg0,String arg1,String arg2,Integer arg3) {
            ws_Clientes.GetACVehiculosCliente request_x = new ws_Clientes.GetACVehiculosCliente();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            ws_Clientes.GetACVehiculosClienteResponse response_x;
            Map<String, ws_Clientes.GetACVehiculosClienteResponse> response_map_x = new Map<String, ws_Clientes.GetACVehiculosClienteResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetACVehiculosCliente',
              'http://ws.salesforce.casapellas.com/',
              'GetACVehiculosClienteResponse',
              'ws_Clientes.GetACVehiculosClienteResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}