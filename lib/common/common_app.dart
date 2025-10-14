import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluplayer/common/common_ad/app_config.dart';
import 'package:flutter/services.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

import 'common_enum.dart';
import 'common_report/common_report.dart';

class CommonApp {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static const MethodChannel _channel = MethodChannel(
    'com.sim.app/device_info',
  );
  static bool haveSim = false; // 是否有sim卡
  static bool isSimulator = true; // 是否是模拟器
  static bool isVip = true; // 是否开启vpn
  static bool isPad = true; // 是否是pad
  static Future<void> init() async {
    try {
      final bool result = await _channel.invokeMethod('haveSim');
      haveSim = result;
    } catch (e) {
      print("get sim info error $e");
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      isSimulator = !iosInfo.isPhysicalDevice;
      isPad = iosInfo.model.toLowerCase().contains('ipad');
    }

    bool isConnected = await VpnConnectionDetector.isVpnActive();
    isVip = isConnected;
  }

  static bool jumpEnable(AppConfigModel model, String? id) {
    bool canJump = true;
    if (model.haveSim && !haveSim) {
      canJump = false;
      CommonReport.eventThings(
        ThingEnum.landpa6EQy5geFail,
        data: {"PuUTVimak": "RqxmLFdTO", "tExnF2": id},
      );
    } else if (model.haveSimulator && isSimulator) {
      canJump = false;
      CommonReport.eventThings(
        ThingEnum.landpa6EQy5geFail,
        data: {"PuUTVimak": "hEWmQ", "tExnF2": id},
      );
    } else if (model.haveVip && isVip) {
      canJump = false;
      CommonReport.eventThings(
        ThingEnum.landpa6EQy5geFail,
        data: {"PuUTVimak": "XIWzzPLm", "tExnF2": id},
      );
    } else if (model.pad && isPad) {
      canJump = false;
      CommonReport.eventThings(
        ThingEnum.landpa6EQy5geFail,
        data: {"PuUTVimak": "VHQoGulpp", "tExnF2": id},
      );
    }
    return canJump;
  }
}
