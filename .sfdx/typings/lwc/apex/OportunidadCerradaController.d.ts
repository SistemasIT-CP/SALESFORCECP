declare module "@salesforce/apex/OportunidadCerradaController.obtenerPickList" {
  export default function obtenerPickList(): Promise<any>;
}
declare module "@salesforce/apex/OportunidadCerradaController.obtenerDetalle" {
  export default function obtenerDetalle(param: {razon: any}): Promise<any>;
}
declare module "@salesforce/apex/OportunidadCerradaController.obtenerMarcas" {
  export default function obtenerMarcas(param: {detalle: any}): Promise<any>;
}
declare module "@salesforce/apex/OportunidadCerradaController.setearRazonPerdida" {
  export default function setearRazonPerdida(param: {idOpp: any, razon: any, detalle: any, marca: any}): Promise<any>;
}
