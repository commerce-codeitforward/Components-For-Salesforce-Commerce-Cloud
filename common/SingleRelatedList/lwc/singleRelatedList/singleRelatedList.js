import { LightningElement, api, track, wire } from 'lwc';
import getFieldSetFields from '@salesforce/apex/SingleRelatedListController.getFieldSetFields';
import getRecordValues from '@salesforce/apex/SingleRelatedListController.getRecordValues';

export default class SingleRelatedList extends LightningElement {
    
    @api errors;
        
    @track relatedListObjectName;
    @track relatedListParentField;
    @track fieldSetName;
    @track filterField;
    @track filterValue;
    @track hideCheckBoxColumn;
    @track columnWidthsMode;
    @track resizeColumnDisabled;
    @track hideTableHeader;
    @track keyField = 'Id';
    @track columns;
    @track records;
    @track isPreview = false;
    @track hasRecords = false;
    @track titleValue;
    @track showTitle = false;
    

    _layoutProperties;
    _productId;
    layoutPropsSet = false;

    @api 
    set recordId(value) {
        this._productId = value;
        this.getFieldMembers();
        this.getRecords();
    }
    get recordId() {
        return this._productId;
    }

    @api
    set layoutProperties(value) {
        if (value) {
            debugger;
            this._layoutProperties = JSON.parse(value);
            this.relatedListObjectName = this._layoutProperties.relatedListObjectName;
            this.relatedListParentField = this._layoutProperties.relatedListParentField;
            this.fieldSetName = this._layoutProperties.fieldSetName;
            this.filterField = this._layoutProperties.filterField;
            this.filterValue = this._layoutProperties.filterValue;
            this.hideCheckBoxColumn = this._layoutProperties.hideCheckBoxColumn;
            this.columnWidthsMode = this._layoutProperties.columnWidthsMode;
            this.resizeColumnDisabled = this._layoutProperties.resizeColumnDisabled;
            this.hideTableHeader = this._layoutProperties.hideTableHeader;
            this.keyField = this._layoutProperties.keyField;
            this.titleValue = this._layoutProperties.titleValue;
            this.showTitle = this._layoutProperties.showTitle;
            this.layoutPropsSet = true;
        }
    }

    get layoutProperties() {
        return this._layoutProperties;
    }

    connectedCallback() {
        // debugger;
        this.getFieldMembers();
        this.getRecords();
    };

    async getFieldMembers() {
        // debugger;
        try {
            if(this.isInSitePreview()){
                this.columns = [
                    { label: 'Name', fieldName: 'Name', type: 'text' },
                    { label: 'Description', fieldName: 'Description', type: 'text' },
                ]
            }
            else if( this.layoutPropsSet) {
            let result = await getFieldSetFields({ 
                objectName: this.relatedListObjectName,
                fieldSetName: this.fieldSetName });
            this.columns = result.fieldList;
            this.errors = undefined;
            console.log('_productId: '+this._productId);
                }
        } catch (e) {
            console.error(e);
            this.errors = e;
            this.columns = undefined;
        }
    }

    async getRecords()
    {
        // debugger;
        try {
            if(this.isInSitePreview()){
                this.records = [
                    { Id: 1, Name: 'Name1', Description: 'Description1' },
                    { Id: 2, Name: 'Name2', Description: 'Description2' }
                ];
                this.hasRecords = true;
            }
            else if(!this.isInSitePreview() && this._productId != null && this._productId != '' && this.layoutPropsSet) {
                let result = await getRecordValues({ 
                    objectName: this.relatedListObjectName,
                    fieldSetName: this.fieldSetName,
                    parentField: this.relatedListParentField,
                    recordId: this._productId,
                    keyField: this.keyField,
                    filterField: this.filterField,
                    filterValue: this.filterValue });
                this.records = result;
                this.errors = undefined;
                if(this.records.length >0){
                    this.hasRecords = true;
                } else {
                    this.hasRecords = false;
                }
            }
        } catch {
            console.error(e);
            this.errors = e;
        }
    }

    /**
     * Determines if you are in the experience builder currently
     */
    isInSitePreview() {
        let url = document.URL;
        return (
        url.indexOf('sitepreview') > 0 ||
        url.indexOf('livepreview') > 0 ||
        url.indexOf('live-preview') > 0 ||
        url.indexOf('live.') > 0 ||
        url.indexOf('.builder.') > 0
        );
    }
}
