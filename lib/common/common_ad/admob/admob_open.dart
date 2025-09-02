import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobOpenLoader extends BaseAd {
  AppOpenAd? _ad;

  @override
  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
  }) async {
    // await admobManager.admobInitFuture.future;
    await AppOpenAd.load(
      adUnitId: adPlacement,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          listener?.success?.call();
          _ad = ad;
        },
        onAdFailedToLoad: (error) {
          listener?.error?.call(
            CommonAdLoadError('${error.code}', error.message),
          );
        },
      ),
    );
  }

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    if (!isAvailable()) {
      return;
    }
    _ad?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isADShowProcess = true;
        listener?.success?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        isADShowProcess = false;
        dispose();
        listener?.error?.call(
          CommonAdLoadError('${error.code}', error.message),
        );
      },
      onAdClicked: (ad) {
        listener?.onClick?.call();
      },
      onAdDismissedFullScreenContent: (ad) {
        isADShowProcess = false;
        dispose();
        listener?.onClose?.call();
      },
    );
    final adSourceName =
        _ad?.responseInfo?.loadedAdapterResponseInfo?.adSourceName;
    final networkName = adSourceName ?? 'admob';
    _ad?.onPaidEvent =
        (
          Ad ad,
          double valueMicros,
          PrecisionType precision,
          String currencyCode,
        ) {
          listener?.onPaidCallback?.call(
            valueMicros,
            precision,
            currencyCode,
            networkName,
          );
        };
    _ad?.show();
  }

  @override
  bool isAvailable() {
    return _ad != null && !isADShowProcess;
  }

  @override
  Future<void> dispose() async {
    _ad?.dispose();
    _ad = null;
  }
}
