import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import "dart:developer";
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:just_audio/just_audio.dart';
import '../../../../core/services/extentions.dart';
import '../../domain/usecases/crm_usecases.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';


import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/location_manager.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/common_widgets/custom_raised_button.dart';
import '../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../core/utils/common_widgets/show_confirmation_dialog.dart';
import '../../../../core/utils/common_widgets/voice_recorder_sheet.dart';
import '../../../../core/utils/constants/cache_keys.dart';
import '../../../../core/utils/constants/cls_crypto.dart';
import '../../../../core/utils/methods/distance_calculator.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/check_user.dart';
import '../../data/models/country.dart';
import '../../data/models/customer_address.dart';
import '../../data/models/drop_down_obj.dart';
import '../../data/models/file_response.dart';
import '../../data/models/nearby_customers.dart';
import '../../data/models/procedure.dart';
import '../allTabs/all_proc/view_models/all_proc_view_model.dart';
import '../allTabs/home/home_view_model.dart';
import '../allTabs/settings/settings_view_model.dart';
import '../main_app_bar.dart';
import '../procedure_information/procedure_information_view_model.dart';
import 'package:file_picker/file_picker.dart';

final procedurePlaceViewModelProvider =
    ChangeNotifierProvider((ref) => ProcedurePlaceViewModel());

class ProcedurePlaceViewModel extends ChangeNotifier {
  late BuildContext context;
  Procedure? procedureObj;
  bool isEditProcedure = false;
  bool isFromCheckAndRepair=false;
  bool isManual = false;
  bool isResetManual = true;
  Position? currentLocation;
  int selectedTab = 0;
  CustomerAddress? selectedCustomerAddress;
  final durationController = TextEditingController();
  DateTime? startTime;
  List<Procedure> customerProcedures = [];
  List<NearbyCustomers> nearbyCustomers = [];
  List<NearbyCustomers> allCustomerAddress = [];

  DropdownObj? selectedCountry;
  List<DropdownObj> countriesDropDownList = [DropdownObj(name: "", id: "")];

  DropdownObj? selectedCity;
  List<DropdownObj> citiesDropDownList = [DropdownObj(name: "", id: "")];

  DropdownObj? selectedArea;
  List<DropdownObj> areasDropDownList = [DropdownObj(name: "", id: "")];

  bool isHideTopBox = false;

  bool isLoadingAdress = false;
  bool isEditAdress = false;
  bool isEditAdressLocation = false;

  String? nameA;
  String? nameE;

  StreamSubscription<Position>? positionStream;

  // DropdownObj? selectedDuration;
  // List<DropdownObj> durationnList = [DropdownObj(name: "", id: "")];

  Timer? timer;
  int min = 0;
  int secondsRemaining = 0;
  int elapsedSeconds = 0;

  bool isStopTimer = false;
  bool isTimerFinished = false;

  bool isAddNewProcedure = false;

  bool isShowArrivedDialog = true;

  bool canDismiss = true;

  String? noteValue;
  String? durationValue;

  reset() {
    canDismiss = true;
    isManual = false;
    startTime = null;
    procedureObj = null;
    currentLocation = null;
    selectedCustomerAddress = null;
    selectedTab = 0;
    isEditProcedure = false;
    isFromCheckAndRepair=false;
    nameA = null;
    nameE = null;
    selectedCountry = null;
    selectedCity = null;
    durationController.text = "";
    selectedArea = null;

    stopLocationUpdates();

    timer?.cancel();
    isTimerFinished = false;
    isStopTimer = false;

    //selectedDuration = null;
    isAddNewProcedure = false;
    noteValue = null;
    durationValue = null;

    isShowArrivedDialog = true;
    isHideTopBox = false;

    selectedFiles = [];
    allAudios = [];
    uploadedFiles = [];
  }

  Future getMain() async {
    startLocationUpdates();
    await getCountries();
    await getCustomerAddresses();
    await getCurrentLocation();

    // durationnList = List<DropdownObj>.generate(
    //   59,
    //   (index) => DropdownObj(id: "${index + 1}", name: "${index + 1}"),
    // );
  }

  changeIsEditProc(bool value) {
    isEditProcedure = value;
    notifyListeners();
  }
  changeIsFromCheckAndRepair(bool value) {
    isFromCheckAndRepair = value;
    notifyListeners();
  }

