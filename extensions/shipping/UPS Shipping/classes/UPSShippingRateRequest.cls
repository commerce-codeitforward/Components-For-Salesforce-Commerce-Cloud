public class UPSShippingRateRequest {

	public class TransactionReference {
		public String CustomerContext {get;set;} 

		public TransactionReference(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CustomerContext') {
							CustomerContext = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TransactionReference consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public RateRequest RateRequest {get;set;} 

	public UPSShippingRateRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'RateRequest') {
						RateRequest = new RateRequest(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'UPSShippingRateRequest consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Address {
		public List<String> AddressLine {get;set;} 
		public String City {get;set;} 
		public String StateProvinceCode {get;set;} 
		public String PostalCode {get;set;} 
		public String CountryCode {get;set;} 
    public Address() {}
		public Address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressLine') {
							AddressLine = arrayOfString(parser);
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'StateProvinceCode') {
							StateProvinceCode = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'CountryCode') {
							CountryCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Pickup {
		public String Date_Z {get;set;} // in json: Date
		public String Time_Z {get;set;} // in json: Time

		public Pickup(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Date') {
							Date_Z = parser.getText();
						} else if (text == 'Time') {
							Time_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Pickup consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipmentTotalWeight {
		public CustomerClassification UnitOfMeasurement {get;set;} 
		public String Weight {get;set;} 

		public ShipmentTotalWeight(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'UnitOfMeasurement') {
							UnitOfMeasurement = new CustomerClassification(parser);
						} else if (text == 'Weight') {
							Weight = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ShipmentTotalWeight consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipmentCharges {
		public BillShipper BillShipper {get;set;} 

		public ShipmentCharges(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BillShipper') {
							BillShipper = new BillShipper(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ShipmentCharges consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Request {
		public TransactionReference TransactionReference {get;set;} 

		public Request(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TransactionReference') {
							TransactionReference = new TransactionReference(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Request consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Dimensions {
		public CustomerClassification UnitOfMeasurement {get;set;} 
		public String Length {get;set;} 
		public String Width {get;set;} 
		public String Height {get;set;} 

		public Dimensions(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'UnitOfMeasurement') {
							UnitOfMeasurement = new CustomerClassification(parser);
						} else if (text == 'Length') {
							Length = parser.getText();
						} else if (text == 'Width') {
							Width = parser.getText();
						} else if (text == 'Height') {
							Height = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Dimensions consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Shipment {
		public Shipper Shipper {get;set;} 
		public ShipTo ShipTo {get;set;} 
		public ShipTo ShipFrom {get;set;} 
		public List<PaymentDetails> PaymentDetails {get;set;} 
		public ShipmentRatingOptions ShipmentRatingOptions {get;set;} 
		public CustomerClassification Service {get;set;} 
		public ShipmentTotalWeight ShipmentTotalWeight {get;set;} 
		public String NumOfPieces {get;set;} 
		public List<Package_Z> Package_Z {get;set;} // in json: Package
		public DeliveryTimeInformation DeliveryTimeInformation {get;set;} 
		public ShipmentCharges ShipmentCharges {get;set;} 

		public Shipment(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Shipper') {
							Shipper = new Shipper(parser);
						} else if (text == 'ShipTo') {
							ShipTo = new ShipTo(parser);
						} else if (text == 'ShipFrom') {
							ShipFrom = new ShipTo(parser);
						} else if (text == 'PaymentDetails') {
							PaymentDetails = arrayOfPaymentDetails(parser);
						} else if (text == 'ShipmentRatingOptions') {
							ShipmentRatingOptions = new ShipmentRatingOptions(parser);
						} else if (text == 'Service') {
							Service = new CustomerClassification(parser);
						} else if (text == 'ShipmentTotalWeight') {
							ShipmentTotalWeight = new ShipmentTotalWeight(parser);
						} else if (text == 'NumOfPieces') {
							NumOfPieces = parser.getText();
						} else if (text == 'Package') {
							Package_Z = arrayOfPackage_Z(parser);
						} else if (text == 'DeliveryTimeInformation') {
							DeliveryTimeInformation = new DeliveryTimeInformation(parser);
						} else if (text == 'ShipmentCharges') {
							ShipmentCharges = new ShipmentCharges(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Shipment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipmentCharge {
		public String Type {get;set;} 
		public BillThirdParty BillThirdParty {get;set;} 

		public ShipmentCharge(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Type') {
							Type = parser.getText();
						} else if (text == 'BillThirdParty') {
							BillThirdParty = new BillThirdParty(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ShipmentCharge consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomerClassification {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public CustomerClassification(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerClassification consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BillShipper {
		public String AccountNumber {get;set;} 

		public BillShipper(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AccountNumber') {
							AccountNumber = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BillShipper consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DeliveryTimeInformation {
		public String PackageBillType {get;set;} 
		public Pickup Pickup {get;set;} 

		public DeliveryTimeInformation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'PackageBillType') {
							PackageBillType = parser.getText();
						} else if (text == 'Pickup') {
							Pickup = new Pickup(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DeliveryTimeInformation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Shipper {
		public String Name {get;set;} 
		public String ShipperNumber {get;set;} 
		public Address Address {get;set;} 

		public Shipper(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'ShipperNumber') {
							ShipperNumber = parser.getText();
						} else if (text == 'Address') {
							Address = new Address(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Shipper consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipTo {
		public String Name {get;set;} 
		public Address Address {get;set;} 
    public ShipTo() {
    }
		public ShipTo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Address') {
							Address = new Address(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ShipTo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PaymentDetails {
		public ShipmentCharge ShipmentCharge {get;set;} 

		public PaymentDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ShipmentCharge') {
							ShipmentCharge = new ShipmentCharge(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'PaymentDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Package_Z {
		public CustomerClassification SimpleRate {get;set;} 
		public CustomerClassification PackagingType {get;set;} 
		public Dimensions Dimensions {get;set;} 
		public ShipmentTotalWeight PackageWeight {get;set;} 
		public String OversizeIndicator {get;set;} 
		public String MinimumBillableWeightIndicator {get;set;} 

		public Package_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'SimpleRate') {
							SimpleRate = new CustomerClassification(parser);
						} else if (text == 'PackagingType') {
							PackagingType = new CustomerClassification(parser);
						} else if (text == 'Dimensions') {
							Dimensions = new Dimensions(parser);
						} else if (text == 'PackageWeight') {
							PackageWeight = new ShipmentTotalWeight(parser);
						} else if (text == 'OversizeIndicator') {
							OversizeIndicator = parser.getText();
						} else if (text == 'MinimumBillableWeightIndicator') {
							MinimumBillableWeightIndicator = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Package_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RateRequest {
		public Request Request {get;set;} 
		public CustomerClassification CustomerClassification {get;set;} 
		public Shipment Shipment {get;set;} 

		public RateRequest(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Request') {
							Request = new Request(parser);
						} else if (text == 'CustomerClassification') {
							CustomerClassification = new CustomerClassification(parser);
						} else if (text == 'Shipment') {
							Shipment = new Shipment(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RateRequest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BillThirdParty {
		public String AttentionName {get;set;} 
		public String Name {get;set;} 
		public String AccountNumber {get;set;} 
		public Address_Z Address {get;set;} 

		public BillThirdParty(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AttentionName') {
							AttentionName = parser.getText();
						} else if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'AccountNumber') {
							AccountNumber = parser.getText();
						} else if (text == 'Address') {
							Address = new Address_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'BillThirdParty consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Address_Z {
		public String AddressLine {get;set;} 
		public String City {get;set;} 
		public String StateProvinceCode {get;set;} 
		public String PostalCode {get;set;} 
		public String CountryCode {get;set;} 

    public Address_Z(){

    }
		public Address_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressLine') {
							AddressLine = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'StateProvinceCode') {
							StateProvinceCode = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'CountryCode') {
							CountryCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ShipmentRatingOptions {
		public String TPFCNegotiatedRatesIndicator {get;set;} 
		public String NegotiatedRatesIndicator {get;set;} 

		public ShipmentRatingOptions(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TPFCNegotiatedRatesIndicator') {
							TPFCNegotiatedRatesIndicator = parser.getText();
						} else if (text == 'NegotiatedRatesIndicator') {
							NegotiatedRatesIndicator = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ShipmentRatingOptions consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static UPSShippingRateRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new UPSShippingRateRequest(parser);
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
	




    private static List<Package_Z> arrayOfPackage_Z(System.JSONParser p) {
        List<Package_Z> res = new List<Package_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Package_Z(p));
        }
        return res;
    }
















    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }





    private static List<PaymentDetails> arrayOfPaymentDetails(System.JSONParser p) {
        List<PaymentDetails> res = new List<PaymentDetails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new PaymentDetails(p));
        }
        return res;
    }



}