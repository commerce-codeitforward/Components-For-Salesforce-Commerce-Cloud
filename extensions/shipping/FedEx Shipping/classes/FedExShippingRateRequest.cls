public class FedExShippingRateRequest {
  public AccountNumber accountNumber;
  public RequestedShipment requestedShipment;

  public class Address {
    public String postalCode;
    public String countryCode;
  }

  public class Shipper {
    public Address address;
  }

  public class RequestedPackageLineItems {
    public Weight weight;
  }

  public class RequestedShipment {
    public Shipper shipper;
    public Shipper recipient;
    public String pickupType;
    public List<String> rateRequestType;
    public List<RequestedPackageLineItems> requestedPackageLineItems;
  }

  public class Weight {
    public String units;
    public Decimal value;
  }

  public class AccountNumber {
    public String value;
  }

  public static FedExShippingRateRequest parse(String json) {
    return (FedExShippingRateRequest) System.JSON.deserialize(
      json,
      FedExShippingRateRequest.class
    );
  }
}