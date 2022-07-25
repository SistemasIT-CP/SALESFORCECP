import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import savePdf from '@salesforce/apex/GenerarCotizacionVaciaController.savePdf';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

export default class GenerarCotizacionVaciaAutolote extends LightningElement {
    @api recordId;
    showModal = false;
    maxYear;

    @wire(getRecord, { recordId: '$recordId', fields: ['Opportunity.Account.Name'] })
    account;

    get accountName() {
        return getFieldValue(this.account.data, 'Opportunity.Account.Name');
    }

    connectedCallback(){
        this.maxYear = new Date().getFullYear();
    }

    openModal(){
        this.showModal = true;
    }

    closeModal(){
        this.showModal = false;
    }

    generarCotizacion(){
        var inputs = this.template.querySelectorAll("input");
        var textAreas = this.template.querySelectorAll("textarea");
        var requiredMissing = false;
        var argumentos = 'id=' + this.recordId;

        inputs.forEach(function(elem) {
            let id = elem.id.split('-')[0];
            let value = elem.type === 'checkbox'? elem.checked : elem.value;

            if (elem.required && value == '') {
                requiredMissing = true;
            }

            argumentos += ';' + id + '=' + value;
        });

        textAreas.forEach(function(elem) {
            let id = elem.id.split('-')[0];
            argumentos += ';' + id + '=' + elem.value;
        });

        if (requiredMissing) {
            console.log('nope');
        } else {
            savePdf({argumentos: argumentos})
                .then((result)=>{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Exito',
                            message: 'Se ha generado el pdf correctamente',
                            variant: 'success',
                        }),
                    );

                    var url = '/servlet/servlet.FileDownload?file=' + result;
                    window.open(url, '_self');
                })
                .catch(error=>{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creando PDF',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });

            this.closeModal()
        }
    }
}