import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../domain/usecases/crm_usecases.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/common_widgets/error_dialog.dart';
import '../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../core/utils/common_widgets/show_snack_bar.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../../../core/utils/constants/cls_crypto.dart';
import '../../data/models/check_user.dart';
import '../../data/models/customer_specification.dart';
import '../../data/models/drop_down_obj.dart';
import '../../data/models/procedure.dart';
import '../../data/models/representative.dart';
import '../allTabs/settings/settings_view_model.dart';
import '../tab_bar/tab_bar_screen.dart';



final procInfoViewModelProvider =
    ChangeNotifierProvider((ref) => ProcInfoViewModel());

enum ProcInfoStatusTypes {
  editing,
  addNew,
  close,
  show,
}

class ProcInfoViewModel extends ChangeNotifier {
  late BuildContext context;

  final procedureObj = StateProvider<Procedure?>((ref) => null);
  final isEdit =
      StateProvider<ProcInfoStatusTypes>((ref) => ProcInfoStatusTypes.show);

  bool isCloseEdit = false;
  bool isLoading = false;
  bool isWalkin = false;

  DateTime selectedDateTime = DateTime.now();

  int? eventAction;

  String? selectedEventId;
  String? selectedRepres;
  CustomerSpecification? selectedCust;
  String? selectedAddress;
  String? selectedContact;
  String? selectedType;
  String? selectedNature;

  String? contacValue;
  String? durationValue;
  String? noteValue;
  String? enteredByUser;

  Representative? selectedRepresentative;
  List<Representative> representativeList = [];
  List<DropdownObj> representativeDropDownList = [
    DropdownObj(name: "", id: "")
  ];

  CustomerSpecification? selectedAddressObj;
  List<CustomerSpecification> addressList = [];
  List<DropdownObj> addressDropDownList = [DropdownObj(name: "", id: "")];

  CustomerSpecification? selectedContactObj;
  List<CustomerSpecification> contactsList = [];
  List<DropdownObj> contactsDropDownList = [DropdownObj(name: "", id: "")];

  CustomerSpecification? selectedTypeObj;
  List<CustomerSpecification> typesList = [];
  List<DropdownObj> typesDropDownList = [DropdownObj(name: "", id: "")];

  CustomerSpecification? selectedNaturObj;
  List<CustomerSpecification> natureList = [];
  List<DropdownObj> natureDropDownList = [DropdownObj(name: "", id: "")];

  Map<String, dynamic> generateParameters() {
    Map<String, dynamic> params = {};
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    params["userID"] = user?.userId;
    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    return params;
  }

  String getTitleText(ProcInfoStatusTypes isEdit) {
    switch (isEdit) {
      case ProcInfoStatusTypes.editing:
        return "Edit Procedure".localized();

      case ProcInfoStatusTypes.addNew:
        return "Add new procedure".localized();

      case ProcInfoStatusTypes.close:
        if (eventAction == 2) {
          return "Cancel Procedure".localized();
        } else {
          return "Close Procedure".localized();
        }

      case ProcInfoStatusTypes.show:
        return "Procedure Information".localized();
    }
  }

  reset() {
    isCloseEdit = false;
    selectedRepres = null;
    selectedCust = null;
    selectedAddress = null;
    selectedType = null;
    selectedNature = null;
    notifyListeners();
  }

  resetCustomerFilters() {
    selectedAddress = null;
    addressList = [];
    addressDropDownList = [DropdownObj(name: "", id: "")];
    selectedAddressObj = null;

    selectedContact = null;
    contactsList = [];
    contactsDropDownList = [DropdownObj(name: "", id: "")];
    selectedContactObj = null;

    notifyListeners();
  }

