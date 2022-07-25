public with sharing class Product_Imagenes_Controller {

     @AuraEnabled
    public static List<ImagenProducto__c> getImagenes(String idProd) {
        
        List<ImagenProducto__c> lprodImagenes = [Select Id, Name, urlimagen__c, ProductCode__c
                    from ImagenProducto__c Where ProductCode__c =: idProd];
         
        return (lprodImagenes);
    }
    
    
}