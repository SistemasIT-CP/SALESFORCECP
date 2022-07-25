({
	getCalificaciones : function(component,helper) {
    var action = component.get("c.getCalificacionCliente");
    var recordID = component.get("v.recordId");
    
    action.setParams({
      'recordId': recordID
    });
    action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") 
      {
         var storeResponse = response.getReturnValue();
         var data=JSON.parse(JSON.stringify(storeResponse));
         console.log('@@@ Data '+  JSON.stringify(storeResponse));
         component.set("v.calificacionesList", data.calificaciones);
         component.set("v.Total",data.Total);
         component.set("v.Poderacion",data.CalificacionFinal);
         component.set("v.Nombrecliente",data.Nombre);
         component.set("v.Tipocliente",data.Tipocliente);
        
      }else if (state === "ERROR") 
      {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
      $A.enqueueAction(action);
    
	},
    getCalificacionesOP : function(component,helper) {
    var action = component.get("c.getCalificacionOportunidad");
    var recordID = component.get("v.recordId");
    
    action.setParams({
      'recordId': recordID
    });
    action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") 
      {
         var storeResponse2 = response.getReturnValue();
         var data2=JSON.parse(JSON.stringify(storeResponse2));
         console.log('@@@ Data '+  JSON.stringify(storeResponse2));
         component.set("v.calificacionesOPList", data2.calificacionesOP);
         component.set("v.TotalOP",data2.TotalOP);
         component.set("v.PoderacionOP",data2.CalificacionFinalOP);
         
        
      }else if (state === "ERROR") 
      {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
      $A.enqueueAction(action);
    
	}
})