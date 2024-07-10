import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/extentions.dart';
import '../../../core/services/local_repo/local_user_repository.dart';
import '../../../core/services/routing/navigation_service.dart';
import '../../../core/services/routing/routes.dart';
import '../../../core/services/service_locator/dependency_injection.dart';
import '../../../core/utils/common_widgets/error_dialog.dart';
import '../../../core/utils/common_widgets/show_confirmation_dialog.dart';
import '../../../core/utils/constants/cls_crypto.dart';
import '../../crm/data/models/check_user.dart';
import '../../crm/data/models/client_information.dart';
import '../../crm/data/models/error_res.dart';
import '../../crm/domain/usecases/crm_usecases.dart';


final signupViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

//final getClientInfoData = FutureProvider((ref) => SignupViewModel().getClientInfo());

class SignupViewModel extends ChangeNotifier {
  String userId = '';
  String password = '';
  String license = '';

  bool isUserIdValid = true;
  bool isPasswordValid = true;
  bool isLicenseValid = true;

  String userIdErrorText = '';
  String passwordErrorText = '';
  String licenseErrorText = '';

  bool isObscureText = true;
  bool isLoading = false;

  obscureText() {
    isObscureText = !isObscureText;
    notifyListeners();
  }

  void validateUserId(String value) {
    userId = value.trim();
    isUserIdValid = value.isNotEmpty;

    if (isUserIdValid) {
      userIdErrorText = '';
    } else {
      userIdErrorText = 'userId is required';
    }

    notifyListeners();
  }

  void validatePassword(String value) {
    password = value.trim();
    isPasswordValid = value.isNotEmpty;

    if (isPasswordValid) {
      passwordErrorText = '';
    } else {
      passwordErrorText = 'Password is required';
    }

    notifyListeners();
  }

  void validateLicense(String value) {
    license = value.trim();
    isLicenseValid = value.isNotEmpty;

    if (isLicenseValid) {
      licenseErrorText = '';
    } else {
      licenseErrorText = 'License Key is required';
    }

    notifyListeners();
  }

  bool get isFormValid => isUserIdValid && isPasswordValid && isLicenseValid;

// handle all text fields and check license key is valid
  Future signup(BuildContext context) async {
    validateUserId(userId);
    validatePassword(password);
    validateLicense(license);

    if (isFormValid) {
      runZonedGuarded(
        () async {
          await getClientInfo(context);
          isLoading = false;
          notifyListeners();
        },
        (e, s) {
          isLoading = false;
          notifyListeners();
          ErrorResponse.handelError(context, e, "signup");
        },
      );
    }
  }

// check license key is valid after that check user is registered in system from api
  Future getClientInfo(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {};
    data["ProductID"] = 8;
    data["LicenseKey"] = ClsCrypto("").encrypt(license.replaceAll(" ", "-"));

    ClientInformation? value = await GetClientInfoUseCase(sl()).call(data);
    if (value != null) {
      checkUserRequest(context, value);
    }
    isLoading = false;
    notifyListeners();
  }

// check user is registered in system from api and check if reigested in device or rplace the license key
  checkUserRequest(BuildContext context, ClientInformation value) async {
    Map<String, dynamic> data = {};
    data["ClientID"] = value.clientID;
    data["UserID"] = ClsCrypto(value.authKey ?? "").encrypt(userId);
    data["Password"] = ClsCrypto(value.authKey ?? "").encrypt(password);
    data["LicenseKey"] =
        ClsCrypto(value.authKey ?? "").encrypt(license.replaceAll(" ", "-"));
    data["IsLogin"] = false;

    //sl<LocalUserRepo>().setClientInformation(value);

    CheckUser? user = await SignupUserUseCase(sl()).call(data);
    if ((user?.clientID?.isNotEmpty ?? false) &&
        (user?.clientSecret?.isNotEmpty ?? false)) {
      user?.authKey = value.authKey;
      user?.userId = data["UserID"];
      user?.userName = userId;
      user?.password = data["Password"];
      user?.userClientID = data["ClientID"];
      user?.licenseKey = data["LicenseKey"];
      if (sl<LocalUserRepo>().checkIfExist(user!) != null) {
        if (sl<LocalUserRepo>().checkIfExist(user)!.licenseKey ==
            user.licenseKey) {
          delete(user.userId);
        } else {
          replace(user);
        }
      } else {
        storeUser(user);
      }
    } else {
      if (user?.resultMsg == "Invalid Sign Up User") {
        showErrorDialog(message: "errorPassword".localized());
      } else {
        showErrorDialog(message: user?.resultMsg ?? "");
      }
    }
    isLoading = false;
    notifyListeners();
  }

// show alert to confirm  delete license form device
  delete(String? userId) {
    showConfirmationDialog(
      context: sl<NavigationService>().getContext(),
      title: 'Warning!'.localized(),
      content: "delete license".localized(),
      onAccept: () {
        sl<LocalUserRepo>().removeCheckUserById(userId);
        Navigator.of(sl<NavigationService>().getContext()).pop(false);
      },
    );
  }

// show alert to confirm  replace license form device
  replace(CheckUser value) {
    showConfirmationDialog(
      context: sl<NavigationService>().getContext(),
      title: 'Warning!'.localized(),
      content: "replace license".localized(),
      onAccept: () {
        if (sl<LocalUserRepo>().removeCheckUserByUsername(value.userName)) {
          sl<LocalUserRepo>().setCheckUser(value);
        }

        Navigator.of(sl<NavigationService>().getContext()).pop(false);
      },
    );
  }

// show alert to notic user the license key is registered in device
  storeUser(CheckUser value) {
    sl<LocalUserRepo>().setCheckUser(value);
    if (value.resultMsg != "") {
      showConfirmationDialog(
        barrierDismissible: false,
        context: sl<NavigationService>().getContext(),
        title: 'Information!'.localized(),
        textButton: 'ok'.localized(),
        content: "License added on device.".localized(),
        onAccept: () {
          Navigator.of(sl<NavigationService>().getContext()).pop(false);
        },
      );
    } else {
      Navigator.of(sl<NavigationService>().getContext()).pop(false);
    }
  }

// when user clicks on the back button show alert dialog to disregard modifications
  backButton({BuildContext? context}) {
    showConfirmationDialog(
        context: context ?? sl<NavigationService>().getContext(),
        title: 'Warning!'.localized(),
        content: "disregard modifications".localized(),
        onAccept: () {
          Navigator.of(context!).pop();
          sl<NavigationService>().navigateToAndReplace(loginScreen);
        });
  }
}
