import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluplayer/common/common_report/common_event.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../vip/provider/provider.dart';
import '../common_enum.dart';
import 'base_ad.dart';
import 'base_ad_model.dart';

final admobHelper2 = AdmobAdHelper2(idKey: 'adConfigTime');
final admobHelper3 = AdmobAdHelper2(idKey: 'adConfigTime_reward');

class AdmobAdHelper2 {
  final String idKey;
  List<BaseAdModel> adList = [];

  BaseAdModel? _openAD;
  bool _openLoading = false;

  AdmobAdHelper2({required this.idKey});

  void refreshADConfig() {
    try {
      final config = FirebaseRemoteConfig.instance;
      String adRemoteJson = config.getString(idKey);
      // if (kDebugMode) {
      //   adRemoteJson =
      //       'ewogICAgIm9wZW4iOiBbCiAgICAgICAgewogICAgICAgICAgICAiaWQiOiAiY2EtYXBwLXB1Yi0zOTQwMjU2MDk5OTQyNTQ0LzM5ODY2MjQ1MTEiLAogICAgICAgICAgICAiaWQyIjogImNhLWFwcC1wdWItMzk0MDI1NjA5OTk0MjU0NC8yNTIxNjkzMzE2IiwKICAgICAgICAgICAgInNvcnQiOiAxLAogICAgICAgICAgICAic291cmNlIjogImFkbW9iIiwKICAgICAgICAgICAgIm5hbWUiOiAibmF0aXZlIgogICAgICAgIH0KICAgIF0KfQ==';
      // }
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
        return b.sort.compareTo(a.sort);
      });
    }
    return adList;
  }

  Future<BaseAdModel?> _load(
    List<BaseAdModel> adWrappers, {
    CommAdLoadListener? load,
    required ThingSourceEnum value,
  }) async {
    if(globalOpenVip) return null;
    CommonReport.eventThings(
      ThingEnum.adReqPlR1Kacement,
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
    required ThingSourceEnum value,
    Future<bool> Function({required ThingSourceEnum value})? adLoader,
    ValueChanged<bool>? onReward,
  }) async {
    CommonReport.eventThings(
      ThingEnum.adNee8aQdShow,
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
        success: (e) {
          CommonEvent.showSuccessAd(value, isSecond: true, isSecondNativeAd: e);
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
            value.value,
            model.id,
            model.adType.name,
          );
        },
      ),
    );
    return closeCompleter.future;
  }

  ///开屏位置
  Future<bool> loadOpenAd({required ThingSourceEnum value}) async {
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
          CommonEvent.loadFail(value, true, error.code);
        },
      ),
    );
    _openLoading = false;
    if (_openAD != null) {
      CommonEvent.loadSuccess(value, true);
    }
    return _openAD != null;
  }

  Future<bool> showOpenAd({required ThingSourceEnum value}) async {
    return _showAD(_openAD, value: value, adLoader: loadOpenAd);
  }
}
