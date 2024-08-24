global with sharing class UPSShippingRateResponse {
  global class Response {
    global ResponseStatus ResponseStatus;
    //global List<ResponseStatus> Alert;
    global TransactionReference TransactionReference;
  }

  global class TransactionReference {
    global String CustomerContext;
  }

  global RateResponse RateResponse;

  global class ResponseStatus {
    global String Code;
    global String Description;
  }

  global class BillingWeight {
    global ResponseStatus UnitOfMeasurement;
    global String Weight;
  }

  global class GuaranteedDelivery {
    global String BusinessDaysInTransit;
  }

  global class RateResponse {
    global Response Response;
    global List<RatedShipment> RatedShipment;
  }

  global class TransportationCharges {
    global String CurrencyCode;
    global String MonetaryValue;
  }

  global class RatedPackage {
    global TransportationCharges TransportationCharges;
    global TransportationCharges ServiceOptionsCharges;
    global TransportationCharges TotalCharges;
    global String Weight;
    global BillingWeight BillingWeight;
  }

  global class GuaranteedDelivery_Z {
    global String BusinessDaysInTransit;
    global String DeliveryByTime;
  }

  global class RatedShipment {
    global ResponseStatus Service;
    //global List<ResponseStatus> RatedShipmentAlert;
    global BillingWeight BillingWeight;
    global TransportationCharges TransportationCharges;
    global TransportationCharges ServiceOptionsCharges;
    global TransportationCharges TotalCharges;
    global RatedPackage RatedPackage;
    global GuaranteedDelivery GuaranteedDelivery;
  }

  global static UPSShippingRateResponse parse(String json) {
    return (UPSShippingRateResponse) System.JSON.deserialize(
      json,
      UPSShippingRateResponse.class
    );
  }
}