import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import consultarInventario from '@salesforce/apex/ConsultarInventarioController.consultarInventario';

export default class ConsultarInventarioButton extends LightningElement {
    @api recordId;

    consultarInventarioWS() {
        consultarInventario({
            oppId: this.recordId
        })
        .then(result => {
            console.log(result);
            if (result.includes('Ok.')) {
                this.showNotification('Oportunidad valida', 'success', result.replace('Ok. ', ''));
            } else {
                this.showNotification('Error', 'error', result);
            }
        })
        .catch(error => {
            this.showNotification('Error', 'error', error.body.message);
        });
    }   

    showNotification(title, variant, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}