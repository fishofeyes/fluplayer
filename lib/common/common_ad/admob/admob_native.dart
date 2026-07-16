import 'dart:async';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_ad/native_ad_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobNativeLoader extends BaseAd {
  NativeAd? ad;
  NativeAd? ad2;
  CommAdShowListener? showListener;
  NativeAdListener? nativeListener;
  NativeAdListener? nativeListener2;
  AdmobNativeLoader();

  @override
  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
    String? nativeId,
  }) async {
    bool hasError = true;
    CommonAdLoadError? adError;
    final result = await _loadOneAd(adPlacement);
    NativeLoadResponse? result2;
    if (nativeId != null) {
      result2 = await _loadOneAd2(nativeId);
    }
    if (result.hasError == false) {
      hasError = false;
    } else if (result.hasError) {
      adError = result.error;
      if (result2?.hasError == false) {
        hasError = false;
      }
    }
    if (hasError) {
      if (adError == null) return;
      listener?.error?.call(adError);
    } else {
      listener?.success?.call();
    }
  }

  @override
  Future<void> dispose() async {
    ad?.dispose();
    ad2?.dispose();
    ad2 = null;
    ad = null;
    isADShowProcess = false;
  }

  @override
  bool isAvailable() {
    return ad != null || ad2 != null;
  }

  Future<NativeLoadResponse> _loadOneAd(String adId) async {
    Completer<NativeLoadResponse> completer = Completer();
    nativeListener = NativeAdListener(
      onAdLoaded: (e) async {
        ad = e as NativeAd;
        completer.complete(NativeLoadResponse());
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        completer.complete(
          NativeLoadResponse(
            hasError: true,
            error: CommonAdLoadError('${error.code}', error.message),
          ),
        );
      },
      onAdImpression: (ad) {
        showListener?.success?.call(false);
      },
      onAdClicked: (ad) {
        showListener?.onClick?.call();
      },
      onAdClosed: (e) {
        dispose();
      },
      onAdWillDismissScreen: (ad) {},
      onAdOpened: (ad) {},
      onPaidEvent:
          (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            final adSourceName =
                ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName;
            final networkName = adSourceName ?? 'admob';
            showListener?.onPaidCallback?.call(
              valueMicros,
              precision,
              currencyCode,
              networkName,
            );
          },
    );
    final t = NativeAd(
      adUnitId: adId,
      listener: nativeListener!,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.white,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
      ),
    );
    t.load();
    return completer.future;
  }

  Future<NativeLoadResponse> _loadOneAd2(String adId) async {
    Completer<NativeLoadResponse> completer = Completer();
    nativeListener2 = NativeAdListener(
      onAdLoaded: (e) async {
        ad2 = e as NativeAd;
        completer.complete(NativeLoadResponse());
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        completer.complete(
          NativeLoadResponse(
            hasError: true,
            error: CommonAdLoadError('${error.code}', error.message),
          ),
        );
      },
      onAdImpression: (ad) {
        showListener?.success?.call(true);
      },
      onAdClicked: (ad) {
        showListener?.onClick?.call();
      },
      onAdClosed: (e) {
        dispose();
      },
      onAdWillDismissScreen: (ad) {},
      onAdOpened: (ad) {},
      onPaidEvent:
          (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            final adSourceName =
                ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName;
            final networkName = adSourceName ?? 'admob';
            showListener?.onPaidCallback?.call(
              valueMicros,
              precision,
              currencyCode,
              networkName,
            );
          },
    );
    final t = NativeAd(
      adUnitId: adId,
      listener: nativeListener2!,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    );
    t.load();
    return completer.future;
  }

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    if (!isAvailable()) {
      return;
    }
    showListener = listener;
    if (commonContext != null) {
      if (ad == null && ad2 != null) {
        await showDialog(
          context: commonContext!,
          barrierDismissible: false,
          useSafeArea: false,
          builder: (ctx) => NativeAdPage(ad: ad2!),
        );
      } else {
        await showDialog(
          context: commonContext!,
          barrierDismissible: false,
          useSafeArea: false,
          builder: (ctx) => NativeAdPage(ad: ad!, ad2: ad2),
        );
      }
      dispose();
      await Future.delayed(const Duration(milliseconds: 300));
      showListener?.onClose?.call();
    }
  }
}

class NativeLoadResponse {
  bool hasError;
  CommonAdLoadError? error;

  NativeLoadResponse({this.hasError = false, this.error});
}
