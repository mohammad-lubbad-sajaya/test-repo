import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/crm/data/models/user_company.dart';
import '../extentions.dart';

/*
  The LocalListsRepo class is responsible for managing local lists using the SharedPreferences package.
  It provides methods to set and retrieve various types of data from the shared preferences.
*/

class LocalListsRepo {
  final SharedPreferences sharedPreferences;

  LocalListsRepo({required this.sharedPreferences});

//////////////UserCompanies//////////////////
  static const _userCompanies = '_userCompanies';
  Future<void> setUserCompanies(List<UserCompany> data) {
    String jsonObj = jsonEncode(data);
    return sharedPreferences.setString(_userCompanies, jsonObj);
  }

  List<UserCompany>? getUserCompaniesList() {
    String? data = sharedPreferences.get(_userCompanies) as String?;
    if (data != null) {
      final List<UserCompany>? list = UserCompany.decode(data);
      if (list != null) {
        return list;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  UserCompany? getUserCompanyById(String? companyID) {
    List<UserCompany?>? data = getUserCompaniesList() ?? [];
    return data
        .firstWhereOrNull((obj) => obj?.companyID.toString() == companyID);
  }

  void removeUserCompanies() {
    sharedPreferences.remove(_userCompanies);
  }
///////////////////////////////////////
}
