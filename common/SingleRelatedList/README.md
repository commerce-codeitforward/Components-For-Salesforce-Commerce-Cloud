# Cybersource - B2B / B2C Commerce for LWR
This component can be used on any Record Detail Page to display 1 Child Object of the Detail Record. 
There are a few configuration options outline below.
The component uses a Datatable to display the related records. This columns in the Datatable are configured using a FieldSet of your choosing. YOu will be able to select it from the related objects Field Set metadata.


Install instructions:
1. Deploy the code in the SingleRelatedList folder into your org.
2. Assign the SingleRelatedListUser and SingleRelatedListAdmin appropriately.
  -  Each Permission Set grants access to the SingleRelatedListController apex code.
  -  SingleRelatedListAdmin Permission Set also grants access to the SingleRelatedListCPEController apex code used to configure the compoenent in Experience Builder.
  -  You can also use these Permissions Sets to grant access to any Objects or fields used in the component.
3. Open a Record Detail page in Experience Builder
4. Under Custom components, drag and drop the "Single Related List" component into the desired location. You can drop multiple components into one page to display more than one related record list.
5. On the "Data Binding" Tab 
  - Select the Parent Object from the "Parent Object" dropdown.
  - Select the Child / Related object from the "Related Object" dropdown. This is necessary to fill the "Related Object" dropdown.
  - Select the Field Set for your related object using the "Field Set" dropdown. You must define your Field Set under the Object settings in Salesforce Setup.
  - Select the Lookup Field that is used to associate the Child Object to the Parent Object using the "Lookup Field" dropdown.
6. Expand the "Table Options" section of the component configuration panel.
  - Enter the value you would like to be displayed as the Title of the Datatable in the "Table Title" text input. This is optional.
  - Check the "Show Title" checkbox if you would like the "Table Title" to be displayed in the component.
  - Check the "Hide Table Header Row" checkbox if you do not want the Column Headers to be displayed.
  - Check the "Disable Column Resizing" checkbox to disable column resizing.
  - Select the Column Widths Mode" option. 
    - auto: columns will adjust automatically in the space allotted.
    - fixed: columns will divide equally in the space allotted.
7. Expand the "Option Filter" section of the component configuration panel.
  - Select the Field you would like to use to limit the rows displayed in the component using the "Filter Field" dropdown.(Optional)
  - In the "Filter Value" text input, enter a filter value appropriate for the "Filter Field" selected.
8. The final property in the editor, is the "Record Id" with a default of {!recordId}. This is needed to get the Parent Object Id into the component. 
  

A few things to keep in mind.
You need to create your feild set on the appropriate object.
The Filter Field and Filter Value inputs are optional. If you do not enter any filter options, all relatyed records will be returned. 


Component Contents:
- singleRelatedList LWC: This component uses the the configuration properties to display the Related Records on the page.
- singleRelatedListControllerCPE LWC: This is the component that is displayed ast the Property Editor in Experience Cloud to configure the metadata used by the singleRelatedList LWC.
- SingleRelatedListController apex class: This class has all the methods to retrieve the Related Object Fieldset Fields and the Records that are displayed in the component.
- singleRelatedListControllerCPE apex class: This class hass all the methods to retrieve metadata used in the dropdowns.
- singleRelatedListPE experienceTypeBundle: This metadata is used to tell Experience Cloud to use the singleRelatedListControllerCPE component as the property editor. see https://resources.docs.salesforce.com/rel1/doc/en-us/static/pdf/Custom_Property_Types_and_Editors_Beta_Summer-23.pdf?_ga=2.5467699.1465389377.1742399017-448798302.1742226744 for more information about Custom Property Types and Property Editors.