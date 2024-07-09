import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/extentions.dart';
import '../../crm/domain/usecases/crm_usecases.dart';

import '../../../core/services/local_repo/local_lists_repository.dart';
import '../../../core/services/local_repo/local_repository.dart';
import '../../../core/services/local_repo/local_user_repository.dart';
import '../../../core/services/routing/navigation_service.dart';
import '../../../core/services/routing/routes.dart';
import '../../../core/services/service_locator/dependency_injection.dart';
import '../../../core/utils/common_widgets/error_dialog.dart';
import '../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../core/utils/constants/cls_crypto.dart';
import '../../crm/data/models/check_user.dart';
import '../../crm/data/models/error_res.dart';
import '../../crm/data/models/user_company.dart';
import '../../crm/presentation/allTabs/home/home_view_model.dart';
import '../../crm/presentation/allTabs/settings/settings_view_model.dart';


final loginViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  return LoginViewModel();
});

final isRememberMeProvider = StateProvider<bool?>((ref) {
  return sl<LocalRepo>().getIsRememberMe();
});

final userIdProvider = StateProvider<String>((ref) {
  // to get user id and set in the userId text field
  CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
  return user?.userName ?? "";
});

class LoginViewModel extends ChangeNotifier {
  late BuildContext context;
  String userId = '';
  String password = '';

  bool isUserIdValid = true;
  bool isPasswordValid = true;

  String userIdErrorText = '';
  String passwordErrorText = '';

  bool isObscureText = true;
  bool isLoading = false;

  obscureText() {
    isObscureText = !isObscureText;
    notifyListeners();
  }

  checkRememberMe(bool value) {
    sl<LocalRepo>().setIsRememberMe(value);
    notifyListeners();
  }

  validateUserId(String value) {
    userId = value.trim();
    isUserIdValid = value.isNotEmpty;

    if (isUserIdValid) {
      userIdErrorText = '';
    } else {
      userIdErrorText = 'userId is required';
    }

    notifyListeners();
  }

  validatePassword(String value) {
    password = value.trim();
    isPasswordValid = value.isNotEmpty;

    if (isPasswordValid) {
      passwordErrorText = '';
    } else {
      passwordErrorText = 'Password is required';
    }

    notifyListeners();
  }

  //reset all variables when finished from this view model
  reset() {
    userId = '';
    password = '';

    isUserIdValid = true;
    isPasswordValid = true;

    userIdErrorText = '';
    passwordErrorText = '';
    context.read(homeViewModelProvider).params = {};
    context.read(homeViewModelProvider).selectedEnteredUser = null;
    context.read(homeViewModelProvider).selectedEnteredUsersObj = null;

    context.read(homeViewModelProvider).selectedEventCountDate = null;
  }

  bool get isFormValid => isUserIdValid && isPasswordValid;

  //handel all text fields and show loader and request user token
  Future login(BuildContext context) async {
    validateUserId(userId);
    validatePassword(password);

    if (isFormValid) {
      isLoading = true;
      notifyListeners();
      LoadingAlertDialog.show(
        context,
        title: "Login".localized(),
      );
      runZonedGuarded(
        () async {
          await getUserToken();

          isLoading = false;
          LoadingAlertDialog.dismiss();
          notifyListeners();
        },
        (e, s) {
          isLoading = false;

          LoadingAlertDialog.dismiss();
          notifyListeners();
          ErrorResponse.handelError(context, e, "login");
        },
      );
    }
  }

  //check if user registered in system and get user token from api
  Future getUserToken() async {
    Map<String, dynamic> data = {};
    CheckUser? checkUser = getRegisteredUser();
    if (checkUser != null) {
      data["grant_type"] = "password";
      data["username"] = userId;
      data["password"] = password;
      data["client_id"] = checkUser.clientID;
      data["client_secret"] = checkUser.clientSecret;
      //data["selectedUserCompany"] = checkUser.selectedUserCompany;
      data["scope"] = "offline_access";

      await GenerateUserTokenUseCase(sl()).call(data).then((userToken) => {
            if (userToken != null)
              {
                sl<LocalUserRepo>().setUserToken(userToken),
                sl<Dio>().options.headers.addAll(
                  {'Authorization': '${userToken.accessToken}'},
                ),
                loginRequest(),
              },
          });
    }
  }

  //check if user registered in system and store user in shared preferences after that go to home screeb
  Future loginRequest() async {
    CheckUser? checkUser = getRegisteredUser();
    if (checkUser != null) {
      Map<String, dynamic> data = {};

      data["UserID"] = ClsCrypto(checkUser.authKey ?? "").encrypt(userId);
      data["Password"] = ClsCrypto(checkUser.authKey ?? "").encrypt(password);
      data["LicenseKey"] = checkUser.licenseKey;
      data["ClientID"] = checkUser.userClientID;
      data["IsLogin"] = true;
      await LoginUseCase(sl()).call(data).then((value) => {
            if (value?.resultMsg == "Valid User")
              {
                getUserCompanyList(checkUser),
              }
          });
    }
  }

  Future<List<UserCompany>> getUserCompanyList(CheckUser checkUser) async {
    Map<String, dynamic> data = {};

    data["ClientID"] = checkUser.userClientID;
    data["UserID"] = checkUser.userId;

    List<UserCompany>? list = await GetUserCompaniesUseCase(sl()).call(data) ;
    sl<LocalListsRepo>().setUserCompanies(list ?? []);
    reset();

    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    if (user?.userId == checkUser.userId) {
      if (user?.selectedUserCompany?.companyID == null) {
        // save user with frst company
        context
            .read(settingsViewModelProvider)
            .saveSelectedOptionInUser(list?.first);
      }
      // else dont need to save user because it's already saved
    } else {
      //save new user and save first item
      sl<LocalUserRepo>().setLoggedUser(checkUser);
      context
          .read(settingsViewModelProvider)
          .saveSelectedOptionInUser(list?.first);
    }

    sl<NavigationService>().navigateToAndRemove(tabBarScreen);
    return list ?? [];
  }

//check if user registered in system
  CheckUser? getRegisteredUser() {
    CheckUser? user = sl<LocalUserRepo>().getCheckUserByName(userId);
    if (user != null) {
      return user;
    } else {
      showErrorDialog(
        message: "not licensed".localized(),
      );
      return null;
    }
  }
}
