public with sharing class TaxableCartItem {
  public TaxableCartItem() {
  }

  public String id { get; set; }
  public Decimal amount { get; set; }
  public Decimal quantity { get; set; }
  public String sku { get; set; }
  public String lineItemType { get; set; }
  public String taxClassId { get; set; }
  public String productExemptionCode { get; set; }
  public String entityUseCode { get; set; }
  public String street { get; set; }
  public String city { get; set; }
  public String state { get; set; }
  public String postalCode { get; set; }
  public String country { get; set;}
  public List<LineItemTaxDetails> lineItemTexas = new List<LineItemTaxDetails>();
}