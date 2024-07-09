

import '../../data/models/check_user.dart';
import '../../data/models/client_information.dart';
import '../../data/models/country.dart';
import '../../data/models/customer_address.dart';
import '../../data/models/customer_specification.dart';
import '../../data/models/entered_users.dart';
import '../../data/models/event_count.dart';
import '../../data/models/file_response.dart';
import '../../data/models/nearby_customers.dart';
import '../../data/models/procedure.dart';
import '../../data/models/representative.dart';
import '../../data/models/user_company.dart';
import '../../data/models/user_token.dart';
import '../../data/models/vouchers.dart';

abstract class RepoInterface {
  Future<ClientInformation?> getClientInfo({required Map<String, dynamic> data});
  
  Future<CheckUser?> signupUser({required Map<String, dynamic> data});
  
  Future<UserToken?> generateUserToken({required Map<String, dynamic> data});
  
  Future<UserToken?> refreshUserToken({required Map<String, dynamic> data});
  
  Future<CheckUser?> login({required Map<String, dynamic> data});
  
  Future<List<UserCompany>?> getUserCompanies({required Map<String, dynamic> data});
  
  Future<bool> checkIsAdmin({required Map<String, dynamic> data});
  
  Future<List<EnteredUsers>?> getEventEnteredByUsers({required Map<String, dynamic> data});
  
  Future<List<Representative>?> getRepresentatives({required Map<String, dynamic> data});
  
  Future<List<EventCount>?> getEventsCountAndDate({required Map<String, dynamic> data});
  
  Future<int?> getEventBadgeCount({required Map<String, dynamic> data});
  
  Future<List<Procedure>?> getOpenedProcedures({required Map<String, dynamic> data, required int minutes});
  
  Future<List<CustomerSpecification>?> getCustomerCategories({required Map<String, dynamic> data});
  
  Future<List<CustomerSpecification>?> getWalkInCategories({required Map<String, dynamic> data});
  
  Future<List<CustomerSpecification>?> getCustomersPage({required Map<String, dynamic> data});
  
  Future<List<CustomerSpecification>?> getCustomerAddresses({required Map<String, dynamic> data});
  
  Future<List<CustomerSpecification>?> getCustomerContacts({required Map<String, dynamic> data});
  
  Future<List<CustomerSpecification>?> getCustomerEventProperty({required Map<String, dynamic> data});
  
  Future<int?> addNewEvent({required Map<String, dynamic> data});
  
  Future<int?> updateEvent({required Map<String, dynamic> data});
  
  Future<int?> duplicateEvent({required Map<String, dynamic> data});
  
  Future<List<Vouchers>?> getVouchers({required Map<String, dynamic> data});
  
  Future<int?> updateVouchers({required List<Map<String, dynamic>> data});
  
  Future<List<Procedure>?> getInquirys({required Map<String, dynamic> data});
  
  Future<List<CustomerAddress>?> getCustomerAddressesById({required Map<String, dynamic> data});
  
  Future<List<Procedure>?> getCustomerProcedures({required Map<String, dynamic> data});
  
  Future<List<NearbyCustomers>?> getNearbyCustomers({required Map<String, dynamic> data});
  
  Future<List<NearbyCustomers>?> getAllCustomerAdresses({required Map<String, dynamic> data});
  
  Future<List<Country>?> getCountries({required Map<String, dynamic> data});
  
  Future<List<Country>?> getCities({required Map<String, dynamic> data});
  
  Future<List<Country>?> getAreas({required Map<String, dynamic> data});
  
  Future<int?> addNewAddressOrEdit({required Map<String, dynamic> data});
  
  Future<int?> closeCurrentProcedure({required Map<String, dynamic> data});
  
  Future<FileResponse?> uploadFileChunk({required Map<String, dynamic> data});
  
  Future<String?> insertFileAttachment({required Map<String, dynamic> data});
  
  Future<String?> deleteFileAttachment({required Map<String, dynamic> data});
   Future<String> getConnectionState();
}