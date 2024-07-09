import 'dart:convert';
import 'dart:developer';
import '../../../features/crm/data/models/check_user.dart';
import '../../../features/crm/data/models/user_token.dart';
import '../extentions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configrations/general_configrations.dart';

// this class is used to all genral user funsctions in app and store all data in shared preferences
class LocalUserRepo {
  final SharedPreferences sharedPreferences;

  LocalUserRepo({required this.sharedPreferences});

  // *****************user************************* //
  static const _userToken = 'userToken';
  Future setUserToken(UserToken user) {
    String userJson = jsonEncode(user);
    return sharedPreferences.setString(_userToken, userJson);
  }

  UserToken? getUserToken() {
    String? user = sharedPreferences.getString(_userToken);
    if (user != null) {
      if (GeneralConfigurations().isDebug) {
        log("USER TOKEN =======================================> $user");
      }

      var map = jsonDecode(user);
      return UserToken.fromJson(map);
    }
    return null;
  }

  void removeUserToken() {
    sharedPreferences.remove(_userToken);
  }
  //****************************************** //

  // ***************LoggedUser******************** //
  static const _loggedUser = 'loggedUser';

  Future setLoggedUser(CheckUser obj) {
    String objJson = jsonEncode(obj);
    return sharedPreferences.setString(_loggedUser, objJson);
  }

  CheckUser? getLoggedUser() {
    String? obj = sharedPreferences.getString(_loggedUser);
    if (obj != null) {
      var map = jsonDecode(obj);
      return CheckUser.fromJson(map);
    }
    return null;
  }

  void removeLoggedUser() {
    sharedPreferences.remove(_loggedUser);
  }
// ********************************************* //

// ***************checkUser******************** //
  static const _checkUser = 'checkUser';

  Future setCheckUser(CheckUser obj) {
    List<CheckUser>? data = getCheckUsers() ?? [];
    data.add(obj);

    List<String> jsonList =
        data.map((obj) => jsonEncode(obj.toJson())).toList();

    return sharedPreferences.setStringList(_checkUser, jsonList);
  }

  List<CheckUser>? getCheckUsers() {
    List<String>? jsonList = sharedPreferences.getStringList(_checkUser);

    return jsonList != null
        ? jsonList.map((json) => CheckUser.fromJson(jsonDecode(json))).toList()
        : [];
  }

  CheckUser? getCheckUserById(String? userId) {
    List<CheckUser?>? data = getCheckUsers() ?? [];
    return data.firstWhereOrNull((obj) => obj?.userId == userId);
  }

  CheckUser? getCheckUserByName(String? userName) {
    List<CheckUser?>? data = getCheckUsers() ?? [];
    return data.firstWhereOrNull((obj) => obj?.userName == userName);
  }

  CheckUser? checkIfExist(CheckUser value) {
    if (value.userId != null) {
      return getCheckUserById(value.userId!) ??
          getCheckUserByName(value.userName!);
    } else {
      return null;
    }
  }

  bool removeCheckUserById(String? userId) {
    List<CheckUser>? data = getCheckUsers() ?? [];
    if (data.isNotEmpty) {
      data.removeWhere((obj) => obj.userId == userId);

      List<String> jsonList =
          data.map((obj) => jsonEncode(obj.toJson())).toList();

      sharedPreferences.setStringList(_checkUser, jsonList);
      return true;
    } else {
      return false;
    }
  }

  bool removeCheckUserByUsername(String? username) {
    List<CheckUser>? data = getCheckUsers() ?? [];
    if (data.isNotEmpty) {
      data.removeWhere((obj) => obj.userName == username);

      List<String> jsonList =
          data.map((obj) => jsonEncode(obj.toJson())).toList();

      sharedPreferences.setStringList(_checkUser, jsonList);
      return true;
    } else {
      return false;
    }
  }

  void removeCheckUsers() {
    sharedPreferences.remove(_checkUser);
  }
// ****************************************** //
}
