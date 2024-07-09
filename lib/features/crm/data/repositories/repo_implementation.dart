
import '../models/check_user.dart';
import '../models/client_information.dart';
import '../models/country.dart';
import '../models/customer_address.dart';
import '../models/customer_specification.dart';
import '../models/entered_users.dart';
import '../models/event_count.dart';
import '../models/file_response.dart';
import '../models/nearby_customers.dart';
import '../models/procedure.dart';
import '../models/representative.dart';
import '../models/user_company.dart';
import '../models/user_token.dart';
import '../models/vouchers.dart';

import '../../domain/repository interfaces/repo_interface.dart';
import '../data source/remote_data_source_interface.dart';

class RepoImplementation implements RepoInterface {
  final RemoteDataSourceInterFace remoteDataSource;

  RepoImplementation({required this.remoteDataSource});

  @override
  Future<int?> addNewAddressOrEdit({required Map<String, dynamic> data}) {
    return remoteDataSource.addNewAddressOrEdit(data: data);
  }

  @override
  Future<int?> addNewEvent({required Map<String, dynamic> data}) {
    return remoteDataSource.addNewEvent(data: data);
  }

  @override
  Future<bool> checkIsAdmin({required Map<String, dynamic> data}) {
    return remoteDataSource.checkIsAdmin(data: data);
  }

  @override
  Future<int?> closeCurrentProcedure({required Map<String, dynamic> data}) {
    return remoteDataSource.closeCurrentProcedure(data: data);
  }

  @override
  Future<String?> deleteFileAttachment({required Map<String, dynamic> data}) {
    return remoteDataSource.deleteFileAttachment(data: data);
  }

  @override
  Future<int?> duplicateEvent({required Map<String, dynamic> data}) {
    return remoteDataSource.duplicateEvent(data: data);
  }

  @override
  Future<UserToken?> generateUserToken({required Map<String, dynamic> data}) {
    return remoteDataSource.generateUserToken(data: data);
  }

  @override
  Future<List<NearbyCustomers>?> getAllCustomerAdresses({required Map<String, dynamic> data}) {
    return remoteDataSource.getAllCustomerAdresses(data: data);
  }

  @override
  Future<List<Country>?> getAreas({required Map<String, dynamic> data}) {
    return remoteDataSource.getAreas(data: data);
  }

  @override
  Future<List<Country>?> getCities({required Map<String, dynamic> data}) {
    return remoteDataSource.getCities(data: data);
  }

  @override
  Future<ClientInformation?> getClientInfo({required Map<String, dynamic> data}) {
    return remoteDataSource.getClientInfo(data: data);
  }

  @override
  Future<List<Country>?> getCountries({required Map<String, dynamic> data}) {
    return remoteDataSource.getCountries(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerAddresses({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerAddresses(data: data);
  }

  @override
  Future<List<CustomerAddress>?> getCustomerAddressesById({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerAddressesById(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerCategories({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerCategories(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerContacts({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerContacts(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerEventProperty({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerEventProperty(data: data);
  }

  @override
  Future<List<Procedure>?> getCustomerProcedures({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomerProcedures(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getCustomersPage({required Map<String, dynamic> data}) {
    return remoteDataSource.getCustomersPage(data: data);
  }

  @override
  Future<int?> getEventBadgeCount({required Map<String, dynamic> data}) {
    return remoteDataSource.getEventBadgeCount(data: data);
  }

  @override
  Future<List<EnteredUsers>?> getEventEnteredByUsers({required Map<String, dynamic> data}) {
    return remoteDataSource.getEventEnteredByUsers(data: data);
  }

  @override
  Future<List<EventCount>?> getEventsCountAndDate({required Map<String, dynamic> data}) {
    return remoteDataSource.getEventsCountAndDate(data: data);
  }

  @override
  Future<List<Procedure>?> getInquirys({required Map<String, dynamic> data}) {
    return remoteDataSource.getInquirys(data: data);
  }

  @override
  Future<List<NearbyCustomers>?> getNearbyCustomers({required Map<String, dynamic> data}) {
    return remoteDataSource.getNearbyCustomers(data: data);
  }

  @override
  Future<List<Procedure>?> getOpenedProcedures({required Map<String, dynamic> data, required int minutes}) {
    return remoteDataSource.getOpenedProcedures(data: data, minutes: minutes);
  }

  @override
  Future<List<Representative>?> getRepresentatives({required Map<String, dynamic> data}) {
    return remoteDataSource.getRepresentatives(data: data);
  }

  @override
  Future<List<UserCompany>?> getUserCompanies({required Map<String, dynamic> data}) {
    return remoteDataSource.getUserCompanies(data: data);
  }

  @override
  Future<List<Vouchers>?> getVouchers({required Map<String, dynamic> data}) {
    return remoteDataSource.getVouchers(data: data);
  }

  @override
  Future<List<CustomerSpecification>?> getWalkInCategories({required Map<String, dynamic> data}) {
    return remoteDataSource.getWalkInCategories(data: data);
  }

  @override
  Future<String?> insertFileAttachment({required Map<String, dynamic> data}) {
    return remoteDataSource.insertFileAttachment(data: data);
  }

  @override
  Future<CheckUser?> login({required Map<String, dynamic> data}) {
    return remoteDataSource.login(data: data);
  }

  @override
  Future<UserToken?> refreshUserToken({required Map<String, dynamic> data}) {
    return remoteDataSource.refreshUserToken(data: data);
  }

  @override
  Future<CheckUser?> signupUser({required Map<String, dynamic> data}) {
    return remoteDataSource.signupUser(data: data);
  }

  @override
  Future<int?> updateEvent({required Map<String, dynamic> data}) {
    return remoteDataSource.updateEvent(data: data);
  }

  @override
  Future<int?> updateVouchers({required List<Map<String, dynamic>> data}) {
    return remoteDataSource.updateVouchers(data: data);
  }

  @override
  Future<FileResponse?> uploadFileChunk({required Map<String, dynamic> data}) {
    return remoteDataSource.uploadFileChunk(data: data);
  }
  
  @override
  Future<String> getConnectionState() {
  return remoteDataSource.getConnectionState();
  }
}