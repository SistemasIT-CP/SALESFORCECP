import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunities from '@salesforce/apex/FlujoAnfitrionController.getOpportunities';
import getModelosByMarca from '@salesforce/apex/FlujoAnfitrionController.getModelosByMarca';
import getUserBySucursal from '@salesforce/apex/FlujoAnfitrionController.getUserBySucursal';
import createLeadAnfitrion from '@salesforce/apex/FlujoAnfitrionController.createLeadAnfitrion';
import crearTareaDeAnfitrion from '@salesforce/apex/FlujoAnfitrionController.crearTareaDeAnfitrion';
import userId from '@salesforce/user/Id';

export default class FlujoAnfitrion extends LightningElement {
    
    welcomeScreen = true;
    newClient = false;
    oldClient = false;
    disabledNext = true;
    leadRedirect = false;
    disabledEdition = false;
    editOpp = false;
    loaded = false;
    leadId = '';
    columns =  [
        {label: 'Nombre de la oportunidad', fieldName: 'nombreOpp', type: 'text', hideDefaultActions: true},
        {label: 'Marca', fieldName: 'marca', type: 'text', hideDefaultActions: true},
        {label: 'Codigo de cliente', fieldName: 'codigoCliente', type: 'text', hideDefaultActions: true},
        {label: 'Vendedor', fieldName: 'vendedor', type: 'text', hideDefaultActions: true},
        {label: 'Fecha de creacion', fieldName: 'fechaCreacion', type: 'date', hideDefaultActions: true}
    ];
    selectedOpp;
    @track opportunitiesList;
    searchValue = '';
    marcasOptions = [];
    modelosMap = {};
    modelosOptions = [];
    sucursalesOptions = [];
    userMap = {};
    userOptions = [];
    searchValue = '';

    connectedCallback() {
        getModelosByMarca({
        })
        .then(result => {
            var marcaList = [];

            for(var marca in result) {
                marcaList.push(marca);
            }

            this.marcasOptions = marcaList;
            this.modelosMap = result;
        })
        .catch(error => {
            this.showNotification('Error', 'error', error.body.message);
            this.opportunitiesList = null;
        });

        getUserBySucursal({
        })
        .then(result => {
            var sucuralesList = [];

            for(var sucursal in result) {
                sucuralesList.push(sucursal);
            }

            this.sucursalesOptions = sucuralesList;
            this.userMap = result;
        })
        .catch(error => {
            this.showNotification('Error', 'error', error.body.message);
            this.opportunitiesList = null;
        });
    }

    handleclick(event) {
        if (event.target.name == 'Cliente nuevo' || event.target.name == 'Ninguna oportunidad aplica') {
            this.welcomeScreen = false;
            this.newClient = true;
            this.oldClient = false;
            this.leadRedirect = false;
            this.editOpp = false;
        } else if (event.target.name == 'Inicio') {
            this.welcomeScreen = true;
            this.newClient = false;
            this.oldClient = false;
            this.editOpp = false;
            this.leadRedirect = false;
        } else if (event.target.name == 'Ir al Lead') {
            var urlToRedirect = window.location.origin;
            window.location.replace(urlToRedirect + '/lightning/r/' + this.leadId + '/view');
        } else {
            this.welcomeScreen = false;
            this.newClient = false;
            this.oldClient = true;
        }
    }

    searchKeyword(event) {
        this.searchValue = event.target.value;
    }

    handleSearchKeyword() {
        if (this.searchValue !== '') {
            this.loaded = true;

            getOpportunities({
                    searchKey: this.searchValue
                })
                .then(result => {
                    var list = [];

                    for (var i = 0; i < result.length; i++) {
                        var aux = {};
                        var data = result[i];

                        aux['id'] = data.Id;
                        aux['nombreOpp'] = data.Name;
                        aux['fechaCreacion'] = data.CreatedDate;
                        aux['vendedor'] = data.Owner.Name;
                        aux['codigoCliente'] = data.Account.CodigoCliente__c;

                        if (data.Marca_UDC__c != null) {
                            aux['marca'] = data.Marca_UDC__r.Name;
                        }

                        list.push(aux);
                    } 

                    if (list.length == 0) {
                        this.showNotification('Error', 'error', 'No se ha encontrado ninguna oportunidad');
                    }

                    this.opportunitiesList = list;
                    this.loaded = false;
                })
                .catch(error => {
                    this.showNotification('Error', 'error', error.body.message);
                    console.log(error);
                    this.loaded = false;
                    this.opportunitiesList = null;
                });
        } else {
            this.showNotification('Error', 'error', 'Por favor, ingrese un valor...');
        }
    }

