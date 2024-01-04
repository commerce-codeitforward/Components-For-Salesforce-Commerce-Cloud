import { LightningElement, api, wire } from 'lwc';
import communityId from '@salesforce/community/Id';
import userId from '@salesforce/user/Id';
import currency from '@salesforce/i18n/currency';
import lang from '@salesforce/i18n/lang';
import locale from '@salesforce/i18n/locale';
import timeZone from '@salesforce/i18n/timeZone';
import createContactUser from '@salesforce/apex/AccountManagement.createContactUser';
import getAccountContacts from '@salesforce/apex/AccountManagement.getAccountContacts';
import getDynamicPicklistOptions from '@salesforce/apex/AccountManagement.getDynamicPicklistOptions';
import getMultiCurrencyEnabled from '@salesforce/apex/AccountManagement.getMultiCurrencyEnabled';
import getSelectedProfilesForCommunity from '@salesforce/apex/AccountManagement.getSelectedProfilesForCommunity';
import {
    addUser,
    buyerCreationErrorLabel,
    buyerCreationErrorMessage,
    buyerCreationSuccessLabel,
    buyerCreationSuccessMessage,
    requiredFieldsLabel,
    requiredFieldsMessage
} from './labels';

export default class AddCommunityUser extends LightningElement {
    @api accountId;
    @api permissionSetNames;
    communityId = communityId;
    contactDetails = {};
    contactOptions = [];
    currencyOptions = [];
    defaultCurrency = currency;
    defaultEmailEncoding = 'UTF-8';
    defaultLanguage = lang ? lang.replace('-', '_') : 'en_US';
    defaultLocale = locale ? locale.replace('-', '_') : 'en_US';
    defaultTimeZone = timeZone;
    emailEncodingOptions = [];
    isMultiCurrencyEnabled = false;
    languageOptions = [];
    localeOptions = [];
    profileOptions = [];
    timezoneOptions = [];
    user = {};
    userId = userId;

    label = {
        addUser
    };

    @wire(getMultiCurrencyEnabled)
    wiredMultiCurrencyEnabled({ data }) {
        if (data) { this.isMultiCurrencyEnabled = data; }
    }

    /**
     * gather the timezones for the user to select from
     */
    @wire(getDynamicPicklistOptions, { objectName: 'User', fieldName: 'TimeZoneSidKey' })
    wiredTimezoneOptions({ data }) {
        if (data) { this.timezoneOptions = JSON.parse(data); }
    }

    /**
     * gather the locales for the user to select from
     */
    @wire(getDynamicPicklistOptions, { objectName: 'User', fieldName: 'LocaleSidKey' })
    wiredLocaleOptions({ data }) {
        if (data) { this.localeOptions = JSON.parse(data); }
    }

    /**
     * gather the languages for the user to select from
     */
    @wire(getDynamicPicklistOptions, { objectName: 'User', fieldName: 'LanguageLocaleKey' })
    wiredLanguageOptions({ data }) {
        if (data) { this.languageOptions = JSON.parse(data); }
    }

    /**
     * gather the email encodings for the user to select from
     */
    @wire(getDynamicPicklistOptions, { objectName: 'User', fieldName: 'EmailEncodingKey' })
    wiredEmailEncodingOptions({ data }) {
        if (data) { this.emailEncodingOptions = JSON.parse(data); }
    }

    /**
     * gather the currencies for the user to select from
     */
    @wire(getDynamicPicklistOptions, { objectName: 'User', fieldName: 'DefaultCurrencyIsoCode' })
    wiredCurrencyOptions({ data }) {
        if (data) { this.currencyOptions = JSON.parse(data); }
    }

    /**
     * get selected profiles for the community
     */
    @wire(getSelectedProfilesForCommunity, { communityId: '$communityId' })
    wiredSelectedProfiles({ data }) {
        if (data) { this.profileOptions = data.map(profile => ({ label: profile.Name, value: profile.Id })) }
    }

    /**
     * gather the contacts for the user to select from
     */
    async getContactOptions() {
        try {
            if (!this.accountId) return;
            const data = await getAccountContacts({ accountId: this.accountId });
            if (data) {
                this.contactOptions = data.map(contact => ({ label: contact.Name, value: contact.Id }));
                this.contactDetails = data.reduce((acc, contact) => {
                    acc[contact.Id] = contact;
                    return acc;
                }, {});
            }
        } catch (error) {
            console.error(`error in getContactOptions: ${error}`);
        }
    }

    async connectedCallback() {
        await this.getContactOptions();
    }

    handleContactChange(event) {
        const selectedContactId = event.detail.value;
        const selectedContact = this.contactDetails[selectedContactId];
        if (selectedContact) {
            if (selectedContact.FirstName) {
                this.template.querySelector('lightning-input[data-fieldid=FirstName]').value = selectedContact.FirstName;
            }
            if (selectedContact.LastName) {
                this.template.querySelector('lightning-input[data-fieldid=LastName]').value = selectedContact.LastName;
                this.template.querySelector('lightning-input[data-fieldid=Alias]').value = selectedContact.LastName.substring(0, 5).toLowerCase(); // Alias has max of 5 characters
            }
            if (selectedContact.Email) {
                this.template.querySelector('lightning-input[data-fieldid=Email]').value = selectedContact.Email;
                this.template.querySelector('lightning-input[data-fieldid=Username]').value = selectedContact.Email;
            }
            const nickname = selectedContact.Email ? selectedContact.Email.substring(0, selectedContact.Email.indexOf('@')) : selectedContact.LastName || '';
            if (nickname) {
                this.template.querySelector('lightning-input[data-fieldid=CommunityNickname]').value = nickname;
            }
        }
    }

    /**
     * Validate all form fields.
     * Check all field fields with the "validate" class and if they're
     * not valid, then report the validity and return false. Otherwise,
     * return true.
     */
    validateFormFields() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            this.user[inputField.dataset.fieldid] = inputField.value;
        });
        return isValid;
    }

    handleUserCancel() {
        this.dispatchEvent(new CustomEvent('cancelusercreation'));
    }

    async handleUserCreation() {
        const resultDetails = {
            label: buyerCreationErrorLabel,
            message: buyerCreationErrorMessage,
            mode: 'dismissible',
            variant: 'error'
        };
        try {
            if (!this.validateFormFields()) {
                resultDetails.label = requiredFieldsLabel;
                resultDetails.message = requiredFieldsMessage;
            } else {
                const result = await createContactUser({
                    userMap: this.user,
                    accountId: this.accountId,
                    userId: this.userId,
                    permissionSetNames: this.permissionSetNames ? this.permissionSetNames.split(',') : null
                });
                if (result.success && result.userId && result.contactId) {
                    resultDetails.label = buyerCreationSuccessLabel;
                    resultDetails.message = buyerCreationSuccessMessage;
                    resultDetails.variant = 'success';

                    // remove the contact from the list of available contacts
                    this.contactOptions = this.contactOptions.filter(contact => contact.value !== result.contactId);
                }
            }
        } catch (error) {
            resultDetails.message = error?.body?.message || error?.message || resultDetails.message;
        } finally {
            this.dispatchEvent(new CustomEvent('usercreationresponse', { detail: resultDetails }));
        }
    }

    get getMultiCurrencyLayoutItemSize() {
        return this.isMultiCurrencyEnabled ? '6' : '12';
    }
}