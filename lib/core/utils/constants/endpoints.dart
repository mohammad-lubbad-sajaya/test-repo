class Endpoints {

//version number
String version = "0.4.6";

  // base url

  static const  String baseUrl = "http://api.sajaya.com";
  //   String baseUrl = "http://37.60.247.39";
  //  String baseUrl = "http://213.6.102.221:8053/";

  static const  String port1 = ":57788/";
   static const String port2 = ":57988/";

  static const  String api = "api/";

  // receiveTimeout
    int receiveTimeout = 15000;
  // connectTimeout
    int connectionTimeout = 15000;

   String getClientInfo = "$port1${api}Sajaya/GetClientInfo";
   String checkUser = "$port1${api}Sajaya/CheckUser";
   String getToken = "${port2}API_SajayaFunctions.svc/token";

   String getUserCompanies = "$port1${api}Sajaya/GetUserCompanies";

   String checkIsAdmin = "$port1${api}CRM/CheckAdmin";
   String getEventEnteredByUsers =
      "$port1${api}CRM/GetCRMEventEnteredByUsers";

   String getEventsCount = "$port1${api}CRM/GetCRMOpenEventCount";
   String getEventBadgeCount = "$port1${api}CRM/GetCRMEventCount";
   String getRepresentatives = "$port1${api}CRM/GetCRMRepresentatives";
   String getOpenProcedures = "$port1${api}CRM/GetCRMOpenEvents";

   String getCustomerCategories = "$port1${api}CRM/GetCRMCustCategories";
   String getWalkInCategories = "$port1${api}CRM/GetCRMMainCustomers";
   String getCustomers = "$port1${api}CRM/GetCRMCustomersNew";
   String getCustomersPage = "$port1${api}CRM/GetCRMCustomersPage";
   String getCustomerAddresses = "$port1${api}CRM/GetCRMAddressesNew";
   String getCustomerContacts = "$port1${api}CRM/GetCRMContacts";
   String getEventProperty = "$port1${api}CRM/GetCRMEventProperty";

   String addEvent = "$port1${api}CRM/AddCRMEventNew";
   String editEvent = "$port1${api}CRM/UpdateCRMEvent";
   String duplicateEvent = "$baseUrl$port1${api}CRM/DuplicateCRMEvent";

   String getVouchers = "$port1${api}CRM/GetCRMEventTrans";
   String updateVouchers = "$port1${api}CRM/UpdateCRMEventTrans";
   String getInquiry = "$port1${api}CRM/GetCRMAllEvents";

   String getAllCountries = "$port1${api}CRM/GetCRMSysCountries";
   String getCitiesByCountryId = "$port1${api}CRM/GetCRMSysCities";
   String getAreasByCityId = "$port1${api}CRM/GetCRMSysAreas";
   String getCustomerAddressesById = "$port1${api}CRM/GetCRMGeoAddresses";
   String geCustomerProcedures = "$port1${api}CRM/GetCRMOpenCustEvents";
   String getNearbyCustomers = "$port1${api}CRM/GetCRMNearbyCustomers";
   String getAllCustomerAdresses =
      "$port1${api}CRM/GetCRMNearbyCustomerAddresses";

   String getCountries = "$port1${api}CRM/GetCRMSysCountries";
   String getCities = "$port1${api}CRM/GetCRMSysCities";
   String getAreas = "$port1${api}CRM/GetCRMSysAreas";

   String addCustomerAddress = "$port1${api}CRM/AddCRMRecCustomerAddress";
   String closeCurrentProcedure = "$port1${api}CRM/AddCRMActualEvent";

   String uploadFileChunk = "$port1${api}CRM/UploadCRMChunk";
   String insertFileAttachment = "$port1${api}CRM/InsertCRMAttachment";
   String deleteFileAttachment = "$port1${api}CRM/DeleteCRMAttachment";
}
