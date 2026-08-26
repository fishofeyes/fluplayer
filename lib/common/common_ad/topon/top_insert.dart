import 'dart:async';

import 'package:fluplayer/common/common_ad/top_ad_helper.dart';
import 'package:secmtp_sdk/at_index.dart';

import '../base_ad.dart';

class TopInsert extends BaseAd {
  String? adId;
  bool isAllowShow = false;

  @override
  Future<void> loadAD(
      String adPlacement, {
        CommAdLoadListener? listener,
        String? nativeId,
      }) async {
    // TODO: implement loadAD
    final completer = Completer<void>();
    adId = adPlacement;
    topHelper.addLoadListener(
      adUnitId: adPlacement,
      onLoad: CommAdLoadListener(
        success: () {
          isAllowShow = true;
          listener?.success?.call();
          completer.complete();
        },
        error: (e) {
          dispose();
          listener?.error?.call(e);
          completer.complete();
        },
      ),
    );
    Future.delayed(const Duration(seconds: 15)).then((e) {
      if (completer.isCompleted == false) {
        listener?.error?.call(CommonAdLoadError("-1", "topon load time out"));
        completer.complete();
      }
    });
    ATInterstitialManager.loadInterstitialAd(
      placementID: adPlacement,
      extraMap: {
        ATInterstitialManager.useRewardedVideoAsInterstitialKey(): true,
      },
    );

    return completer.future;
  }

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    // TODO: implement show
    if (adId == null) {
      listener?.error?.call(CommonAdLoadError('-1', 'topon ADID IS NULL'));
      return;
    }
    topHelper.addShowListener(
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
    ATInterstitialManager.showInterstitialAd(placementID: adId!);
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
