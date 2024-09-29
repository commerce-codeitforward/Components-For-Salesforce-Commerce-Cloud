public class AvalaraTaxResponse {
  public class Addresses {
    public String id { get; set; }
    public String transactionId { get; set; }
    public String boundaryLevel { get; set; }
    public String line1 { get; set; }
    public String line2 { get; set; }
    public String line3 { get; set; }
    public String city { get; set; }
    public String region { get; set; }
    public String postalCode { get; set; }
    public String country { get; set; }
    public String taxRegionId { get; set; }
    public String latitude { get; set; }
    public String longitude { get; set; }

    public Addresses() {
    }
    public Addresses(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'id') {
              id = parser.getText();
            } else if (text == 'transactionId') {
              transactionId = parser.getText();
            } else if (text == 'boundaryLevel') {
              boundaryLevel = parser.getText();
            } else if (text == 'line1') {
              line1 = parser.getText();
            } else if (text == 'line2') {
              line2 = parser.getText();
            } else if (text == 'line3') {
              line3 = parser.getText();
            } else if (text == 'city') {
              city = parser.getText();
            } else if (text == 'region') {
              region = parser.getText();
            } else if (text == 'postalCode') {
              postalCode = parser.getText();
            } else if (text == 'country') {
              country = parser.getText();
            } else if (text == 'taxRegionId') {
              taxRegionId = parser.getText();
            } else if (text == 'latitude') {
              latitude = parser.getText();
            } else if (text == 'longitude') {
              longitude = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Addresses consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Details {
    public String id { get; set; }
    public String transactionLineId { get; set; }
    public String transactionId { get; set; }
    public String addressId { get; set; }
    public String country { get; set; }
    public String region { get; set; }
    public String stateFIPS { get; set; }
    public Decimal exemptAmount { get; set; }
    public String exemptReasonId { get; set; }
    public Boolean inState { get; set; }
    public String jurisCode { get; set; }
    public String jurisName { get; set; }
    public String jurisdictionId { get; set; }
    public String signatureCode { get; set; }
    public String stateAssignedNo { get; set; }
    public String jurisType { get; set; }
    public Decimal nonTaxableAmount { get; set; }
    public String nonTaxableRuleId { get; set; }
    public String nonTaxableType { get; set; }
    public Double rate { get; set; }
    public String rateRuleId { get; set; }
    public String rateSourceId { get; set; }
    public String serCode { get; set; }
    public String sourcing { get; set; }
    public Double tax { get; set; }
    public Decimal taxableAmount { get; set; }
    public String taxType { get; set; }
    public String taxName { get; set; }
    public String taxAuthorityTypeId { get; set; }
    public String taxRegionId { get; set; }
    public Double taxCalculated { get; set; }
    public String taxOverride { get; set; }
    public String rateType { get; set; }
    public Double taxableUnits { get; set; }
    public Integer nonTaxableUnits { get; set; }
    public Double exemptUnits { get; set; }
    public Integer reportingTaxableUnits { get; set; }
    public Integer reportingNonTaxableUnits { get; set; }
    public Integer reportingExemptUnits { get; set; }
    public Decimal reportingTax { get; set; }
    public Decimal reportingTaxCalculated { get; set; }
    public String jurisdictionType { get; set; }
    public String taxSubTypeId { get; set; }
    public String rateTypeCode { get; set; }
    public String unitOfBasis { get; set; }
    public Boolean isNonPassThru { get; set; }
    public Boolean isFee { get; set; }
    public String liabilityType { get; set; }
    public String chargedTo { get; set; }

    public Details() {
    }
    public Details(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'id') {
              id = parser.getText();
            } else if (text == 'transactionLineId') {
              transactionLineId = parser.getText();
            } else if (text == 'transactionId') {
              transactionId = parser.getText();
            } else if (text == 'addressId') {
              addressId = parser.getText();
            } else if (text == 'country') {
              country = parser.getText();
            } else if (text == 'region') {
              region = parser.getText();
            } else if (text == 'stateFIPS') {
              stateFIPS = parser.getText();
            } else if (text == 'exemptAmount') {
              exemptAmount = parser.getDecimalValue();
            } else if (text == 'exemptReasonId') {
              exemptReasonId = parser.getText();
            } else if (text == 'inState') {
              inState = parser.getBooleanValue();
            } else if (text == 'jurisCode') {
              jurisCode = parser.getText();
            } else if (text == 'jurisName') {
              jurisName = parser.getText();
            } else if (text == 'jurisdictionId') {
              jurisdictionId = parser.getText();
            } else if (text == 'signatureCode') {
              signatureCode = parser.getText();
            } else if (text == 'stateAssignedNo') {
              stateAssignedNo = parser.getText();
            } else if (text == 'jurisType') {
              jurisType = parser.getText();
            } else if (text == 'nonTaxableAmount') {
              nonTaxableAmount = parser.getDecimalValue();
            } else if (text == 'nonTaxableRuleId') {
              nonTaxableRuleId = parser.getText();
            } else if (text == 'nonTaxableType') {
              nonTaxableType = parser.getText();
            } else if (text == 'rate') {
              rate = parser.getDoubleValue();
            } else if (text == 'rateRuleId') {
              rateRuleId = parser.getText();
            } else if (text == 'rateSourceId') {
              rateSourceId = parser.getText();
            } else if (text == 'serCode') {
              serCode = parser.getText();
            } else if (text == 'sourcing') {
              sourcing = parser.getText();
            } else if (text == 'tax') {
              tax = parser.getDoubleValue();
            } else if (text == 'taxableAmount') {
              taxableAmount = parser.getDecimalValue();
            } else if (text == 'taxType') {
              taxType = parser.getText();
            } else if (text == 'taxName') {
              taxName = parser.getText();
            } else if (text == 'taxAuthorityTypeId') {
              taxAuthorityTypeId = parser.getText();
            } else if (text == 'taxRegionId') {
              taxRegionId = parser.getText();
            } else if (text == 'taxCalculated') {
              taxCalculated = parser.getDoubleValue();
            } else if (text == 'taxOverride') {
              taxOverride = parser.getText();
            } else if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'taxableUnits') {
              taxableUnits = parser.getDoubleValue();
            } else if (text == 'nonTaxableUnits') {
              nonTaxableUnits = parser.getIntegerValue();
            } else if (text == 'exemptUnits') {
              exemptUnits = parser.getDoubleValue();
            } else if (text == 'reportingTaxableUnits') {
              reportingTaxableUnits = parser.getIntegerValue();
            } else if (text == 'reportingNonTaxableUnits') {
              reportingNonTaxableUnits = parser.getIntegerValue();
            } else if (text == 'reportingExemptUnits') {
              reportingExemptUnits = parser.getIntegerValue();
            } else if (text == 'reportingTax') {
              reportingTax = parser.getDecimalValue();
            } else if (text == 'reportingTaxCalculated') {
              reportingTaxCalculated = parser.getDecimalValue();
            } else if (text == 'jurisdictionType') {
              jurisdictionType = parser.getText();
            } else if (text == 'taxSubTypeId') {
              taxSubTypeId = parser.getText();
            } else if (text == 'rateTypeCode') {
              rateTypeCode = parser.getText();
            } else if (text == 'unitOfBasis') {
              unitOfBasis = parser.getText();
            } else if (text == 'isNonPassThru') {
              isNonPassThru = parser.getBooleanValue();
            } else if (text == 'isFee') {
              isFee = parser.getBooleanValue();
            } else if (text == 'liabilityType') {
              liabilityType = parser.getText();
            } else if (text == 'chargedTo') {
              chargedTo = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Details consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public String id { get; set; }
  public String code { get; set; }
  public String companyId { get; set; }
  public String date_Z { get; set; } // in json: date
  public String paymentDate { get; set; }
  public String status { get; set; }
  public String type { get; set; }
  public String batchCode { get; set; }
  public String currencyCode { get; set; }
  public String exchangeRateCurrencyCode { get; set; }
  public String customerUsageType { get; set; }
  public String entityUseCode { get; set; }
  public String customerVendorCode { get; set; }
  public String customerCode { get; set; }
  public String exemptNo { get; set; }
  public Boolean reconciled { get; set; }
  public String locationCode { get; set; }
  public String reportingLocationCode { get; set; }
  public String purchaseOrderNo { get; set; }
  public String referenceCode { get; set; }
  public String salespersonCode { get; set; }
  public Double totalAmount { get; set; }
  public Double totalExempt { get; set; }
  public Double totalDiscount { get; set; }
  public Double totalTax { get; set; }
  public Double totalTaxable { get; set; }
  public Double totalTaxCalculated { get; set; }
  public String adjustmentReason { get; set; }
  public Boolean locked { get; set; }
  public String version { get; set; }
  public String exchangeRateEffectiveDate { get; set; }
  public Double exchangeRate { get; set; }
  public String description { get; set; }
  public String email { get; set; }
  public String modifiedDate { get; set; }
  public String modifiedUserId { get; set; }
  public String taxDate { get; set; }
  public List<Lines> lines { get; set; }
  public List<Addresses> addresses { get; set; }
  public List<Summary> summary { get; set; }
  public List<TaxDetailsByTaxType> taxDetailsByTaxType { get; set; }

  public AvalaraTaxResponse() {
  }
  public AvalaraTaxResponse(JSONParser parser) {
    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
      if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
        String text = parser.getText();
        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
          if (text == 'id') {
            id = parser.getText();
          } else if (text == 'code') {
            code = parser.getText();
          } else if (text == 'companyId') {
            companyId = parser.getText();
          } else if (text == 'date') {
            date_Z = parser.getText();
          } else if (text == 'paymentDate') {
            paymentDate = parser.getText();
          } else if (text == 'status') {
            status = parser.getText();
          } else if (text == 'type') {
            type = parser.getText();
          } else if (text == 'batchCode') {
            batchCode = parser.getText();
          } else if (text == 'currencyCode') {
            currencyCode = parser.getText();
          } else if (text == 'exchangeRateCurrencyCode') {
            exchangeRateCurrencyCode = parser.getText();
          } else if (text == 'customerUsageType') {
            customerUsageType = parser.getText();
          } else if (text == 'entityUseCode') {
            entityUseCode = parser.getText();
          } else if (text == 'customerVendorCode') {
            customerVendorCode = parser.getText();
          } else if (text == 'customerCode') {
            customerCode = parser.getText();
          } else if (text == 'exemptNo') {
            exemptNo = parser.getText();
          } else if (text == 'reconciled') {
            reconciled = parser.getBooleanValue();
          } else if (text == 'locationCode') {
            locationCode = parser.getText();
          } else if (text == 'reportingLocationCode') {
            reportingLocationCode = parser.getText();
          } else if (text == 'purchaseOrderNo') {
            purchaseOrderNo = parser.getText();
          } else if (text == 'referenceCode') {
            referenceCode = parser.getText();
          } else if (text == 'salespersonCode') {
            salespersonCode = parser.getText();
          } else if (text == 'totalAmount') {
            totalAmount = parser.getDoubleValue();
          } else if (text == 'totalExempt') {
            totalExempt = parser.getDoubleValue();
          } else if (text == 'totalDiscount') {
            totalDiscount = parser.getDoubleValue();
          } else if (text == 'totalTax') {
            totalTax = parser.getDoubleValue();
          } else if (text == 'totalTaxable') {
            totalTaxable = parser.getDoubleValue();
          } else if (text == 'totalTaxCalculated') {
            totalTaxCalculated = parser.getDoubleValue();
          } else if (text == 'adjustmentReason') {
            adjustmentReason = parser.getText();
          } else if (text == 'locked') {
            locked = parser.getBooleanValue();
          } else if (text == 'version') {
            version = parser.getText();
          } else if (text == 'exchangeRateEffectiveDate') {
            exchangeRateEffectiveDate = parser.getText();
          } else if (text == 'exchangeRate') {
            exchangeRate = parser.getDoubleValue();
          } else if (text == 'description') {
            description = parser.getText();
          } else if (text == 'email') {
            email = parser.getText();
          } else if (text == 'modifiedDate') {
            modifiedDate = parser.getText();
          } else if (text == 'modifiedUserId') {
            modifiedUserId = parser.getText();
          } else if (text == 'taxDate') {
            taxDate = parser.getText();
          } else if (text == 'lines') {
            lines = arrayOfLines(parser);
          } else if (text == 'addresses') {
            addresses = arrayOfAddresses(parser);
          } else if (text == 'summary') {
            summary = arrayOfSummary(parser);
          } else if (text == 'taxDetailsByTaxType') {
            taxDetailsByTaxType = arrayOfTaxDetailsByTaxType(parser);
          } else {
            System.debug(
              LoggingLevel.WARN,
              'AvalaraTaxResponse consuming unrecognized property: ' + text
            );
            consumeObject(parser);
          }
        }
      }
    }
  }

  public class NonPassthroughDetails {
    public NonPassthroughDetails() {
    }
    public NonPassthroughDetails(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            {
              System.debug(
                LoggingLevel.WARN,
                'NonPassthroughDetails consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class TaxDetailsByTaxType {
    public String taxType { get; set; }
    public Decimal totalTaxable { get; set; }
    public Double totalExempt { get; set; }
    public Decimal totalNonTaxable { get; set; }
    public Double totalTax { get; set; }

    public TaxDetailsByTaxType() {
    }
    public TaxDetailsByTaxType(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'taxType') {
              taxType = parser.getText();
            } else if (text == 'totalTaxable') {
              totalTaxable = parser.getDecimalValue();
            } else if (text == 'totalExempt') {
              totalExempt = parser.getDoubleValue();
            } else if (text == 'totalNonTaxable') {
              totalNonTaxable = parser.getDecimalValue();
            } else if (text == 'totalTax') {
              totalTax = parser.getDoubleValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'TaxDetailsByTaxType consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Summary {
    public String country { get; set; }
    public String region { get; set; }
    public String jurisType { get; set; }
    public String jurisCode { get; set; }
    public String jurisName { get; set; }
    public String taxAuthorityType { get; set; }
    public String stateAssignedNo { get; set; }
    public String taxType { get; set; }
    public String taxSubType { get; set; }
    public String taxName { get; set; }
    public String rateType { get; set; }
    public Double taxable { get; set; }
    public Double rate { get; set; }
    public Double tax { get; set; }
    public Double taxCalculated { get; set; }
    public Double nonTaxable { get; set; }
    public Double exemption { get; set; }

    public Summary() {
    }
    public Summary(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'country') {
              country = parser.getText();
            } else if (text == 'region') {
              region = parser.getText();
            } else if (text == 'jurisType') {
              jurisType = parser.getText();
            } else if (text == 'jurisCode') {
              jurisCode = parser.getText();
            } else if (text == 'jurisName') {
              jurisName = parser.getText();
            } else if (text == 'taxAuthorityType') {
              taxAuthorityType = parser.getText();
            } else if (text == 'stateAssignedNo') {
              stateAssignedNo = parser.getText();
            } else if (text == 'taxType') {
              taxType = parser.getText();
            } else if (text == 'taxSubType') {
              taxSubType = parser.getText();
            } else if (text == 'taxName') {
              taxName = parser.getText();
            } else if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'taxable') {
              taxable = parser.getDoubleValue();
            } else if (text == 'rate') {
              rate = parser.getDoubleValue();
            } else if (text == 'tax') {
              tax = parser.getDoubleValue();
            } else if (text == 'taxCalculated') {
              taxCalculated = parser.getDoubleValue();
            } else if (text == 'nonTaxable') {
              nonTaxable = parser.getDoubleValue();
            } else if (text == 'exemption') {
              exemption = parser.getDoubleValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Summary consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Lines {
    public String id { get; set; }
    public String transactionId { get; set; }
    public String lineNumber { get; set; }
    public String customerUsageType { get; set; }
    public String entityUseCode { get; set; }
    public String description { get; set; }
    public Double discountAmount { get; set; }
    public Double exemptAmount { get; set; }
    public String exemptCertId { get; set; }
    public String exemptNo { get; set; }
    public Boolean isItemTaxable { get; set; }
    public String itemCode { get; set; }
    public Double lineAmount { get; set; }
    public Double quantity { get; set; }
    public String ref1 { get; set; }
    public String ref2 { get; set; }
    public String reportingDate { get; set; }
    public Double tax { get; set; }
    public Double taxableAmount { get; set; }
    public Double taxCalculated { get; set; }
    public String taxCode { get; set; }
    public String taxCodeId { get; set; }
    public String taxDate { get; set; }
    public Boolean taxIncluded { get; set; }
    public List<Details> details { get; set; }
    public List<NonPassthroughDetails> nonPassthroughDetails { get; set; }
    public String hsCode { get; set; }
    public Double costInsuranceFreight { get; set; }
    public String vatCode { get; set; }
    public String vatNumberTypeId { get; set; }
    public String originAddressId { get; set; }
    public String destinationAddressId { get; set; }

    public Lines() {
    }
    public Lines(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'id') {
              id = parser.getText();
            } else if (text == 'transactionId') {
              transactionId = parser.getText();
            } else if (text == 'lineNumber') {
              lineNumber = parser.getText();
            } else if (text == 'customerUsageType') {
              customerUsageType = parser.getText();
            } else if (text == 'entityUseCode') {
              entityUseCode = parser.getText();
            } else if (text == 'description') {
              description = parser.getText();
            } else if (text == 'discountAmount') {
              discountAmount = parser.getDoubleValue();
            } else if (text == 'exemptAmount') {
              exemptAmount = parser.getDoubleValue();
            } else if (text == 'exemptCertId') {
              exemptCertId = parser.getText();
            } else if (text == 'exemptNo') {
              exemptNo = parser.getText();
            } else if (text == 'isItemTaxable') {
              isItemTaxable = parser.getBooleanValue();
            } else if (text == 'itemCode') {
              itemCode = parser.getText();
            } else if (text == 'lineAmount') {
              lineAmount = parser.getDoubleValue();
            } else if (text == 'quantity') {
              quantity = parser.getDoubleValue();
            } else if (text == 'ref1') {
              ref1 = parser.getText();
            } else if (text == 'ref2') {
              ref2 = parser.getText();
            } else if (text == 'reportingDate') {
              reportingDate = parser.getText();
            } else if (text == 'tax') {
              tax = parser.getDoubleValue();
            } else if (text == 'taxableAmount') {
              taxableAmount = parser.getDoubleValue();
            } else if (text == 'taxCalculated') {
              taxCalculated = parser.getDoubleValue();
            } else if (text == 'taxCode') {
              taxCode = parser.getText();
            } else if (text == 'taxCodeId') {
              taxCodeId = parser.getText();
            } else if (text == 'taxDate') {
              taxDate = parser.getText();
            } else if (text == 'taxIncluded') {
              taxIncluded = parser.getBooleanValue();
            } else if (text == 'details') {
              details = arrayOfDetails(parser);
            } else if (text == 'nonPassthroughDetails') {
              nonPassthroughDetails = arrayOfNonPassthroughDetails(parser);
            } else if (text == 'hsCode') {
              hsCode = parser.getText();
            } else if (text == 'costInsuranceFreight') {
              costInsuranceFreight = parser.getDoubleValue();
            } else if (text == 'vatCode') {
              vatCode = parser.getText();
            } else if (text == 'vatNumberTypeId') {
              vatNumberTypeId = parser.getText();
            } else if (text == 'originAddressId') {
              originAddressId = parser.getText();
            } else if (text == 'destinationAddressId') {
              destinationAddressId = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Lines consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public static AvalaraTaxResponse parse(String json) {
    System.JSONParser parser = System.JSON.createParser(json);
    return new AvalaraTaxResponse(parser);
  }

  public static void consumeObject(System.JSONParser parser) {
    Integer depth = 0;
    do {
      System.JSONToken curr = parser.getCurrentToken();
      if (
        curr == System.JSONToken.START_OBJECT ||
        curr == System.JSONToken.START_ARRAY
      ) {
        depth++;
      } else if (
        curr == System.JSONToken.END_OBJECT ||
        curr == System.JSONToken.END_ARRAY
      ) {
        depth--;
      }
    } while (depth > 0 && parser.nextToken() != null);
  }

  private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
    List<Addresses> res = new List<Addresses>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Addresses(p));
    }
    return res;
  }

  private static List<Details> arrayOfDetails(System.JSONParser p) {
    List<Details> res = new List<Details>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Details(p));
    }
    return res;
  }

  private static List<Lines> arrayOfLines(System.JSONParser p) {
    List<Lines> res = new List<Lines>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Lines(p));
    }
    return res;
  }

  private static List<Summary> arrayOfSummary(System.JSONParser p) {
    List<Summary> res = new List<Summary>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Summary(p));
    }
    return res;
  }

  private static List<TaxDetailsByTaxType> arrayOfTaxDetailsByTaxType(
    System.JSONParser p
  ) {
    List<TaxDetailsByTaxType> res = new List<TaxDetailsByTaxType>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new TaxDetailsByTaxType(p));
    }
    return res;
  }

  private static List<NonPassthroughDetails> arrayOfNonPassthroughDetails(
    System.JSONParser p
  ) {
    List<NonPassthroughDetails> res = new List<NonPassthroughDetails>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new NonPassthroughDetails(p));
    }
    return res;
  }
}