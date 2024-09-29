public class VertexTaxResponse{
	public cls_data data;
	public cls_meta meta;
	public class cls_data {
		public cls_currency currency_z;
		public cls_customer customer;
		public String documentDate;	
		public String documentNumber;	
		public cls_lineItems[] lineItems;
		public String postingDate;	
		public boolean returnAssistedParametersIndicator;
		public boolean roundAtLineLevel;
		public String saleMessageType;	
		public cls_seller seller;
		public Double subTotal;	
		public String taxPointDate;	
		public Double total;	
		public Double totalTax;	
		public String transactionId;	
		public String transactionType;	
	}
	public class cls_currency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_customer {
		public cls_administrativeDestination administrativeDestination;
		public cls_customerCode customerCode;
		public cls_destination destination;
		public boolean isTaxExempt;
		public cls_taxRegistrations[] taxRegistrations;
	}
	public class cls_administrativeDestination {
		public String city;	
		public String country;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String taxAreaId;	
	}
	public class cls_customerCode {
		public String classCode;	
		public boolean isBusinessIndicator;
		public String value;	
	}
	public class cls_destination {
		public String city;	
		public String country;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String taxAreaId;	
	}
	public class cls_taxRegistrations {
	}
	public class cls_lineItems {
		public cls_customer customer;
		public Double extendedPrice;	
		public Double fairMarketValue;
		public String lineItemId;	
		public Integer lineItemNumber;	
		public cls_product product;
		public cls_quantity quantity;
		public cls_seller seller;
		public boolean taxIncludedIndicator;
		public cls_taxes[] taxes;
		public Double totalTax;	
		public String transactionType;	
		public String usage;	
	}
	public class cls_product {
		public String productClass;	
		public String value;	
	}
	public class cls_quantity {
		public Double value;	
	}
	public class cls_seller {
		public cls_administrativeOrigin administrativeOrigin;
		public String company;	
		public cls_physicalOrigin physicalOrigin;
		public cls_taxRegistrations[] taxRegistrations;
	}
	public class cls_administrativeOrigin {
		public String city;	
		public String country;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String taxAreaId;	
	}
	public class cls_physicalOrigin {
		public String city;	
		public String country;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String taxAreaId;	
	}
    public class cls_taxes {
		public Double calculatedTax;	
		public cls_calculationRuleId calculationRuleId;
		public Double effectiveRate;	
		public Double exempt;	
		public cls_imposition imposition;
		public cls_impositionType impositionType;
		public boolean isService;
		public cls_jurisdiction jurisdiction;
		public boolean maxTaxIndicator;
		public Double nominalRate;	
		public Double nonTaxable;	
		public boolean notRegisteredIndicator;
		public String situs;	
		public String taxCollectedFromParty;	
		public String taxResult;	
		public String taxStructure;
		public String taxType;
		public Double taxable;	
	}
	public class cls_calculationRuleId {
		public boolean salesTaxHolidayIndicator;
		public boolean userDefined;
		public String value;	
	}
	public class cls_imposition {
		public String impositionId;	
		public boolean userDefined;
		public String value;	
	}
	public class cls_impositionType {
		public String impositionTypeId;	
		public boolean userDefined;
		public String value;	
	}
	public class cls_jurisdiction {
		public String effectiveDate;	
		public String expirationDate;	
		public String jurisdictionId;	
		public String jurisdictionType;	
		public String value;	
	}
	public class cls_meta {
		public String app;
		public Integer timeElapsed;	
		public String timeReceived;
	}
	public static VertexTaxResponse parse(String json){
		return (VertexTaxResponse) System.JSON.deserialize(json, VertexTaxResponse.class);
	}
}