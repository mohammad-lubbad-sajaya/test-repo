import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/extentions.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/services/notifications/notifications_manager.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../../../core/utils/constants/dio_error_printer.dart';
import '../../../../core/utils/constants/endpoints.dart';
import '../../../../core/utils/methods/shared_methods.dart';
import 'remote_data_source_interface.dart';

class RemoteDataSourceImplementation extends RemoteDataSourceInterFace {
  final Dio client;
  RemoteDataSourceImplementation({
    required this.client,
  });
  @override
  Future<int?> addNewAddressOrEdit({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().addCustomerAddress,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      sl<SharedPreferences>()
          .setString(CacheKeys().proceduresList, jsonEncode(response.data));
      // int? code = response.data["code"];

      String? message = response.data["message"];
      String? id = message?.getNumberFromString();
      if (id != null) {
        return int.parse(id);
      } else {
        return null;
      }
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<int?> addNewEvent({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().addEvent,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(jsonEncode(data));
        log("**************************************************************");
        log(response.data.toString());
      }
      return response.data;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<bool> checkIsAdmin({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().checkIsAdmin,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      return response.data;
    } on Exception catch (e) {
      handleDioError(e);
      return false;
    }
  }

  @override
  Future<int?> closeCurrentProcedure(
      {required Map<String, dynamic> data}) async {
    try {
      final _connection = await getConnectionState();
      if (_connection == ConnectivityResult.none.name) {
        _cacheProcedure(jsonEncode(data), CacheKeys().closeProcedureList);
        return 0;
      } else {
        Response response = await client.post(
          sl<Endpoints>().closeCurrentProcedure,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data),
        );
        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          if (GeneralConfigurations().isDebug) {
            log("close=======procedure=================success===========>${response.statusCode}");
          }
          SharedMethods().deleteCachedProcedure(
              jsonEncode(data), CacheKeys().closeProcedureList);
        }
        int? value = response.data;
        if (GeneralConfigurations().isDebug) {
          log("id = " + value.toString());
          log(sl<Endpoints>().closeCurrentProcedure);
          log(jsonEncode(data));
        }

        return value;
      }
    } on Exception catch (e) {
      if (GeneralConfigurations().isDebug) {
        log("close=======procedure=================failed===========>${e.toString()}");
      }

      SharedMethods().deleteCachedProcedure(
          jsonEncode(data), CacheKeys().closeProcedureList);

      handleDioError(e);
      return null;
    }
  }

  _cacheProcedure(String item, String storeKey) {
    final _list = sl<SharedPreferences>().getStringList(
          storeKey,
        ) ??
        [];
    _list.add(item);
    sl<SharedPreferences>().setStringList(storeKey, _list);
  }

  @override
  Future<String> getConnectionState() async {
    //check user current connection state
    final _result = await Connectivity().checkConnectivity();
    return _result.first.name;
  }

  @override
  Future<String?> deleteFileAttachment(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().deleteFileAttachment,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      return response.data;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<int?> duplicateEvent({required Map<String, dynamic> data}) async {
    final _connectionName = await getConnectionState();

    try {
      if (_connectionName == ConnectivityResult.none.name) {
        _cacheProcedure(jsonEncode(data), CacheKeys().duplicateEvent);
        return 0;
      } else {
        Response response = await client.post(
          sl<Endpoints>().duplicateEvent,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data),
        );
        if (GeneralConfigurations().isDebug) {
          log("this is the duplicate event response data : ${response.statusCode}======>${response.data}");
        }
        if (response.statusCode! >= 200 && response.statusCode! < 400) {
          // when api call success we delete the successed item from the cached data
          SharedMethods().deleteCachedProcedure(
              jsonEncode(data), CacheKeys().duplicateEvent);
          SharedMethods()
              .deleteCachedProcedure(jsonEncode(data), CacheKeys().editEvent);
        }
        return response.data;
      }
    } on Exception catch (e) {
      if (GeneralConfigurations().isDebug) {
        log("this is the duplicate   event response data : ${e.toString()}======>");
      }
      SharedMethods()
          .deleteCachedProcedure(jsonEncode(data), CacheKeys().duplicateEvent);
      SharedMethods()
          .deleteCachedProcedure(jsonEncode(data), CacheKeys().editEvent);
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<UserToken?> generateUserToken(
      {required Map<String, dynamic> data}) async {
    try {
      client.options.headers.remove("Authorization");
      Response response = await client.post(
        sl<Endpoints>().getToken,
        options: Options(headers: {}),
        data: jsonEncode(data),
      );
      return UserToken.fromJson(response.data);
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<NearbyCustomers>?> getAllCustomerAdresses(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getAllCustomerAdresses,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<NearbyCustomers> list = response.data
          .map<NearbyCustomers>((x) => NearbyCustomers.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Country>?> getAreas({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getAreas,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<Country> list =
          response.data.map<Country>((x) => Country.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Country>?> getCities({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCities,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<Country> list =
          response.data.map<Country>((x) => Country.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<ClientInformation?> getClientInfo(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getClientInfo,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      return ClientInformation.fromJson(response.data);
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Country>?> getCountries(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCountries,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<Country> list =
          response.data.map<Country>((x) => Country.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerAddresses(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCustomerAddresses,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(jsonEncode(data));
      }
      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerAddress>?> getCustomerAddressesById(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCustomerAddressesById,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<CustomerAddress> list = response.data
          .map<CustomerAddress>((x) => CustomerAddress.fromJson(x))
          .toList();
      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerCategories(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCustomerCategories,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerContacts(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCustomerContacts,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(jsonEncode(data));
      }
      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getCustomerEventProperty(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getEventProperty,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(response.data.toString());
      }
      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Procedure>?> getCustomerProcedures(
      {required Map<String, dynamic> data})async {
  if(GeneralConfigurations().isDebug){
      log(data.toString());
   }
    try {
      Response response = await client.post(
        sl<Endpoints>().geCustomerProcedures,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
if(GeneralConfigurations().isDebug){
  log(response.data.toString());
}
      List<Procedure> list =
          response.data.map<Procedure>((x) => Procedure.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getCustomersPage(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getCustomersPage,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(response.data.toString());
      }
      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<int?> getEventBadgeCount({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getEventBadgeCount,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      return response.data;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<EnteredUsers>?> getEventEnteredByUsers(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getEventEnteredByUsers,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<EnteredUsers> list = response.data
          .map<EnteredUsers>((x) => EnteredUsers.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<EventCount>?> getEventsCountAndDate(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getEventsCount,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<EventCount> list =
          response.data.map<EventCount>((x) => EventCount.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Procedure>?> getInquirys(
      {required Map<String, dynamic> data}) async {
    if (GeneralConfigurations().isDebug) {
      log(data.toString());
    }
    try {
      Response response = await client.post(
        sl<Endpoints>().getInquiry,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(response.data.toString());
      }

      List<Procedure> list =
          response.data.map<Procedure>((x) => Procedure.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<NearbyCustomers>?> getNearbyCustomers(
      {required Map<String, dynamic> data}) async {
    if (GeneralConfigurations().isDebug) {
      log(data.toString());
    }
    try {
      Response response = await client.post(
        sl<Endpoints>().getNearbyCustomers,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log(response.data.toString());
      }
      List<NearbyCustomers> list = response.data
          .map<NearbyCustomers>((x) => NearbyCustomers.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Procedure>?> getOpenedProcedures(
      {required Map<String, dynamic> data, required int minutes}) async {
    if (GeneralConfigurations().isDebug) {
      log(data.toString());
    }
    try {
      final _connection = await getConnectionState();
      if (_connection == ConnectivityResult.none.name) {
        return _fetchLocalProcedures();
      } else {
        Response response = await client.post(
          sl<Endpoints>().getOpenProcedures,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data),
        );
        if (GeneralConfigurations().isDebug) {
          log(response.data.toString());
        }
        //save the data json locally using sharedprefs
        if (data["DateFrom"] == "") {
          sl<SharedPreferences>()
              .setString(CacheKeys().proceduresList, jsonEncode(response.data));
        }
        List<Procedure> list =
            response.data.map<Procedure>((x) => Procedure.fromJson(x)).toList();
        if (list.isNotEmpty) {
          //first i cancel all prev notifications
          NotificationManager().cancellAll();
          //then reschedual notifications for all procedures coming to make sure data and notifications be updated always
          for (var element in list) {
            NotificationManager().showNotification(
              id: element.eventId!,
              title: element.custNameA.toString(),
              body:
                  "${element.eventDesc ?? ""}  At ${element.eventDate?.hour} : ${element.eventDate?.minute}",
              date: element.eventDate!.subtract(Duration(minutes: minutes)),
            );
          }
        }

        return list;
      }
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  List<Procedure> _fetchLocalProcedures() {
    //no connection fetch data locally
    if (sl<SharedPreferences>().getString(CacheKeys().proceduresList) == null) {
      return [];
    }
    final _closeProceduresList =
        sl<SharedPreferences>().getStringList(CacheKeys().duplicateEvent) ?? [];
    final _data = jsonDecode(
        sl<SharedPreferences>().getString(CacheKeys().proceduresList) ?? "");
    List<Procedure> list =
        _data.map<Procedure>((x) => Procedure.fromJson(x)).toList();

    for (var e in _closeProceduresList) {
      if (jsonDecode(e)["EventIsChecked"].toString() == true.toString()) {
        //dont remove the close edit items (items where the user checked for add new procedure )
        continue;
      }
      list.removeWhere((element) =>
          element.eventId.toString() == jsonDecode(e)["EventID"].toString());
    }
    return list;
  }

  @override
  Future<List<Representative>?> getRepresentatives(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getRepresentatives,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<Representative> list = response.data
          .map<Representative>((x) => Representative.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<UserCompany>?> getUserCompanies(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getUserCompanies,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<UserCompany> list = response.data
          .map<UserCompany>((x) => UserCompany.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<Vouchers>?> getVouchers(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getVouchers,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      List<Vouchers> list =
          response.data.map<Vouchers>((x) => Vouchers.fromJson(x)).toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<List<CustomerSpecification>?> getWalkInCategories(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getWalkInCategories,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      List<CustomerSpecification> list = response.data
          .map<CustomerSpecification>((x) => CustomerSpecification.fromJson(x))
          .toList();

      return list;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<String?> insertFileAttachment(
      {required Map<String, dynamic> data}) async {
    try {
      //  data["EventID"] = "1";
      Response response = await client.post(
        sl<Endpoints>().insertFileAttachment,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if (GeneralConfigurations().isDebug) {
        log("insert============attachments================response=================>${response.statusCode}====${response.data}");
      }
      return response.data;
    } on Exception catch (e) {
      if (GeneralConfigurations().isDebug) {
        log("insert============attachments================response=================>${e.toString()}");
      }
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<CheckUser?> login({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().checkUser,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      return CheckUser.fromJson(response.data);
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<UserToken?> refreshUserToken(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().getToken,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      return UserToken.fromJson(response.data);
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<CheckUser?> signupUser({required Map<String, dynamic> data}) async {
    try {
      Response response = await client.post(
        sl<Endpoints>().checkUser,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      return CheckUser.fromJson(response.data);
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<int?> updateEvent({required Map<String, dynamic> data})async {
   if(GeneralConfigurations().isDebug){
    log(data.toString());
    }
    final _connectionName = await getConnectionState();

    try {
      if (_connectionName == ConnectivityResult.none.name) {
        _cacheProcedure(jsonEncode(data), CacheKeys().editEvent);
        return 0;
      }
      Response response = await client.post(
       sl< Endpoints>().editEvent,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      if(GeneralConfigurations().isDebug){
      log("this is the update  event response data : ${response.statusCode}======>${response.data}");
      }

      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        // when api call success we delete the successed item from the cached data

        SharedMethods()
            .deleteCachedProcedure(jsonEncode(data), CacheKeys().editEvent);
      }
      return response.data;
    } on Exception catch (e) {
       if(GeneralConfigurations().isDebug){
      log("this is the update  event response data : ${e.toString()}======>");
       }
      SharedMethods()
          .deleteCachedProcedure(jsonEncode(data), CacheKeys().editEvent);
 if(GeneralConfigurations().isDebug){
      log(e.toString());
 }
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<int?> updateVouchers({required List<Map<String, dynamic>> data})async {
  try {
      Response response = await client.post(
        sl<Endpoints>().updateVouchers,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );
      return response.data;
    } on Exception catch (e) {
      handleDioError(e);
      return null;
    }
  }

  @override
  Future<FileResponse?> uploadFileChunk({required Map<String, dynamic> data}) async{
   Response? response;
    //First Step of Saving Files
    try {
      final _connection = await getConnectionState();
      if (_connection == ConnectivityResult.none.name) {
        _cacheProcedure(jsonEncode(data), CacheKeys().cachedFilesChunksList);
        return null;
      } else {
        response = await client.post(
          sl<Endpoints>().uploadFileChunk,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data),
        );
        if (response.statusCode! >= 200 && response.statusCode! < 400) {
           if(GeneralConfigurations().isDebug){
          log("===========uplode=======files chunks===============response====${response.statusCode}");
           }
          SharedMethods().deleteCachedProcedure(
              jsonEncode(data), CacheKeys().cachedFilesChunksList);
        }
        final _file = FileResponse.fromJson(response.data);
        _file.eventId = data["EventID"].toString();
        return _file;
      }
    } on Exception catch (e) {
       if(GeneralConfigurations().isDebug){
      log("===========uplode=======files chunks=${response?.statusMessage}==============response====${e.toString()}");
       }
      SharedMethods().deleteCachedProcedure(
          jsonEncode(data), CacheKeys().cachedFilesChunksList);
      handleDioError(e);
      return null;
    }
  }
}
