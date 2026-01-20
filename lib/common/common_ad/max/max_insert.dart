import 'dart:async';

import 'package:applovin_max/applovin_max.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_ad/max_ad_helper.dart';

class MaxInterstitialLoader extends BaseAd {
  String? adId;
  bool isAllowShow = false;

  @override
  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
    String? nativeId,
  }) async {
    final completer = Completer<void>();
    adId = adPlacement;
    maxHelper.addLoadListener(
      adUnitId: adPlacement,
      onLoad: CommAdLoadListener(
        success: () {
          isAllowShow = true;
          listener?.success?.call();
          completer.complete();
        },
        error: (error) {
          dispose();
          listener?.error?.call(error);
          completer.complete();
        },
      ),
    );
    Future.delayed(const Duration(seconds: 15)).then((e) {
      if (completer.isCompleted == false) {
        listener?.error?.call(CommonAdLoadError("-1", "max load time out"));
        completer.complete();
      }
    });
    AppLovinMAX.loadInterstitial(adPlacement);
    return completer.future;
  }

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    // TODO: implement show
    if (adId == null) {
      listener?.error?.call(CommonAdLoadError('-1', 'MAX ADID IS NULL'));
      return;
    }
    maxHelper.addShowListener(
      adUnitId: adId!,
      onShow: CommAdShowListener(
        success: (e) {
          isADShowProcess = true;
          isAllowShow = false;
          listener?.success?.call(e);
        },
        error: (error) {
          dispose();
          isADShowProcess = false;
          listener?.error?.call(error);
        },
        onClick: () {
          listener?.onClick?.call();
        },
        onClose: () {
          dispose();
          isADShowProcess = false;
          listener?.onClose?.call();
        },
        onPaidCallback: listener?.onPaidCallback,
      ),
    );
    final isReady = await AppLovinMAX.isInterstitialReady(adId!);
    if (isReady ?? false) {
      AppLovinMAX.showInterstitial(adId!);
    }
  }

  @override
  Future<void> dispose() async {
    isAllowShow = false;
  }

  @override
  bool isAvailable() {
    return adId != null && isAllowShow == true && isADShowProcess == false;
  }
}
