import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabBarViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => TabBarViewModel());

class TabBarViewModel with ChangeNotifier {
  int currenttabBarIndex=0;
  bool isMockedLocation=false;
  bool isEmulator=false;
  bool isMaintenance=true;
  final selectedIndex = StateProvider<int>((ref) => 0);
  final dailyBadgeCount = StateProvider<int>((ref) => 0);
  final allProcBadgeCount = StateProvider<int>((ref) => 0);
changeIsMockedValue(bool newVal){
  isMockedLocation=newVal;
  notifyListeners();
}
changeIsEmulatorValue(bool newVal){
  isEmulator=newVal;
  notifyListeners();
}
  changeIndex(int index){
    currenttabBarIndex=index;
  }
  updateScreen(){
    notifyListeners();
  }
  changeAppMode(bool value){
    isMaintenance=value;
    notifyListeners();
  }
}
