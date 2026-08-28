import 'dart:developer';

import 'package:secmtp_sdk/at_index.dart';

import 'base_ad.dart';

final topHelper = TopAdHelper();

class TopAdHelper {
  static const String toponId = 'h6a8facf818507';
  static const String toponKey = 'a041d71a03d28a9c6c1dc3da08f7371ff';
  Map<String, CommAdLoadListener> load = {};
  Map<String, CommAdShowListener> show = {};

  Future<void> listen() async {
    await ATInitManger.initSDK(appidStr: toponId, appidkeyStr: toponKey);
    ATListenerManager.splashEventHandler.listen((value) {
      if (value.splashStatus == SplashStatus.splashDidFinishLoading) {
        //广告加载成功
        log('topon 开屏广告加载成功 ${value.placementID}');
        load[value.placementID]?.success?.call();
      } else if (value.splashStatus == SplashStatus.splashDidShowSuccess) {
        //广告展示成功
        show[value.placementID]?.success?.call(false);
        show[value.placementID]?.onPaidCallback?.call(
          (value.extraMap['publisher_revenue'] ?? 0) * 1000000,
          null,
          value.extraMap['currency'] ?? 'USD',
          value.extraMap['network_type'] ?? 'topOn',
        );
      } else if (value.splashStatus == SplashStatus.splashDidClick) {
        //广告被点击
        show[value.placementID]?.onClick?.call();
      } else if (value.splashStatus == SplashStatus.splashDidClose) {
        //广告被关闭
        show[value.placementID]?.onClose?.call();
      } else if (value.splashStatus == SplashStatus.splashDidFailToLoad ||
          value.splashStatus == SplashStatus.splashDidTimeout ||
          value.splashStatus == SplashStatus.splashUnknown ||
          value.splashStatus == SplashStatus.splashDidShowFailed) {
        // 广告加载超时 广告加载失败  splashUnknown 广告展示失败
        log('topon 开屏广告加载失败 ${value.placementID}');
        load[value.placementID]?.error?.call(
          CommonAdLoadError('${value.extraMap['code']}', value.requestMessage),
        );
      }
    });
    ATListenerManager.rewardedVideoEventHandler.listen((value) {
      if (value.rewardStatus == RewardedStatus.rewardedVideoDidFinishLoading) {
        //广告加载成功
        log('topon 激励广告加载成功 ${value.placementID}');
        load[value.placementID]?.success?.call();
      } else if (value.rewardStatus ==
          RewardedStatus.rewardedVideoDidStartPlaying) {
        //广告开始播放
        show[value.placementID]?.success?.call(false);
      } else if (value.rewardStatus ==
          RewardedStatus.rewardedVideoDidEndPlaying) {
        //广告结束播放
      } else if (value.rewardStatus ==
          RewardedStatus.rewardedVideoDidRewardSuccess) {
        //激励成功，建议在此回调中下发奖励
        show[value.placementID]?.onPaidCallback?.call(
          (value.extraMap['publisher_revenue'] ?? 0) * 1000000,
          null,
          value.extraMap['currency'] ?? 'USD',
          value.extraMap['network_type'] ?? 'topOn',
        );
      } else if (value.rewardStatus == RewardedStatus.rewardedVideoDidClick) {
        //广告被点击
        show[value.placementID]?.onClick?.call();
      } else if (value.rewardStatus == RewardedStatus.rewardedVideoDidClose) {
        //广告被关闭
        show[value.placementID]?.onClose?.call();
      } else if (value.rewardStatus ==
              RewardedStatus.rewardedVideoDidFailToLoad ||
          value.rewardStatus == RewardedStatus.rewardedVideoUnknown ||
          value.rewardStatus == RewardedStatus.rewardedVideoDidFailToPlay) {
        //广告加载失败 广告播放失败
        log('topon 激励广告加载失败 ${value.placementID}');
        load[value.placementID]?.error?.call(
          CommonAdLoadError('${value.extraMap['code']}', value.requestMessage),
        );
      }
    });
    ATListenerManager.interstitialEventHandler.listen((value) {
      if (value.interstatus ==
          InterstitialStatus.interstitialAdDidFinishLoading) {
        //广告加载成功
        load[value.placementID]?.success?.call();
        log('topon 插屏广告加载成功 ${value.placementID}');
      } else if (value.interstatus ==
          InterstitialStatus.interstitialDidShowSucceed) {
        //广告展示成功
        show[value.placementID]?.success?.call(false);
        show[value.placementID]?.onPaidCallback?.call(
          (value.extraMap['publisher_revenue'] ?? 0) * 1000000,
          null,
          value.extraMap['currency'] ?? 'USD',
          value.extraMap['network_type'] ?? 'topOn',
        );
      } else if (value.interstatus ==
          InterstitialStatus.interstitialAdDidClick) {
        //广告被点击
        show[value.placementID]?.onClick?.call();
      } else if (value.interstatus ==
          InterstitialStatus.interstitialAdDidClose) {
        //广告被关闭
        show[value.placementID]?.onClose?.call();
      } else if (value.interstatus ==
              InterstitialStatus.interstitialAdFailToLoadAD ||
          value.interstatus == InterstitialStatus.interstitialUnknown ||
          value.interstatus == InterstitialStatus.interstitialFailedToShow) {
        //广告加载失败 广告展示失败
        log('topon 插屏广告加载失败 ${value.placementID}');
        load[value.placementID]?.error?.call(
          CommonAdLoadError('${value.extraMap['code']}', value.requestMessage),
        );
      }
    });
  }

  void showToponTestUI() {
    ATInitManger.showDebuggerUI(debugKey: toponKey);
  }

  void addLoadListener({
    required String adUnitId,
    required CommAdLoadListener onLoad,
  }) {
    load[adUnitId] = onLoad;
  }

  void addShowListener({
    required String adUnitId,
    required CommAdShowListener onShow,
  }) {
    show[adUnitId] = onShow;
  }
}
