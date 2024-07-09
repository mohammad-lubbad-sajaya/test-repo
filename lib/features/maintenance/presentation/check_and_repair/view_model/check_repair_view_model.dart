import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    "os error",
    "os error",
    "os error",
    "os error",
  ];
  final List<String> actionList = [
    "os error",
    "os error",
    "os error",
    "os error",
  ];
  final List<String> causeList = [
    "os error",
    "os error",
    "os error",
    "os error",
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
  final caseDetailTextCtrl = TextEditingController();
  final actionDetailTextCtrl = TextEditingController();
  final causeDetailTextCtrl = TextEditingController();
  final corruptedItemDetailTextCtrl = TextEditingController();
  final alternateItemDetailTextCtrl = TextEditingController();
  final notesTextCtrl = TextEditingController();

  changeServiceType(String value) {
    selectedServiceType = value;
    notifyListeners();
  }

  changeServiceLocation(String value) {
    selectedServiceLocation = value;
    notifyListeners();
  }

  changeCase(String val) {
    selectedCase = val;
    notifyListeners();
  }

  changeAction(String val) {
    selectedAction = val;
    notifyListeners();
  }

  changeCause(String val) {
    selectedCause = val;
    notifyListeners();
  }

  changeCorruptedItem(String val) {
    selectedCorruptedItem = val;
    notifyListeners();
  }

  changeAlternateItem(String val) {
    selectedAlternateItem = val;
    notifyListeners();
  }
}
