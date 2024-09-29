public with sharing class ShippingMetaData {
  public ID id { get; set; }
  public String requestJSON { get; set; }
  public String providerImplClass { get; set; }
  public Decimal maxPackageWeight { get; set; }
  public Decimal minPackageWeight { get; set; }
  public String accountNumber { get; set; }
  public Integer displayOrder { get; set; }
  public String carrier { get; set; }
  public String shippinggMethodNames { get; set; }
  public String endPoint { get; set; }
  public String httpMethod { get; set; }
  public String mockedResponse { get; set; }
  public String serviceMode { get; set; }
  public String serviceTimeout { get; set; }
  public String serviceImplClass { get; set; }
  public String namedCredentials { get; set; }
  private Map<String, Object> additionalMeataData = new Map<String, Object>();

  public Object getMetaData(String key) {
    return additionalMeataData.get(key);
  }

  public void addMetaData(String key, Object value) {
    additionalMeataData.put(key, value);
  }
}