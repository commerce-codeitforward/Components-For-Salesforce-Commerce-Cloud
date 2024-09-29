public without sharing class VertexTaxProvider extends TaxProvider {
  public VertexTaxProvider() {
  }

  public override void prepareCreateTransaction(
    TaxProviderRequest taxRequest,
    Map<String, String> callOutRequest
  ) {
    Boolean hasMultipleShipments = taxRequest.hasMultipleShipments != null &&
      taxRequest.hasMultipleShipments == true ? true : false;

    
    VertexTaxRequest vertexRequest = new VertexTaxRequest();
    vertexRequest.transactionType = taxRequest.taxMetaData.transactionType;
    vertexRequest.saleMessageType = taxRequest.taxMetaData.documentType;

    //setting currency 
    VertexTaxRequest.cls_currency currencyZ = new VertexTaxRequest.cls_currency();
    currencyZ.isoCurrencyCodeAlpha = taxRequest.currencyCode;
    vertexRequest.currency_z = currencyZ;

   // setting current date 
   DateTime todaysDate = System.today();
   String todaysDateStr = todaysDate.format('yyyy-MM-dd');
   vertexRequest.documentDate = todaysDateStr;
   vertexRequest.taxPointDate = todaysDateStr;
   
   vertexRequest.documentNumber = String.isNotBlank(taxRequest.cartId) ? taxRequest.cartId : taxRequest.orderNo;
   vertexRequest.transactionId = String.isNotBlank(taxRequest.cartId) ? taxRequest.cartId : taxRequest.orderNo;
    if ( taxRequest.taxableCartItems != null && taxRequest.taxableCartItems.keySet().size() > 0
    ) {
     vertexRequest.lineItems = prepareRequestFromExistingData(
        taxRequest,
        hasMultipleShipments
      );
    } else {
     vertexRequest.lineItems = prepareRequestFromDB(
        taxRequest,
        hasMultipleShipments
      );
    }

    //in case there is single shipment , setting addresses at transaction level 
    if (!hasMultipleShipments) {
      vertexRequest.customer = setCustomerDetails(
        taxRequest,
        taxRequest.street,
        taxRequest.city,
        taxRequest.state,
        taxRequest.postalCode,
        taxRequest.country
      );
      vertexRequest.seller = setSellerDetails(taxRequest);
    }
    
    String vertexRequestBody = JSON.serialize(vertexRequest, true);
    vertexRequestBody = vertexRequestBody.replaceAll('_z', '');
    callOutRequest.put(Constants.SERVICE_REQUEST_BODY, vertexRequestBody);
    System.debug('====== vertexRequest : '+vertexRequestBody);
  }

  public virtual override TaxProviderResponse getTaxFromResponse(
    String strvertexResponseBody,
    TaxProviderRequest tpRequest
  ) {
    TaxProviderResponse tpResponse = new TaxProviderResponse();
    Map<String, LineItemTaxDetails> taxes = new Map<String, LineItemTaxDetails>();
    Map<String, TaxableCartItem> taxableCartItems = tpRequest.taxableCartItems;

    TaxProviderResponse shippingResponse;
    System.debug('====== strvertexResponseBody : '+strvertexResponseBody);
    if (String.isNotBlank(strvertexResponseBody)) {
      VertexTaxResponse vertexTaxResponse = VertexTaxResponse.parse(
        strVertexResponseBody
      );
      if (
        vertexTaxResponse.data.lineItems != null && vertexTaxResponse.data.lineItems.size() > 0
      ) {
        for (VertexTaxResponse.cls_lineItems line : vertexTaxResponse.data.lineItems) {
          String lineItemId = line.lineItemId;
          LineItemTaxDetails liTaxDetails = new LineItemTaxDetails();
          liTaxDetails.tax = 0;
          liTaxDetails.rate = 0;
          if (line.totalTax > 0) {
            liTaxDetails.tax = line.totalTax;
          }
          if (line.fairMarketValue > 0) {
            liTaxDetails.rate = liTaxDetails.tax / line.fairMarketValue;
          }
          taxableCartItems.get(lineItemId).lineItemTexas.add(liTaxDetails);
        }
        tpResponse.taxableCartItems = taxableCartItems;
      }
    }
    return tpResponse;
  }

  private List<VertexTaxRequest.cls_lineItems> prepareRequestFromExistingData(
    TaxProviderRequest taxRequest,
    Boolean hasMultipleShipments
  ) {
    List<VertexTaxRequest.cls_lineItems> lines = new List<VertexTaxRequest.cls_lineItems>();
    for (String id : taxRequest.taxableCartItems.keySet()) {
      TaxableCartItem cartItem = taxRequest.taxableCartItems.get(id);
      VertexTaxRequest.cls_lineItems line = prepareLine(
        id,
        cartItem.sku,
        cartItem.amount,
        cartItem.lineItemType,
        cartItem.quantity,
        cartItem.taxClassId,
        cartItem.productExemptionCode,
        cartItem.entityUseCode,
        taxRequest,
        false
      );
     
      if (hasMultipleShipments) {
        line.seller = setSellerDetails(taxRequest);
        line.customer = setCustomerDetails(
          taxRequest,
          cartItem.street,
          cartItem.city,
          cartItem.state,
          cartItem.postalCode,
          cartItem.country
        );
      }
      lines.add(line);
    }
    return lines;
  }

  private List<VertexTaxRequest.cls_lineItems> prepareRequestFromDB(
    TaxProviderRequest taxRequest,
    Boolean hasMultipleShipments
  ) {
   
    String cartId = taxRequest.cartId;
    taxRequest.taxableCartItems = new Map<String, TaxableCartItem>();
    List<VertexTaxRequest.cls_lineItems> lines = new List<VertexTaxRequest.cls_lineItems>();
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
      VertexTaxRequest.cls_lineItems line = prepareLine(
        cartItem.Id,
        cartItem.SKU !=null ? cartItem.SKU : cartItem.Product2.StockKeepingUnit,
        cartItem.TotalLineAmount,
        cartItem.Type,
        cartItem.Quantity,
        taxRequest.taxMetaData.useProductTaxCodes && cartItem.Product2.Tax_Class_Id__c !=null ? cartItem.Product2.Tax_Class_Id__c : null,
        taxRequest.taxMetaData.productTaxExemption ? cartItem.Product2.Exemption_Code__c : null,
        taxRequest.taxMetaData.productTaxExemption ? cartItem.Product2.Entity_Use_Code__c : null,
        taxRequest,
        true
      );
      if (hasMultipleShipments) {
        line.seller = setSellerDetails(taxRequest);
        line.customer = setCustomerDetails(
          taxRequest,
          cartItem.CartDeliveryGroup.DeliverToStreet,
          cartItem.CartDeliveryGroup.DeliverToCity,
          cartItem.CartDeliveryGroup.DeliverToState,
          cartItem.CartDeliveryGroup.DeliverToPostalCode,
          cartItem.CartDeliveryGroup.DeliverToCountry
        );
      }
      lines.add(line);
    }
    return lines;
  }

  private VertexTaxRequest.cls_lineItems prepareLine(
    ID id,
    String sku,
    Decimal taxableAmount,
    String type,
    Decimal quantity,
    String taxClassId,
    String exemptionCode,
    String entityUseCode,
    TaxProviderRequest taxRequest,
    Boolean setInRequestToo
  ) {
    VertexTaxRequest.cls_lineItems line = new VertexTaxRequest.cls_lineItems();
    line.lineItemId = id;
    line.extendedPrice = taxableAmount;
    line.fairMarketValue = taxableAmount;
    line.usage = type;
    VertexTaxRequest.cls_product product = new VertexTaxRequest.cls_product();
    product.value = sku;
    line.product = product;
    VertexTaxRequest.cls_quantity prdQuantity = new VertexTaxRequest.cls_quantity();
    prdQuantity.value = quantity;
    line.quantity = prdQuantity;
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
  VertexTaxRequest.cls_seller setSellerDetails(
    TaxProviderRequest taxRequest
  ) {
    VertexTaxRequest.cls_seller seller = new VertexTaxRequest.cls_seller();
    VertexTaxRequest.cls_physicalOrigin origin = new VertexTaxRequest.cls_physicalOrigin();
    origin.streetAddress1 = taxRequest.taxMetaData.shipFromLine1;
    origin.city = taxRequest.taxMetaData.shipFromCity;
    origin.mainDivision = taxRequest.taxMetaData.shipFromState;
    origin.postalCode = taxRequest.taxMetaData.shipFromZipCode;
    origin.country = taxRequest.taxMetaData.shipFromCountry;
    if (String.isNotBlank(taxRequest.taxMetaData.companyCode)) {
      seller.company = taxRequest.taxMetaData.companyCode;
     }
    seller.physicalOrigin = origin;
    return seller;
  }

  VertexTaxRequest.cls_customer setCustomerDetails(
    TaxProviderRequest taxRequest,
    String street,
    String city,
    String state,
    String postalCode,
    String country
  ) {
    VertexTaxRequest.cls_customer customer = new VertexTaxRequest.cls_customer();
    VertexTaxRequest.cls_customerCode customerCd = new VertexTaxRequest.cls_customerCode();
     if (String.isNotBlank( taxRequest.taxMetaData.customerCode)) {
      customerCd.classCode =   taxRequest.taxMetaData.customerCode;
      customerCd.isBusinessIndicator = true; 
      customerCd.value =  taxRequest.taxMetaData.customerCode;
      customer.customerCode = customerCd;
     }

     if (taxRequest.taxMetaData.customerTaxExemption){
      if (String.isNotBlank(taxRequest.customerExemptionCode)) {
        VertexTaxRequest.cls_exemptionCertificate exemptionCertificate = new VertexTaxRequest.cls_exemptionCertificate();
        exemptionCertificate.exemptionCertificateNumber = taxRequest.customerExemptionCode;
        exemptionCertificate.value = taxRequest.customerExemptionCode;
        customer.exemptionCertificate = exemptionCertificate;
        
      }else{
        customer.isTaxExempt = true;
      }
      if (String.isNotBlank(taxRequest.entityUseCode)) {
        customer.exemptionReasonCode = taxRequest.entityUseCode;
       }
     }
		VertexTaxRequest.cls_destination destination = new VertexTaxRequest.cls_destination();
    destination.streetAddress1 = street;
    destination.city = city;
    destination.mainDivision = state;
    destination.postalCode = postalCode;
    destination.country = country;

    
    customer.destination = destination;
    return customer;
  }
}