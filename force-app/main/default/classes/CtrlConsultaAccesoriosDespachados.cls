public class CtrlConsultaAccesoriosDespachados {
    public String idInfNeg;
    public String accesorios;
    public List<String>	accesoriosList;	
    public List<String>	accesoriosNoDispList;	
        
    public CtrlConsultaAccesoriosDespachados(){
    }
    
    public pageReference validaAccesoriosDespachados(){
        idInfNeg = ApexPages.currentPage().getParameters().get('id');
        accesoriosList = new List<String>();
        accesoriosNoDispList = new List<String>();
        accesorios = '';
        List<Accesorios_del_informe__c> accInfList = new List<Accesorios_del_informe__c>();
        
        if (String.isNotBlank(idInfNeg)) {
            ActualizarAccesoriosDespachados.ActualizarAccesoriosDespachados(idInfNeg);
            ActualizarAccesoriosSolicitados.ActualizarAccesoriosSolicitados(idInfNeg);
        }
        
        PageReference p = new PageReference('/' + idInfNeg);
        p.setRedirect(true);
		return p;
    } 
}