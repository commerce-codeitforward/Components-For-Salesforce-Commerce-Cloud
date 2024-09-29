public without sharing class LineItemTaxDetails {
    public LineItemTaxDetails() {

    }

    public  Decimal rate  { get; set; }
    public  Decimal tax  { get; set; }
    public String taxName { get; set; }
    public String taxType { get; set; }
    
}