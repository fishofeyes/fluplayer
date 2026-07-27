import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_app.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/out_page.dart';
import 'package:flutter/material.dart';

import 'common_enum.dart';
import 'common_report/common_report.dart';

class CommonAfHelper {
  static final CommonAfHelper _instance = CommonAfHelper._internal();
  factory CommonAfHelper() {
    return _instance;
  }
  CommonAfHelper._internal();

  late AppsflyerSdk _appsflyerSdk;

  // 是否是延迟深链
  bool isDeep = false;
  bool isInHome = false;
  Map<String, String>? deepLinkValue;

  Future<void> init() async {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "ZtETeJ8XgKRg2qRPDdFE46",
      manualStart: true,
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      print("-=-=-=-=-=status: ${dp.status}, value: ${dp.deepLink?.deepLinkValue}");
      switch (dp.status) {
        case Status.FOUND:
          isDeep = dp.deepLink?.isDeferred ?? false;
          final deep = dp.deepLink?.deepLinkValue ?? '';
          deepLinkValue = Uri.parse(deep).queryParameters;
          if(isInHome) {
            jumpAccept(sender: deepLinkValue);
          }
          break;
        default:
          print("error deep link ${dp.status}");
      }
    });
    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  Future<void> jumpAccept({Map<String, String>? sender}) async {
    if (sender == null) return;
    final model = OutModel.fromMap(sender);
    CommonReport.eventThings(
      ThingEnum.deepliJgyZHnkOpen,
      data: {"vgJDrflFt": isDeep ? "HBYSNoNAil" : "yJWTu"},
    );
    bool canJump = CommonApp.jumpEnable(
      admobHelper.appConfigModel,
      model.outUrl,
    );
    if (!canJump) return;
    Navigator.popUntil(commonContext!, (e) => e.isFirst);
    await Future.delayed(const Duration(milliseconds: 100));
    await showDialog(
      context: commonContext!,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (ctx) => OutPage(model: model),
    );
    dismiss();
  }

  void dismiss() async {
    deepLinkValue = null;
  }

  void tryJump() async {
    await jumpAccept(sender: deepLinkValue);
    dismiss();
  }
}
