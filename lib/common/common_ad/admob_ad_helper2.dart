import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluplayer/common/common_report/common_event.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common_enum.dart';
import 'base_ad.dart';
import 'base_ad_model.dart';

final admobHelper2 = AdmobAdHelper2();

class AdmobAdHelper2 {
  List<BaseAdModel> adList = [];

  BaseAdModel? _openAD;
  bool _openLoading = false;

  void refreshADConfig() {
    try {
      final config = FirebaseRemoteConfig.instance;
      final adRemoteJson = config.getString('_remoteConfigKey_second');
      if (adRemoteJson.isEmpty) {
        adList.clear();
        return;
      }
      final adText = utf8.decode(base64Decode(adRemoteJson));
      Map cloakJson = json.decode(adText);
      adList = _initADInfo(cloakJson, AdPositionEnum.open);
    } catch (e) {
      debugPrint('解析广告参数出现异常 $e}');
    }
  }

  List<BaseAdModel> _initADInfo(Map cloakJson, AdPositionEnum key) {
    List<BaseAdModel> adList = [];
    if (cloakJson.keys.contains(key.name)) {
      List adJsonArray = cloakJson[key.name];
      for (final map in adJsonArray) {
        adList.add(BaseAdModel.fromMap(map, key));
      }
      adList.sort((a, b) {
        return a.sort.compareTo(b.sort);
      });
    }
    return adList;
  }

  Future<BaseAdModel?> _load(
    List<BaseAdModel> adWrappers, {
    CommAdLoadListener? load,
    required MySessionValue value,
  }) async {
    CommonReport.myEvent(
      MySessionEvent.adReqPlR1Kacement,
      data: {"PuUTVimak": value.value, "gNAuA": 2},
    );
    for (final adWrapper in adWrappers) {
      final result = await adWrapper.load(listener: load);
      if (result) {
        return adWrapper;
      }
    }
    return null;
  }

  Future<bool> _showAD(
    BaseAdModel? model, {
    required MySessionValue value,
    Future<bool> Function({required MySessionValue value})? adLoader,
    ValueChanged<bool>? onReward,
  }) async {
    CommonReport.myEvent(
      MySessionEvent.adNee8aQdShow,
      data: {"PuUTVimak": value.value, "gNAuA": 2},
    );
    Completer<bool> closeCompleter = Completer();
    final isEnable = model?.isEnable() ?? false;
    if (!isEnable) {
      CommonEvent.showFailed(value, "no padding", isSecond: true);
      return false;
    }

    model?.showAD(
      listener: CommAdShowListener(
        success: () {
          CommonEvent.showSuccessAd(value, isSecond: true);
        },
        error: (adError) {
          CommonEvent.showFailed(value, adError.msg, isSecond: true);
          closeCompleter.complete(false);
        },
        onClick: () {
          CommonEvent.adClick(value, true);
        },
        onClose: () {
          closeCompleter.complete(true);
          adLoader?.call(value: value);
        },
        onReward: (isComplete) {
          onReward?.call(isComplete);
        },
        onPaidCallback: (ecpm, _, currencyCode, networkName) {
          CommonEvent.reportAd(
            ecpm,
            currencyCode,
            networkName,
            model.position.name,
            model.id,
            model.adType.name,
          );
        },
      ),
    );
    return closeCompleter.future;
  }

  ///开屏位置
  Future<bool> loadOpenAd({required MySessionValue value}) async {
    if (_openLoading) {
      debugPrint('开屏请求中不请求');
      return false;
    }
    if (_openAD?.isCacheAvailable() ?? false) {
      debugPrint('开屏缓存可用不重复请求');
      return false;
    }
    final splashADList = adList;
    if (splashADList.isEmpty) {
      return false;
    }

    _openLoading = true;
    _openAD = await _load(
      splashADList,
      value: value,
      load: CommAdLoadListener(
        error: (error) {
          CommonEvent.loadFail(value, true);
        },
      ),
    );
    _openLoading = false;
    if (_openAD != null) {
      CommonEvent.loadSuccess(value, true);
    }
    return _openAD != null;
  }

  Future<bool> showOpenAd({required MySessionValue value}) async {
    return _showAD(_openAD, value: value, adLoader: loadOpenAd);
  }
}
