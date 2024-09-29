public without sharing class VertexTaxRequest{
	public String accumulationCustomerNumber;	
	public String accumulationDocumentNumber;	
	public String billingType;	
	public cls_companyCodeCurrency companyCodeCurrency;
	public cls_currency currency_z;
	public cls_currencyConversionFactors[] currencyConversionFactors;
	public cls_customer customer;
	public String deliveryTerm;	
	public cls_discount discount;
	public String documentDate;	
	public String documentNumber;	
	public String documentSequenceId;	
	public String documentType;	
	public cls_exemptOverrides[] exemptOverrides;
	public cls_impositionInclusions[] impositionInclusions;
	public boolean isTaxOnlyAdjustmentIndicator;
	public cls_lineItems[] lineItems;
	public String locationCode;	
	public cls_nonTaxableOverrides[] nonTaxableOverrides;
	public String orderType;	
	public cls_originalCurrency originalCurrency;
	public String paymentDate;	
	public boolean postToJournal;
	public String postingDate;	
	public Integer proratePercentage;	
	public cls_rateOverrides[] rateOverrides;
	public boolean returnAssistedParametersIndicator;
	public boolean returnGeneratedLineItemsIndicator;
	public boolean returnTimeElapsedDetailsIndicator;
	public boolean roundAtLineLevel;
	public String saleMessageType;	
	public cls_seller seller;
	public String simplificationCode;	
	public cls_situsOverride situsOverride;
	public cls_taxOverride taxOverride;
	public String taxPointDate;	
	public String transactionId;	
	public String transactionType;	
	public class cls_companyCodeCurrency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_currency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_currencyConversionFactors {
		public Integer conversionFactor;	
		public cls_sourceCurrency sourceCurrency;
		public cls_targetCurrency targetCurrency;
	}
	public class cls_sourceCurrency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_targetCurrency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_customer {
		public cls_administrativeDestination administrativeDestination;
		public cls_customerCode customerCode;
		public cls_destination destination;
		public cls_exemptionCertificate exemptionCertificate;
		public String exemptionReasonCode;	
		public boolean isTaxExempt;
		public cls_taxRegistrations[] taxRegistrations;
	}
	public class cls_administrativeDestination {
		public String city;	
		public String country;	
		public cls_currencyConversion currencyConversion;
		public String externalJurisdictionCode;	
		public String latitude;	
		public String locationCode;	
		public String locationCustomsStatus;	
		public String longitude;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String streetAddress2;	
		public String subDivision;	
		public String taxAreaId;	
	}
	public class cls_currencyConversion {
		public cls_currency currency_z;
		public Double rate;	
	}
	public class cls_customerCode {
		public String classCode;	
		public boolean isBusinessIndicator;
		public String value;	
	}
	public class cls_destination {
		public String city;	
		public String country;	
		public cls_currencyConversion currencyConversion;
		public String externalJurisdictionCode;	
		public String latitude;	
		public String locationCode;	
		public String locationCustomsStatus;	
		public String longitude;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String streetAddress2;	
		public String subDivision;	
		public String taxAreaId;	
	}
	public class cls_exemptionCertificate {
		public String exemptionCertificateNumber;	
		public String value;	
	}
	public class cls_taxRegistrations {
		public boolean hasPhysicalPresenceIndicator;
		public cls_impositionType impositionType;
		public String isoCountryCode;	
		public String jurisdictionId;	
		public String mainDivision;	
		public cls_nexusOverrides[] nexusOverrides;
		public cls_physicalLocations[] physicalLocations;
		public String taxRegistrationNumber;	
		public cls_filingCurrency filingCurrency;
		public String taxRegistrationType;	
	}
	public class cls_impositionType {
		public String impositionTypeId;	
		public boolean userDefined;
		public String value;	
		public String withholdingType;	
	}
	public class cls_nexusOverrides {
		public boolean city;
		public boolean country;
		public boolean district;
		public String locationRole;	
		public boolean mainDivision;
		public boolean subDivision;
	}
	public class cls_physicalLocations {
		public String city;	
		public String country;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String streetAddress2;	
		public String subDivision;	
		public String taxAreaId;	
	}
	public class cls_filingCurrency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public class cls_discount {
		public String discountType;
		public Integer discountValue;	
		public String userDefinedDiscountCode;	
	}
	public class cls_exemptOverrides {
		public Integer amount;	
		public cls_impositionType impositionType;
		public String jurisdictionType;	
		public String reasonCode;	
	}
	public class cls_impositionInclusions {
		public cls_impositionType impositionType;
		public String jurisdictionType;	
	}
	public class cls_lineItems {
		public Double amountBilledToDate;	
		public String chainTransactionPhase;	
		public cls_commodityCode commodityCode;
		public Double companyCodeCurrencyTaxAmount;	
		public Double companyCodeCurrencyTaxableAmount;	
		public Double cost;	
		public String costCenter;	
		public String countryOfOriginISOCode;	
		public cls_customer customer;
		public String deliveryTerm;	
		public String departmentCode;	
		public cls_discount discount;
		public cls_exemptOverrides[] exemptOverrides;
		public String exportProcedure;	
		public Double extendedPrice;	
		public Double fairMarketValue;	
		public cls_flexibleFields flexibleFields;
		public Double freight;	
		public String generalLedgerAccount;	
		public cls_impositionInclusions[] impositionInclusions;
		public Double inputTotalTax;	
		public String intrastatCommodityCode;	
		public boolean isMulticomponent;
		public Double landedCost;	
		public String lineItemId;	
		public Integer lineItemNumber;	
		public cls_lineType lineType;
		public cls_lineTypes[] lineTypes;
		public String locationCode;	
		public String materialCode;	
		public String materialOrigin;	
		public Integer modeOfTransport;	
		public Integer natureOfTransaction;	
		public Integer netMassKilograms;	
		public cls_nonTaxableOverrides[] nonTaxableOverrides;
		public cls_product product;
		public String projectNumber;	
		public cls_quantity quantity;
		public cls_rateOverrides[] rateOverrides;
		public cls_returnsFields returnsFields;
		public cls_seller seller;
		public String simplificationCode;	
		public cls_situsOverride situsOverride;
		public cls_statisticalValue statisticalValue;
		public cls_supplementaryUnit supplementaryUnit;
		public Double previousTaxPaid;	
		public String taxDate;	
		public boolean taxIncludedIndicator;
		public cls_taxOverride taxOverride;
		public String titleTransfer;	
		public String transactionType;	
		public Double unitPrice;	
		public String usage;	
		public String usageClass;	
		public String vendorSKU;	
		public cls_volume volume;
		public cls_weight weight;
	}
	public class cls_commodityCode {
		public String commodityCodeType;	
		public String value;	
	}
	public class cls_flexibleFields {
		public cls_flexibleCodeFields[] flexibleCodeFields;
		public cls_flexibleDateFields[] flexibleDateFields;
		public cls_flexibleNumericFields[] flexibleNumericFields;
	}
	public class cls_flexibleCodeFields {
		public Integer fieldId;	
		public String value;	
	}
	public class cls_flexibleDateFields {
		public Integer fieldId;	
		public String value;	
	}
	public class cls_flexibleNumericFields {
		public Integer fieldId;	
		public Integer value;	
	}
	public class cls_lineType {
		public String accumulationLocation;	
		public String content;	
		public String direction;	
		public String status;	
		public String value;	
	}
	public class cls_lineTypes {
		public String accumulationLocation;	
		public String basis;	
		public String content;	
		public Double count;	
		public String direction;	
		public Integer lineTypeNumber;	
		public String status;	
		public String value;	
	}
	public class cls_nonTaxableOverrides {
		public Double amount;	
		public cls_impositionType impositionType;
		public String jurisdictionType;	
		public String reasonCode;	
	}
	public class cls_product {
		public String productClass;	
		public String value;	
	}
	public class cls_quantity {
		public String unitOfMeasure;	
		public Double value;	
	}
	public class cls_rateOverrides {
		public cls_impositionType impositionType;
		public String jurisdictionType;	
		public Double rate;	
	}
	public class cls_returnsFields {
		public cls_returnsCodeFields[] returnsCodeFields;
		public cls_returnsDateFields[] returnsDateFields;
		public cls_returnsIndicatorFields[] returnsIndicatorFields;
		public cls_returnsNumericFields[] returnsNumericFields;
	}
	public class cls_returnsCodeFields {
		public String name;	
		public String value;	
	}
	public class cls_returnsDateFields {
		public String name;	
		public String value;	
	}
	public class cls_returnsIndicatorFields {
		public String name;	
		public boolean value;
	}
	public class cls_returnsNumericFields {
		public String name;	
		public Integer value;	
	}
	public class cls_seller {
		public cls_administrativeOrigin administrativeOrigin;
		public String company;	
		public String department;	
		public cls_dispatcher dispatcher;
		public String division;	
		public boolean nexusIndicator;
		public String nexusReasonCode;	
		public cls_physicalOrigin physicalOrigin;
		public cls_taxRegistrations[] taxRegistrations;
		public String utilityProvider;	
	}
	public class cls_administrativeOrigin {
		public String city;	
		public String country;	
		public cls_currencyConversion currencyConversion;
		public String externalJurisdictionCode;	
		public String latitude;	
		public String locationCode;	
		public String locationCustomsStatus;	
		public String longitude;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String streetAddress2;	
		public String subDivision;	
		public String taxAreaId;	
	}
	public class cls_dispatcher {
		public cls_dispatcherCode dispatcherCode;
		public cls_taxRegistrations[] taxRegistrations;
	}
	public class cls_dispatcherCode {
		public String classCode;	
		public String value;	
	}
	public class cls_physicalOrigin {
		public String city;	
		public String country;	
		public cls_currencyConversion currencyConversion;
		public String externalJurisdictionCode;	
		public String latitude;	
		public String locationCode;	
		public String locationCustomsStatus;	
		public String longitude;	
		public String mainDivision;	
		public String postalCode;	
		public String streetAddress1;	
		public String streetAddress2;	
		public String subDivision;	
		public String taxAreaId;	
	}
	public class cls_situsOverride {
		public String taxingLocation;	
	}
	public class cls_statisticalValue {
		public Integer amount;	
		public cls_currency currency_z;
	}
	public class cls_supplementaryUnit {
		public String unitType;	
		public Integer value;	
	}
	public class cls_taxOverride {
		public String overrideReasonCode;	
		public String overrideType;	
	}
	public class cls_volume {
		public String unitOfMeasure;	
		public Double value;	
	}
	public class cls_weight {
		public String unitOfMeasure;	
		public Double value;	
	}
	public class cls_originalCurrency {
		public String isoCurrencyCodeAlpha;	
		public Integer isoCurrencyCodeNum;	
		public String isoCurrencyName;	
	}
	public static VertexTaxRequest parse(String json){
		return (VertexTaxRequest) System.JSON.deserialize(json, VertexTaxRequest.class);
	}
}