  changeIsManual(bool value) {
    isManual = value;
    notifyListeners();
  }

  changeIsResetManual(bool value) {
    isResetManual = value;
    notifyListeners();
  }

  startTimer() {
    isStopTimer = true;

    startTime = DateTime.now();
    sl<SharedPreferences>()
        .setString(CacheKeys().startTime, startTime.toString());
    min = int.parse(durationValue ?? "0");
    secondsRemaining = min * 60;
    notifyListeners();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        if (secondsRemaining < 1) {
          // Timer is finished, perform your desired action here
          if (GeneralConfigurations().isDebug) {
            log('Timer finished!');
          }
        } else {
          secondsRemaining = secondsRemaining - 1;
        }
        elapsedSeconds = DateTime.now().difference(startTime!).inSeconds;
        notifyListeners();
      },
    );
  }

  stopTimer() {
    isStopTimer = false;
    timer?.cancel();
    secondsRemaining = 0;
    elapsedSeconds = 0;
    notifyListeners();
  }

  timerFinished({int? manualMin, int? manualSec}) {
    if (manualMin != null) {
      elapsedSeconds = manualMin * 60;
      notifyListeners();
    }
    final _storedTime = DateTime.parse(
        sl<SharedPreferences>().getString(CacheKeys().startTime).toString());
    final _localElapsedSeconds =
        DateTime.now().difference(_storedTime).inSeconds;
    if (manualSec != null) {
      elapsedSeconds = manualSec;
      notifyListeners();
    }
    //we calculate diffrence between stored duration and the counter
    final _diffrence = _localElapsedSeconds - elapsedSeconds;
//if diff is more than 5 min we show dialog to user to tell him
    if (_diffrence > 300) {
      _buildClosingWayDialog(
          context,
          context.read(settingsViewModelProvider).isDark,
          _localElapsedSeconds,
          elapsedSeconds);
    } else {
      // if no diff we proceed with the closing procedure normally
      _calculateDuration(elapsedSeconds);
    }
  }

  _buildClosingWayDialog(
      BuildContext context, bool isDark, int localElapsedSec, int elapsed) {
    showConfirmationDialog(
        context: context,
        barrierDismissible: false,
        isDark: isDark,
        title: "choose time".localized(),
        contentWidget: Container(
          color: isDark ? darkDialogsColor : Colors.white,
          height: isManual ? 220 : 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRaisedButton(
                child: customTextApp(
                    text: "device timing".localized()+" : "+_getDurationString(localElapsedSec),
                    color: Colors.white),
                color: secondaryColor,
                onTap: () {
                  _calculateDuration(localElapsedSec);
                  Navigator.pop(context);
                },
                colors: const [secondaryColor, secondaryColor],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomRaisedButton(
                child: customTextApp(
                    text: "counter timing".localized()+" : "+_getDurationString(elapsed), color: Colors.white),
                color: secondaryColor,
                onTap: () {
                  _calculateDuration(elapsed);
                  Navigator.pop(context);
                },
                colors: const [secondaryColor, secondaryColor],
              ),
            ],
          ),
        ),
        actions: []);
  }

  _calculateDuration(int secondsToCalc) {
    isTimerFinished = true;

    durationValue = _getDurationString(secondsToCalc);

    notifyListeners();
  }

  _getDurationString(int secondsToCalc) {
    int minutes = (secondsToCalc / 60).floor();
    int seconds = secondsToCalc % 60;

    return "$minutes.$seconds";
  }

  String getTimerText() {
    int hours = secondsRemaining ~/ 3600;
    int minutes = (secondsRemaining % 3600) ~/ 60;
    int seconds = secondsRemaining % 60;

    String formattedDuration =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return formattedDuration;
  }

  String getElapsedText() {
    int minutes = (elapsedSeconds / 60).floor();
    int seconds = elapsedSeconds % 60;
    return '00:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  startLocationUpdates() {
    const locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);

    positionStream = Geolocator.getPositionStream(
      desiredAccuracy: locationOptions.accuracy,
      distanceFilter: locationOptions.distanceFilter,
    ).listen((Position position) {
      currentLocation = position;
      showArrivedDialog();
      if (GeneralConfigurations().isDebug) {
        log('position: $position');
      }
      notifyListeners();
    });
  }

  stopLocationUpdates() {
    positionStream?.cancel();
    positionStream = null;
  }

  getCurrentLocation() async {
    LoadingAlertDialog.show(context, title: "GetCurrentLocation".localized());

    try {
      // Retrieve the current location using LocationManager
      final Position position = await LocationManager.getCurrentLocation();
      if (GeneralConfigurations().isDebug) {
        log("this is the position state here :  ======================> is Mocked : ${position.isMocked}");
      }

      // Use the retrieved position as needed
      currentLocation = position;
      if (GeneralConfigurations().isDebug) {
        log('Latitude: ${position.latitude}');
        log('Longitude: ${position.longitude}');
      }
      LoadingAlertDialog.dismiss();
    } catch (e) {
      // Handle exceptions, such as permission denied or location retrieval errors
      if (GeneralConfigurations().isDebug) {
        log('Failed to retrieve location: $e');
      }
      LoadingAlertDialog.dismiss();
    }
    notifyListeners();
  }

  Map<String, dynamic> generateParameters({bool isEnteredByUser = false}) {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    Map<String, dynamic> params = {};
    if (isEnteredByUser) {
      var selectedEnteredUser =
          context.read(homeViewModelProvider).selectedEnteredUser;
      selectedEnteredUser ??= user?.userName;
      params["enteredByUser"] =
          ClsCrypto(user?.authKey ?? "").encrypt(selectedEnteredUser!);
    } else {
      params["userID"] = user?.userId;
    }

    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    return params;
  }

  Future<List<CustomerAddress>> getCustomerAddresses() async {
    LoadingAlertDialog.show(context,
        title: "Get Customer Addresses".localized());

    Map<String, dynamic> data = generateParameters();
    data["AddressID"] = procedureObj?.addressId ?? 0;

    List<CustomerAddress>? list =
        await GetCustomerAddressesByIdUseCase(sl()).call(data) ;
    if (list != null && list.isNotEmpty) {
      selectedCustomerAddress = list.first;

      nameA = list.first.addressNameA ?? "";
      nameE = list.first.addressNameE ?? "";
      selectedCountry = countriesDropDownList.firstWhereOrNull(
        (e) => e.id == list.first.countryID.toString(),
      );
    }

    LoadingAlertDialog.dismiss();
    notifyListeners();
    await getCities();
    await getAreas();
    return list ?? [];
  }

  Future<List<Procedure>> getCustomerProcedures() async {
    LoadingAlertDialog.show(context, title: "getOpenedProcedures".localized());

    Map<String, dynamic> data = generateParameters(isEnteredByUser: true);
    data["RepresentiveID"] = procedureObj?.representiveId ?? 0;
    data["custID"] = procedureObj?.custId ?? 0;
    data["walkinID"] = procedureObj?.walkinId ?? 0;

    List<Procedure>? list =
        await  GetCustomerProceduresUseCase(sl()).call(data) ;

    customerProcedures = list ?? [];
    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  Future<List<NearbyCustomers>> getNearbyCustomers() async {
    LoadingAlertDialog.show(context, title: "getNearbyCustomers".localized());

    Map<String, dynamic> data = generateParameters();
    data["custID"] = 0;
    data["walkinID"] = 0;
    data["AddressID"] = 0;
    data["CenterLat"] = currentLocation?.latitude ?? 0.0;
    data["CenterLng"] = currentLocation?.longitude ?? 0.0;
    data["Radius"] = context.read(settingsViewModelProvider).distanceinMeter;
    data["IsCheckDistance"] = true;

    List<NearbyCustomers>? list =
        await  GetNearbyCustomersUseCase(sl()).call(data) ;

    nearbyCustomers = list ?? [];
    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  Future<List<NearbyCustomers>> getAllCustomersAddress() async {
    LoadingAlertDialog.show(context, title: "getCustomerAddress".localized());

    Map<String, dynamic> data = generateParameters();
    data["custID"] = procedureObj?.custId ?? 0;
    // Set "WalkinID" to 0 if "isWalkIn" is false, otherwise use the "walkinId".
    data["WalkinID"] =
        procedureObj?.isWalkIn == false ? 0 : procedureObj?.walkinId;
    data["AddressID"] = 0;
    data["CenterLat"] = currentLocation?.latitude ?? 0.0;
    data["CenterLng"] = currentLocation?.longitude ?? 0.0;
    data["Radius"] = context.read(settingsViewModelProvider).distanceinMeter;
    data["IsCheckDistance"] = false;

    List<NearbyCustomers>? list =
        await    GetAllCustomerAddressesUseCase(sl()).call(data) ;

    allCustomerAddress = list ?? [];
    allCustomerAddress.sort((a, b) => sortByDistance(a, b));

    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  int sortByDistance(NearbyCustomers a, NearbyCustomers b) {
    double latitude = currentLocation?.latitude ?? 0;
    double longitude = currentLocation?.longitude ?? 0;

    double lat1 = double.parse(a.locationNorth ?? "0");
    double lon1 = double.parse(a.locationEast ?? "0");

    double lat2 = double.parse(b.locationNorth ?? "0");
    double lon2 = double.parse(b.locationEast ?? "0");

    double distanceA =
        DistanceCalculator.calculateDistance(lat1, lon1, latitude, longitude);

    double distanceB =
        DistanceCalculator.calculateDistance(lat2, lon2, latitude, longitude);

    return distanceA.compareTo(distanceB);
  }

  Future<List<Country>> getCountries() async {
    LoadingAlertDialog.show(context, title: "getCountries".localized());

    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "";

    List<Country>? list = await  GetCountriesUseCase(sl()).call(data) ;

    if (list != null) {
      //countriesList = list;
      countriesDropDownList = list.toDropdownObj();
    }

    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  Future<List<Country>> getCities() async {
    LoadingAlertDialog.show(context, title: "getCities".localized());
    if (selectedCountry == null) {
      LoadingAlertDialog.dismiss();
      return [];
    }
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "";
    data["Param1"] = selectedCountry?.id;

    List<Country>? list = await  GetCitiesUseCase(sl()).call(data);

    if (list != null) {
      //citiesList = list;
      citiesDropDownList = list.toDropdownObj();

      //citiesDropDownList.insert(0, DropdownObj(name: "", id: ""));
      selectedCity = citiesDropDownList.firstWhereOrNull(
          (e) => e.id == selectedCustomerAddress?.cityID.toString());
    }

    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  Future<List<Country>> getAreas() async {
    LoadingAlertDialog.show(context, title: "getAreas".localized());
    if (selectedCountry == null) {
      LoadingAlertDialog.dismiss();
      return [];
    }
    if (selectedCity == null) {
      LoadingAlertDialog.dismiss();
      return [];
    }
    Map<String, dynamic> data = generateParameters();
    data["PropertyTable"] = "";
    data["Param1"] = selectedCountry?.id ?? 0;
    data["Param2"] = selectedCity?.id;

    List<Country>? list = await  GetAreasUseCase(sl()).call(data) ;

    if (list != null && list.isNotEmpty) {
      //areasList = list;
      areasDropDownList = list.toDropdownObj();
      areasDropDownList.insert(0, DropdownObj(name: "", id: ""));
      setSelectedArea(selectedCustomerAddress?.areaID.toString());
      selectedArea ??= areasDropDownList[1];
    }
    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  setSelectedCountry(String? value) {
    selectedCountry =
        countriesDropDownList.firstWhereOrNull((e) => e.id == value);

    citiesDropDownList.clear();
    areasDropDownList.clear();

    getCities().then(
      (value) => {
        if (value.isNotEmpty)
          {
            setSelectedCity(value.first.id.toString()),
          }
      },
    );
  }

  setSelectedCity(String? value) {
    selectedCity = citiesDropDownList.firstWhereOrNull((e) => e.id == value);

    areasDropDownList.clear();
    getAreas();
    notifyListeners();
  }

  setSelectedArea(String? value) {
    selectedArea = areasDropDownList.firstWhereOrNull((e) => e.id == value);
    notifyListeners();
  }

  hideTopBox() {
    isHideTopBox = !isHideTopBox;
    notifyListeners();
  }

  // setSelectedDuration(String? value) {
  //   selectedDuration = durationnList.firstWhereOrNull((e) => e.id == value);
  //   stopTimer();
  // }

  changeIsAddNewProcedure(bool? value) {
    isAddNewProcedure = value ?? false;
    notifyListeners();
  }

  void noteText(String text) {
    noteValue = text;
  }

  void durationText(String text) {
    durationValue = text;
  }

  double? getDistance() {
    final lat1 =
        double.tryParse(selectedCustomerAddress?.locationNorth ?? "0") ?? 0.0;
    final lon1 =
        double.tryParse(selectedCustomerAddress?.locationEast ?? "0") ?? 0.0;

    final lat2 = currentLocation?.latitude ?? 0.0;
    final lon2 = currentLocation?.longitude ?? 0.0;

    final distance =
        DistanceCalculator.calculateDistance(lat1, lon1, lat2, lon2);

    // Print the calculated distance
    if (GeneralConfigurations().isDebug) {
      log('Distance: $distance meters');
    }
    String? value = DistanceCalculator.roundDistance(distance, 0);

    return double.parse(value);
  }

  String getDistanceFromated() {
    double value = getDistance() ?? 0.0;

    // Create a NumberFormat instance for formatting with commas as thousands and hundreds separators
    NumberFormat formatter = NumberFormat('#,##0');

    formatter.format(value);
    // Print the calculated distance
    if (GeneralConfigurations().isDebug) {
      log('Distance formatter: ${formatter.format(value)} meters');
    }

    return formatter.format(value);
  }

  didChangeCustomerProcedure(Procedure? obj) {
    procedureObj = obj;
    changeSelectedTab(0);
    notifyListeners();
  }

  didSelectCustomer(NearbyCustomers? obj) {
    procedureObj?.custId = obj?.custId ?? 0;
    procedureObj?.walkinId = obj?.walkInId ?? 0;

    getCustomerProcedures().then(
      (value) => {
        procedureObj = customerProcedures.first,
        getCustomerAddresses().then(
          (value) => {
            selectedTab = 2,
          },
        ),
      },
    );
    notifyListeners();
  }

  didSelectAddress(NearbyCustomers? obj) {
    procedureObj?.custId = obj?.custId ?? 0;
    procedureObj?.walkinId = obj?.walkInId ?? 0;
    procedureObj?.addressId = obj?.addressID ?? 0;
    procedureObj?.addressNameA = obj?.addressNameA;
    procedureObj?.addressNameE = obj?.addressNameE;

    selectedCustomerAddress?.addressID = obj?.addressID ?? 0;
    selectedCustomerAddress?.addressNameA = obj?.addressNameA;
    selectedCustomerAddress?.addressNameE = obj?.addressNameE;

    selectedCustomerAddress?.locationEast = obj?.locationEast;
    selectedCustomerAddress?.locationNorth = obj?.locationNorth;

    isShowArrivedDialog = true;
    changeSelectedTab(0);
    showArrivedDialog();
  }

  didSelectAddAddress({required bool isEdit}) {
    selectedTab = 4;
    isEditAdress = isEdit;

    notifyListeners();
  }

  void nameAText(String text) {
    nameA = text;
  }

  void nameEText(String text) {
    nameE = text;
  }

  changeSelectedTab(int index) {
    selectedTab = index;
    switch (selectedTab) {
      case 0:
        getCustomerAddresses();
        break;

      case 1:
        getNearbyCustomers();
        break;

      case 2:
        getCustomerProcedures();
        break;

      case 3:
        getAllCustomersAddress();
        break;

      case 4:
        break;

      case 5:
        durationValue = procedureObj?.eventDuration?.toInt().toString();
        // selectedDuration = DropdownObj(
        //     id: procedureObj?.eventDuration.toString(),
        //     name: procedureObj?.eventDuration.toString());
        // if (durationnList.any((e) => e.id == selectedDuration?.id) == false) {
        //   durationnList.add(selectedDuration!);
        // }
        break;

      default:
    }
    notifyListeners();
  }

  Future<int?> editOrAddnew() async {
    Map<String, dynamic> data = generateParameters();

    data["EventID"] = procedureObj?.eventId ?? 0;
    data["AddressID"] = isEditAdress ? procedureObj?.addressId : 0;

    data["AddressNameA"] = nameA ?? "";
    data["AddressNameE"] = nameE ?? "";
    data["CountryID"] = selectedCountry?.id ?? 0;
    data["CityID"] = selectedCity?.id ?? 0;
    data["AreaID"] = selectedArea?.id ?? 0;
    data["TaxTypeID"] = selectedCustomerAddress?.taxTypeID ?? 0;

    data["LocationNorth"] = isEditAdressLocation
        ? currentLocation?.latitude.toString()
        : selectedCustomerAddress?.locationNorth.toString();

    data["LocationEast"] = isEditAdressLocation
        ? currentLocation?.longitude.toString()
        : selectedCustomerAddress?.locationEast.toString();

    isLoadingAdress = true;
    notifyListeners();

    int? value = await  AddNewAddressOrEditUseCase(sl()).call(data) ;

    isLoadingAdress = false;
    notifyListeners();
    if (value != null) {
      procedureObj?.addressId = value;
      selectedCustomerAddress?.addressID = value;
      selectedCustomerAddress?.addressNameA = nameA;
      selectedCustomerAddress?.addressNameE = nameE;

      selectedCustomerAddress?.locationNorth = data["LocationNorth"];
      selectedCustomerAddress?.locationEast = data["LocationEast"];
      isShowArrivedDialog = true;
      changeSelectedTab(0);

      showArrivedDialog();
      return value;
    } else {
      return null;
    }
  }

  Future<int?> closeProcedure() async {
    //  if (noteValue == null) {
    //   showErrorDialog(message: "Please enter note.".localized());
    //   return null;
    // }

    Map<String, dynamic> data = generateParameters();
    data["eventID"] = procedureObj?.eventId ?? 0;
    data["eventDate"] = getNowDate();

    data["contactPerson"] = procedureObj?.contactPerson ?? 0;

    data["addressID"] = selectedCustomerAddress?.addressID ?? "";

    data["eventDuration"] = durationValue;
    data["eventDesc"] = noteValue ?? "";

    data["locationNorth"] = selectedCustomerAddress?.locationNorth ?? "";
    data["locationEast"] = selectedCustomerAddress?.locationEast ?? "";

    isLoadingAdress = true;
    notifyListeners();

    int? id = await   CloseCurrentProcedureUseCase(sl()).call(data) ;
    isLoadingAdress = false;
    notifyListeners();
    if (id != null) {
      //showSnackBar("${"New procedure added".localized()} $id");
      final homeViewModel = context.read(homeViewModelProvider);
      final allProcViewModel = context.read(allProcModelProvider);

      if (isAddNewProcedure) {
        var procInfoViewModel = context.read(procInfoViewModelProvider);
        context.read(procInfoViewModel.procedureObj.state).state = procedureObj;
        procInfoViewModel.eventAction = 1;
        procInfoViewModel.isCloseEdit = true;
        context.read(procInfoViewModel.isEdit.state).state =
            ProcInfoStatusTypes.close;
        Navigator.of(context).popAndPushNamed(procedureInformationScreen);
      } else {
        final _connection = await  GetConnectionStateUseCase(sl()).call() ;
        if (_connection == ConnectivityResult.none.name) {
          Navigator.of(context).pop(true);
        } else {
          reloadHomeData(context, allProcViewModel, homeViewModel);
          Navigator.of(context).pop(true);
        }
      }
      reset();
      return id;
    } else {
      return null;
    }
  }

  showArrivedDialog() {
    double distance = getDistance() ?? 0;
    if (distance < context.read(settingsViewModelProvider).distanceinMeter &&
        isShowArrivedDialog) {
      isShowArrivedDialog = false;
      showConfirmationDialog(
        isDark:context.read(settingsViewModelProvider).isDark ,
        barrierDismissible: false,
        context: context,
        title: "Information!".localized(),
        content: "you arrived".localized(),
        onAccept: () {
          changeSelectedTab(5);

          Navigator.of(context).pop(false);

          return true;
        },
        onError: () {
          if(GeneralConfigurations().isDebug){
          log("eror ");
          }
          return false;
        },
      );
    }
    if (distance > context.read(settingsViewModelProvider).distanceinMeter) {
      if (selectedTab == 5) {
        if (isStopTimer) {
          timerFinished();
          stopTimer();
        }
        if (isTimerFinished == false) {
          changeSelectedTab(0);
        }
      }
    }
  }

  List<File> selectedFiles = [];

  Future captureImageOrViedo({required bool isImage}) async {
    XFile? pickedImages;

    if (isImage) {
      pickedImages = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedImages = await ImagePicker().pickVideo(source: ImageSource.camera);
    }

    if (pickedImages != null) {
      //String base64String = File(pickedImages.path).toBase64();
      String fileName = pickedImages.path.getFileName();
      String extension = pickedImages.path.getFileExtension();

      File compressdfile;
      if (isImage) {
        compressdfile = await compressImage(File(pickedImages.path));
      } else {
        LoadingAlertDialog.show(context,
            title: "Compressing Video".localized());
        compressdfile = await compressVideo(File(pickedImages.path));
        LoadingAlertDialog.dismiss();
      }

      sendFileChunks(compressdfile.toBase64(), fileName, extension);
      selectedFiles.add(File(compressdfile.path));

      notifyListeners();
    }
  }

  Future<void> selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        "docx",
        'xlsx',
        'xls',
        'jpg',
        'jpeg',
        'png',
        "txt",
      ],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      String base64String = files[0].toBase64();
      String fileName = files[0].path.getFileName();
      String extension = files[0].path.getFileExtension();

      if (files[0].path.getFileType() == FileTypeValue.image) {
        var compressdfile = await compressImage(files[0]);

        sendFileChunks(compressdfile.toBase64(), fileName, extension);
        selectedFiles += [compressdfile];
      } else if (files[0].path.getFileType() == FileTypeValue.video) {
        LoadingAlertDialog.show(context,
            title: "Compressing Video".localized());
        var compressdfile = await compressVideo(files[0]);
        LoadingAlertDialog.dismiss();

        sendFileChunks(compressdfile.toBase64(), fileName, extension);
        selectedFiles += [compressdfile];
      } else {
        sendFileChunks(base64String, fileName, extension);
        selectedFiles += files;
      }
    } else {
      // User canceled the picker
    }

    notifyListeners();
  }

  void deleteImage(int index) {
    var obj = selectedFiles.removeAt(index);
    getFileIndexAndDelete(obj.path.getFileName());
  }

  void deleteVoice(int index) {
    var obj = allAudios.removeAt(index);
    getFileIndexAndDelete(obj.file.first!.path.getFileName());
  }

  getFileIndexAndDelete(String fileName) {
    for (int i = 0; i < uploadedFiles.length; i++) {
      var lastIndex = uploadedFiles[i].imagePath?.lastIndexOf('_');
      if (lastIndex != -1) {
        // Check if '_' exists in the string
        String? name = uploadedFiles[i].imagePath?.substring(0, lastIndex);
        if (name == fileName) {
          deleteFile(i).then((value) => {
                if (value)
                  {
                    uploadedFiles.removeAt(i),
                    notifyListeners(),
                  }
              });
        }
      }
    }
  }

  Future<Uint8List?> loadVideoThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150,
      quality: 25,
    );
  }

  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  List<FullPickerOutput> allAudios = [];

  getVoiceFile(FullPickerOutput value) async {
    String? baseFile = value.file.first?.toBase64();
    if (GeneralConfigurations().isDebug) {
      log(baseFile.toString());
      log(value.file.first?.path.toString() ?? "");
    }
    String base64String = baseFile ?? "";
    String fileName = value.file.first!.path.getFileName();
    String extension = value.file.first!.path.getFileExtension();
    await sendFileChunks(base64String, fileName, extension);
    allAudios.add(value);
    notifyListeners();
  }

  Future<bool> deleteFile(int index) async {
    LoadingAlertDialog.show(
      context,
      title: "Deleting file".localized(),
    );

    Map<String, dynamic> body = generateParameters();
    body["DocPath"] = uploadedFiles[index].imagePath;
    body["FType"] = uploadedFiles[index].fileExtension;

    String? value = await  DeleteFileAttachmentUseCase(sl()).call(body) ;

    LoadingAlertDialog.dismiss();
    if (value == "Txt file at was deleted.") {
      return true;
    } else {
      return false;
    }
  }

  List<FileResponse> uploadedFiles = [];

  sendFileChunks(String base64String, String fileName, String extension) async {
    // Dividing the Base64 string into 50 KB chunks
    LoadingAlertDialog.show(
      context,
      title: "Uploading file".localized(),
    );
    canDismiss = false;
    notifyListeners();
    int chunkSize = 50 * 1024; // 50 KB
    List<String> chunks = [];
    for (int i = 0; i < base64String.length; i += chunkSize) {
      int end = i + chunkSize < base64String.length
          ? i + chunkSize
          : base64String.length;
      chunks.add(base64String.substring(i, end));
    }

    //String identifier = '$fileNameـ${DateTime.now().millisecondsSinceEpoch}';
    String identifier =
        fileName + "_" + DateTime.now().millisecondsSinceEpoch.toString();
    for (int i = 0; i < chunks.length; i++) {
      String chunk = chunks[i];
      bool isLastChunk = i == chunks.length - 1; // is last one

      Map<String, dynamic> body = generateParameters();
      body["Identifier"] = identifier;
      body["FileExtension"] = extension;
      body["IsLastChunk"] = isLastChunk;
      body["Base64Chunk"] = chunk;
      body["EventID"] = procedureObj?.eventId;
      // debugPrint(
      //     "*************************************************************************************");
      // debugPrint("$i");

      // debugPrint("$body");
      // debugPrint(
      //     "*************************************************************************************");
      FileResponse? value = await  UploadFileChunkUseCase(sl()).call(body) ;

      if (value?.message == "File successfully created!") {
        uploadedFiles.add(value!);
      }
      if (value?.message == null) {
        break;
      }
    }
    LoadingAlertDialog.dismiss();
    canDismiss = true;
    notifyListeners();
    if (GeneralConfigurations().isDebug) {
      log("$uploadedFiles");
    }
  }

  Future insertFileAttachment({bool showLoading = true}) async {
    final _connection = await  GetConnectionStateUseCase(sl()).call() ;
    if (_connection == ConnectivityResult.none.name) {
      return;
    }
    //final List<Future<String?>> requests = [];

    for (int i = 0; i < uploadedFiles.length; i++) {
      if (showLoading) {
        LoadingAlertDialog.show(
          context,
          title: "Uploading file".localized(),
        );
      }
      Map<String, dynamic> data = generateParameters();
      CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
      data["CompanyID"] = user?.selectedUserCompany?.companyID.toString();
      data["EventID"] =
          procedureObj?.eventId.toString() ?? uploadedFiles[i].eventId;

      data["DocPath"] = uploadedFiles[i].imagePath;
      data["DocDesc"] = "";
      data["FType"] = uploadedFiles[i].fileExtension;
      await  InsertFileAttachmentUseCase(sl()).call(data) ;
      if (showLoading) {
        LoadingAlertDialog.dismiss();
      }
    }

    //await Future.wait(requests);
  }

  save() async {
    final _connection = await   GetConnectionStateUseCase(sl()).call() ;
    if (_connection == ConnectivityResult.none.name) {
      closeProcedure();
    } else {
      await insertFileAttachment().then(
        (value) async => {
          if (!isEditProcedure)
            {
              await closeProcedure(),
            }
          else
            {Navigator.of(context).pop(true)}
        },
      );
    }
  }

  executeCachedData() async {
    final _connection =  await  GetConnectionStateUseCase(sl()).call() ;
    if (_connection == ConnectivityResult.none.name) {
      return;
    }
    //first we uplode the cached files then we close the cached closing procedures

    _uplodeCachedAttachments().then((value) => _closeCachedProcedures());
  }

  Future<void> _uplodeCachedAttachments() async {
    final _prefs = sl<SharedPreferences>();

    final _savedChuncksList =
        _prefs.getStringList(CacheKeys().cachedFilesChunksList) ?? [];

    if (_savedChuncksList.isNotEmpty) {
      uploadedFiles.clear();
      for (var chunkElement in _savedChuncksList) {
        final _fileResponse =
            await UploadFileChunkUseCase(sl()).call(jsonDecode(chunkElement));
        if (_fileResponse?.message == "File successfully created!") {
          uploadedFiles.add(_fileResponse!);
        }
        if (_fileResponse?.message == null) {
          break;
        }
      }
      insertFileAttachment(showLoading: false);
    }
  }

  _closeCachedProcedures() {
    final _prefs = sl<SharedPreferences>();

    final _closeCachedProceduresList =
        _prefs.getStringList(CacheKeys().closeProcedureList) ?? [];
    if (_closeCachedProceduresList.isNotEmpty) {
      for (var element in _closeCachedProceduresList) {
        CloseCurrentProcedureUseCase(sl()).call(jsonDecode(element))  ;
      }
    }
  }
}
