import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_app.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/out_page.dart';
import 'package:flutter/material.dart';

import 'common_enum.dart';
import 'common_report/common_report.dart';

bool _isShowAccept = false;

class CommonAfHelper {
  static final CommonAfHelper _instance = CommonAfHelper._internal();
  factory CommonAfHelper() {
    return _instance;
  }
  CommonAfHelper._internal();

  late AppsflyerSdk _appsflyerSdk;

  // 是否是延迟深链
  bool isDeep = false;
  Map<String, String>? deepLinkValue;
  Function()? onDismiss;

  Future<void> init() async {
    if (!isProd) return;
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "TYf2mHakoyPhfxp5XnrYGU",
      appId: "6751945078",
      timeToWaitForATTUserAuthorization: 30,
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          isDeep = dp.deepLink?.isDeferred ?? false;
          final deep = dp.deepLink?.deepLinkValue ?? '';
          deepLinkValue = Uri.parse(deep).queryParameters;
          jumpAccept(sender: deepLinkValue);
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

  void jumpAccept({Map<String, String>? sender}) async {
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
    if (_isShowAccept) {
      onDismiss?.call();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _isShowAccept = true;
    showDialog(
      context: commonContext!,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (ctx) => OutPage(model: model),
    );
  }

  void dismiss() async {
    _isShowAccept = false;
    deepLinkValue = null;
  }
}
