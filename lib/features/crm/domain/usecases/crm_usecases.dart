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
import '../repository interfaces/repo_interface.dart';

class AddNewAddressOrEditUseCase {
  final RepoInterface repository;

  AddNewAddressOrEditUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.addNewAddressOrEdit(data: data);
}

class AddNewEventUseCase {
  final RepoInterface repository;

  AddNewEventUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.addNewEvent(data: data);
}

class CheckIsAdminUseCase {
  final RepoInterface repository;

  CheckIsAdminUseCase(this.repository);

  Future<bool> call(Map<String, dynamic> data) => repository.checkIsAdmin(data: data);
}

class CloseCurrentProcedureUseCase {
  final RepoInterface repository;

  CloseCurrentProcedureUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.closeCurrentProcedure(data: data);
}

class DeleteFileAttachmentUseCase {
  final RepoInterface repository;

  DeleteFileAttachmentUseCase(this.repository);

  Future<String?> call(Map<String, dynamic> data) => repository.deleteFileAttachment(data: data);
}
class GetConnectionStateUseCase {
  final RepoInterface repository;

  GetConnectionStateUseCase(this.repository);

  Future<String?> call() => repository.getConnectionState();
}

class DuplicateEventUseCase {
  final RepoInterface repository;

  DuplicateEventUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.duplicateEvent(data: data);
}

class GenerateUserTokenUseCase {
  final RepoInterface repository;

  GenerateUserTokenUseCase(this.repository);

  Future<UserToken?> call(Map<String, dynamic> data) => repository.generateUserToken(data: data);
}

class GetAllCustomerAddressesUseCase {
  final RepoInterface repository;

  GetAllCustomerAddressesUseCase(this.repository);

  Future<List<NearbyCustomers>?> call(Map<String, dynamic> data) => repository.getAllCustomerAdresses(data: data);
}

class GetAreasUseCase {
  final RepoInterface repository;

  GetAreasUseCase(this.repository);

  Future<List<Country>?> call(Map<String, dynamic> data) => repository.getAreas(data: data);
}

class GetCitiesUseCase {
  final RepoInterface repository;

  GetCitiesUseCase(this.repository);

  Future<List<Country>?> call(Map<String, dynamic> data) => repository.getCities(data: data);
}

class GetClientInfoUseCase {
  final RepoInterface repository;

  GetClientInfoUseCase(this.repository);

  Future<ClientInformation?> call(Map<String, dynamic> data) => repository.getClientInfo(data: data);
}

class GetCountriesUseCase {
  final RepoInterface repository;

  GetCountriesUseCase(this.repository);

  Future<List<Country>?> call(Map<String, dynamic> data) => repository.getCountries(data: data);
}

class GetCustomerAddressesUseCase {
  final RepoInterface repository;

  GetCustomerAddressesUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getCustomerAddresses(data: data);
}

class GetCustomerAddressesByIdUseCase {
  final RepoInterface repository;

  GetCustomerAddressesByIdUseCase(this.repository);

  Future<List<CustomerAddress>?> call(Map<String, dynamic> data) => repository.getCustomerAddressesById(data: data);
}

class GetCustomerCategoriesUseCase {
  final RepoInterface repository;

  GetCustomerCategoriesUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getCustomerCategories(data: data);
}

class GetCustomerContactsUseCase {
  final RepoInterface repository;

  GetCustomerContactsUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getCustomerContacts(data: data);
}

class GetCustomerEventPropertyUseCase {
  final RepoInterface repository;

  GetCustomerEventPropertyUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getCustomerEventProperty(data: data);
}

class GetCustomerProceduresUseCase {
  final RepoInterface repository;

  GetCustomerProceduresUseCase(this.repository);

  Future<List<Procedure>?> call(Map<String, dynamic> data) => repository.getCustomerProcedures(data: data);
}

class GetCustomersPageUseCase {
  final RepoInterface repository;

  GetCustomersPageUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getCustomersPage(data: data);
}

