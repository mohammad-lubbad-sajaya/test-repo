import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';
import '../../../crm/domain/usecases/crm_usecases.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../core/utils/constants/cls_crypto.dart';
import '../../../crm/data/models/check_user.dart';
import '../../../crm/data/models/entered_users.dart';
import '../../../crm/data/models/event_count.dart';
import '../../../crm/data/models/procedure.dart';
import '../../tab_bar/tab_bar_view_model.dart';
import '../settings/settings_view_model.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeViewModel extends ChangeNotifier {
  late BuildContext context;
  final textController = TextEditingController();

  Map<String, dynamic> params = {};

  bool? isAdmin;

  List<EnteredUsers> enteredUsersList = [];
  EnteredUsers? selectedEnteredUsersObj;
  String? selectedEnteredUser;

  List<EventCount> eventsCountList = [];
  String? selectedEventCountDate;

  List<Procedure> proceduresList = [];
  List<Procedure> filteredProcedures = [];

  getMain({
    bool isShowLoading = true,
  }) {
    clearSearch();
    generateParameters();
    checkIsAdmin(isShowLoading: isShowLoading);
  }

  Future refresh() async {
    getEventBadgeCount();
    notifyListeners();
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

    selectedEnteredUser ??= user?.userName;
    params["enteredByUser"] =
        ClsCrypto(user?.authKey ?? "").encrypt(selectedEnteredUser!);

    params["clientID"] = user?.userClientID;
    params["RepresentiveID"] = selectedEnteredUsersObj?.representiveId ?? 0;

    if (selectedEventCountDate != null) {
      final date =
          selectedEventCountDate!.convertToFormat("yyyy-MM-dd'T'HH:mm:ss");
      params["DateFrom"] = date;
    } else {
      params["DateFrom"] = "";
    }
  }

  Map<String, dynamic> getUserInfoParameters() {
    Map<String, dynamic> data = {};
    data["userID"] = params["userID"];
    data["clientID"] = params["clientID"];
    data["databaseName"] = params["databaseName"];
    return data;
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

  //check is logged user is admin or not
  Future<bool> checkIsAdmin({
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "checkIsAdmin".localized(),
      );
    }
    bool isAdmin =
        await CheckIsAdminUseCase(sl()).call(getUserInfoParameters());

    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    this.isAdmin = isAdmin;
    if (isAdmin) {
      getEventEnteredByUsers(isShowLoading: isShowLoading);
    } else {
      getEventsCountAndDate(isShowLoading: isShowLoading);
    }

    return isAdmin;
  }

  //get all users representative to logged user and show them in list
  Future<List<EnteredUsers>> getEventEnteredByUsers({
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "getEventEnteredByUsers".localized(),
      );
    }
    List<EnteredUsers>? list =
        await GetEventEnteredByUsersUseCase(sl()).call(getUserInfoParameters());

    enteredUsersList = list ?? [];
    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    getEventsCountAndDate(isShowLoading: isShowLoading);

    return list ?? [];
  }

  resetProcedures() {
    proceduresList = [];
    filteredProcedures = [];
    notifyListeners();
  }

  //to change SelectedEnteredUser and reset selected date and get all events again
  setSelectedEnteredUser(String? value) {
    selectedEnteredUser = value;
    selectedEnteredUsersObj =
        enteredUsersList.firstWhereOrNull((e) => e.enteredByUser == value);
  }

  String? getSelectedEnteredUserName() {
    return isEnglish()
        ? selectedEnteredUsersObj?.userNameE
        : selectedEnteredUsersObj?.userNameA;
  }

  //get all users dates to show in dropdown and get all events again
  Future<List<EventCount>> getEventsCountAndDate({
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "getEventsCountAndDate".localized(),
      );
    }

    Map<String, dynamic> data = getFilteredParameters();

    data["DateFrom"] = "";
    List<EventCount>? list =
        await GetEventsCountAndDateUseCase(sl()).call(data);
    eventsCountList = list ?? [];
    checkIfSelectedEventCountDateIsExist();

    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    getEventBadgeCount(isShowLoading: isShowLoading);

    return list ?? [];
  }

  checkIfSelectedEventCountDateIsExist() {
    if (selectedEventCountDate != null) {
      var obj = eventsCountList.firstWhereOrNull((obj) =>
          obj.eventDate?.converStringToDate() == selectedEventCountDate);
      if (obj == null) {
        selectedEventCountDate = null;
        resteDate(isShowLoading: false);
      }
    }
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

    Map<String, dynamic> newData = getFilteredParameters();
    if (params["DateFrom"] == "") {
      newData["DateFrom"] = getToday();
    } else {
      newData["DateFrom"] = newData["DateFrom"];
    }

    int? value2 =  await GetEventBadgeCountUseCase(sl()).call(newData);

    var tabBarViewModel = context.read(tabBarViewModelProvider);
    context.read(tabBarViewModel.allProcBadgeCount.state).state =
        allProcValue ?? 0;

    context.read(tabBarViewModel.dailyBadgeCount.state).state = value2 ?? 0;

    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    getOpenedProcedures(isShowLoading: isShowLoading);

    return allProcValue;
  }

  //get all selected user events
  Future<List<Procedure>> getOpenedProcedures({
    bool isAll = false,
    bool isShowLoading = true,
  }) async {
    if (isShowLoading) {
      LoadingAlertDialog.show(
        context,
        title: "getOpenedProcedures".localized(),
      );
    }
    Map<String, dynamic> data = getFilteredParameters();
    if (isAll) {
      data["DateFrom"] = "";
    } else {
      if (params["DateFrom"] == "") {
        data["DateFrom"] = getToday();
      } else {
        data["DateFrom"] = data["DateFrom"];
      }
    }

    List<Procedure>? list = await GetOpenedProceduresUseCase(sl())
        .call(data, context.read(settingsViewModelProvider).remindInMinutes);
    proceduresList = list ?? [];
    filteredProcedures = proceduresList;
    if (isShowLoading) {
      LoadingAlertDialog.dismiss();
    }
    notifyListeners();
    return list ?? [];
  }

  //change selected user date and get all events again
  setSelectedEventCount(String? value) {
    clearSearch();
    selectedEventCountDate = value;
    generateParameters();
    getEventBadgeCount();
  }

  //reste selected Date to today and get all events again
  resteDate({
    bool isShowLoading = true,
  }) {
    selectedEventCountDate = null;
    generateParameters();
    getEventEnteredByUsers(isShowLoading: isShowLoading);
  }

  bool isUserIDSelected(String? userName) {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    return user?.userName?.toLowerCase() == userName?.toLowerCase();
  }
}
