import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/out_page.dart';
import 'package:flutter/material.dart';

bool _isShowAccept = false;

class CommonAfHelper {
  static final CommonAfHelper _instance = CommonAfHelper._internal();
  factory CommonAfHelper() {
    return _instance;
  }
  CommonAfHelper._internal();

  late AppsflyerSdk _appsflyerSdk;

  // 是否是延迟深链
  bool? isDeep;
  Map<String, String>? deepLinkValue;
  Function()? onDismiss;

  Future<void> init() async {
    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "",
      timeToWaitForATTUserAuthorization: 30,
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          isDeep = dp.deepLink?.isDeferred;
          final deep = dp.deepLink?.deepLinkValue ?? '';
          deepLinkValue = Uri.parse(deep).queryParameters;
          jumpAccept();
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
    if (_isShowAccept) {
      onDismiss?.call();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _isShowAccept = true;
    showModalBottomSheet(
      context: commonContext!,
      isScrollControlled: true,
      builder: (ctx) => OutPage(model: model),
    );
  }

  void dismiss() async {
    _isShowAccept = false;
    deepLinkValue = null;
  }
}
