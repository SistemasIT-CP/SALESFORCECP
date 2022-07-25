declare module "@salesforce/apex/FlujoAnfitrionController.getOpportunities" {
  export default function getOpportunities(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/FlujoAnfitrionController.getModelosByMarca" {
  export default function getModelosByMarca(): Promise<any>;
}
declare module "@salesforce/apex/FlujoAnfitrionController.getUserBySucursal" {
  export default function getUserBySucursal(): Promise<any>;
}
declare module "@salesforce/apex/FlujoAnfitrionController.crearTareaDeAnfitrion" {
  export default function crearTareaDeAnfitrion(param: {userId: any, oppId: any}): Promise<any>;
}
declare module "@salesforce/apex/FlujoAnfitrionController.createLeadAnfitrion" {
  export default function createLeadAnfitrion(param: {firstName: any, middleName: any, lastName: any, email: any, phone: any, identification: any, marca: any, modelo: any, owner: any}): Promise<any>;
}
