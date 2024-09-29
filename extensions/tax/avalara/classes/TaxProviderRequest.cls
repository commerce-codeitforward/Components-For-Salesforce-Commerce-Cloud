public with sharing class TaxProviderRequest {
  public TaxProviderRequest() {
  }

  public String cartId { get; set; }
  public String orderNo { get; set; }
  public String street { get; set; }
  public String city { get; set; }
  public String state { get; set; }
  public String postalCode { get; set; }
  public String country { get; set; }
  public Boolean hasMultipleShipments { get; set; }
  public String taxTransacionType { get; set; }
  public String customerTaxId { get; set; }
  public TaxMetaData taxMetaData { get; set; }
  public String webStoreId { get; set; }
  public String taxTransactionId { get; set; }
  public String customerExemptionCode { get; set; }
  public String entityUseCode { get; set; }
  public String currencyCode { get; set; }
  public Map<String, TaxableCartItem> taxableCartItems { get; set; }

  private Map<String, Object> additionalData = new Map<String, Object>();

  public Object getData(String key) {
    return additionalData.get(key);
  }

  public void addData(String key, Object value) {
    additionalData.put(key, value);
  }
}