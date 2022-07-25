trigger CombosDeInformeDeNegociacionTrigger on CombosDeInformeDeNegociacion__c (after insert) {
    if(Trigger.IsAfter && Trigger.IsInsert && Trigger.New.Size()==1){
        
        List<AccesoriosComboParaNegociacion__c> accComboNegList = new List<AccesoriosComboParaNegociacion__c>();
        
        for(Combo_Accesorio__c c_acc:  [SELECT Id, Name, Accesorio__c, Cantidad__c, Accesorio__r.CodigoParte__c, 
                                                 Accesorio__r.Descripcion__c, Accesorio__r.Precio__c, Combo__c 
                                                 FROM Combo_Accesorio__c WHERE Combo__c =: Trigger.New[0].Combo__c]
           ){
               AccesoriosComboParaNegociacion__c accComboNeg = new AccesoriosComboParaNegociacion__c ();
               accComboNeg.Accesorio__c 			= c_acc.Accesorio__c;
               accComboNeg.Cantidad__c 				= c_acc.Cantidad__c;
               accComboNeg.Combo_del_informe__c		= Trigger.New[0].Id;
               accComboNeg.Descripcion__c			= c_acc.Accesorio__r.Descripcion__c;
                   
               accComboNegList.add(accComboNeg);
               
           }
        
           if(accComboNegList.size()>0){
           		insert accComboNegList;		     
               
               for(AccesoriosComboParaNegociacion__c accCPN: accComboNegList){
                   accCPN.Asociar_al_informe_Negociacion__c = true;
               }
               
               update accComboNegList;
               
               
           }
        
    }
}