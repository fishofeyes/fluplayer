import 'dart:async';

import 'package:secmtp_sdk/at_rewarded.dart';

import '../../common_report/common_report.dart';
import '../base_ad.dart';
import '../top_ad_helper.dart';

class TopReward extends BaseAd {
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
    final userId = await CommonReport.uniqueId();
    ATRewardedManager.loadRewardedVideo(
      placementID: adPlacement,
      extraMap: {ATRewardedManager.kATAdLoadingExtraUserIDKey(): userId},
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
    ATRewardedManager.showRewardedVideo(placementID: adId!);
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
