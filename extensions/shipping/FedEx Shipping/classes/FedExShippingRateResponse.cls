public class FedExShippingRateResponse {
  public class ShipmentRateDetail_Z {
    public String rateZone { get; set; }
    public Integer dimDivisor { get; set; }
    public Double fuelSurchargePercent { get; set; }
    public Double totalSurcharges { get; set; }
    public Double totalFreightDiscount { get; set; }
    public List<SurCharges_Z> surCharges { get; set; }
    public TotalBillingWeight totalBillingWeight { get; set; }
    public String currency_Z { get; set; } // in json: currency

    public ShipmentRateDetail_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateZone') {
              rateZone = parser.getText();
            } else if (text == 'dimDivisor') {
              dimDivisor = parser.getIntegerValue();
            } else if (text == 'fuelSurchargePercent') {
              fuelSurchargePercent = parser.getDoubleValue();
            } else if (text == 'totalSurcharges') {
              totalSurcharges = parser.getDoubleValue();
            } else if (text == 'totalFreightDiscount') {
              totalFreightDiscount = parser.getDoubleValue();
            } else if (text == 'surCharges') {
              surCharges = arrayOfSurCharges_Z(parser);
            } else if (text == 'totalBillingWeight') {
              totalBillingWeight = new TotalBillingWeight(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'ShipmentRateDetail_Z consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class RatedPackages_Z {
    public Integer groupNumber { get; set; }
    public Double effectiveNetDiscount { get; set; }
    public PackageRateDetail_Z packageRateDetail { get; set; }

    public RatedPackages_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'groupNumber') {
              groupNumber = parser.getIntegerValue();
            } else if (text == 'effectiveNetDiscount') {
              effectiveNetDiscount = parser.getDoubleValue();
            } else if (text == 'packageRateDetail') {
              packageRateDetail = new PackageRateDetail_Z(parser);
            } else {
              System.debug(
                LoggingLevel.WARN,
                'RatedPackages_Z consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public String transactionId { get; set; }
  public String customerTransactionId { get; set; }
  public Output output { get; set; }

  public FedExShippingRateResponse(JSONParser parser) {
    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
      if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
        String text = parser.getText();
        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
          if (text == 'transactionId') {
            transactionId = parser.getText();
          } else if (text == 'customerTransactionId') {
            customerTransactionId = parser.getText();
          } else if (text == 'output') {
            output = new Output(parser);
          } else {
            System.debug(
              LoggingLevel.WARN,
              'FedExShippingRateResponse consuming unrecognized property: ' +
              text
            );
            consumeObject(parser);
          }
        }
      }
    }
  }

  public class ServiceDescription_Z {
    public String serviceId { get; set; }
    public String serviceType { get; set; }
    public String code { get; set; }
    public List<Names> names { get; set; }
    public String description { get; set; }
    public String astraDescription { get; set; }

    public ServiceDescription_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'serviceId') {
              serviceId = parser.getText();
            } else if (text == 'serviceType') {
              serviceType = parser.getText();
            } else if (text == 'code') {
              code = parser.getText();
            } else if (text == 'names') {
              names = arrayOfNames(parser);
            } else if (text == 'description') {
              description = parser.getText();
            } else if (text == 'astraDescription') {
              astraDescription = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'ServiceDescription_Z consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class ServiceDescription {
    public String serviceId { get; set; }
    public String serviceType { get; set; }
    public String code { get; set; }
    public List<Names> names { get; set; }
    public String serviceCategory { get; set; }
    public String description { get; set; }
    public String astraDescription { get; set; }

    public ServiceDescription(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'serviceId') {
              serviceId = parser.getText();
            } else if (text == 'serviceType') {
              serviceType = parser.getText();
            } else if (text == 'code') {
              code = parser.getText();
            } else if (text == 'names') {
              names = arrayOfNames(parser);
            } else if (text == 'serviceCategory') {
              serviceCategory = parser.getText();
            } else if (text == 'description') {
              description = parser.getText();
            } else if (text == 'astraDescription') {
              astraDescription = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'ServiceDescription consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class PackageRateDetail_Z {
    public String rateType { get; set; }
    public String ratedWeightMethod { get; set; }
    public Double baseCharge { get; set; }
    public Double netFreight { get; set; }
    public Double totalSurcharges { get; set; }
    public Double netFedExCharge { get; set; }
    public Double totalTaxes { get; set; }
    public Double netCharge { get; set; }
    public Double totalRebates { get; set; }
    public TotalBillingWeight billingWeight { get; set; }
    public Double totalFreightDiscounts { get; set; }
    public List<SurCharges_Z> surcharges { get; set; }
    public String currency_Z { get; set; } // in json: currency

    public PackageRateDetail_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'ratedWeightMethod') {
              ratedWeightMethod = parser.getText();
            } else if (text == 'baseCharge') {
              baseCharge = parser.getDoubleValue();
            } else if (text == 'netFreight') {
              netFreight = parser.getDoubleValue();
            } else if (text == 'totalSurcharges') {
              totalSurcharges = parser.getDoubleValue();
            } else if (text == 'netFedExCharge') {
              netFedExCharge = parser.getDoubleValue();
            } else if (text == 'totalTaxes') {
              totalTaxes = parser.getDoubleValue();
            } else if (text == 'netCharge') {
              netCharge = parser.getDoubleValue();
            } else if (text == 'totalRebates') {
              totalRebates = parser.getDoubleValue();
            } else if (text == 'billingWeight') {
              billingWeight = new TotalBillingWeight(parser);
            } else if (text == 'totalFreightDiscounts') {
              totalFreightDiscounts = parser.getDoubleValue();
            } else if (text == 'surcharges') {
              surcharges = arrayOfSurCharges_Z(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'PackageRateDetail_Z consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class OperationalDetail {
    public Boolean ineligibleForMoneyBackGuarantee { get; set; }
    public String astraDescription { get; set; }
    public String airportId { get; set; }
    public String serviceCode { get; set; }

    public OperationalDetail(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'ineligibleForMoneyBackGuarantee') {
              ineligibleForMoneyBackGuarantee = parser.getBooleanValue();
            } else if (text == 'astraDescription') {
              astraDescription = parser.getText();
            } else if (text == 'airportId') {
              airportId = parser.getText();
            } else if (text == 'serviceCode') {
              serviceCode = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'OperationalDetail consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class RatedPackages {
    public Integer groupNumber { get; set; }
    public Double effectiveNetDiscount { get; set; }
    public PackageRateDetail packageRateDetail { get; set; }

    public RatedPackages(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'groupNumber') {
              groupNumber = parser.getIntegerValue();
            } else if (text == 'effectiveNetDiscount') {
              effectiveNetDiscount = parser.getDoubleValue();
            } else if (text == 'packageRateDetail') {
              packageRateDetail = new PackageRateDetail(parser);
            } else {
              System.debug(
                LoggingLevel.WARN,
                'RatedPackages consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class RatedShipmentDetails {
    public String rateType { get; set; }
    public String ratedWeightMethod { get; set; }
    public Double totalDiscounts { get; set; }
    public Double totalBaseCharge { get; set; }
    public Double totalNetCharge { get; set; }
    public Double totalNetFedExCharge { get; set; }
    public ShipmentRateDetail shipmentRateDetail { get; set; }
    public List<RatedPackages> ratedPackages { get; set; }
    public String currency_Z { get; set; } // in json: currency

    public RatedShipmentDetails(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'ratedWeightMethod') {
              ratedWeightMethod = parser.getText();
            } else if (text == 'totalDiscounts') {
              totalDiscounts = parser.getDoubleValue();
            } else if (text == 'totalBaseCharge') {
              totalBaseCharge = parser.getDoubleValue();
            } else if (text == 'totalNetCharge') {
              totalNetCharge = parser.getDoubleValue();
            } else if (text == 'totalNetFedExCharge') {
              totalNetFedExCharge = parser.getDoubleValue();
            } else if (text == 'shipmentRateDetail') {
              shipmentRateDetail = new ShipmentRateDetail(parser);
            } else if (text == 'ratedPackages') {
              ratedPackages = arrayOfRatedPackages(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'RatedShipmentDetails consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class RatedShipmentDetails_Z {
    public String rateType { get; set; }
    public String ratedWeightMethod { get; set; }
    public Double totalDiscounts { get; set; }
    public Double totalBaseCharge { get; set; }
    public Double totalNetCharge { get; set; }
    public Double totalNetFedExCharge { get; set; }
    public ShipmentRateDetail_Z shipmentRateDetail { get; set; }
    public List<RatedPackages_Z> ratedPackages { get; set; }
    public String currency_Z { get; set; } // in json: currency

    public RatedShipmentDetails_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'ratedWeightMethod') {
              ratedWeightMethod = parser.getText();
            } else if (text == 'totalDiscounts') {
              totalDiscounts = parser.getDoubleValue();
            } else if (text == 'totalBaseCharge') {
              totalBaseCharge = parser.getDoubleValue();
            } else if (text == 'totalNetCharge') {
              totalNetCharge = parser.getDoubleValue();
            } else if (text == 'totalNetFedExCharge') {
              totalNetFedExCharge = parser.getDoubleValue();
            } else if (text == 'shipmentRateDetail') {
              shipmentRateDetail = new ShipmentRateDetail_Z(parser);
            } else if (text == 'ratedPackages') {
              ratedPackages = arrayOfRatedPackages_Z(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'RatedShipmentDetails_Z consuming unrecognized property: ' +
                text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class SurCharges {
    public String type { get; set; }
    public String description { get; set; }
    public Double amount { get; set; }

    public SurCharges(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'type') {
              type = parser.getText();
            } else if (text == 'description') {
              description = parser.getText();
            } else if (text == 'amount') {
              amount = parser.getDoubleValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'SurCharges consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Names {
    public String type { get; set; }
    public String encoding { get; set; }
    public String value { get; set; }

    public Names(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'type') {
              type = parser.getText();
            } else if (text == 'encoding') {
              encoding = parser.getText();
            } else if (text == 'value') {
              value = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Names consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class ShipmentRateDetail {
    public String rateZone { get; set; }
    public Integer dimDivisor { get; set; }
    public Double fuelSurchargePercent { get; set; }
    public Double totalSurcharges { get; set; }
    public Double totalFreightDiscount { get; set; }
    public List<SurCharges> surCharges { get; set; }
    public String pricingCode { get; set; }
    public TotalBillingWeight totalBillingWeight { get; set; }
    public String currency_Z { get; set; } // in json: currency
    public String rateScale { get; set; }

    public ShipmentRateDetail(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateZone') {
              rateZone = parser.getText();
            } else if (text == 'dimDivisor') {
              dimDivisor = parser.getIntegerValue();
            } else if (text == 'fuelSurchargePercent') {
              fuelSurchargePercent = parser.getDoubleValue();
            } else if (text == 'totalSurcharges') {
              totalSurcharges = parser.getDoubleValue();
            } else if (text == 'totalFreightDiscount') {
              totalFreightDiscount = parser.getDoubleValue();
            } else if (text == 'surCharges') {
              surCharges = arrayOfSurCharges(parser);
            } else if (text == 'pricingCode') {
              pricingCode = parser.getText();
            } else if (text == 'totalBillingWeight') {
              totalBillingWeight = new TotalBillingWeight(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else if (text == 'rateScale') {
              rateScale = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'ShipmentRateDetail consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class PackageRateDetail {
    public String rateType { get; set; }
    public String ratedWeightMethod { get; set; }
    public Double baseCharge { get; set; }
    public Double netFreight { get; set; }
    public Double totalSurcharges { get; set; }
    public Double netFedExCharge { get; set; }
    public Double totalTaxes { get; set; }
    public Double netCharge { get; set; }
    public Double totalRebates { get; set; }
    public TotalBillingWeight billingWeight { get; set; }
    public Double totalFreightDiscounts { get; set; }
    public List<SurCharges> surcharges { get; set; }
    public String currency_Z { get; set; } // in json: currency

    public PackageRateDetail(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'rateType') {
              rateType = parser.getText();
            } else if (text == 'ratedWeightMethod') {
              ratedWeightMethod = parser.getText();
            } else if (text == 'baseCharge') {
              baseCharge = parser.getDoubleValue();
            } else if (text == 'netFreight') {
              netFreight = parser.getDoubleValue();
            } else if (text == 'totalSurcharges') {
              totalSurcharges = parser.getDoubleValue();
            } else if (text == 'netFedExCharge') {
              netFedExCharge = parser.getDoubleValue();
            } else if (text == 'totalTaxes') {
              totalTaxes = parser.getDoubleValue();
            } else if (text == 'netCharge') {
              netCharge = parser.getDoubleValue();
            } else if (text == 'totalRebates') {
              totalRebates = parser.getDoubleValue();
            } else if (text == 'billingWeight') {
              billingWeight = new TotalBillingWeight(parser);
            } else if (text == 'totalFreightDiscounts') {
              totalFreightDiscounts = parser.getDoubleValue();
            } else if (text == 'surcharges') {
              surcharges = arrayOfSurCharges(parser);
            } else if (text == 'currency') {
              currency_Z = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'PackageRateDetail consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class RateReplyDetails {
    public String serviceType { get; set; }
    public String serviceName { get; set; }
    public String packagingType { get; set; }
    public List<RatedShipmentDetails> ratedShipmentDetails { get; set; }
    public List<RatedShipmentDetails_Z> ratedShipmentDetails_Z { get; set; }
    public OperationalDetail operationalDetail { get; set; }
    public String signatureOptionType { get; set; }
    public ServiceDescription serviceDescription { get; set; }

    public RateReplyDetails(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'serviceType') {
              serviceType = parser.getText();
            } else if (text == 'serviceName') {
              serviceName = parser.getText();
            } else if (text == 'packagingType') {
              packagingType = parser.getText();
            } else if (text == 'ratedShipmentDetails') {
              ratedShipmentDetails = arrayOfRatedShipmentDetails(parser);
            } else if (text == 'ratedShipmentDetails_Z') {
              ratedShipmentDetails_Z = arrayOfRatedShipmentDetails_Z(parser);
            } else if (text == 'operationalDetail') {
              operationalDetail = new OperationalDetail(parser);
            } else if (text == 'signatureOptionType') {
              signatureOptionType = parser.getText();
            } else if (text == 'serviceDescription') {
              serviceDescription = new ServiceDescription(parser);
            } else {
              System.debug(
                LoggingLevel.WARN,
                'RateReplyDetails consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class TotalBillingWeight {
    public String units { get; set; }
    public Double value { get; set; }

    public TotalBillingWeight(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'units') {
              units = parser.getText();
            } else if (text == 'value') {
              value = parser.getDoubleValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'TotalBillingWeight consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Output {
    public List<Alerts> alerts { get; set; }
    public List<RateReplyDetails> rateReplyDetails { get; set; }
    public String quoteDate { get; set; }
    public Boolean encoded { get; set; }

    public Output(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'alerts') {
              alerts = arrayOfAlerts(parser);
            } else if (text == 'rateReplyDetails') {
              rateReplyDetails = arrayOfRateReplyDetails(parser);
            } else if (text == 'quoteDate') {
              quoteDate = parser.getText();
            } else if (text == 'encoded') {
              encoded = parser.getBooleanValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Output consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Alerts {
    public String code { get; set; }
    public String message { get; set; }
    public String alertType { get; set; }

    public Alerts(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'code') {
              code = parser.getText();
            } else if (text == 'message') {
              message = parser.getText();
            } else if (text == 'alertType') {
              alertType = parser.getText();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'Alerts consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class SurCharges_Z {
    public String type { get; set; }
    public String description { get; set; }
    public String level { get; set; }
    public Double amount { get; set; }

    public SurCharges_Z(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'type') {
              type = parser.getText();
            } else if (text == 'description') {
              description = parser.getText();
            } else if (text == 'level') {
              level = parser.getText();
            } else if (text == 'amount') {
              amount = parser.getDoubleValue();
            } else {
              System.debug(
                LoggingLevel.WARN,
                'SurCharges_Z consuming unrecognized property: ' + text
              );
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public static FedExShippingRateResponse parse(String json) {
    System.JSONParser parser = System.JSON.createParser(json);
    return new FedExShippingRateResponse(parser);
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

  private static List<Alerts> arrayOfAlerts(System.JSONParser p) {
    List<Alerts> res = new List<Alerts>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Alerts(p));
    }
    return res;
  }

  private static List<RatedPackages_Z> arrayOfRatedPackages_Z(
    System.JSONParser p
  ) {
    List<RatedPackages_Z> res = new List<RatedPackages_Z>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new RatedPackages_Z(p));
    }
    return res;
  }

  private static List<SurCharges> arrayOfSurCharges(System.JSONParser p) {
    List<SurCharges> res = new List<SurCharges>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new SurCharges(p));
    }
    return res;
  }

  private static List<RatedShipmentDetails_Z> arrayOfRatedShipmentDetails_Z(
    System.JSONParser p
  ) {
    List<RatedShipmentDetails_Z> res = new List<RatedShipmentDetails_Z>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new RatedShipmentDetails_Z(p));
    }
    return res;
  }

  private static List<Names> arrayOfNames(System.JSONParser p) {
    List<Names> res = new List<Names>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new Names(p));
    }
    return res;
  }

  private static List<RatedShipmentDetails> arrayOfRatedShipmentDetails(
    System.JSONParser p
  ) {
    List<RatedShipmentDetails> res = new List<RatedShipmentDetails>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new RatedShipmentDetails(p));
    }
    return res;
  }

  private static List<RateReplyDetails> arrayOfRateReplyDetails(
    System.JSONParser p
  ) {
    List<RateReplyDetails> res = new List<RateReplyDetails>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new RateReplyDetails(p));
    }
    return res;
  }

  private static List<SurCharges_Z> arrayOfSurCharges_Z(System.JSONParser p) {
    List<SurCharges_Z> res = new List<SurCharges_Z>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new SurCharges_Z(p));
    }
    return res;
  }

  private static List<RatedPackages> arrayOfRatedPackages(System.JSONParser p) {
    List<RatedPackages> res = new List<RatedPackages>();
    if (p.getCurrentToken() == null)
      p.nextToken();
    while (p.nextToken() != System.JSONToken.END_ARRAY) {
      res.add(new RatedPackages(p));
    }
    return res;
  }
}