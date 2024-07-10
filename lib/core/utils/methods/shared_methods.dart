import 'dart:developer';

import"package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/crm/presentation/tab_bar/tab_bar_view_model.dart';
import '../../services/configrations/general_configrations.dart';
import '../../services/device_info_manager.dart';
import '../../services/extentions.dart';
import '../../services/location_manager.dart';
import '../../services/service_locator/dependency_injection.dart';


class SharedMethods{
  deleteCachedProcedure(String item, String storeKey) {
    final _list = sl<SharedPreferences>().getStringList(
          storeKey,
        ) ??
        [];
    _list.removeWhere(
      (element) => element == item,
    );
    sl<SharedPreferences>().remove(storeKey);
  }
    void checkLocationMocking(BuildContext context) async {

    final Position position = await LocationManager.getCurrentLocation(isFromHome: true);
     if(GeneralConfigurations().isDebug){
    log("this is the position state here :  ======================> is Mocked : ${position.isMocked}");
     }
    context
        .read(tabBarViewModelProvider)
        .changeIsMockedValue(position.isMocked);

        context
        .read(tabBarViewModelProvider)
        .changeIsEmulatorValue(await DeviceInfoManager().isEmulatorDevice());
        
  }
}