  showData() {
    var obj = context.read(procedureObj.state).state;

    selectedEventId = obj?.eventId.toString();
    isWalkin = obj?.isWalkIn ?? false;
    setSelectedRepres(obj?.representiveId.toString());

    var customer = CustomerSpecification(
      id: obj?.custId,
      nameA: obj?.custNameA,
      nameE: obj?.custNameE,
      isWalkIn: obj?.isWalkIn,
      filterId: obj?.walkinId ?? 0,
    );
    setSelectedCust(customer);

    setSelectedType(obj?.eventTypeId.toString());
    setSelectedNature(obj?.eventNatureId.toString());

    durationValue = obj?.eventDuration?.toInt().toString() ??
        selectedNaturObj?.option1.toString() ??
        "60";
  }

  Future getMain() async {
    LoadingAlertDialog.show(context, title: "LoadingOptions".localized());
    await getRepresentatives();
    await getNatureList();
    await getTypesList();
    LoadingAlertDialog.dismiss();
  }

  Future<List<Representative>> getRepresentatives() async {
    Map<String, dynamic> data = generateParameters();
    data["userID"] = "";

    List<Representative>? list =
        await GetRepresentativesUseCase(sl()).call(data) ;

    if (list != null) {
      representativeList = list;
      representativeDropDownList = list.toDropdownObj();
      selectedRepresentative = list.first;
    }

    notifyListeners();
    return list ?? [];
  }

  Future<List<CustomerSpecification>> getCustomerAddresses(
      // BuildContext context,
      ) async {
    //LoadingAlertDialog.show(context);

    Map<String, dynamic> data = generateParameters();
    data["CustID"] = selectedCust?.id;
    // Set "WalkinID" to 0 if "isWalkIn" is false, otherwise use the "filterId".
    data["WalkinID"] =
        selectedCust?.isWalkIn == false ? 0 : selectedCust?.filterId;
    data["IsWalkin"] = selectedCust?.isWalkIn;

    List<CustomerSpecification>? list =
        await GetCustomerAddressesUseCase(sl()).call(data) ;

    if (list != null && list.isNotEmpty) {
      addressList = list;
      addressDropDownList = list.toDropdownObj();
      selectedAddressObj = list.first;

      var obj = context.read(procedureObj.state).state;
      if (obj?.addressId != null) {
        setSelectedAddress(obj?.addressId.toString());
      }
    }

    //LoadingAlertDialog.dismiss();

    notifyListeners();
    return list ?? [];
  }

  Future<List<CustomerSpecification>> getCustomerContacts() async {
    Map<String, dynamic> data = generateParameters();
    data["CustID"] = selectedCust?.id;
    data["WalkinID"] = selectedCust?.filterId;
    data["IsWalkin"] = selectedCust?.isWalkIn;

    List<CustomerSpecification>? list =
        await    GetCustomerContactsUseCase(sl()).call(data);

    if (list != null && list.isNotEmpty) {
      contactsList = list;
      contactsDropDownList = list.toDropdownObj();
      selectedContactObj = list.first;

      var obj = context.read(procedureObj.state).state;
      if (obj?.contactPersonId != null) {
        setSelectedContact(obj?.contactPersonId.toString());
      }
    }

    notifyListeners();
    return list ?? [];
  }

  Future<List<CustomerSpecification>> getTypesList() async {
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "CrmSrvEventsType";

    List<CustomerSpecification>? list =
        await   GetCustomerEventPropertyUseCase(sl()).call(data)  ;

    if (list != null && list.isNotEmpty) {
      typesList = list;
      typesDropDownList = list.toDropdownObj();
      selectedTypeObj = list.first;
    }

    notifyListeners();
    return list ?? [];
  }

  Future<List<CustomerSpecification>> getNatureList() async {
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "CrmSrvEventsNature";

    List<CustomerSpecification>? list =
        await  GetCustomerEventPropertyUseCase(sl()).call(data) ;

    if (list != null && list.isNotEmpty) {
      natureList = list;
      natureDropDownList = list.toDropdownObj();
      selectedNaturObj = list.first;
    }

    notifyListeners();
    return list ?? [];
  }

