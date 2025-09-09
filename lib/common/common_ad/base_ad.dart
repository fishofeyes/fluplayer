import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdPositionEnum { open, media, detail, native }

enum ADType { open, interstitial, native, rewarded }

class CommonAdLoadError {
  String code;
  String msg;

  CommonAdLoadError(this.code, this.msg);
}

class CommAdShowListener {
  Function(
    double valueMicros,
    PrecisionType? precision,
    String currencyCode,
    String networkName,
  )?
  onPaidCallback;
  Function(CommonAdLoadError adError)? error;
  VoidCallback? success;
  ValueChanged<bool>? onReward;
  VoidCallback? onClick;
  VoidCallback? onClose;

  CommAdShowListener({
    this.success,
    this.error,
    this.onClick,
    this.onClose,
    this.onReward,
    this.onPaidCallback,
  });
}

class CommAdLoadListener {
  Function(CommonAdLoadError adError)? error;
  VoidCallback? success;

  CommAdLoadListener({this.success, this.error});
}

class BaseAd {
  bool isADShowProcess = false;

  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
  }) async {}

  Future<void> show({CommAdShowListener? listener}) async {}

  Future<void> dispose() async {}

  bool isAvailable() => false;
}
