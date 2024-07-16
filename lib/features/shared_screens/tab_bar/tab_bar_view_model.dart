import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/extentions.dart';
import '../../../core/utils/common_widgets/show_confirmation_dialog.dart';
import '../../crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../../maintenance/presentation/check_and_repair/view_model/check_repair_view_model.dart';
import '../allTabs/all_proc/view_models/all_services_requests_view_model.dart';

import '../../../core/services/configrations/general_configrations.dart';

final tabBarViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => TabBarViewModel());

class TabBarViewModel with ChangeNotifier {
  int currenttabBarIndex = 0;
  bool isMockedLocation = false;
  bool isEmulator = false;
  bool isMaintenance = false;
  final selectedIndex = StateProvider<int>((ref) => 0);
  final dailyBadgeCount = StateProvider<int>((ref) => 0);
  final allProcBadgeCount = StateProvider<int>((ref) => 0);
  StreamSubscription<Position>? positionStream;
  Position? currentLocation;

  changeIsMockedValue(bool newVal) {
    isMockedLocation = newVal;
    notifyListeners();
  }

  changeIsEmulatorValue(bool newVal) {
    isEmulator = newVal;
    notifyListeners();
  }

  changeIndex(int index) {
    currenttabBarIndex = index;
  }

  updateScreen() {
    notifyListeners();
  }

  changeAppMode(bool value) {
    isMaintenance = value;
    notifyListeners();
  }

  stopLocationUpdates() {
    positionStream?.cancel();
    positionStream = null;
  }

  startLocationUpdates(BuildContext context) {
    const locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);

    positionStream = Geolocator.getPositionStream(
      desiredAccuracy: locationOptions.accuracy,
      distanceFilter: locationOptions.distanceFilter,
    ).listen((Position position) {
      currentLocation = position;
      for (var service
          in context.read(allServicesRequestviewModel).servicesRequestsList) {
    
        if (context.read(procedurePlaceViewModelProvider).getDistance(
                currentLat: position.latitude,
                currentLong: position.longitude,
                custlat: service.latitude,
                custlong: service.longitude)! <
            100) {
          showConfirmationDialog(
              context: context,
              title: "arrived to".localized(),
              actions: [
                TextButton(
                    onPressed: () {
                    
                      context.read(checkAndRepairViewModel).checkIn(service.bondNo);
                        Navigator.pop(context);
                    },
                    child: Text("yes".localized())),
                        TextButton(
                    onPressed: () {
                    
                      //context.read(checkAndRepairViewModel).checkIn();
                        Navigator.pop(context);
                    },
                    child: Text("no".localized()))
              ]);
        }
      }

      if (GeneralConfigurations().isDebug) {
        log('positionnnn: $position');
      }
      notifyListeners();
    });
  }
}
