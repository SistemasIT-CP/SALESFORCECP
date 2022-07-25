public class OportunidadCerradaController {

    @AuraEnabled
    public static List<String> obtenerPickList() {
        List<String> picklistOptions = new List<String>();

        Schema.DescribeFieldResult field = Opportunity.Razon_perdida__c.getDescribe();

        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            if (f.getLabel() != 'Oportunidad Duplicada' && f.getLabel() != 'Cliente en Lista Negra') {
                picklistOptions.add(f.getLabel());
            }
        }


        return picklistOptions;
    }

    @AuraEnabled
    public static List<String> obtenerDetalle(String razon) {
        List<String> picklistOptions = new List<String>();

        Schema.DescribeFieldResult F = Opportunity.Detalle_de_perdida__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();

        Map<String, List<String>> mapaDependencias = getDependentPicklistValues(T);

        for (String key : mapaDependencias.keySet()) {
            if (key == razon) {
                picklistOptions = mapaDependencias.get(key);
            }
        }

        return picklistOptions;
    }

    @AuraEnabled
    public static List<String> obtenerMarcas(String detalle) {
        List<String> picklistOptions = new List<String>();

        Schema.DescribeFieldResult F = Opportunity.Marca_detalle_de_perdida__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();

        Map<String, List<String>> mapaDependencias = getDependentPicklistValues(T);

        for (String key : mapaDependencias.keySet()) {
            if (key == detalle) {
                picklistOptions = mapaDependencias.get(key);
            }
        }

        return picklistOptions;
    }

    @AuraEnabled
    public static String setearRazonPerdida(String idOpp, String razon, String detalle, String marca){
        List<Opportunity> oppList = 
            [SELECT ID, Razon_perdida__c, Detalle_de_perdida__c, Marca_detalle_de_perdida__c
            FROM Opportunity
            WHERE ID =: idOpp
            LIMIT 1
            ];

        System.debug(razon);

        if (!oppList.isEmpty()) {
            oppList[0].Razon_perdida__c = razon;
            
            if (String.isNotBlank(detalle)) {
                oppList[0].Detalle_de_perdida__c = detalle;
            }
            
            if (String.isNotBlank(marca)) {
                oppList[0].Marca_detalle_de_perdida__c = marca;
            }

            List<Database.SaveResult> srList = Database.update(oppList, false);

            if (!srList[0].isSuccess()) {
                return 'Error: ' + srList[0].getErrors()[0].getMessage();
            } else {
                return 'Bien';
            }
        } else {
            return 'Error: No se han encontrado oportunidades';
        }
    }

    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
}