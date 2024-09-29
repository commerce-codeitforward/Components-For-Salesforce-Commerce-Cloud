public class AvalaraTaxRequest {
	
	public class Addresses {
		public ShipFrom shipFrom {get;set;} 
		public ShipFrom shipTo {get;set;} 
		public Addresses() {}
		public Addresses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'shipFrom') {
							shipFrom = new ShipFrom(parser);
						} else if (text == 'shipTo') {
							shipTo = new ShipFrom(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Lines> lines {get;set;} 
	public Addresses addresses {get;set;} 
	public String code {get;set;} 
	public String type {get;set;} 
	public String companyCode {get;set;} 
	public String date_Z {get;set;} // in json: date
	public String salespersonCode {get;set;} 
	public String customerCode {get;set;} 
	public String customerUsageType {get;set;} 
	public String entityUseCode {get;set;} 
	public Integer discount {get;set;} 
	public String exemptionNo {get;set;} 
	public String reportingLocationCode {get;set;} 
	public String purchaseOrderNo {get;set;} 
	public String currencyCode {get;set;} 
	public String description {get;set;} 
	public String referenceCode {get;set;} 
	public Boolean commit_Z {get;set;} // in json: commit
	public String batchCode {get;set;} 
	public String serviceMode {get;set;} 
	public Integer exchangeRate {get;set;} 
	public String exchangeRateEffectiveDate {get;set;} 
	public String exchangeRateCurrencyCode {get;set;} 
	public String posLaneCode {get;set;} 
	public String businessIdentificationNo {get;set;} 
	public Boolean isSellerImporterOfRecord {get;set;} 
	public String email {get;set;} 
	public String debugLevel {get;set;} 
	public String customerSupplierName {get;set;} 
	public Integer dataSourceId {get;set;} 
	public String deliveryTerms {get;set;} 
	public TaxOverride taxOverride {get;set;} 
	public List<Parameters> parameters {get;set;} 
	public List<UserDefinedFields> userDefinedFields {get;set;} 

	public AvalaraTaxRequest() {}
	public AvalaraTaxRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'lines') {
						lines = arrayOfLines(parser);
					} else if (text == 'addresses') {
						addresses = new Addresses(parser);
					} else if (text == 'code') {
						code = parser.getText();
					} else if (text == 'type') {
						type = parser.getText();
					} else if (text == 'companyCode') {
						companyCode = parser.getText();
					} else if (text == 'date') {
						date_Z = parser.getText();
					} else if (text == 'salespersonCode') {
						salespersonCode = parser.getText();
					} else if (text == 'customerCode') {
						customerCode = parser.getText();
					} else if (text == 'customerUsageType') {
						customerUsageType = parser.getText();
					} else if (text == 'entityUseCode') {
						entityUseCode = parser.getText();
					} else if (text == 'discount') {
						discount = parser.getIntegerValue();
					} else if (text == 'exemptionNo') {
						exemptionNo = parser.getText();
					} else if (text == 'reportingLocationCode') {
						reportingLocationCode = parser.getText();
					} else if (text == 'purchaseOrderNo') {
						purchaseOrderNo = parser.getText();
					} else if (text == 'currencyCode') {
						currencyCode = parser.getText();
					} else if (text == 'description') {
						description = parser.getText();
					} else if (text == 'referenceCode') {
						referenceCode = parser.getText();
					} else if (text == 'commit') {
						commit_Z = parser.getBooleanValue();
					} else if (text == 'batchCode') {
						batchCode = parser.getText();
					} else if (text == 'serviceMode') {
						serviceMode = parser.getText();
					} else if (text == 'exchangeRate') {
						exchangeRate = parser.getIntegerValue();
					} else if (text == 'exchangeRateEffectiveDate') {
						exchangeRateEffectiveDate = parser.getText();
					} else if (text == 'exchangeRateCurrencyCode') {
						exchangeRateCurrencyCode = parser.getText();
					} else if (text == 'posLaneCode') {
						posLaneCode = parser.getText();
					} else if (text == 'businessIdentificationNo') {
						businessIdentificationNo = parser.getText();
					} else if (text == 'isSellerImporterOfRecord') {
						isSellerImporterOfRecord = parser.getBooleanValue();
					} else if (text == 'email') {
						email = parser.getText();
					} else if (text == 'debugLevel') {
						debugLevel = parser.getText();
					} else if (text == 'customerSupplierName') {
						customerSupplierName = parser.getText();
					} else if (text == 'dataSourceId') {
						dataSourceId = parser.getIntegerValue();
					} else if (text == 'deliveryTerms') {
						deliveryTerms = parser.getText();
					} else if (text == 'taxOverride') {
						taxOverride = new TaxOverride(parser);
					} else if (text == 'parameters') {
						parameters = arrayOfParameters(parser);
					} else if (text == 'userDefinedFields') {
						userDefinedFields = arrayOfUserDefinedFields(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'AvalaraTaxRequest consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class TaxAmountByTaxTypes {
		public String taxTypeId {get;set;} 
		public Integer taxAmount {get;set;} 

		public TaxAmountByTaxTypes() {}
		public TaxAmountByTaxTypes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'taxTypeId') {
							taxTypeId = parser.getText();
						} else if (text == 'taxAmount') {
							taxAmount = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'TaxAmountByTaxTypes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TaxOverride {
		public String type {get;set;} 
		public Integer taxAmount {get;set;} 
		public String taxDate {get;set;} 
		public String reason {get;set;} 
		public List<TaxAmountByTaxTypes> taxAmountByTaxTypes {get;set;} 

		public TaxOverride() {}
		public TaxOverride(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'taxAmount') {
							taxAmount = parser.getIntegerValue();
						} else if (text == 'taxDate') {
							taxDate = parser.getText();
						} else if (text == 'reason') {
							reason = parser.getText();
						} else if (text == 'taxAmountByTaxTypes') {
							taxAmountByTaxTypes = arrayOfTaxAmountByTaxTypes(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TaxOverride consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Parameters {
		public String name {get;set;} 
		public String value {get;set;} 
		public String unit {get;set;} 

		public Parameters() {}
		public Parameters(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else if (text == 'unit') {
							unit = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Parameters consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipFrom {
		public String id {get;set;} 
		public Integer transactionId {get;set;} 
		public String boundaryLevel {get;set;} 
		public String line1 {get;set;} 
		public String city {get;set;} 
		public String region {get;set;} 
		public String postalCode {get;set;} 
		public String country {get;set;} 
		public Integer taxRegionId {get;set;} 

		public ShipFrom() {}
		public ShipFrom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'transactionId') {
							transactionId = parser.getIntegerValue();
						} else if (text == 'boundaryLevel') {
							boundaryLevel = parser.getText();
						} else if (text == 'line1') {
							line1 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'region') {
							region = parser.getText();
						} else if (text == 'postalCode') {
							postalCode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'taxRegionId') {
							taxRegionId = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'ShipFrom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UserDefinedFields {
		public String name {get;set;} 
		public String value {get;set;} 

		public UserDefinedFields() {}
		public UserDefinedFields(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UserDefinedFields consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Lines {
		public String number_Z {get;set;} // in json: number
		public Double quantity {get;set;} 
		public Double amount {get;set;} 
		public String taxCode {get;set;} 
		public String customerUsageType {get;set;} 
		public String entityUseCode {get;set;} 
		public String itemCode {get;set;} 
		public String exemptionCode {get;set;} 
		public Boolean discounted {get;set;} 
		public Boolean taxIncluded {get;set;} 
		public String revenueAccount {get;set;} 
		public String ref1 {get;set;} 
		public String ref2 {get;set;} 
		public String description {get;set;} 
		public String businessIdentificationNo {get;set;} 
		public TaxOverride taxOverride {get;set;} 
		public List<Parameters> parameters {get;set;} 
		public List<UserDefinedFields> userDefinedFields {get;set;} 
		public String hsCode {get;set;} 
		public Integer merchantSellerId {get;set;} 
		public String merchantSellerIdentifier {get;set;} 
		public String marketplaceLiabilityType {get;set;} 
		public String originationDocumentId {get;set;} 
		public String originationSite {get;set;} 
		public String category {get;set;} 
		public String summary {get;set;} 
		public Addresses addresses {get;set;} 

		public Lines() {}
		public Lines(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'quantity') {
							quantity = parser.getDoubleValue();
						} else if (text == 'amount') {
							amount = parser.getDoubleValue();
						} else if (text == 'taxCode') {
							taxCode = parser.getText();
						} else if (text == 'customerUsageType') {
							customerUsageType = parser.getText();
						} else if (text == 'entityUseCode') {
							entityUseCode = parser.getText();
						} else if (text == 'itemCode') {
							itemCode = parser.getText();
						} else if (text == 'exemptionCode') {
							exemptionCode = parser.getText();
						} else if (text == 'discounted') {
							discounted = parser.getBooleanValue();
						} else if (text == 'taxIncluded') {
							taxIncluded = parser.getBooleanValue();
						} else if (text == 'revenueAccount') {
							revenueAccount = parser.getText();
						} else if (text == 'ref1') {
							ref1 = parser.getText();
						} else if (text == 'ref2') {
							ref2 = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'businessIdentificationNo') {
							businessIdentificationNo = parser.getText();
						} else if (text == 'taxOverride') {
							taxOverride = new TaxOverride(parser);
						} else if (text == 'parameters') {
							parameters = arrayOfParameters(parser);
						} else if (text == 'userDefinedFields') {
							userDefinedFields = arrayOfUserDefinedFields(parser);
						} else if (text == 'hsCode') {
							hsCode = parser.getText();
						} else if (text == 'merchantSellerId') {
							merchantSellerId = parser.getIntegerValue();
						} else if (text == 'merchantSellerIdentifier') {
							merchantSellerIdentifier = parser.getText();
						} else if (text == 'marketplaceLiabilityType') {
							marketplaceLiabilityType = parser.getText();
						} else if (text == 'originationDocumentId') {
							originationDocumentId = parser.getText();
						} else if (text == 'originationSite') {
							originationSite = parser.getText();
						} else if (text == 'category') {
							category = parser.getText();
						} else if (text == 'summary') {
							summary = parser.getText();
						} else if (text == 'addresses') {
							addresses = new Addresses(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Lines consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static AvalaraTaxRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new AvalaraTaxRequest(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<TaxAmountByTaxTypes> arrayOfTaxAmountByTaxTypes(System.JSONParser p) {
        List<TaxAmountByTaxTypes> res = new List<TaxAmountByTaxTypes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new TaxAmountByTaxTypes(p));
        }
        return res;
    }






    private static List<UserDefinedFields> arrayOfUserDefinedFields(System.JSONParser p) {
        List<UserDefinedFields> res = new List<UserDefinedFields>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new UserDefinedFields(p));
        }
        return res;
    }




    private static List<Parameters> arrayOfParameters(System.JSONParser p) {
        List<Parameters> res = new List<Parameters>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Parameters(p));
        }
        return res;
    }





    private static List<Lines> arrayOfLines(System.JSONParser p) {
        List<Lines> res = new List<Lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Lines(p));
        }
        return res;
    }

}