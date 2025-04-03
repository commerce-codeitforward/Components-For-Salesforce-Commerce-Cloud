import { LightningElement, api, track } from 'lwc';
import getObjectList from '@salesforce/apex/SingleRelatedListCPEController.getObjectList';
import getRelatedObjects from '@salesforce/apex/SingleRelatedListCPEController.getRelatedObjects';
import getFieldSets from '@salesforce/apex/SingleRelatedListCPEController.getFieldSets';
import getObjectFields from '@salesforce/apex/SingleRelatedListCPEController.getObjectFields';

export default class SingleRelatedListControllerCPE extends LightningElement {

    configProps = {
        parentObject: "",
        relatedListObjectName : "",
        relatedListParentField : "",
        fieldSetName : "",
        filterField : "",
        filterValue : "",
        hideCheckBoxColumn : true,
        columnWidthsMode : "auto",
        resizeColumnDisabled : true,
        hideTableHeader : false,
        keyField : "Id",
        titleValue : "",
        showTitle : true
    };
    
    @track objectList;
    @track relatedObjectList;
    @track fieldSetList;
    @track fieldList;
    
    @api label;
    @api schema; // the JSON Schema derived from the accompanying property type.
    @api errors; 

    columnWidthsModeOptions = [
        { label: 'fixed', value: 'fixed' },
        { label: 'auto', value: 'auto' }];
    

    @api 
    set value(value) {
        debugger;
        if(value){
            this.configProps = JSON.parse(value);
            this.retrieveAllData();
        }
    }
    get value() {
        return JSON.stringify(this.configProps);
    }

    connectedCallback() {
        debugger;
        this.retrieveAllData();
    }

    retrieveAllData() {
        this.getParentObjects();
        this.getRelatedObjects();
        this.getFieldSets();
        this.getObjectFields();
    }

    async getParentObjects() {
        debugger;
        await getObjectList()
            .then(result => {
                this.objectList = result;
            })
            .catch(error => {
                this.errors = error;
            });
        }

    async getRelatedObjects() {
        debugger;
        if(this.configProps.parentObject != null && this.configProps.parentObject != ''){
            await getRelatedObjects({ objectName: this.configProps.parentObject })
                .then(result => {
                    this.relatedObjectList = result;
                }) 
                .catch(error => {
                    this.errors = error;
                });
            }
    }

    async getFieldSets(){ 
        debugger;
        if(this.configProps.relatedListObjectName != null && this.configProps.relatedListObjectName != ''){
            await getFieldSets({ objectName: this.configProps.relatedListObjectName })
                .then(result => {
                    this.fieldSetList = result;
                    })
                .catch(error => {
                    this.errors = error;
                });
            }
    }

    async getObjectFields(){
        debugger; 
        if(this.configProps.relatedListObjectName != null && this.configProps.relatedListObjectName != ''){
            await getObjectFields({ objectName: this.configProps.relatedListObjectName })
                .then(result => {
                    this.fieldList = result;
                })
                .catch(error => {
                    this.errors = error;
                });
            }
    }
    
    handleParentObjectChange(event) {
        debugger;
        this.configProps.parentObject = event.detail.value;
        this.getRelatedObjects();
        this.notifyConfigChange();
    }
   
    
    handleRelatedObjectChange(event) {
        debugger;
        this.configProps.relatedListObjectName = event.detail.value;
        this.getFieldSets();
        this.getRelatedObjectFields();
        this.notifyConfigChange();
    }

    handleFieldSetChange(event) {
        debugger;
        this.configProps.fieldSetName = event.detail.value;
        this.notifyConfigChange();
    }

    handleLookupFieldChange(event) {
        debugger;
        this.configProps.relatedListParentField = event.detail.value;
        this.notifyConfigChange();
    }

    handleFilterFieldChange(event) {
        this.configProps.filterField = event.detail.value;
        this.notifyConfigChange();
    }

    handleFilterValueChange(event) {
        this.configProps.filterValue = event.detail.value;
    }
    
    handleFilterValueBlur(event) {
        debugger;
        if(this.configProps.filterField != null 
            && this.configProps.filterField != '' 
            && this.configProps.filterField != undefined 
            && this.configProps.filterValue != null
            && this.configProps.filterValue != '' 
            && this.configProps.filterValue != undefined
        ){
            this.notifyConfigChange();    
        }
        
    }

    handleHideCheckBoxColumnChange(event) {
        debugger;
        this.configProps.hideCheckBoxColumn = event.detail.checked;
        this.notifyConfigChange();
    }

    handleDisableColumneResizeChange(event) {
        debugger;
        this.configProps.resizeColumnDisabled = event.detail.checked;
        this.notifyConfigChange();
    }

    handlehideTableHeaderChange(event) {
        debugger;
        this.configProps.hideTableHeader = event.detail.checked;
        this.notifyConfigChange();
    }

    handleShowTitleChange(event) {
        debugger;
        this.configProps.showTitle = event.detail.checked;
        this.notifyConfigChange();
    }

    handleTitleChange(event) {
        this.configProps.titleValue = event.detail.value;
    }

    handleTitleBlur(event) {
        debugger;
        this.notifyConfigChange();
    }

    handleColumnWidthsModeChange(event) {
        debugger;
        this.configProps.columnWidthsMode = event.detail.value;
        this.notifyConfigChange();
    }
    

    notifyConfigChange(){
        this.dispatchEvent(new CustomEvent("valuechange", {detail: {value: JSON.stringify(this.configProps)}}));
        
    }

}