class GetEventBadgeCountUseCase {
  final RepoInterface repository;

  GetEventBadgeCountUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.getEventBadgeCount(data: data);
}

class GetEventEnteredByUsersUseCase {
  final RepoInterface repository;

  GetEventEnteredByUsersUseCase(this.repository);

  Future<List<EnteredUsers>?> call(Map<String, dynamic> data) => repository.getEventEnteredByUsers(data: data);
}

class GetEventsCountAndDateUseCase {
  final RepoInterface repository;

  GetEventsCountAndDateUseCase(this.repository);

  Future<List<EventCount>?> call(Map<String, dynamic> data) => repository.getEventsCountAndDate(data: data);
}

class GetInquirysUseCase {
  final RepoInterface repository;

  GetInquirysUseCase(this.repository);

  Future<List<Procedure>?> call(Map<String, dynamic> data) => repository.getInquirys(data: data);
}

class GetNearbyCustomersUseCase {
  final RepoInterface repository;

  GetNearbyCustomersUseCase(this.repository);

  Future<List<NearbyCustomers>?> call(Map<String, dynamic> data) => repository.getNearbyCustomers(data: data);
}

class GetOpenedProceduresUseCase {
  final RepoInterface repository;

  GetOpenedProceduresUseCase(this.repository);

  Future<List<Procedure>?> call(Map<String, dynamic> data, int minutes) => repository.getOpenedProcedures(data: data, minutes: minutes);
}

class GetRepresentativesUseCase {
  final RepoInterface repository;

  GetRepresentativesUseCase(this.repository);

  Future<List<Representative>?> call(Map<String, dynamic> data) => repository.getRepresentatives(data: data);
}

class GetUserCompaniesUseCase {
  final RepoInterface repository;

  GetUserCompaniesUseCase(this.repository);

  Future<List<UserCompany>?> call(Map<String, dynamic> data) => repository.getUserCompanies(data: data);
}

class GetVouchersUseCase {
  final RepoInterface repository;

  GetVouchersUseCase(this.repository);

  Future<List<Vouchers>?> call(Map<String, dynamic> data) => repository.getVouchers(data: data);
}

class GetWalkInCategoriesUseCase {
  final RepoInterface repository;

  GetWalkInCategoriesUseCase(this.repository);

  Future<List<CustomerSpecification>?> call(Map<String, dynamic> data) => repository.getWalkInCategories(data: data);
}

class InsertFileAttachmentUseCase {
  final RepoInterface repository;

  InsertFileAttachmentUseCase(this.repository);

  Future<String?> call(Map<String, dynamic> data) => repository.insertFileAttachment(data: data);
}

class LoginUseCase {
  final RepoInterface repository;

  LoginUseCase(this.repository);

  Future<CheckUser?> call(Map<String, dynamic> data) => repository.login(data: data);
}

class RefreshUserTokenUseCase {
  final RepoInterface repository;

  RefreshUserTokenUseCase(this.repository);

  Future<UserToken?> call(Map<String, dynamic> data) => repository.refreshUserToken(data: data);
}

class SignupUserUseCase {
  final RepoInterface repository;

  SignupUserUseCase(this.repository);

  Future<CheckUser?> call(Map<String, dynamic> data) => repository.signupUser(data: data);
}

class UpdateEventUseCase {
  final RepoInterface repository;

  UpdateEventUseCase(this.repository);

  Future<int?> call(Map<String, dynamic> data) => repository.updateEvent(data: data);
}

class UpdateVouchersUseCase {
  final RepoInterface repository;

  UpdateVouchersUseCase(this.repository);

  Future<int?> call(List<Map<String, dynamic>> data) => repository.updateVouchers(data: data);
}

class UploadFileChunkUseCase {
  final RepoInterface repository;

  UploadFileChunkUseCase(this.repository);

  Future<FileResponse?> call(Map<String, dynamic> data) => repository.uploadFileChunk(data: data);
}
