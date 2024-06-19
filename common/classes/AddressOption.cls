public class AddressOption {
    // Property for the label of the country, maximum of 80 characters
    @AuraEnabled public String label { get; set; }

    // Property for the value of the country code, exactly 2 characters
    @AuraEnabled  public String value { get; set; }

    // Property for the ID, exactly 18 characters
    @AuraEnabled public String id { get; set; }

    // Constructor to initialize the CountryCode object
    public AddressOption(String label, String value, String id) {
        this.label = label;
        this.value = value;
        this.id = id;
    }
}