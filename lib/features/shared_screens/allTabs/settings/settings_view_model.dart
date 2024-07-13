import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/services/local_repo/local_lists_repository.dart';
import '../../../../core/services/local_repo/local_repository.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../../crm/data/models/check_user.dart';
import '../../../crm/data/models/drop_down_obj.dart';
import '../../../crm/data/models/user_company.dart';



final settingsViewModelProvider =
    ChangeNotifierProvider((ref) => SettingsViewModel());

class SettingsViewModel with ChangeNotifier {
  List<DropdownObj> dropDownList = [];
  String? selectedOption;
  UserCompany? selectedOptionObj;
  int distanceinMeter = 500;
  int remindInMinutes = 10;
  bool isDark = false;
  getCachedDistanceAndRemindMinures() {
    if (GeneralConfigurations().isDebug) {
      log(sl<SharedPreferences>()
          .getInt(CacheKeys().distanceInMeter)
          .toString());
      log(sl<SharedPreferences>().getInt(CacheKeys().remindMinutes).toString());
    }
    distanceinMeter =
        sl<SharedPreferences>().getInt(CacheKeys().distanceInMeter) ?? 500;
    remindInMinutes =
        sl<SharedPreferences>().getInt(CacheKeys().remindMinutes) ?? 10;
    notifyListeners();
  }

  changeDistance(int newVal) {
    distanceinMeter = newVal;
    sl<SharedPreferences>().setInt(CacheKeys().distanceInMeter, newVal);
    notifyListeners();
  }

  changeRemindTime(int newVal) {
    remindInMinutes = newVal;
    sl<SharedPreferences>().setInt(CacheKeys().remindMinutes, newVal);
    notifyListeners();
  }

  getTheme() {
    isDark = sl<LocalRepo>().getTheme();
    //notifyListeners();
  }

  setTheme() {
    isDark = !isDark;
    sl<LocalRepo>().setTheme(isDark);
    notifyListeners();
  }
  // final dropdownValueProvider = StateProvider<String?>((ref) => null);

  // final getUserCompanyListFutureProvider =
  //     FutureProvider.autoDispose<List<UserCompany>>((ref) async {
  //   Map<String, dynamic> data = {};
  //   CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
  //   data["ClientID"] = user?.userClientID;
  //   data["UserID"] = user?.userId;

  //   List<UserCompany>? list = await sl<ApiRepo>().getUserCompanies(data: data);
  //   //ref.read(dropdownValueProvider.state).state = list[0].companyNameA ?? "";
  //   return list ?? [];
  // });

  getUserCompanyList() {
    // get user company list from shared_preferences
    // and check if user select object before and make it selected

    final list = sl<LocalListsRepo>().getUserCompaniesList() ?? [];
    dropDownList = list
        .map(
          (e) => DropdownObj(
            name: isEnglish() ? e.companyNameE : e.companyNameA,
            id: e.companyID.toString(),
          ),
        )
        .toList();

    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    if (user?.selectedUserCompany?.companyID != null) {
      selectedOption = user?.selectedUserCompany?.companyID.toString();
      selectedOptionObj = user?.selectedUserCompany;
    } else {
      selectedOption = list[0].companyID.toString();
      selectedOptionObj = list[0];
      saveSelectedOptionInUser(selectedOptionObj);
    }

    notifyListeners();
  }

  UserCompany? getCompanyById(String id) {
    UserCompany? obj = sl<LocalListsRepo>().getUserCompanyById(id);
    return obj;
  }

  setSelectedOption(String? option) {
    selectedOption = option;
    selectedOptionObj = getCompanyById(option!);
    saveSelectedOptionInUser(selectedOptionObj);
    notifyListeners();
  }

  saveSelectedOptionInUser(UserCompany? obj) {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    user?.selectedUserCompany = obj;

    sl<LocalUserRepo>().setLoggedUser(user!);
  }
}
