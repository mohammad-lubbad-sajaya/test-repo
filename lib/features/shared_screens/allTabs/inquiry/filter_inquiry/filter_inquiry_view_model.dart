import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../crm/domain/usecases/crm_usecases.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../../core/utils/constants/cls_crypto.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../crm/data/models/check_user.dart';
import '../../../../crm/data/models/customer_specification.dart';
import '../../../../crm/data/models/drop_down_obj.dart';
import '../../../../crm/data/models/entered_users.dart';
import '../../../../crm/data/models/representative.dart';


final filterInquiryViewModelProvider =
    ChangeNotifierProvider((ref) => FilterIInquiryViewModel());

class FilterIInquiryViewModel extends ChangeNotifier {
  late BuildContext context;

  DateTime now = DateTime.now();

  bool isOpen = true;
  bool isClosed = false;
  bool isCanceled = false;
  bool isScheduled = false;
  bool isWalkin = true;
  bool isOrdinary = true;
  String? selectedRepres;
  String? selectedEnteredUser;
  String? selectedPeriod;
  DateTime selectedFromDate = DateTime(DateTime.now().year, 1, 1);
  DateTime selectedToDate = DateTime(DateTime.now().year + 1, 0, 31);

  Representative? selectedRepresentative;
  List<Representative> representativeList = [];
  List<DropdownObj> representativeDropDownList = [
    DropdownObj(name: "", id: "")
  ];

  EnteredUsers? selectedEnteredUserObj;
  List<EnteredUsers> enteredUsersList = [];
  List<DropdownObj> enteredUsersDropDownList = [
    DropdownObj(name: "", id: ""),
  ];

  List<DropdownObj> allTypesList = [];
  List<DropdownObj> typesList = [];

  List<DropdownObj> allNatureList = [];
  List<DropdownObj> natureList = [];

  List<DropdownObj> periodList = [];

  CustomerSpecification? selectedCust;

  Map<String, dynamic> generateParameters() {
    Map<String, dynamic> params = {};
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    params["userID"] = user?.userId;
    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    return params;
  }

  setPeriodList() {
    periodList = [
      DropdownObj(id: "1", name: "Upcoming".localized()),
      DropdownObj(id: "2", name: "Today".localized()),
      DropdownObj(id: "3", name: "Last day".localized()),
      DropdownObj(id: "4", name: "Last week".localized()),
      DropdownObj(id: "5", name: "Last month".localized()),
      DropdownObj(id: "6", name: "Last 3 months".localized()),
      DropdownObj(id: "7", name: "Last year".localized()),
    ];
  }

  setSelectedRepresAndUserByUserName(String? value) {
    if (selectedRepresentative == null) {
      selectedRepresentative = representativeList
          .firstWhereOrNull((e) => e.userId?.toLowerCase().toString() == value);
      if (selectedRepresentative != null) {
        selectedRepres = selectedRepresentative?.id.toString();
      }
    }

    if (selectedEnteredUserObj == null) {
      selectedEnteredUserObj = enteredUsersList
          .firstWhereOrNull((e) => e.enteredByUser?.toLowerCase() == value);
      if (selectedEnteredUserObj != null) {
        selectedEnteredUser = selectedEnteredUserObj?.enteredByUser.toString();
      }
    }

    notifyListeners();
  }

  reset() {
    selectedRepresentative = null;
    selectedRepres = null;

    selectedEnteredUserObj = null;
    selectedEnteredUser = null;

    selectedCust = null;
    isOpen = true;
    isClosed = false;
    isCanceled = false;
    isScheduled = false;

    isWalkin = true;
    isOrdinary = true;

    allTypesList = [];
    allNatureList = [];

    typesList = allTypesList;
    natureList = allNatureList;

    restPeriod();
    notifyListeners();
  }

  restPeriod() {
    selectedPeriod = null;
    selectedFromDate = DateTime(DateTime.now().year, 1, 1);
    selectedToDate = DateTime(DateTime.now().year + 1, 0, 31);
  }

