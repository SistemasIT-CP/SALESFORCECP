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
                console.log("Estado Oportunidad F. Interno = " + state);
                
                var array = response.getReturnValue();
                console.log("Array= " + array);
                var nombreOpp = array[0];							// Nombre de la Oportunidad
                var tipoOpp_nombre = array[1];						//Tipo de Oportunidad
                var currentStep = array[2]							//Etapa actual
                var oppId = array[3];								//Id de la Oportunidad
                var vendedorOpp = array[4];							//Nombre del vendedor
                var stepStage = array[5];							//Etapa de la Oportunidad (Número)
                var tipoOpp = array[5];								// Tipo de Oportunidad "FB"
                
               // var indica_etapa = parseInt(stepStage);
               
                console.log("Número Etapa: " + indica_etapa);
                console.log(typeof(indica_etapa));

                component.set("v.oppParalela", oppId);
                component.set("v.vendedor", vendedorOpp);
                
                if (tipoOpp_nombre.includes("Financiamiento Interno")) {
                    component.set("v.interno",true);  
                  //  component.set("v.step", stepStage);
                    
                    
                    // Configura las etapas 
                    //  
                   
             
                            
                    if (currentStep.includes("Oportunidad Identificada")){
                        
                        component.set("v.step", "1");

                    } else if (currentStep.includes("Pre - Filtro")){
                            
                            component.set("v.step", "2");
 
                    }
                       
                      else if (currentStep.includes("Recopilar Información")){
                            
                            component.set("v.step", "3");
                           
                      }
                       else if (currentStep.includes("Información Completa")){
                            
                            component.set("v.step", "4");
                           
                       }
                           else if (currentStep.includes("Aprobación Por Comité")){
                            
                            component.set("v.step", "5");
                          
                           }
                                        
                       else if (currentStep.includes("Firma de Contrato")){
                            var step = "6";
                            component.set("v.step", "6");
                            
                       }
                       else if (currentStep.includes("Esperando Faturación")){
                             
                           var step = "7";
                            component.set("v.step", step);
                          
                       }
                                        
                           else {
                            
                            component.set("v.step", "8");
                        
                           }
                
                  
                    
                    
                    
                    //
                    // *********************** //
                    
                    //Oculta etapas según paso//
                    var indica_etapa = parseInt(component.get("v.step"));
               
                    switch (true) {
                            
                        case (indica_etapa <6):
                            component.set("v.muestra5",true);
                            component.set("v.muestra6",false); 
                            console.log("Muestra hasta etapa 5");
                            break;
                        case (indica_etapa => 6) :
                             component.set("v.muestra5",false);
                            component.set("v.muestra6",true); 
                            console.log("Oculta las etapas 1-2");

                } 
                    
                }   else {
                    
					component.set("v.activo",false);        
                    component.set("v.interno",false);  
                                
                }
               
                component.set("v.name",nombreOpp);
                component.set("v.tipo",tipoOpp_nombre);
                //component.set("v.step",stepStage);
                component.set("v.etapa",currentStep);
                component.set("v.loaded", false);
                
            } else {
                
                	console.log("Estado Oportunidad F. Interno = " + state);
					component.set("v.activo",false);  
                    component.set("v.interno",false);       
                
                
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