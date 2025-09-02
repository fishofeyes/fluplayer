import 'package:applovin_max/applovin_max.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_ad/max_ad_helper.dart';

class MaxOpenLoader extends BaseAd {
  String? adId;
  bool isAllowShow = false;

  @override
  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
  }) async {
    adId = adPlacement;
    maxHelper.addLoadListener(
      adUnitId: adPlacement,
      onLoad: CommAdLoadListener(
        success: () {
          isAllowShow = true;
          listener?.success?.call();
        },
        error: (error) {
          dispose();
          listener?.error?.call(error);
        },
      ),
    );
    AppLovinMAX.loadAppOpenAd(adPlacement);
  }

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    if (adId == null) {
      listener?.error?.call(CommonAdLoadError('-1', 'MAX ADID IS NULL'));
      return;
    }
    maxHelper.addShowListener(
      adUnitId: adId!,
      onShow: CommAdShowListener(
        success: () {
          isADShowProcess = true;
          isAllowShow = false;
          listener?.success?.call();
        },
        error: (error) {
          dispose();
          isADShowProcess = false;
          listener?.error?.call(error);
        },
        onClose: () {
          dispose();
          isADShowProcess = false;
          listener?.onClose?.call();
        },
        onClick: () {
          listener?.onClick?.call();
        },
        onPaidCallback: listener?.onPaidCallback,
      ),
    );
    final isOk = await AppLovinMAX.isAppOpenAdReady(adId!) ?? false;
    if (isOk) {
      AppLovinMAX.showAppOpenAd(adId!);
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
