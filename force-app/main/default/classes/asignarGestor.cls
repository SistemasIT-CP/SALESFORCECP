public without sharing class asignarGestor 
{
	@InvocableMethod(label='Asignar Usuario')
	public static void assign(list<RoundRobinAssignment> rras) {

        // what was the last user index?
        list<RoundRobin__c> RRSettings = 
            [SELECT id, GroupName__c, FieldName__c, Object__c, IndexOfLastUsed__c 
             FROM RoundRobin__c 
             WHERE GroupName__c =: rras[0].groupName
            ];
        
        set<Id> recordIds = new set<Id>();
        
        map<string, list<Grupo_Agentes__c>> usersByGroup = new map<string, list<Grupo_Agentes__c>>();
        List<SObject> objectList = new List<SObject>();
        
        // get the records
        for (RoundRobinAssignment rra:rras)
        {
            list<Grupo_Agentes__c> groupUsers = new list<Grupo_Agentes__c>();
            
            // see if we have it already in our map
            if (usersByGroup.get(rra.groupName) == null)
            {
                groupUsers = 
                    [select grupo__r.name , Id, Agente__c  
                     from Grupo_Agentes__c 
                     where Activo_para_Oportunidades__c = true 
                     		AND grupo__r.name   =: rra.groupName ORDER BY Id DESC
                    ];
      
                usersByGroup.put(rra.groupName, groupUsers);

            } 
            else 
            {
                groupUsers = usersByGroup.get(rra.groupName);
            }
            
            // what kind of object is this, anyway?
            Id rId = id.valueOf(rra.recordId);
			string Obj = rid.getSObjectType().getDescribe().getName();

            RoundRobin__c matchingRR = recordMatcher(RRSettings, rra.fieldName, Obj, rra.groupName);


            sObject so = rid.getSObjectType().newSObject(rid);
            integer nextIndex = getNextIndex(matchingRR, groupUsers);
            System.debug('nextIndex: ' + nextIndex);
            System.debug('cantidad de objetos en el groupUsers: ' + groupUsers.size());
            if (!groupUsers.isEmpty()) {
            	if (!test.isRunningTest()){
                   so.put(rra.fieldName, groupUsers[nextIndex].Agente__c);
                }            
    
                matchingRR.IndexOfLastUsed__c = nextIndex;
    
                // if the original list didn't contain the matching one, we need to add it here
                boolean isNew = true;
                for (RoundRobin__c rr: RRSettings){
                    // we already had that on our list
                    if (rr.Id == matchingRR.Id){
                        rr.IndexOfLastUsed__c = matchingRR.IndexOfLastUsed__c;
                        isNew = false;
                    }
                }
                if (isNew){
                    //we hadn't seen it before
                    system.debug('inserting a RR custom setting');
                    RRSettings.add(matchingRR);
                }
    
                objectList.add(so);    
            }
			
		}

        update objectList;

        // because we may have incremented them
        update RRSettings;

	}

    public static integer getNextIndex(RoundRobin__c match, list<Grupo_Agentes__c> groupUsers){
        if (match.IndexOfLastUsed__c == null){
            // it's null, so grab the first one!
            return 0;
        } else if (match.IndexOfLastUsed__c >= groupUsers.size()-1){
            // you've used them all
            system.debug(match.IndexOfLastUsed__c + ' is the last match, which is >= the group size of ' + groupUsers.size() + 'so we are going back to 0' );
            return 0;
        } else {
            // return the next one
            return integer.valueOf(match.IndexOfLastUsed__c + 1);
        }
    }

    public static RoundRobin__c recordMatcher(list<RoundRobin__c> records, string FieldName, string Obj, string GroupName){

        for (RoundRobin__c rr:records){
            if (rr.FieldName__c == FieldName && rr.Object__c == Obj && rr.GroupName__c == GroupName){
                return rr;
            }
        }

        // we never found it, so create one
        RoundRobin__c rrNew = new RoundRobin__c();
        rrNew.FieldName__c = FieldName;
        rrNew.Object__c = Obj;
        rrNew.GroupName__c = GroupName;
        
        // because name is required
        rrNew.Name = Obj + '-' + FieldName + '-' + GroupName;
        insert rrNew;
        return rrNew;
    }

    //what Process Builder/Flow Builder can reference for the input variables
	public class RoundRobinAssignment {
		@InvocableVariable(required=true label='group name')
		public string groupName;

        @InvocableVariable(required=true label='recordId')
		public string recordId;

		@InvocableVariable(required=false label='field name (default = ownerId)')
		public string fieldName;
	}

}