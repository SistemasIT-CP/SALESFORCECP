@Istest (seealldata= true)
public class asignarGestor_Test {
    
    @istest
    public static void Test(){
        List<asignarGestor.RoundRobinAssignment> ra = new List<asignarGestor.RoundRobinAssignment>();
        
        RoundRobin__c rr = [SELECT id, GroupName__c, FieldName__c, Object__c, IndexOfLastUsed__c FROM RoundRobin__c WHERE  GroupName__c = 'Bancario'];
        
        asignarGestor.RoundRobinAssignment ra2 = new asignarGestor.RoundRobinAssignment();
        ra2.groupName = 'Bancario';
        ra2.recordId = rr.Id;
            
        ra.add(ra2);
            
        asignarGestor.assign(ra);
                
    }
    
    @istest
    public static void assignTest(){
        List<asignarGestor.RoundRobinAssignment> ra = new List<asignarGestor.RoundRobinAssignment>();
        
        RoundRobin__c rr = 
            [SELECT id, GroupName__c, FieldName__c, Object__c, IndexOfLastUsed__c 
             FROM RoundRobin__c 
             WHERE GroupName__c = 'Bancario'
            ];
        
        Grupo_Oportunidades__c go = new Grupo_Oportunidades__c();
        go.Name = 'Bancario';
        insert go;
        
        Grupo_Agentes__c ga = new Grupo_Agentes__c();
        ga.Activo_para_Oportunidades__c = true;
        ga.grupo__c = go.ID;
        insert ga;
        
        asignarGestor.RoundRobinAssignment ra2 = new asignarGestor.RoundRobinAssignment();
        ra2.groupName = 'Bancario';
        ra2.recordId = rr.Id;
        ra.add(ra2);
            
        asignarGestor.assign(ra);
                
    }

}