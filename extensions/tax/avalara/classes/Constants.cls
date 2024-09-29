public with sharing class Constants {
  // Shipping Provider Details
  public static final String REQUEST_MAPPER = 'request_mapper';
  public static final String REQUEST_JSON = 'request_json';
  public static final String RESPONSE_MAPPER = 'response_mapper';
  public static final String IMPL_CLASS = 'impl_class';
  public static final String MAX_PACKAGE_WEIGHT = 'max_package_weight';
  public static final String MIN_PACKAGE_WEIGHT = 'min_package_weight';
  public static final String MOCKED_RESPONSE = 'mocked_response';
  public static final String SHIPPING_METHOD_NAMES = 'shipping_method_names';
  public static final String SHIPPING_PRODUCT = 'shipping_product';
  public static final String CART_DELIVERY_GROUP = 'cart_delivery_grooup';
  public static final String PACKAGE_WEIGHT = 'package_weight';
  public static final String CART_ID = 'cart_id';

  // Service  details
  public static final String REQUEST_URL = 'request_url';
  public static final String END_POINT = 'end_point';
  public static final String HTTP_METHOD = 'http_method';
  public static final String SERVICE_TIMEOUT = 'service_timeout';
  public static final String SERVICE_MODE = 'service_mode';
  public static final String SERVICE_MODE_LIVE = 'LIVE';
  public static final String SERVICE_REQUEST_BODY = 'service_request_body';
  public static final String SERVICE_RESPONSE_BODY = 'service_response_body';
  public static final String RESPONSE_REASON_CODE = 'response_reason_code';
  public static final String SERVICE_IMPL_CLASS = 'service_impl_class';
  public static final String HTTP_POST = 'POST';
  public static final Integer HTTP_DEFAULT_TIMEOUT = 5000;
  public static final Integer HTTP_200 = 200;
  public static final Integer HTTP_400 = 400;
  public static final Integer HTTP_401 = 401;
  public static final Integer HTTP_403 = 403;
  public static final String HTTP_RESPONSE_STATUS = 'status';
  public static final String HTTP_RESPONSE_STATUS_SUCCESS = 'success';
  public static final String HTTP_RESPONSE_STATUS_ERROR = 'error';
  public static final String HTTP_HEADER_CONTENT_TYPE = 'Content-Type';
  public static final String HTTP_HEADER_CONTENT_TYPE_JSON = 'application/json';
  // Named Credentials
  public static final String NAMED_CREDENTIALS = 'named_credentials';
  public static final String CALLOUT = 'callout:';
  public static final String USERNAME = 'username';
  public static final String PASSWORD = 'password';
  public static final String CREDENNTIALS_USERNAME = '{!$Credential.Username}';
  public static final String CREDENNTIALS_PASSWORD = '{!$Credential.Password}';

  // Shipper
  public static final String SHIPPER_NAME = 'shipper_name';
  public static final String SHIPPER_ATTENTION_NAME = 'shipper_attention_name';
  public static final String SHIPPER_PHONE_NUMER = 'shipper_phone_number';
  public static final String SHIPPER_FAX_NUMBER = 'shipper_fax_number';
  public static final String SHIPPER_ACCOUNT_NUMBER = 'shipper_account_number';
  public static final String SHIPPER_ADDRESS1 = 'shipper_address1';
  public static final String SHIPPER_CITY = 'shipper_city';
  public static final String SHIPPER_STATE = 'shipper_state';
  public static final String SHIPPER_POSTAL_CODE = 'shipper_postal_code';
  public static final String SHIPPER_COUNTRY_CODE = 'shipper_country_code';

  // Ship From
  public static final String SHIP_FROM_NAME = 'ship_from_name';
  public static final String SHIP_FROM_ATTENTION_NAME = 'ship_from_attention_name';
  public static final String SHIP_FROM_PHONE_NUMER = 'ship_from_phone_number';
  public static final String SHIP_FROM_FAX_NUMBER = 'ship_from_fax_number';
  public static final String SHIP_FROM_ADDRESS1 = 'ship_from_address1';
  public static final String SHIP_FROM_CITY = 'ship_from_city';
  public static final String SHIP_FROM_STATE = 'ship_from_state';
  public static final String SHIP_FROM_POSTAL_CODE = 'ship_from_postal_code';
  public static final String SHIP_FROM_COUNTRY_CODE = 'ship_from_country_code';

  // Shit To
  public static final String SHIP_TO_NAME = 'ship_to_name';
  public static final String SHIP_TO_ATTENTION_NAME = 'ship_to_attention_name';
  public static final String SHIP_TO_PHONE_NUMER = 'ship_to_phone_number';
  public static final String SHIP_TO_FAX_NUMBER = 'ship_to_fax_number';
  public static final String SHIP_TO_ADDRESS1 = 'ship_to_address1';
  public static final String SHIP_TO_CITY = 'ship_to_city';
  public static final String SHIP_TO_STATE = 'ship_to_state';
  public static final String SHIP_TO_POSTAL_CODE = 'ship_to_postal_code';
  public static final String SHIP_TO_COUNTRY_CODE = 'ship_to_country_code';
  public static final String SHIP_TO_COUNTRY = 'ship_to_country';

  // Cart
  public static final String EXTENSION_CART = 'extension_cart';
}