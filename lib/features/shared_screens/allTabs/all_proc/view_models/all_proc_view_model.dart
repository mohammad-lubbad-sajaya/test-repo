import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../../core/utils/constants/cls_crypto.dart';
import '../../../../crm/data/models/check_user.dart';
import '../../../../crm/data/models/procedure.dart';
import '../../../../crm/domain/usecases/crm_usecases.dart';
import '../../../tab_bar/tab_bar_view_model.dart';
import '../../home/home_view_model.dart';
import '../../settings/settings_view_model.dart';

final allProcModelProvider =
    ChangeNotifierProvider((ref) => AllProcViewModel());

class AllProcViewModel extends ChangeNotifier {
  late BuildContext context;
  final textController = TextEditingController();

  Map<String, dynamic> params = {};

  List<Procedure> proceduresList = [];
  List<Procedure> filteredProcedures = [];

  getMain({
    bool isShowLoading = true,
  }) {
    clearSearch();
    generateParameters();
    getEventBadgeCount(isShowLoading: isShowLoading);
  }

  Future refresh() async {
    getMain();
  }

  void filterList(String searchText) {
    List<Procedure> filteredNameList = [];
    List<Procedure> filteredDecList = [];

    if (searchText.isEmpty) {
      filteredProcedures = proceduresList;
    } else {
      // Filter the list based on the search text
      filteredNameList = proceduresList.where((item) {
        final name = isEnglish() ? item.custNameE ?? "" : item.custNameA ?? "";
        return name.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      filteredDecList = proceduresList.where((item) {
        final desc = item.eventDesc ?? "";
        return desc.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      filteredProcedures = filteredNameList + filteredDecList;
    }

    notifyListeners();
  }

  clearSearch() {
    textController.text = "";
    filteredProcedures = proceduresList;
    notifyListeners();
  }

  generateParameters() {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    params["userID"] = user?.userId;
    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    var selectedEnteredUser =
        context.read(homeViewModelProvider).selectedEnteredUser;

    selectedEnteredUser ??= user?.userName;
    params["enteredByUser"] =
        ClsCrypto(user?.authKey ?? "").encrypt(selectedEnteredUser!);

    params["clientID"] = user?.userClientID;

    var selectedEnteredUsersObj =
        context.read(homeViewModelProvider).selectedEnteredUsersObj;
    params["RepresentiveID"] = selectedEnteredUsersObj?.representiveId ?? 0;

    params["DateFrom"] = "";
  }

  Map<String, dynamic> getFilteredParameters() {
    Map<String, dynamic> data = {};
    data["databaseName"] = params["databaseName"];
    data["enteredByUser"] = params["enteredByUser"];
    data["RepresentiveID"] = params["RepresentiveID"];
    data["clientID"] = params["clientID"];
    data["DateFrom"] = params["DateFrom"];
    return data;
  }

  //get all selected user events
  Future<List<Procedure>> getOpenedProcedures({
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "getOpenedProcedures".localized(),
      );
    }

    List<Procedure>? list = await GetOpenedProceduresUseCase(sl())
        .call(params, context.read(settingsViewModelProvider).remindInMinutes);
   

    proceduresList = list ?? [];
    filteredProcedures = proceduresList;

    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }

    notifyListeners();

    return list ?? [];
  }

  //get Badge Count to show in dayily tab and get all events
  Future<int?> getEventBadgeCount({
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "getEventBadgeCount".localized(),
      );
    }

    Map<String, dynamic> data = getFilteredParameters();

    data["DateFrom"] = "";

    int? allProcValue = await GetEventBadgeCountUseCase(sl()).call(data);

    var tabBarViewModel = context.read(tabBarViewModelProvider);
    context.read(tabBarViewModel.allProcBadgeCount.state).state =
        allProcValue ?? 0;

    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    getOpenedProcedures(isShowLoading: isShowLoading);

    return allProcValue;
  }
}
