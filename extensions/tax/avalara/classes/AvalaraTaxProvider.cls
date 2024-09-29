public without sharing class AvalaraTaxProvider extends TaxProvider {
  public AvalaraTaxProvider() {
  }

  public override void prepareCreateTransaction(TaxProviderRequest taxRequest,Map<String, String> callOutRequest) {
    Boolean hasMultipleShipments = taxRequest.hasMultipleShipments != null && taxRequest.hasMultipleShipments == true ? true: false;

    AvalaraTaxRequest avalaraRequest = new AvalaraTaxRequest();
    avalaraRequest.type = taxRequest.taxTransacionType;
    avalaraRequest.currencyCode = taxRequest.currencyCode;
    avalaraRequest.commit_Z = taxRequest.taxMetaData.isCommit;
    // if (
    //   String.isNotBlank(avalaraRequest.type) &&
    //   avalaraRequest.type.contains('Invoice')
    // ) {
    //   avalaraRequest.commit_Z = true;
    // }else{
    //   avalaraRequest.commit_Z = false;
    // }

    if (String.isNotBlank(taxRequest.taxMetaData.companyCode)) {
      avalaraRequest.companyCode = taxRequest.taxMetaData.companyCode;
    }

    if (String.isNotBlank(taxRequest.taxMetaData.customerCode)) {
      avalaraRequest.customerCode = taxRequest.taxMetaData.customerCode;
    }

    if (String.isNotBlank(taxRequest.customerTaxId)) {
      avalaraRequest.businessIdentificationNo = taxRequest.customerTaxId;
    }

    if (String.isNotBlank(taxRequest.customerExemptionCode)) {
      avalaraRequest.exemptionNo = taxRequest.customerExemptionCode;
    }

    if (String.isNotBlank(taxRequest.entityUseCode)) {
      avalaraRequest.entityUseCode = taxRequest.entityUseCode;
    }

    avalaraRequest.date_Z = System.now() + '';
    //taxRequest.taxableCartItems = null;
    if (taxRequest.taxableCartItems != null &&  taxRequest.taxableCartItems.keySet().size() > 0 ) {
      avalaraRequest.lines = prepareRequestFromExistingData(
        taxRequest,
        hasMultipleShipments
      );
    } else {
      avalaraRequest.lines = prepareRequestFromDB(
        taxRequest,
        hasMultipleShipments
      );
    }

    if (!hasMultipleShipments) {
      AvalaraTaxRequest.Addresses addresses = new AvalaraTaxRequest.Addresses();
      addresses.shipFrom = prepareShipFromAddress(taxRequest);
      addresses.shipTo = prepareShipToAddress(
        taxRequest.street,
        taxRequest.city,
        taxRequest.state,
        taxRequest.postalCode,
        taxRequest.country
      );
      avalaraRequest.addresses = addresses;
    }
    
    String avalaraRequestBody = JSON.serialize(avalaraRequest, true);
    avalaraRequestBody = avalaraRequestBody.replaceAll('_Z', '');
    callOutRequest.put(Constants.SERVICE_REQUEST_BODY, avalaraRequestBody);
    System.debug('====== avalaraRequest : '+avalaraRequestBody);
  }

  public virtual override TaxProviderResponse getTaxFromResponse(
    String strAvalaraResponseBody,
    TaxProviderRequest tpRequest
  ) {
    TaxProviderResponse tpResponse = new TaxProviderResponse();
    Map<String, LineItemTaxDetails> taxes = new Map<String, LineItemTaxDetails>();
    Map<String, TaxableCartItem> taxableCartItems = tpRequest.taxableCartItems;

    TaxProviderResponse shippingResponse;
    System.debug('====== strAvalaraResponseBody : '+strAvalaraResponseBody);
    if (String.isNotBlank(strAvalaraResponseBody)) {
      AvalaraTaxResponse avalaraTaxResponse = AvalaraTaxResponse.parse(
        strAvalaraResponseBody
      );
      if ( avalaraTaxResponse.lines != null && avalaraTaxResponse.lines.size() > 0 ) {
        for (AvalaraTaxResponse.Lines line : avalaraTaxResponse.lines) {
          String lineNumber = line.lineNumber;
          LineItemTaxDetails liTaxDetails = new LineItemTaxDetails();
          liTaxDetails.tax = 0;
          liTaxDetails.rate = 0;
          if (line.tax > 0) {
            liTaxDetails.tax = line.tax;
          }
          if (line.taxableAmount > 0) {
            liTaxDetails.rate = liTaxDetails.tax / line.taxableAmount;
          }
            if(!Test.isRunningTest()){
                taxableCartItems.get(lineNumber).lineItemTexas.add(liTaxDetails);
            }          
        }
        tpResponse.taxableCartItems = taxableCartItems;
      }
    }
    return tpResponse;
  }

  private List<AvalaraTaxRequest.Lines> prepareRequestFromExistingData(
    TaxProviderRequest taxRequest,
    Boolean hasMultipleShipments
  ) {
    List<AvalaraTaxRequest.Lines> lines = new List<AvalaraTaxRequest.Lines>();
    for (String id : taxRequest.taxableCartItems.keySet()) {
      TaxableCartItem cartItem = taxRequest.taxableCartItems.get(id);
      AvalaraTaxRequest.Lines line = prepareLine(
        id,
        cartItem.sku,
        cartItem.amount,
        cartItem.lineItemType,
        cartItem.taxClassId,
        cartItem.productExemptionCode,
        cartItem.entityUseCode,
        taxRequest,
        false
      );
     
      if (hasMultipleShipments) {
        AvalaraTaxRequest.Addresses addresses = new AvalaraTaxRequest.Addresses();
        addresses.shipFrom = prepareShipFromAddress(taxRequest);
        addresses.shipTo = prepareShipToAddress(
          cartItem.street,
          cartItem.city,
          cartItem.state,
          cartItem.postalCode,
          cartItem.country
        );
        line.addresses = addresses;
      }
      lines.add(line);
    }
    return lines;
  }

  private List<AvalaraTaxRequest.Lines> prepareRequestFromDB(
    TaxProviderRequest taxRequest,
    Boolean hasMultipleShipments
  ) {
   
    String cartId = taxRequest.cartId;
    taxRequest.taxableCartItems = new Map<String, TaxableCartItem>();
    List<AvalaraTaxRequest.Lines> lines = new List<AvalaraTaxRequest.Lines>();
    String query = 'SELECT Id, Sku, TotalLineAmount, Quantity, Type,Product2Id,Name,Product2.Family, Product2.StockKeepingUnit';
    if (hasMultipleShipments) {
      query += ',CartDeliveryGroup.Id,CartDeliveryGroup.DeliverToStreet,CartDeliveryGroup.DeliverToCity,CartDeliveryGroup.DeliverToState,CartDeliveryGroup.DeliverToPostalCode,CartDeliveryGroup.DeliverToCountry';
    }
    if(taxRequest.taxMetaData.useProductTaxCodes){
      query += ',Product2.Tax_Class_Id__c';
    }
    if(taxRequest.taxMetaData.productTaxExemption){
      query += ',Product2.Taxable__c,Product2.Entity_Use_Code__c,Product2.Exemption_Code__c';
    }
    query += ' FROM CartItem WHERE  cartId=:cartId';
    if (!taxRequest.taxMetaData.shippingItemsTaxable) {
      query += ' AND Type = \'Product\'';
    }
    for (CartItem cartItem : Database.query(query)) {
      AvalaraTaxRequest.Lines line = prepareLine(
        cartItem.Id,
        cartItem.SKU !=null ? cartItem.SKU : cartItem.Product2.StockKeepingUnit,
        cartItem.TotalLineAmount,
        cartItem.Type,
        taxRequest.taxMetaData.useProductTaxCodes && cartItem.Product2.Tax_Class_Id__c !=null ? cartItem.Product2.Tax_Class_Id__c : null,
        taxRequest.taxMetaData.productTaxExemption ? cartItem.Product2.Exemption_Code__c : null,
        taxRequest.taxMetaData.productTaxExemption ? cartItem.Product2.Entity_Use_Code__c : null,
        taxRequest,
        true
      );
      if (hasMultipleShipments) {
        AvalaraTaxRequest.Addresses addresses = new AvalaraTaxRequest.Addresses();
        addresses.shipFrom = prepareShipFromAddress(taxRequest);
        addresses.shipTo = prepareShipToAddress(
          cartItem.CartDeliveryGroup.DeliverToStreet,
          cartItem.CartDeliveryGroup.DeliverToCity,
          cartItem.CartDeliveryGroup.DeliverToState,
          cartItem.CartDeliveryGroup.DeliverToPostalCode,
          cartItem.CartDeliveryGroup.DeliverToCountry
        );
        line.addresses = addresses;
      }
      lines.add(line);
    }
    return lines;
  }

  private AvalaraTaxRequest.Lines prepareLine(
    ID id,
    String sku,
    Decimal taxableAmount,
    String type,
    String taxClassId,
    String exemptionCode,
    String entityUseCode,
    TaxProviderRequest taxRequest,
    Boolean setInRequestToo
  ) {
    AvalaraTaxRequest.Lines line = new AvalaraTaxRequest.Lines();
    line.number_Z = id;
    line.itemCode = sku;
    line.amount = taxableAmount;
    if (String.isNotBlank(taxRequest.taxMetaData.taxationPolicy)) {
      line.taxIncluded = taxRequest.taxMetaData.taxationPolicy.equalsIgnoreCase( 'net' ) ? false : true;
    }
    line.taxCode = taxClassId;
    line.exemptionCode = exemptionCode;
    line.entityUseCode = entityUseCode;
    if (setInRequestToo) {
      TaxableCartItem tcItem = new TaxableCartItem();
      tcItem.id = id;
      tcItem.amount = taxableAmount;
      tcItem.sku = sku;
      tcItem.lineItemType = type;
      taxRequest.taxableCartItems.put(id, tcItem);
    }

    return line;
  }

  public override void prepareCommitTransaction(TaxProviderRequest taxRequest, Map<String, String> callOutRequest) {

  }
  AvalaraTaxRequest.ShipFrom prepareShipFromAddress(TaxProviderRequest taxRequest) {
    AvalaraTaxRequest.ShipFrom address = new AvalaraTaxRequest.ShipFrom();

    address.line1 = taxRequest.taxMetaData.shipFromLine1;
    address.city = taxRequest.taxMetaData.shipFromCity;
    address.region = taxRequest.taxMetaData.shipFromState;
    address.postalCode = taxRequest.taxMetaData.shipFromZipCode;
    address.country = taxRequest.taxMetaData.shipFromCountry;

    return address;
  }

  AvalaraTaxRequest.ShipFrom prepareShipToAddress(
    String street,
    String city,
    String state,
    String postalCode,
    String country
  ) {
    AvalaraTaxRequest.ShipFrom address = new AvalaraTaxRequest.ShipFrom();
    address.line1 = street;
    address.city = city;
    address.region = state;
    address.postalCode = postalCode;
    address.country = country;
    return address;
  }
}