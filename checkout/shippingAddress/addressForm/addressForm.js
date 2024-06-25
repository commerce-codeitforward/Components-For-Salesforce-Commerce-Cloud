import { api, LightningElement, wire } from 'lwc';

export default class AddressForm extends LightningElement {
    @api address = {};
    @api required = false;
    @api inputDisabled = false; 
    @api hideDefaultCheckbox = false;

    // Passed in from parent and used to control Country dropdown.
    // Format is [{value: 'value', label: 'label'}]
    @api countryOptions = [];

    // Passed in from parent and used to control State/Province dropdown
    // Format is [{country: {value: 'value', label: 'label'}}]
    @api allRegionOptions = [];

    // Current set of region options
    regionOptions = [];
    workingAddress = {};

    connectedCallback() {
        this.workingAddress = JSON.parse(JSON.stringify(this.address));
    }

    renderedCallback() {
        this.regionOptions = this.allRegionOptions[this.workingAddress['country']];
        if (this.address.isDefault) this.refs.defaultAddressCheckbox.checked = true;
    }

    /**
     * 
     * Builds standard name value
     * 
     */
    getName(first, last){
        const firstName = first ? first : '';
        const lastName = last ? last : '';
        return firstName+' '+lastName;
    }

    /**
     * 
     * Save current state of the country picklist
     * 
     */
    handleCountryChange(event) {
        // If the country changed reset the regionOptions
        if (this.workingAddress.country !== event.target.value) {
            this.regionOptions = event.target.value ? this.allRegionOptions[event.target.value] : null;
        }
        this.workingAddress.country = event.target.value;
        this.sendCommitIfValid();
    }

    /**
     * 
     * Save current state of the street as entered
     * 
     */
    handleStreetChange(event) {
        this.workingAddress.street = event.target.value;
    }

    /**
     * 
     * Save current state of the State/Province dropdown
     * 
     */
    handleRegionChange(event) {
        this.workingAddress.region = event.target.value;
        this.sendCommitIfValid();
    }

    handleCommit(event) {
        switch (event.target) {
            case this.refs.firstName: 
                this.workingAddress.firstName = event.target.value.trim();
                this.workingAddress.name = this.getName(this.workingAddress['firstName'], this.workingAddress['lastName']);
                this.sendCommitIfValid();
                break;
            case this.refs.lastName: 
                this.workingAddress.lastName = event.target.value.trim();
                this.workingAddress.name = this.getName(this.workingAddress['firstName'], this.workingAddress['lastName']);
                this.sendCommitIfValid();
                break;
            case this.refs.city: 
                this.workingAddress.city = event.target.value.trim();
                this.sendCommitIfValid();
                break;
            case this.refs.postalCode: 
                this.workingAddress.postalCode = event.target.value.trim();
                this.sendCommitIfValid();
                break;
        }
    }

    handleOnFocusOut(event) {
        switch (event.currentTarget) { 
            case this.refs.street:
                this.sendCommitIfValid();
        }
    }

    /**
     * 
     * Handles when checkbox indicating the default address is checked
     * 
     */
    handleDefaultClick(event) {
        this.workingAddress.isDefault = this.refs.defaultAddressCheckbox.checked;
        this.sendCommitIfValid();
    }

    sendCommitIfValid() {
        if (this.isValidAddress()) this.dispatchEvent(new CustomEvent("addresscommit"));
    }

    /**
     * 
     * Allows parent to get a copy of the current address information
     * 
     */
    @api
    getAddress() {
        return JSON.parse(JSON.stringify(this.workingAddress));
    }

    /**
     * 
     * Determines if the current state of the address information is valid
     * 
     */
    @api
    isValidAddress() {
        const isValid = Boolean( 
            this.workingAddress['firstName'] && 
            this.workingAddress['lastName'] &&
            this.workingAddress['country'] &&
            this.workingAddress['street'] &&
            this.workingAddress['city'] &&
            this.workingAddress['region'] &&
            this.workingAddress['postalCode'] );
        return isValid
    }

    @api
    setAllRegionCodes(regionData) {
    }
}