  Future selectDateTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      locale: Locale(isEnglish() ? "en" : "ar", "GB"),
      context: context,
      initialDate: selectedDateTime,
      firstDate: selectedDateTime.isBefore(DateTime.now())
          ? selectedDateTime
          : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 200)),
      builder: (context, child) {
        return Theme(
          data: context.read(settingsViewModelProvider).isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(primary: primaryColor),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(primary: primaryColor),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
          child: child!,
        );
      },
    );
    if (pickedDateTime == null) {
      return;
    }
    pickedDateTime = DateTime(
      pickedDateTime.year,
      pickedDateTime.month,
      pickedDateTime.day,
      DateTime.now().hour,
      DateTime.now().minute,
    );
    if (
        pickedDateTime
            .isAfter(DateTime.now().subtract(const Duration(minutes: 10)))) {
      final TimeOfDay? pickedTime = await showTimePicker(
        confirmText: "OK".localized(),
        cancelText: "Cancel".localized(),
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
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        final _date = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (_date.isAfter(DateTime.now())) {
          selectedDateTime = _date;
        } else {
          showErrorDialog(message: "You cant pick a time in the past  !");
        }
        notifyListeners();
      }
    } else {
      showErrorDialog(message: "You cant pick a past date !");
    }
  }

  setSelectedRepres(String? value) {
    selectedRepres = value;
    selectedRepresentative =
        representativeList.firstWhereOrNull((e) => e.id.toString() == value);
    if (selectedRepresentative == null) {
      selectedRepres = null;
    }
    notifyListeners();
  }

  setSelectedRepresByUserName(String? value) {
    selectedRepresentative = representativeList
        .firstWhereOrNull((e) => e.userId?.toLowerCase().toString() == value);
    if (selectedRepresentative != null) {
      selectedRepres = selectedRepresentative?.id.toString();
    }
    notifyListeners();
  }

  setSelectedCust(CustomerSpecification? value) {
    selectedCust = value;
    resetCustomerFilters();
    getCustomerAddresses();
    getCustomerContacts();

    notifyListeners();
  }

  setSelectedAddress(String? value) {
    selectedAddress = value;
    selectedAddressObj =
        addressList.firstWhereOrNull((e) => e.id.toString() == value);
    if (selectedAddressObj == null) {
      selectedAddress = null;
    }
    notifyListeners();
  }

  setSelectedContact(String? value) {
    selectedContact = value;
    selectedContactObj =
        contactsList.firstWhereOrNull((e) => e.id.toString() == value);

    contacValue =
        isEnglish() ? selectedContactObj?.nameE : selectedContactObj?.nameA;

    if (selectedContactObj == null) {
      selectedContact = null;
    }
    notifyListeners();
  }

  setSelectedType(String? value) {
    selectedType = value;
    selectedTypeObj =
        typesList.firstWhereOrNull((e) => e.id.toString() == value);
    if (selectedTypeObj == null) {
      selectedType = null;
    }
    notifyListeners();
  }

  setSelectedNature(String? value) async {
    selectedNature = value;
    selectedNaturObj =
        natureList.firstWhereOrNull((e) => e.id.toString() == value);

    durationValue = selectedNaturObj?.option1?.toString();

    if (selectedNaturObj == null) {
      selectedNature = null;
    }
    notifyListeners();
  }

  void contacText(String text) {
    contacValue = text;
  }

  void durationText(String text) {
    durationValue = text;
  }

  void noteText(String text) {
    noteValue = text;
  }

  void isWalkinChangeValue(bool value) {
    isWalkin = value;
    selectedCust = null;
    resetCustomerFilters();
    notifyListeners();
  }

  changeIsCloseEdit(bool? value) {
    isCloseEdit = value ?? false;
    notifyListeners();
  }

  bool checkAddEnteredData() {
    if (selectedRepres == null) {
      showErrorDialog(message: "Please select representative.".localized());
      return false;
    }

    if (selectedCust?.id == null) {
      showErrorDialog(message: "Please select customer.".localized());
      return false;
    }

    if (selectedAddress == null && !isWalkin) {
      showErrorDialog(message: "Please select address.".localized());
      return false;
    }

    // if (isWalkin) {
    //   if (contacValue == null) {
    //     showErrorDialog(message: "Please select contact.".localized());
    //     return false;
    //   }
    // } else {
    //   if (selectedContact == null) {
    //     showErrorDialog(message: "Please select contact.".localized());
    //     return false;
    //   }
    // }

    if (selectedType == null) {
      showErrorDialog(message: "Please select type.".localized());
      return false;
    }

    if (selectedNature == null) {
      showErrorDialog(message: "Please select nature.".localized());
      return false;
    }

    if (durationValue == null) {
      showErrorDialog(message: "Please enter duration.".localized());
      return false;
    }

    if (noteValue == null) {
      showErrorDialog(message: "Please enter note.".localized());
      return false;
    }

    return true;
  }

  Future<int?> addnew() async {
    if (checkAddEnteredData() == false) {
      //showErrorDialog(message: "entered data is not complete".localized());
      return null;
    }
//TODO:check the filter id
    Map<String, dynamic> data = generateParameters();
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    data["EventCustID"] = selectedCust?.id;
    data["EventWalkInID"] = isWalkin ? selectedCust?.filterId : -1;
    data["EventDate"] = selectedDateTime.toStringFormat("yyyy-MM-ddTHH:mm:ss");

    data["EventEnteredByUser"] = user?.userName;
    data["EventRepresentiveID"] = selectedRepres;
    data["EventAddressID"] = selectedAddress;
    data["EventNatureID"] = selectedNature;
    data["EventTypeID"] = selectedType;

    data["EventDuration"] = durationValue;
    data["EventDesc"] = noteValue ?? "";

    data["EventContactPersonID"] = selectedContact ?? 0;
    data["EventContactPerson"] = contacValue ?? "";

    isLoading = true;
    notifyListeners();

    int? id = await AddNewEventUseCase(sl()).call(data);

    isLoading = false;
    notifyListeners();
    if (id != null) {
      showSnackBar("${"New procedure added".localized()} $id");
      Navigator.of(context).pop();
      return id;
    } else {
      return null;
    }
  }

  bool checkEditEnteredData(bool isCached) {
    if (selectedRepres == null && !isCached) {
      showErrorDialog(message: "Please select representative.".localized());
      return false;
    }

    if (selectedAddress == null && !isWalkin && !isCached) {
      showErrorDialog(message: "Please select address.".localized());
      return false;
    }

    if (selectedType == null && !isCached) {
      showErrorDialog(message: "Please select type.".localized());
      return false;
    }

    if (selectedNature == null && !isCached) {
      showErrorDialog(message: "Please select nature.".localized());
      return false;
    }

    if (durationValue == null && !isCached) {
      showErrorDialog(message: "Please enter duration.".localized());
      return false;
    }

    if (noteValue == null && !isCached) {
      showErrorDialog(message: "Please enter note.".localized());
      return false;
    }

    return true;
  }

  Future<int?> editEvent(
      {Map<String, dynamic>? eventData,
      bool isCached = false,
      Procedure? object}) async {
    //isCached is true when we are handling cached data (when we execute it on a cached procedure )
    var _obj = object;
    final _connection = await GetConnectionStateUseCase(sl()).call() ;

    if (_connection != ConnectivityResult.none.name) {
      if (checkEditEnteredData(isCached) == false && !isCached) {
        showErrorDialog(message: "entered data is not complete".localized());
        return null;
      }
    } else {
      if (durationValue == null) {
        showErrorDialog(message: "Please enter duration.".localized());
      }

      if (noteValue == null) {
        showErrorDialog(message: "Please enter note.".localized());
      }
    }

    Map<String, dynamic> data = generateParameters();

    data["EventID"] = selectedEventId ?? "";
    data["EventDate"] = selectedDateTime.toStringFormat("yyyy-MM-ddTHH:mm:ss");

    data["RepresentiveID"] = selectedRepres ?? _obj?.representiveId.toString();
    data["AddressID"] = selectedAddress ?? _obj?.addressId;
    data["EventNatureID"] = selectedNature ?? _obj?.eventNatureId.toString();
    data["EventTypeID"] = selectedType ?? _obj?.eventTypeId.toString();

    data["EventDuration"] = durationValue ?? _obj?.eventDuration.toString();
    data["EventDesc"] = noteValue ?? "";

    data["ContactPersonID"] = selectedContact ?? 0;
    data["ContactPerson"] = contacValue ?? "";

    isLoading = true;
    notifyListeners();
    if (GeneralConfigurations().isDebug) {
      log(noteValue ?? "");
    }
    if (_connection == ConnectivityResult.none.name) {
      //edit the cached data locally
      _editLocalData(_obj!.eventId!);
    }
    int? id = await   UpdateEventUseCase(sl()).call(eventData??data) ;

    isLoading = false;
    notifyListeners();

    if (id != null) {
      showSnackBar("Procedure edited successfully".localized());
      Navigator.of(context).pop();
      return id;
    } else {
      return null;
    }
  }

  _editLocalData(int eventId) {
    if (context.read(connectionProvider.notifier).state ==
        ConnectivityResult.wifi.name) {
      return;
    }
    //this updates the data locally so the user see the changed data when there is no connection
    final _data = jsonDecode(
        sl<SharedPreferences>().getString(CacheKeys().proceduresList) ?? "");
    if (_data == "" || _data == null) {
      return;
    }
    List<Procedure> list =
        _data.map<Procedure>((x) => Procedure.fromJson(x)).toList();
    list.firstWhere((element) => element.eventId == eventId).eventDesc =
        noteValue;
    list.firstWhere((element) => element.eventId == eventId).eventDuration =
        double.parse(durationValue.toString());
    sl<SharedPreferences>()
        .setString(CacheKeys().proceduresList, jsonEncode(list));
  }

  Future<int?> duplicateEvent(
      {Map<String, dynamic>? eventData,
      bool isCached = false,
      Procedure? object}) async {
    var obj = object;

    final _connection = await GetConnectionStateUseCase(sl()).call() ;
    if (_connection != ConnectivityResult.none.name) {
      if (checkDuplicateEnteredData(isCached) == false && !isCached) {
        showErrorDialog(message: "entered data is not complete".localized());
        return null;
      }
    }

    Map<String, dynamic> data = generateParameters();

    data["EventID"] = selectedEventId ?? "";
    data["EventAction"] = eventAction ?? 0;
    data["EventIsChecked"] = isCloseEdit;
    data["EventDate"] = selectedDateTime.toStringFormat("yyyy-MM-ddTHH:mm:ss");

    data["EventNatureID"] = selectedNature ?? obj?.eventNatureId.toString();
    data["EventTypeID"] = selectedType ?? obj?.eventTypeId.toString();

    data["EventDuration"] = durationValue ?? obj?.eventDuration.toString();
    data["EventDesc"] = noteValue ?? "";

    isLoading = true;
    notifyListeners();
    if (isCloseEdit) {
      //its edit so we edit the local data
      _editLocalData(obj!.eventId!);
    }
    int? id = await    DuplicateEventUseCase(sl()).call(eventData??data) ;

    isLoading = false;
    notifyListeners();

    if (id != null) {
      if (isCloseEdit) {
        showSnackBar("${"New procedure added".localized()} $id");
      }
      Navigator.of(context).pop(false);
      return id;
    } else {
      return null;
    }
  }

  bool checkDuplicateEnteredData(bool isCached) {
    if (selectedType == null && !isCached) {
      showErrorDialog(message: "Please select type.".localized());
      return false;
    }

    if (selectedNature == null && !isCached) {
      showErrorDialog(message: "Please select nature.".localized());
      return false;
    }

    if (durationValue == null && !isCached) {
      showErrorDialog(message: "Please enter duration.".localized());
      return false;
    }

    if (noteValue == null && !isCached) {
      showErrorDialog(message: "Please enter note.".localized());
      return false;
    }

    return true;
  }
}
