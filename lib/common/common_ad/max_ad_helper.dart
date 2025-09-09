import 'dart:async';
import 'dart:convert';

import 'package:applovin_max/applovin_max.dart';
import 'base_ad.dart';

final maxHelper = MaxAdHelper();

class MaxAdHelper {
  Map<String, CommAdLoadListener> load = {};
  Map<String, CommAdShowListener> show = {};

  Future<void> listen() async {
    await AppLovinMAX.initialize("");
    AppLovinMAX.setMuted(true);
    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad) {
          load[ad.adUnitId]?.success?.call();
        },
        onAdLoadFailedCallback: (adUnitId, maxError) {
          load[adUnitId]?.error?.call(
            CommonAdLoadError('${maxError.code}', maxError.message),
          );
        },
        onAdDisplayedCallback: (ad) {
          show[ad.adUnitId]?.success?.call();
          show[ad.adUnitId]?.onPaidCallback?.call(
            ad.revenue * 1000000,
            null,
            'USD',
            ad.networkName,
          );
        },
        onAdDisplayFailedCallback: (ad, error) {
          show[ad.adUnitId]?.error?.call(
            CommonAdLoadError('${error.code}', error.message),
          );
        },
        onAdClickedCallback: (ad) {
          show[ad.adUnitId]?.onClick?.call();
        },
        onAdHiddenCallback: (ad) {
          show[ad.adUnitId]?.onClose?.call();
        },
      ),
    );
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          load[ad.adUnitId]?.success?.call();
        },
        onAdLoadFailedCallback: (adUnitId, maxError) {
          load[adUnitId]?.error?.call(
            CommonAdLoadError('${maxError.code}', maxError.message),
          );
        },
        onAdDisplayedCallback: (ad) {
          show[ad.adUnitId]?.success?.call();
          show[ad.adUnitId]?.onPaidCallback?.call(
            ad.revenue * 1000000,
            null,
            'USD',
            ad.networkName,
          );
        },
        onAdDisplayFailedCallback: (ad, error) {
          show[ad.adUnitId]?.error?.call(
            CommonAdLoadError('${error.code}', error.message),
          );
        },
        onAdClickedCallback: (ad) {
          show[ad.adUnitId]?.onClick?.call();
        },
        onAdHiddenCallback: (ad) {
          show[ad.adUnitId]?.onClose?.call();
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {
          show[ad.adUnitId]?.onReward?.call(true);
        },
      ),
    );
    AppLovinMAX.setAppOpenAdListener(
      AppOpenAdListener(
        onAdLoadedCallback: (ad) {
          load[ad.adUnitId]?.success?.call();
        },
        onAdLoadFailedCallback: (adUnitId, maxError) {
          load[adUnitId]?.error?.call(
            CommonAdLoadError('${maxError.code}', maxError.message),
          );
        },
        onAdDisplayedCallback: (ad) {
          show[ad.adUnitId]?.success?.call();
          show[ad.adUnitId]?.onPaidCallback?.call(
            ad.revenue * 1000000,
            null,
            'USD',
            ad.networkName,
          );
        },
        onAdDisplayFailedCallback: (ad, error) {
          show[ad.adUnitId]?.error?.call(
            CommonAdLoadError('${error.code}', error.message),
          );
        },
        onAdClickedCallback: (ad) {
          show[ad.adUnitId]?.onClick?.call();
        },
        onAdHiddenCallback: (ad) {
          show[ad.adUnitId]?.onClose?.call();
        },
      ),
    );
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
