import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalCheckoutAddressForm extends LightningModal {
    @api address = {};
    @api title = 'Enter Address';
    @api disabled = false;
    @api required = false;
    saveDisabled = false;
    addressForm = null;

    // Passed in from parent and used to control Country dropdown.
    // Format is [{value: 'value', label: 'label'}]
    @api countryOptions = [];

    // Passed in from parent and used to control State/Province dropdown
    // Format is [{country: {value: 'value', label: 'label'}}]
    @api allRegionOptions = [];

    /**
     * 
     * connectedCallback functionality
     * 
     */
    connectedCallback() {
        this.address = JSON.parse(JSON.stringify(this.address));
    }

    /**
     * 
     * renderedCallback functionality
     * 
     */
    renderedCallback() {
        this.addressForm = this.template.querySelector("c-address-form");
        this.saveDisabled = !this.addressForm.isValidAddress();
    }

    /**
     * 
     * Handles whenever an addressForm field loses focus
     * 
     */
    handleAddressOnFocusOutEvent(event){
        this.saveDisabled = !this.addressForm.isValidAddress();
    }

    /**
     * 
     * Handles when cancel button is clicked. returns that the address was not changed
     * and the values for the address as time of cancel
     * 
     */
    handleCancelClick () {
        this.close({changed: false, address: this.address});
    }

    /**
     * 
     * Handles when save button is clicked. returns that the address was not changed
     * and the values for the address as time of cancel
     * 
     */
    handleSaveClick () {
        this.close({changed: true, address: this.addressForm.getAddress()});
    }
}