import 'dart:async';

import 'package:fluplayer/common/common_ad/admob/admob_native.dart';
import 'package:fluplayer/common/common_ad/max/max_open.dart';
import 'package:flutter/material.dart';
import 'admob/admob_insert.dart';
import 'admob/admob_open.dart';
import 'admob/admob_reward.dart';
import 'base_ad.dart';
import 'max/max_insert.dart';
import 'max/max_rewarded.dart';

class BaseAdModel {
  BaseAd adLoader = BaseAd();
  AdPositionEnum position = AdPositionEnum.open;
  ADType adType = ADType.open;
  String id = '';
  int sort = 1;
  int loadADTime = 0;
  bool isAdmob = true;

  BaseAdModel({
    required this.id,
    required this.adLoader,
    required this.position,
    required this.adType,
  });

  BaseAdModel.fromMap(Map map, AdPositionEnum type) {
    sort = map['sort'] ?? 1;
    id = map['id'] ?? '';
    isAdmob = map['source'] == 'admob';
    adType = ADType.values.firstWhere(
      (e) => e.toString() == 'ADType.${map['name']}',
      orElse: () => ADType.open,
    );
    position = type;
    adLoader = getADLoader();
  }

  int getNow() => DateTime.now().millisecondsSinceEpoch;

  Future<bool> load({CommAdLoadListener? listener}) async {
    Completer<bool> loadCompleter = Completer();
    await adLoader.loadAD(
      id,
      listener: CommAdLoadListener(
        success: () {
          loadADTime = getNow();
          listener?.success?.call();
          loadCompleter.complete(true);
        },
        error: (error) async {
          listener?.error?.call(error);
          loadCompleter.complete(false);
          debugPrint(
            '广告加载失败 $position $id errorCode: ${error.code} ${error.msg}',
          );
          // PostEventHelper.instance
          //     .logEvent(name: 'ad_fail_ios', parameters: {'value': getADPositionName(), 'code': error.code});
        },
      ),
    );
    return loadCompleter.future;
  }

  Future<void> showAD({CommAdShowListener? listener}) async {
    adLoader.show(listener: listener);
  }

  bool isEnable() {
    if (!isAvailable()) {
      debugPrint('广告不可用不展示');
      return false;
    }

    if (!isAlive()) {
      debugPrint('广告超时不展示并且重新请求');
      resetAD();
      load();
      return false;
    }
    return true;
  }

  bool isCacheAvailable() {
    return isAlive() && isAvailable();
  }

  bool isAlive() {
    final intervalTime = getNow() - loadADTime;
    return intervalTime < 50 * 1000 * 60;
  }

  bool isAvailable() {
    return adLoader.isAvailable();
  }

  bool isShowing() {
    return adLoader.isADShowProcess;
  }

  void resetAD() {
    loadADTime = 0;
  }

  BaseAd getADLoader() {
    switch (adType) {
      case ADType.open:
        if (!isAdmob) return MaxOpenLoader();
        return AdmobOpenLoader();
      case ADType.interstitial:
        if (!isAdmob) return MaxInterstitialLoader();
        return AdmobInterLoader();
      case ADType.native:
        return AdmobNativeLoader();
      case ADType.rewarded:
        if (!isAdmob) return MaxRewardLoader();
        return AdmobRewardLoader();
    }
  }
}
