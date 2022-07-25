declare module "@salesforce/apex/ModificarDatosDeCuenta.tipoDeCuenta" {
  export default function tipoDeCuenta(param: {cuentaID: any}): Promise<any>;
}
declare module "@salesforce/apex/ModificarDatosDeCuenta.eliminarDocumentos" {
  export default function eliminarDocumentos(param: {idArhivos: any}): Promise<any>;
}
declare module "@salesforce/apex/ModificarDatosDeCuenta.enviarAprobacion" {
  export default function enviarAprobacion(param: {cuentaID: any, name: any, tipo: any, cedula: any, idArhivos: any}): Promise<any>;
}
