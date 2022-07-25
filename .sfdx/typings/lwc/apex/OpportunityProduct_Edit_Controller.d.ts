declare module "@salesforce/apex/OpportunityProduct_Edit_Controller.getProductos" {
  export default function getProductos(param: {idOpp: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityProduct_Edit_Controller.AsignarMotorChasis" {
  export default function AsignarMotorChasis(param: {idOppProd: any, Motor: any, Chasis: any, Color: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityProduct_Edit_Controller.Desasignar" {
  export default function Desasignar(param: {idOppProd: any, motivo: any, tipoDeasignacion: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityProduct_Edit_Controller.obtenerRecordTypeOpp" {
  export default function obtenerRecordTypeOpp(param: {recordID: any}): Promise<any>;
}
declare module "@salesforce/apex/OpportunityProduct_Edit_Controller.CrearInformeNegociacion" {
  export default function CrearInformeNegociacion(param: {idOppProd: any}): Promise<any>;
}
