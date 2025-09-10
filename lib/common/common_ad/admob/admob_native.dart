import 'dart:async';

import 'package:extended_image/extended_image.dart' as my;
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_ad/native_ad_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobNativeLoader extends BaseAd {
  NativeAd? ad;
  CommAdShowListener? showListener;
  AdmobNativeLoader();

  @override
  Future<void> loadAD(
    String adPlacement, {
    CommAdLoadListener? listener,
  }) async {
    bool hasError = true;
    CommonAdLoadError? adError;
    final result = await _loadOneAd(adPlacement);
    if (result.hasError == false && hasError == true) {
      hasError = false;
    } else if (result.hasError) {
      adError = result.error;
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
    isADShowProcess = false;
  }

  @override
  bool isAvailable() {
    return ad != null;
  }

  Future<NativeLoadResponse> _loadOneAd(String adId) async {
    Completer<NativeLoadResponse> completer = Completer();
    final t = NativeAd(
      adUnitId: adId,
      listener: NativeAdListener(
        onAdLoaded: (e) async {
          ad = e as NativeAd;
          completer.complete(NativeLoadResponse());
          // commRef?.read(refreshProvider.notifier).state =
          //     DateTime.now().millisecondsSinceEpoch;
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
          ad.dispose();
          showListener?.success?.call();
        },
        onAdClicked: (ad) {
          showListener?.onClick?.call();
        },
        onAdClosed: (e) {
          ad?.dispose();
          showListener?.onClick?.call();
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
      ),
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

  @override
  Future<void> show({CommAdShowListener? listener}) async {
    if (!isAvailable()) {
      return;
    }
    showListener = listener;
    if (commonContext != null) {
      await showDialog(
        context: commonContext!,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (ctx) => NativeAdPage(ad: ad!),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      showListener?.onClose?.call();
      dispose();
    }
  }
}

class NativeLoadResponse {
  bool hasError;
  CommonAdLoadError? error;

  NativeLoadResponse({this.hasError = false, this.error});
}
