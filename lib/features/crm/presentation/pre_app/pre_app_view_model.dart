// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajaya_general_app/core/services/extentions.dart';
import 'package:sajaya_general_app/features/crm/domain/usecases/crm_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/services/local_repo/local_repository.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/common_widgets/show_snack_bar.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../../../core/utils/methods/shared_methods.dart';
import '../../data/models/error_res.dart';
import '../../data/models/procedure.dart';
import '../../data/models/user_token.dart';
import '../allTabs/all_proc/view_models/all_proc_view_model.dart';
import '../allTabs/home/home_view_model.dart';
import '../procedure_information/procedure_information_view_model.dart';
import '../procedure_place/procedure_place_view_model.dart';


final preAppViewModelProvider =
    ChangeNotifierProvider((ref) => PreAppViewModel());

class PreAppViewModel with ChangeNotifier {
  bool refreshTokenLoading = false;
  String? refreshTokenError;
  var isConnected = false;

  Future<void> getMain({bool isCached = false, BuildContext? context}) async {
    // refreshTokenLoading = true;
    // refreshTokenError = null;

    runZonedGuarded(
      () async {
        var user = sl<LocalUserRepo>().getUserToken();
        final _connection = await  GetConnectionStateUseCase(sl()).call();
        var isRememberMe = sl<LocalRepo>().getIsRememberMe()??false;

        if (user?.accessToken != null&&isRememberMe) {
          if (_connection == ConnectivityResult.none.name) {
            navigator(screen: tabBarScreen);
          } else {
            sl<Dio>().options.headers.remove("Authorization");
            refreshToken(user!, isCached, context);
          }
        } else {
          navigator(screen: loginScreen);
        }
        notifyListeners();
      },
      (e, s) {
        refreshTokenLoading = false;

        if (!isCached) notifyListeners();
        ErrorResponse.handelError(null, e, "refreshAccessToken");
      },
    );
  }

  // void setNewToken(String token) {
  //   User? _user = sl<LocalRepo>().getUser();
  //   if (_user != null) {
  //     _user.data!.accessToken = token;
  //     sl<LocalRepo>().setUser(_user);
  //     refreshToken();
  //   }
  // }

  void navigator({required String screen}) {
    Timer(
      const Duration(seconds: 2),
      () {
        sl<NavigationService>().navigateToAndRemove(screen);
      },
    );
  }

  void refreshToken(
      UserToken userToken, bool isCached, BuildContext? context) async {
    var user = sl<LocalUserRepo>().getLoggedUser();
    Map<String, dynamic> data = {};
    data["grant_type"] = "refresh_token";

    data["username"] = user?.userName;
    data["client_id"] = user?.clientID;
    data["client_secret"] = user?.clientSecret;
    data["access_token"] = "${userToken.accessToken}";
    data["refresh_token"] = userToken.refreshToken;
    data["scope"] = "offline_access";

    await RefreshUserTokenUseCase(sl()).call(data) .then(
          (newUser) => {
             if(GeneralConfigurations().isDebug){
            log('token: ${newUser?.accessToken}'),
             },
            if (newUser != null)
              {
                sl<LocalUserRepo>().setUserToken(newUser),
                sl<Dio>().options.headers.addAll(
                  {'Authorization': '${newUser.accessToken}'},
                ),
                if (isCached)
                  {
                    //set context value for providers
                    context?.read(allProcModelProvider).context = context,
                    context?.read(homeViewModelProvider).context = context,
                    context?.read(procedurePlaceViewModelProvider).context =
                        context,
                    //get daily and all procedures first and sync data
                    context
                        ?.read(homeViewModelProvider)
                        .getMain(isShowLoading: false),
                    context
                        ?.read(allProcModelProvider)
                        .getMain(isShowLoading: false),
                    Timer(const Duration(seconds: 3), () {
                      //since this executes when there is connection we check cached data and execute if there is cached ops

                      // handle meeting cached data
                      context
                          ?.read(procedurePlaceViewModelProvider)
                          .executeCachedData();

                      //handle edit and close cached procedures
                      _executeCachedOps(context: context);
                    })
                  },
                if (!isCached)
                  {
                    navigator(screen: tabBarScreen),
                  }
              }
            else
              {
                navigator(screen: loginScreen),
              }
          },
        );
  }

  _executeCachedOps({BuildContext? context}) {
    _closeProcedureOps(context!);
    _editProcedureOps(context);

    context.read(allProcModelProvider).getMain();
    context.read(homeViewModelProvider).getMain(isShowLoading: false);
    
  }

  _editProcedureOps(BuildContext context) {
    final _editProceduresList =
        sl<SharedPreferences>().getStringList(CacheKeys().editEvent) ?? [];
    final _allProcedures = context.read(allProcModelProvider).proceduresList;

    if (_editProceduresList.isNotEmpty) {
      for (var element in _editProceduresList) {
        final _procedure = _allProcedures.firstWhere(
          (procedure) =>
              procedure.eventId ==
              int.parse(jsonDecode(element)["EventID"].toString()),
          orElse: () => Procedure(eventId: -1),
        );
        if (_procedure.eventId == -1) {
          showSnackBar(
              "${"Could Not Make Action Procedure Not Exist".localized()} ${jsonDecode(element)["EventID"].toString()}");
          //delete the cached data since its no longer exist

          SharedMethods().deleteCachedProcedure(element, CacheKeys().editEvent);
          continue;
        }
        context
            .read(procInfoViewModelProvider)
            .editEvent(eventData: jsonDecode(element), isCached: true);
      }
    }
  }

  _closeProcedureOps(BuildContext context) {
    final _closeProceduresList =
        sl<SharedPreferences>().getStringList(CacheKeys().duplicateEvent) ?? [];
    final _allProcedures = context.read(allProcModelProvider).proceduresList;
    if (_closeProceduresList.isNotEmpty) {
      for (var element in _closeProceduresList) {
         if(GeneralConfigurations().isDebug){
        log("procedure closing is =============================>${jsonDecode(element)["EventID"].toString()}");
         }
        final _procedure = _allProcedures.firstWhere(
          (procedure) => procedure.eventId.toString() == jsonDecode(element)["EventID"].toString(),
          orElse: () => Procedure(eventId: -1),
        );
        if (_procedure.eventId == -1) {
          showSnackBar(
              "${"Could Not Make Action Procedure Not Exist".localized()} ${jsonDecode(element)["EventID"].toString()}");
          //delete the cached data since its no longer exist
          SharedMethods()
              .deleteCachedProcedure(element, CacheKeys().duplicateEvent);

          continue;
        }
        context
            .read(procInfoViewModelProvider)
            .duplicateEvent(eventData: jsonDecode(element), isCached: true);
      }
    }
  }
}
