import { api, LightningElement, wire } from 'lwc';
import ToastContainer from 'lightning/toastContainer';
import Toast from 'lightning/toast';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import { AppContextAdapter, SessionContextAdapter } from 'commerce/contextApi';
import { effectiveAccount, ManagedAccountsAdapter } from 'commerce/effectiveAccountApi';
import currency from '@salesforce/i18n/currency';
import USER_OBJECT from '@salesforce/schema/User';
import WEB_CART_OBJECT from '@salesforce/schema/WebCart';
import userId from '@salesforce/user/Id';
import getAccountData from '@salesforce/apex/AccountManagement.getAccountData';
import getConstants from '@salesforce/apex/AccountManagement.getConstants';
import isDelegatedExternalUserAdmin from '@salesforce/apex/AccountManagement.isDelegatedExternalUserAdmin';
import {
    addUser,
    errorDefault
} from './labels';
import {
    mockedAccountId,
    mockedWebStoreId,
    mockedCartData,
    mockedUserData
} from './mockData';

const DEFAULT_TAB_VALUE = 'acct-mngt-users';
const DEFAULT_CURRENCY_CODE = currency;

/**
 * Get the default user account
 */
const getUserDefaultAccount = (managedAccounts) => managedAccounts.find((managedAccount) => managedAccount.isCurrentUserDefaultAccount)?.id;

/**
 *  Update the column labels based on the object info
 * @param objectInfo
 * @param columns
 */
const updateColumns = (objectInfo, columns) => {
    columns.forEach((entry) => {
        entry.label = objectInfo?.fields?.[entry.fieldName]?.label || entry.label;
    });
};

export default class AccountManagement extends LightningElement {
    @api showMembersTab;
    @api showCartsTab;
    @api membersTabLabel;
    @api cartsTabLabel;
    @api permissionSetNames;

