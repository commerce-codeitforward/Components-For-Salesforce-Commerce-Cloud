public with sharing class ShippingProviderRequest {
  public ShippingProviderRequest() {
  }

  public String street { get; set; }
  public String city { get; set; }
  public String state { get; set; }
  public String postalCode { get; set; }
  public String country { get; set; }
  public String cartId { get; set; }
  public Decimal packageWeight { get; set; }
  public ShippingMetaData shippingMetaData { get; set; }

  private Map<String, Object> additionalData = new Map<String, Object>();

  public Object getData(String key) {
    return additionalData.get(key);
  }

  public void addData(String key, Object value) {
    additionalData.put(key, value);
  }
}