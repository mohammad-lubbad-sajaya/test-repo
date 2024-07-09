import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoManager {
  // this class is used to detect if user using emulator or physical device 
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Future<bool> isEmulatorDevice() async {
    if (Platform.isAndroid) {
      return _checkAndroid();
    } else {
      return _checkIos();
    }
  }

  Future<bool> _checkAndroid() async {
    try {
      final _androidInfo = _deviceInfo.androidInfo;
      final _info = await _androidInfo;
      return !_info.isPhysicalDevice;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkIos() async {
    try {
      final _iosInfo = _deviceInfo.iosInfo;
      final _info = await _iosInfo;
      return !_info.isPhysicalDevice;
    } catch (e) {
      return false;
    }
  }
}
