public class ClientesWS {
    public class GuardarMonedaCliente {
        public String arg0;
        public String arg1;
        public String arg2;
        public String arg3;
        public String arg4;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg4_type_info = new String[]{'arg4','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3','arg4'};
    }

    public class InactivarActivarCliente {
        public String arg0;
        public String arg1;
        public String arg2;
        public String arg3;
        public String arg4;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg4_type_info = new String[]{'arg4','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3','arg4'};
    }
    
    public class InsertarClientesCredito{
        public String arg0;
        public String arg1;
        public String arg2;
        public String arg3;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg3_type_info = new String[]{'arg3','http://ws.salesforce.casapellas.com/',null,'0','1','false'};       
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2','arg3'};
    }
    
    public class GuardarMonedaClienteResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class InactivarActivarClienteResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }

    public class InsertarClientesCreditoResponse {
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
        private String[] ns_map_type_info = new String[]{'http://ws.salesforce.casapellas.com/', 'ClientesWS'};
        

        public String GuardarMonedaCliente(String arg0,String arg1,String arg2,String arg3,String arg4) {
            ClientesWS.GuardarMonedaCliente request_x = new ClientesWS.GuardarMonedaCliente();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            ClientesWS.GuardarMonedaClienteResponse response_x;
            Map<String, ClientesWS.GuardarMonedaClienteResponse> response_map_x = new Map<String, ClientesWS.GuardarMonedaClienteResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GuardarMonedaCliente',
              'http://ws.salesforce.casapellas.com/',
              'GuardarMonedaClienteResponse',
              'ClientesWS.GuardarMonedaClienteResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }

        public String InactivarActivarCliente(String arg0,String arg1,String arg2,String arg3,String arg4) {
            ClientesWS.InactivarActivarCliente request_x = new ClientesWS.InactivarActivarCliente();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            ClientesWS.InactivarActivarClienteResponse response_x;
            Map<String, ClientesWS.InactivarActivarClienteResponse> response_map_x = new Map<String, ClientesWS.InactivarActivarClienteResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'InactivarActivarCliente',
              'http://ws.salesforce.casapellas.com/',
              'InactivarActivarClienteResponse',
              'ClientesWS.InactivarActivarClienteResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        public String InsertarClientesCredito(String arg0,String arg1,String arg2,String arg3) {
            ClientesWS.InsertarClientesCredito request_x = new ClientesWS.InsertarClientesCredito();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            ClientesWS.InsertarClientesCreditoResponse response_x;
            Map<String, ClientesWS.InsertarClientesCreditoResponse> response_map_x = new Map<String, ClientesWS.InsertarClientesCreditoResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'InsertarClientesCredito',
              'http://ws.salesforce.casapellas.com/',
              'InsertarClientesCreditoResponse',
              'ClientesWS.InsertarClientesCreditoResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}