    isModalOpen = false;
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }

    handleUserCancel() {
        this.isModalOpen = false;
    }

    label = {
        addUser
    };

    /**
     * stores current web store id
     */
    _webStoreId;

    /**
     * stores current effective id
     */
    _effectiveAccountId;

    /**
     * stores user data
     */
    userId = userId;
    isDelegatedExternalAdmin = false;

    /**
     * stores the active tab
     */
    usersTab;
    cartsTab;
    activeTab;

    /**
     * show or hide the spinner / loader
     */
    isLoading = true;

    /**
     * used for displaying error message
     */
    errorMessage;

    /**
     * build columns for the datatable
     */
    userColumns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Email', fieldName: 'Email'},
        {label: 'Title', fieldName: 'Title'},
        {label: 'Active', fieldName: 'IsActive', type: 'boolean'}
    ];
    cartColumns = [
        {label: 'Name', fieldName: 'Name'},
        {label: 'Owner Name', fieldName: 'Owner.Name'},
        {label: 'Total Product Amount in Cart', fieldName: 'TotalProductAmount'}
    ];

    /**
     * update the field labels for the datatable based on the labels from the objects
     * @param data
     */
    @wire(getObjectInfos, { objectApiNames: [USER_OBJECT, WEB_CART_OBJECT] })
    buildDataColumns({ data }) {
        data?.results.forEach(result => {
            if (result.statusCode !== 200) { this.errorMessage = `Error fetching object info: ${result.errorCode} - ${result.message}`; }
            const objectInfo = result.result;
            if (objectInfo.apiName === USER_OBJECT.objectApiName) { updateColumns(objectInfo, this.userColumns); }
            else if (objectInfo.apiName === WEB_CART_OBJECT.objectApiName) { updateColumns(objectInfo, this.cartColumns); }
        });
    }

    /**
     * get the delegated external admin status
     */
    @wire(isDelegatedExternalUserAdmin, { userId: '$userId' })
    wiredPermission({ error, data }) {
        if (data) { this.isDelegatedExternalAdmin = data; }
        if (error) { this.errorMessage = this.handleError(error); }
    }

    /**
     * get the web store id from the AppContextAdapter
     */
    @wire(AppContextAdapter)
    wireAppContext({ error, data, loading }) {
        this.isLoading = loading;
        if (this.isPreview) {
            this._webStoreId = mockedWebStoreId;
        } else {
            if (data) { this.updateWebStoreId(data.webstoreId); }
            if (error) { this.errorMessage = this.handleError(error); }
        }
    }

    @wire(SessionContextAdapter)
    wireSessionContext({ data }) {
        if (data) { this.isPreview = data.isPreview; }
    }

    /**
     * get the constants from the Apex class
     */
    @wire(getConstants)
    handleConstants ({data}) {
        if (data) {
            this.assignConstants(data);
        }
    }

    assignConstants(data) {
        this.usersTab = data.ACCT_MNGT_USERS_TAB;
        this.cartsTab = data.ACCT_MNGT_CARTS_TAB;
    }

    /**
     * use ManagedAccountsAdapter to get the effective account id
     * @param error
     * @param data
     * @param loading
     */
    @wire(ManagedAccountsAdapter, { includeMyAccount: true  })
    handleManagedAccounts({ error, data = [], loading }) {
        this.isLoading = loading;
        if (this.isPreview) {
            this._effectiveAccountId = mockedAccountId;
        } else {
            if (data) { this.updateEffectiveAccountId(effectiveAccount.accountId || getUserDefaultAccount(data) || ''); }
            if (error) { this.errorMessage = this.handleError(error); }
        }
    }

    /**
     * call Apex class to fetch user data based on the effective account id
     * @param data
     * @param loading
     */
    async processAccountData() {
        try {
            this.isLoading = true;

            const isCartsTabActive = (this.activeTab === this.cartsTab);
            let data;

            // exit early if there is no effective account id or web store id
            if (!this._effectiveAccountId || !this._webStoreId) {
                return;
            }

            if (this.isPreview) {
                data = isCartsTabActive ? mockedCartData : mockedUserData;
            } else {
                data = await getAccountData({
                    accountId: this._effectiveAccountId,
                    webStoreId: this._webStoreId,
                    activeTab: this.activeTab
                });
            }

            this[isCartsTabActive ? 'cartData' : 'userData'] = this.mapDataToColumns(data, isCartsTabActive);
            this.isLoading = false;
        } catch (error) {
            this.errorMessage = this.handleError(error);
            this.isLoading = false;
        }
    }

    handleUserCreationResponse(event) {
        const toastDetails = event.detail;
        Toast.show({
            label: toastDetails.label,
            message: toastDetails.message,
            mode: toastDetails.mode,
            variant: toastDetails.variant
        }, this);

        if (toastDetails.variant === 'success') {
            this.closeModal();
            this.processAccountData();
        }
    }

    /**
     * The connectedCallback() lifecycle hook fires when a component is inserted into the DOM.
     */
    async connectedCallback() {
        await this.processAccountData();

        // set up toast container
        const toastContainer = ToastContainer.instance();
        toastContainer.maxToasts = 3;
        toastContainer.toastPosition = 'top-center';
    }

    mapDataToColumns(data, mapCartData = false) {
        return data.map(item => (mapCartData ? this.mapCartDataToColumns(item) : this.mapUserDataToColumns(item)));
    }

    mapUserDataToColumns(user) {
        return { Name: user?.Name, Email: user?.Email, Title: user?.Title, IsActive: user?.IsActive };
    }

    mapCartDataToColumns(cart) {
        const currencyFormatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: cart?.CurrencyIsoCode || DEFAULT_CURRENCY_CODE
        });
        const totalProductAmount = cart?.TotalProductAmount || 0;
        return { Name: cart?.Name || '', 'Owner.Name': cart?.Owner?.Name || '', TotalProductAmount: currencyFormatter.format(totalProductAmount) };
    }

    handleError(err) {
        let errorMessage = errorDefault;
        if (Array.isArray(err?.body)) {
            err.body.forEach(error => { errorMessage += error.message + ' '; });
        } else if (typeof err?.body?.message === 'string') { errorMessage = err.body.message; }
        return errorMessage;
    }

    handleTabClick(event) {
        this.isLoading = true;
        this.activeTab = event?.target?.value || this.usersTab || DEFAULT_TAB_VALUE;
        this.processAccountData();
    }

    @api get effectiveAccountId() {
        return this._effectiveAccountId;
    }
    updateEffectiveAccountId(value) {
        this._effectiveAccountId = value;
        this.processAccountData();
    }

    @api get webStoreId() {
        return this._webStoreId;
    }
    updateWebStoreId(value) {
        this._webStoreId = value;
        this.processAccountData();
    }

    get hasEffectiveAccountId() { return !!this._effectiveAccountId; }
    get hasError() { return !!this.errorMessage; }
    get getErrorMessage() { return this.errorMessage || errorDefault; }
}