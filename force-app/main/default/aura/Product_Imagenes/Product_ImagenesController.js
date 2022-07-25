({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.getImagenes");
        action.setParams ({
             "idProd": component.get("v.recordId")
         });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
            	var data = response.getReturnValue();
                component.set("v.listImagenes", data);

            } 
        });
        
        $A.enqueueAction(action);
		
	}
})