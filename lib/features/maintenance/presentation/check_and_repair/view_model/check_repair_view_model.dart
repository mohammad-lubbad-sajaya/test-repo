import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../crm/data/models/check_repair_model.dart';

final checkAndRepairViewModel =
    ChangeNotifierProvider((ref) => CheckAndRepairViewModel());

class CheckAndRepairViewModel extends ChangeNotifier {
  String? selectedServiceType;
  String? selectedServiceLocation;
  String? selectedCase;
  String? selectedAction;
  String? selectedCause;
  String? selectedCorruptedItem;
  String? selectedAlternateItem;
  DateTime bondDate = DateTime.now();
  bool isNotEditiable = false;

  final List<String> serviceTypes = [
    "فحص و إصلاح",
    "فحص",
    "إصلاح",
  ];
  final List<String> serviceLocations = [
    "مركز الصيانة",
    "موقع العميل ",
    "عن بعد ",
  ];
  final List<String> caseList = [
    "os error1",
    "os error2",
    "os error3",
    "os error4",
  ];
  final List<String> actionList = [
    "os error1",
    "os error2",
    "os error3",
    "os error4",
  ];
  final List<String> causeList = [
    "os error1",
    "os error2",
    "os error3",
    "os error4",
  ];
  final List<String> corruptedItemList = [
    "mouse",
    "keyboared",
    "graphic card",
  ];
  final List<String> alternateItemList = [
    "mouse",
    "keyboared",
    "graphic card",
  ];
  List<CheckRepairModel> checkRepairList = [];
  int currentBondNumber = 0;
  final caseDetailTextCtrl = TextEditingController();
  final actionDetailTextCtrl = TextEditingController();
  final causeDetailTextCtrl = TextEditingController();
  final corruptedItemDetailTextCtrl = TextEditingController();
  final alternateItemDetailTextCtrl = TextEditingController();
  final notesTextCtrl = TextEditingController();

  changeServiceType(String? value) {
    selectedServiceType = value;
    notifyListeners();
  }

  changeEditablity(bool val) {
    isNotEditiable = val;
    notifyListeners();
  }

  changeServiceLocation(String? value) {
    selectedServiceLocation = value;
    notifyListeners();
  }

  fillCheckAndRepairsList() {
    checkRepairList = [
      CheckRepairModel(
          action: actionList.first,
          alternateItem: alternateItemList.first,
          bondNumber: 542,
          cause: causeList.first,
          corruptedItem: corruptedItemList.first,
          cuse: caseList.first,
          endDate: DateTime.now(),
          notes: "",
          serviceLocation: serviceLocations.first,
          serviceType: serviceTypes.first,
          startDate: DateTime.now()),
      CheckRepairModel(
          action: actionList.first,
          alternateItem: alternateItemList.first,
          bondNumber: 542,
          cause: causeList.first,
          corruptedItem: corruptedItemList.first,
          cuse: caseList.first,
          endDate: DateTime.now(),
          notes: "",
          serviceLocation: serviceLocations.first,
          serviceType: serviceTypes.first,
          startDate: DateTime.now()),
    ];
    notifyListeners();
  }

  changeBondNumber(int? newValue) {
    currentBondNumber = newValue ?? 0;
    notifyListeners();
  }

  changeCase(String? val) {
    selectedCase = val;
    notifyListeners();
  }

  changeAction(String? val) {
    selectedAction = val;
    notifyListeners();
  }

  changeCause(String? val) {
    selectedCause = val;
    notifyListeners();
  }

  changeCorruptedItem(String? val) {
    selectedCorruptedItem = val;
    notifyListeners();
  }

  changeAlternateItem(String? val) {
    selectedAlternateItem = val;
    notifyListeners();
  }
}
