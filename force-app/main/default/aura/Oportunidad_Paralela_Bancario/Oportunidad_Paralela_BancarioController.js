({
	doInit : function(component, event, helper) {
        component.set("v.loaded", true);
 
        var action = component.get("c.getOpportunity");
        action.setParams({
            recordId: component.get("v.recordId"),  
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            
            if (state == "SUCCESS") {
                
                console.log("Estado Oportunidad F. Bancario = " + state);
                
                var array = response.getReturnValue();
                console.log("Array= " + array);
                var nombreOpp = array[0];							// Nombre de la Oportunidad
                var tipoOpp_nombre = array[1];						//Tipo de Oportunidad
                var currentStep = array[2]							//Etapa actual
                var oppId = array[3];								//Id de la Oportunidad
                var vendedorOpp = array[4];							//Nombre del vendedor
                var stepStage = array[5];							//Etapa de la Oportunidad (Número)
                var tipoOpp = array[6];								// Tipo de Oportunidad "FB"
                
                var indica_etapa = parseInt(stepStage);
                console.log("Número Etapa: " + indica_etapa);
                console.log(typeof(indica_etapa));

                component.set("v.oppParalela", oppId);
                component.set("v.vendedor", vendedorOpp);
 
                if (tipoOpp_nombre.includes("Financiamiento Bancario")){
                    
                    component.set("v.activo",true);
                    component.set("v.bancario",true);  
                    
                                     
                    if (currentStep.includes("Recopilar Información")){
                        
                        component.set("v.step", "1");

                    } else if (currentStep.includes("Información Completa")){
                            
                            component.set("v.step", "2");
 
                    }
                       
                      else if (currentStep.includes("Formalización Bancaria")){
                            
                            component.set("v.step", "3");
                           
                      }
                       else if (currentStep.includes("Esperando Faturación")){
                            
                            component.set("v.step", "4");
                           
                       }
                           

                                        
                           else {
                            
                            component.set("v.step", "5");
                        
                           }
                    
              
                    
                    
                } else {
                    
					component.set("v.activo",false);  
                    component.set("v.bancario",false);                     
                }
                
                component.set("v.name",nombreOpp);
                component.set("v.tipo",tipoOpp_nombre);
               // component.set("v.step",stepStage);
                component.set("v.etapa",currentStep);
                component.set("v.loaded", false);
                
            } else {
                
                	console.log("Estado Oportunidad F. Bancario = " + state);
					component.set("v.activo",false);  
                    component.set("v.bancario",false);       
                
            }
            
            
        });
        $A.enqueueAction(action);
       // window.location.reload();
           
    },
    
    Oportunidad: function(component, event, helper){
        
        var opp_Id = component.get("v.oppParalela");
        
        console.log("Id: "+ opp_Id);
        
        var url = '/lightning/r/Opportunity/'+opp_Id+'/view';
        //Console.log("URL: "+ url);
        window.open(url, '_blank');
      }
    
})