    selectRow(event){
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length == 1) {
            this.disabledNext = false;
        } else {
            this.disabledNext = true;
        }
    }

    editOpportunity(event){
        const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        this.selectedOpp = selectedRows[0].id;

        this.oldClient = false;
        this.editOpp = true;
        this.loaded = true;
    }

    handleSuccess(event){
        crearTareaDeAnfitrion({
            userId: userId,
            oppId: this.selectedOpp,
        })
        .then(result => {
            console.log(result);

            if (result != 'Ok') {
                this.showNotification('Error', 'error', result);
                this.loaded = false;
            } else {
                this.showNotification('Éxito', 'success', 'La actualización se ha realizado con éxito.');
                this.welcomeScreen = true;
                this.loaded = false;
                this.disabledEdition = false;
                this.editOpp = false;
                this.searchValue = '';
                this.disabledNext = true;
                this.opportunitiesList = [];
            }
        })
        .catch(error => {
            this.loaded = false;
            this.disabledEdition = false;
            this.showNotification('Error', 'error', error.body.message);
            this.opportunitiesList = null;
        });
    }

    errorHandler(event){
        this.loaded = false;
        this.disabledEdition = false;
        this.showNotification('Error', 'error', event.detail.detail);
    }

    showNotification(title, variant, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    createLead(event) {
        event.preventDefault()

        this.newClient = false;
        this.loaded = true;

        var mapa = {};

        this.template.querySelectorAll('input').forEach(element => {
            mapa[element.id.split('-')[0]] = element.value;
        });

        this.template.querySelectorAll('select').forEach(element => {
            mapa[element.id.split('-')[0]] = element.value;
        });

        if (mapa['apellidos'].length == 0 || 
                mapa['vendedor'].length == 0 || 
                    mapa['telefono'].length == 0 || 
                        mapa['modelo'].length == 0) {
            this.showNotification('Error', 'error', 'Todos los campos requeridos deben estar completos.');
            this.loaded = false;
            this.newClient = true;
        } else {
            createLeadAnfitrion({
                firstName : mapa['nombre'],
                middleName : mapa['segundoNombre'],
                lastName : mapa['apellidos'],
                email : mapa['correoElectronico'],
                phone : mapa['telefono'],
                identification : mapa['cedula'],
                marca : mapa['marca'],
                modelo : mapa['modelo'],
                owner : mapa['vendedor']
            })
            .then(result => {
                this.showNotification('Éxito', 'success', 'El lead se ha creado con éxito.');
                this.leadRedirect = true;
                this.loaded = false;
                this.leadId = result;
            })
            .catch(error => {
                var message = error.body.message;
    
                var showMessage = '';
                if (message.includes('OwnerId')) {
                    showMessage = 'El campo Vendedor es requerido.';
                } else if (message.includes('LastName') || message.includes('Apellidos')) {
                    showMessage = 'El campo Apellidos es requerido.';
                } else {
                    showMessage = message;
                }
    
                this.showNotification('Error', 'error', showMessage);
                this.loaded = false;
                this.newClient = true;
                this.modelosOptions = null;
                this.userOptions = null;
            });
        }

    }

    loadManager(event) {
        var resultJSON = JSON.stringify(event.detail.records);

        if( resultJSON.includes('Fecha_de_visita__c') &&
            resultJSON.includes('Tipo_de_visita__c') &&
            resultJSON.includes('Comentario_Anfitri_n__c')
        ) {
            this.loaded = false;

            this.template.querySelectorAll('lightning-input-field').forEach(element => {
                if (element.fieldName.includes('Fecha_de_visita__c')) {
                    var today = new Date();
                    element.value = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
                } else if (element.fieldName.includes('Comentario_Anfitri_n__c') || element.fieldName.includes('Tipo_de_visita__c')) {
                    element.value = null;
                }
            });
        }
    }

    changeSucursal(event) {
        var sucursal = '';

        this.template.querySelectorAll('select').forEach(element => {
            if(element.id.split('-')[0] == 'sucursal') {
                sucursal = element.value;
            } 
        });

        if (sucursal.length > 0) {
            this.userOptions = this.userMap[sucursal];
        } else {
            this.userOptions = null;
        }

    }

    changeMarca(event) {
        var marca = '';

        this.template.querySelectorAll('select').forEach(element => {
            if(element.id.split('-')[0] == 'marca') {
                marca = element.value;
            } 
        });

        if (marca.length > 0) {
            this.modelosOptions = this.modelosMap[marca];
        } else {
            this.modelosOptions = null;
        }

    }

    actualizarRegistro(event){
        this.disabledEdition = true;
        this.loaded = true;
    }
}