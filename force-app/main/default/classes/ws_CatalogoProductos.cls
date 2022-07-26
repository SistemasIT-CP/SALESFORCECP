//Generated by wsdl2apex

public class ws_CatalogoProductos {
    public class GetProductosDia {
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
    public class GetProductosDiaResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    /*public class GetProductosImagenes {
        public String arg0;
        public String arg1;
        public String arg2;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2'};
    }*/
    public class GetProductosImagenesDia {
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
    public class GetProductosImagenesDiaResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    
    public class GetProductos {
        public String arg0;
        public String arg1;
        public String arg2;
        private String[] arg0_type_info = new String[]{'arg0','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg1_type_info = new String[]{'arg1','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] arg2_type_info = new String[]{'arg2','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'arg0','arg1','arg2'};
    }
    public class GetProductosResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    /*public class GetProductosImagenesResponse {
        public String return_x;
        private String[] return_x_type_info = new String[]{'return','http://ws.salesforce.casapellas.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ws.salesforce.casapellas.com/','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }*/
    public class wsProductosPort {
        //public String endpoint_x = 'http://ap1.casapellas.com.ni:9089/GCPWS/wsProductosService';
        public String endpoint_x = Label.URL_WS_Productos;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x = 120000;
        private String[] ns_map_type_info = new String[]{'http://ws.salesforce.casapellas.com/', 'ws_CatalogoProductos'};
            
        public String GetProductos(String arg0,String arg1,String arg2) {
            ws_CatalogoProductos.GetProductos request_x = new ws_CatalogoProductos.GetProductos();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            ws_CatalogoProductos.GetProductosResponse response_x;
            Map<String, ws_CatalogoProductos.GetProductosResponse> response_map_x = new Map<String, ws_CatalogoProductos.GetProductosResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetProductos',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosResponse',
              'ws_CatalogoProductos.GetProductosResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        public String GetProductosImagenesDia(String arg0,String arg1,String arg2,String arg3,String arg4,String arg5) {
            ws_CatalogoProductos.GetProductosImagenesDia request_x = new ws_CatalogoProductos.GetProductosImagenesDia();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            request_x.arg5 = arg5;
            ws_CatalogoProductos.GetProductosImagenesDiaResponse response_x;
            Map<String, ws_CatalogoProductos.GetProductosImagenesDiaResponse> response_map_x = new Map<String, ws_CatalogoProductos.GetProductosImagenesDiaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosImagenesDia',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosImagenesDiaResponse',
              'ws_CatalogoProductos.GetProductosImagenesDiaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        public String GetProductosDia(String arg0,String arg1,String arg2,String arg3,String arg4,String arg5) {
            ws_CatalogoProductos.GetProductosDia request_x = new ws_CatalogoProductos.GetProductosDia();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            request_x.arg3 = arg3;
            request_x.arg4 = arg4;
            request_x.arg5 = arg5;
            ws_CatalogoProductos.GetProductosDiaResponse response_x;
            Map<String, ws_CatalogoProductos.GetProductosDiaResponse> response_map_x = new Map<String, ws_CatalogoProductos.GetProductosDiaResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosDia',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosDiaResponse',
              'ws_CatalogoProductos.GetProductosDiaResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        /*public String GetProductosImagenes(String arg0,String arg1,String arg2) {
            ws_CatalogoProductos.GetProductosImagenes request_x = new ws_CatalogoProductos.GetProductosImagenes();
            request_x.arg0 = arg0;
            request_x.arg1 = arg1;
            request_x.arg2 = arg2;
            ws_CatalogoProductos.GetProductosImagenesResponse response_x;
            Map<String, ws_CatalogoProductos.GetProductosImagenesResponse> response_map_x = new Map<String, ws_CatalogoProductos.GetProductosImagenesResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosImagenes',
              'http://ws.salesforce.casapellas.com/',
              'GetProductosImagenesResponse',
              'ws_CatalogoProductos.GetProductosImagenesResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }*/
    }
}