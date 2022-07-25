declare module "@salesforce/apex/AccesoriosNuevosController.consultarAccesorios" {
  export default function consultarAccesorios(param: {informesID: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.obtenerAccesorios" {
  export default function obtenerAccesorios(): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.obtenerCombos" {
  export default function obtenerCombos(param: {idInforme: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.descripcionCombos" {
  export default function descripcionCombos(param: {idInforme: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.guardarCombos" {
  export default function guardarCombos(param: {idInforme: any, listaCombos: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.guardarAccesorio" {
  export default function guardarAccesorio(param: {idInforme: any, listaAccesorios: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.eliminarAccesorio" {
  export default function eliminarAccesorio(param: {idAccesorio: any}): Promise<any>;
}
declare module "@salesforce/apex/AccesoriosNuevosController.actualizarCantidades" {
  export default function actualizarCantidades(param: {idInforme: any, codigoParte: any, cantidadNueva: any}): Promise<any>;
}