  Future getMain() async {
    LoadingAlertDialog.show(context, title: "LoadingOptions".localized());

    setPeriodList();
    await getEventEnteredByUsers();
    await getRepresentatives();
    if (allTypesList.isEmpty) {
      await getTypesList();
    }
    if (allNatureList.isEmpty) {
      await getNatureList();
    }
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    setSelectedRepresAndUserByUserName(user?.userName);
    LoadingAlertDialog.dismiss();
  }

  Future<List<EnteredUsers>> getEventEnteredByUsers() async {
    List<EnteredUsers>? list =
        await GetEventEnteredByUsersUseCase(sl()).call(generateParameters()) ;

    if (list != null) {
      enteredUsersList = list;
      enteredUsersDropDownList = list.toDropdownObj();
    }

    return list ?? [];
  }

  Future<List<Representative>> getRepresentatives() async {
    Map<String, dynamic> data = generateParameters();
    data["userID"] = "";

    List<Representative>? list =
        await  GetRepresentativesUseCase(sl()).call(data);

    if (list != null) {
      representativeList = list;
      representativeDropDownList = list.toDropdownObj();
    }

    notifyListeners();
    return list ?? [];
  }

  getTypesList() async {
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "CrmSrvEventsType";

    List<CustomerSpecification>? list =
        await GetCustomerEventPropertyUseCase(sl()).call(data);

    if (list != null && list.isNotEmpty) {
      allTypesList = list.toDropdownObj();
      typesList = allTypesList;
      //setSelectedTypeList(list.toDropdownObj());
    }

    notifyListeners();
    return list ?? [];
  }

  getNatureList() async {
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "CrmSrvEventsNature";

    List<CustomerSpecification>? list =
        await  GetCustomerEventPropertyUseCase(sl()).call(data);

    if (list != null && list.isNotEmpty) {
      allNatureList = list.toDropdownObj();
      natureList = allNatureList;
      //setSelectedNaturList(list.toDropdownObj());
    }

    notifyListeners();
    return list ?? [];
  }

  setSelectedTypeList(List<Object?> values) {
    List<DropdownObj> list = [];
    for (var i in values) {
      if (i is DropdownObj) {
        list.add(i);
      }
    }
    typesList = list;
  }

  setSelectedNaturList(List<Object?> values) {
    List<DropdownObj> list = [];
    for (var i in values) {
      if (i is DropdownObj) {
        list.add(i);
      }
    }
    natureList = list;
  }

  setSelectedRepres(String? value) {
    selectedRepres = value;
    selectedRepresentative = representativeList.firstWhereOrNull(
        (e) => e.id.toString().toLowerCase() == value?.toLowerCase());
    if (selectedRepresentative == null) {
      selectedRepres = null;
    }
    notifyListeners();
  }

  setSelectedUser(String? value) {
    selectedEnteredUser = value;
    selectedEnteredUserObj = enteredUsersList.firstWhereOrNull((e) =>
        e.enteredByUser.toString().toLowerCase() == value?.toLowerCase());
    if (selectedEnteredUserObj == null) {
      selectedEnteredUser = null;
    }
    notifyListeners();
  }

  setSelectedPeriod(String? value) {
    selectedPeriod = value;
    setPeriodDate();
    notifyListeners();
  }

  changeIsOpenValue(bool value) {
    isOpen = value;
    notifyListeners();
  }

  changeIsClosedValue(bool value) {
    isClosed = value;
    notifyListeners();
  }

  changeIsCanceledValue(bool value) {
    isCanceled = value;
    notifyListeners();
  }

  changeIsScheduledValue(bool value) {
    isScheduled = value;
    notifyListeners();
  }

  changeIsOrdinaryValue(bool value) {
    isOrdinary = value;
    restSelectedCust();
    notifyListeners();
  }

  changeIsWalkinValue(bool value) {
    isWalkin = value;
    restSelectedCust();
    notifyListeners();
  }

  setSelectedCust(CustomerSpecification? value) {
    selectedCust = value;

    notifyListeners();
  }

  restSelectedCust() {
    if (isOrdinary && isWalkin) {
      selectedCust = null;
    }

    if (isOrdinary == false && isWalkin == false) {
      selectedCust = null;
    }
  }

