declare module "@salesforce/apex/WS_InventorySearchList.getInventario" {
  export default function getInventario(param: {compania: any, linea: any, marca: any, modelo: any, inbond: any}): Promise<any>;
}
declare module "@salesforce/apex/WS_InventorySearchList.getInventarioByString" {
  export default function getInventarioByString(param: {searchKey: any, inventoryList: any}): Promise<any>;
}
declare module "@salesforce/apex/WS_InventorySearchList.cargaPickList" {
  export default function cargaPickList(): Promise<any>;
}
declare module "@salesforce/apex/WS_InventorySearchList.modelosPorMarca" {
  export default function modelosPorMarca(param: {marca: any}): Promise<any>;
}
declare module "@salesforce/apex/WS_InventorySearchList.getCurrentPermission" {
  export default function getCurrentPermission(): Promise<any>;
}
