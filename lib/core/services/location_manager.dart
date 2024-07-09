import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import '../utils/common_widgets/loading_dialog.dart';
import '../utils/common_widgets/show_confirmation_dialog.dart';
import 'routing/navigation_service.dart';
import 'service_locator/dependency_injection.dart';

class LocationManager {
  static Future<Position> getCurrentLocation({bool isFromHome=false}) async {
    // Request location permission
             if(!isFromHome){
                LoadingAlertDialog.dismiss();
             }

    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, proceed with location retrieval
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );



      return position;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Permission denied or permanently denied, prompt the user to retry
      bool isRetried = await _promptPermissionRetry();

      if (isRetried) {
        // Retry the permission request
        return await getCurrentLocation();
      } else {
        throw Exception('Location permission denied.');
      }
    } else {
      throw Exception('Location permission denied.');
    }
  }

  static Future<bool> _promptPermissionRetry() async {
    // show a dialog or prompt the user to retry the permission request
    // Return true if the user wants to retry, false otherwise
    showConfirmationDialog(
      context: sl<NavigationService>().getContext(),
      content: "retry the permission request",
      onAccept: () {
        Navigator.of(sl<NavigationService>().getContext()).pop(false);
        return true;
      },
      onError: () {
        return false;
      },
    );
    return false;
  }
}