  setPeriodDate() {
    switch (selectedPeriod) {
      case "1": //Upcoming
        final tomorrow = now.add(const Duration(days: 1));
        selectedFromDate =
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0, 0);

        final nextYear = DateTime(now.year + 2, now.month, now.day, 0, 0, 0);
        selectedToDate = nextYear;
        break;

      case "2": //Today
        selectedFromDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        selectedToDate = DateTime(now.year, now.month, now.day+1, 0, 0, 0);
        break;

      case "3": //Last day
        final lastDay = now.add(const Duration(days: -1));

        selectedFromDate =
            DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0, 0);

        selectedToDate =
            DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0, 0);
        break;

      case "4": //Last week
        final firstDay = now.add(const Duration(days: -7));
        selectedFromDate =
            DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 0, 0);

        final lastDay = now.add(const Duration(days: -1));
        selectedToDate =
            DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0, 0);
        break;

      case "5": //Last month
        final firstDay =
            DateTime(now.year, now.month - 1, now.day - 1, 0, 0, 0);
        selectedFromDate = firstDay;

        final lastDay = now.add(const Duration(days: -1));
        selectedToDate =
            DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0, 0);
        break;

      case "6": //Last 3 months
        final last3Month = DateTime(now.year, now.month - 3, now.day, 0, 0, 0);
        selectedFromDate = last3Month;

        final lastDay = now.add(const Duration(days: -1));
        selectedToDate =
            DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0, 0);
        break;

      case "7": //Last Yaer
        final lastYaer = DateTime(now.year - 1, now.month, now.day, 0, 0, 0);
        selectedFromDate = lastYaer;

        selectedToDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        break;

      default:
        selectedFromDate = DateTime(DateTime.now().year, 1, 1);
        selectedToDate = DateTime(DateTime.now().year + 1, 0, 31);
    }
  }

  Future selectFromDate(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      locale: Locale(isEnglish() ? "en" : "ar", "GB"),
      context: context,
      initialDate: selectedFromDate,
      firstDate: selectedFromDate.isBefore(DateTime.now())
          ? selectedFromDate
          : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 200)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateTime != null) {
      selectedFromDate = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        0,
        0,
        0,
      );
      notifyListeners();
    }
  }

  Future selectToDate(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      locale: Locale(isEnglish() ? "en" : "ar", "GB"),
      context: context,
      initialDate: selectedToDate,
      firstDate: selectedToDate.isBefore(DateTime.now())
          ? selectedToDate
          : DateTime.now(),
      lastDate:
          selectedToDate.isAfter(DateTime.now().add(const Duration(days: 200)))
              ? selectedToDate
              : DateTime.now().add(const Duration(days: 200)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateTime != null) {
      selectedToDate = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        0,
        0,
        0,
      );
      notifyListeners();
    }
  }

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = {};
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
//TODO: i swiched between cust id and walkin id in case the customer is walkin becuse issue we had erlier in apis the returns the ids flipped in walkin customer
    params["CustID"] = isWalkin?selectedCust?.filterId??0: selectedCust?.id ??
            0; // 0 all customers or the ID set from filter page
    params["WalkinID"] = isWalkin ? selectedCust?.id??0 : 0; // same
    params["representiveID"] = selectedRepresentative?.id ?? 0; //
    params["dateFrom"] =
        selectedFromDate.toStringFormat("yyyy-MM-dd'T'HH:mm:ss");
    params["dateTo"] = selectedToDate.toStringFormat("yyyy-MM-dd'T'HH:mm:ss");
    params["enteredByUser"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(selectedEnteredUserObj?.enteredByUser ?? "");
    params["IsWalkin"] = isWalkin;
    params["IsOrdinary"] = isOrdinary;
    params["IsOpen"] = isOpen;
    params["IsClosed"] = isClosed;
    params["IsCanceled"] = isCanceled;
    params["IsScheduled"] = isScheduled;
    params["NatureArray"] =
        natureList.map((e) => int.parse(e.id ?? "0")).toList();
    params["TypeArray"] = typesList.map((e) => int.parse(e.id ?? "0")).toList();

    return params;
  }
}
