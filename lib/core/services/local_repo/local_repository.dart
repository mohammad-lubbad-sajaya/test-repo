
import '../extentions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import '../../../features/shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_view_model.dart';
import '../../utils/constants/cache_keys.dart';
import '../routing/navigation_service.dart';
import '../routing/routes.dart';
import '../service_locator/dependency_injection.dart';
import 'local_lists_repository.dart';
import 'local_user_repository.dart';


/*
  The LocalRepo class is responsible for managing local data using the SharedPreferences package.
  It provides methods to set and retrieve various types of data from the shared preferences.
*/

class LocalRepo {
  final SharedPreferences sharedPreferences;

  LocalRepo({required this.sharedPreferences});

  // *****************languange************************* //
  static const _languange = 'language';
  Future setLanguage(String value) {
    return sharedPreferences.setString(_languange, value);
  }

  String? getLanguage() {
    return sharedPreferences.getString(_languange);
  }
  // ****************************************** //

  // *************isRememberMe********************* //
  static const _isRememberMe = 'isRememberMe';
  Future setIsRememberMe(bool value) {
    return sharedPreferences.setBool(_isRememberMe, value);
  }

  bool? getIsRememberMe() {
    return sharedPreferences.getBool(_isRememberMe);
  }
void setTheme(bool isDark){
  sharedPreferences.setBool(CacheKeys().isDark, isDark);
}
bool getTheme(){
  return sharedPreferences.getBool(CacheKeys().isDark)??false;
}
  // ****************************************** //

  //This method is responsible for performing logout operations.
  //It likely belongs to a larger application context. In the provided code,
  logout() {
    BuildContext context = sl<NavigationService>().getContext();
    final filterViewModel = context.read(filterInquiryViewModelProvider);
    filterViewModel.reset();
    //sl<ApiRepo>().logout();
    sl<LocalUserRepo>().removeUserToken();
    sl<LocalListsRepo>().removeUserCompanies();

    //sl<LocalUserRepo>().removeLoggedUser();
    //sl<LocalRepo>().setIsRememberMe(false);
    sl<NavigationService>().navigateToAndRemove(preAppScreen);

  }
}
