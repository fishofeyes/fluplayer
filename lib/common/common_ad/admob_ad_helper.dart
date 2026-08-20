import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper2.dart';
import 'package:fluplayer/common/common_ad/app_config.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_ad/max_ad_helper.dart';
import 'package:fluplayer/common/common_val.dart';
import 'package:fluplayer/vip/provider/provider.dart';
import 'package:fluplayer/vip/provider/vip.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../common.dart';
import '../common_enum.dart';
import '../common_report/common_event.dart';
import '../common_report/common_report.dart';
import 'base_ad_model.dart';

final admobHelper = AdmobAdHelper();

class AdmobAdHelper {
  Map<AdPositionEnum, List<BaseAdModel>> adDataMap = {};
  int mediaPlayPoint = 600; //请求超时 单位秒
  int _adInterval = 0; //同广告场景展示间隔单位 秒

  BaseAdModel? _openAd;
  BaseAdModel? _playerAd;
  BaseAdModel? _channelAd;
  BaseAdModel? _nativeAd;
  BaseAdModel? _playVideoAd;

  bool _openLoading = false;
  bool _playerLoading = false;
  bool _channelLoading = false;
  bool _nativeLoading = false;
  bool _playVideoLoading = false;

  bool adShowing = false;
  String showText = '';
  String adSubText = '';
  String adConfigText = '';
  int launchTime = 7; //首次打开广告延迟展示时间 秒
  double nativeMayClick = 0.5; //原生广告关闭率
  double closeAdRate = 0.5; //原生广告关闭率
  int nativeShowTime = 3; //原生广告展示时间 秒
  AppConfigModel appConfigModel = AppConfigModel();
  int lastShowTime = 0;
  String _currentVipConfig = '';
  int showAdTag = 0;
  int playVideoN = 5; //n默认为5；y默认值修改为10s
  int playVideoY = 10; // 播放到第几秒展示广告
  double playVideoClickAdRate = 0.0; // 点击广告比例，默认1全部点击
  int playVideoMethod = 0; //0按时间 1按次数

  Future<void> init() async {
    refreshADConfig();
    await maxHelper.listen();
    await MobileAds.instance.initialize();
    MobileAds.instance.setAppMuted(true);
    await FirebaseRemoteConfig.instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: Duration.zero,
      ),
    );
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) async {
      await FirebaseRemoteConfig.instance.activate();
      refreshADConfig();
    });
  }

  int currentTime() => DateTime.now().millisecondsSinceEpoch;

  void updateVipModels() {
    if (_currentVipConfig.isEmpty) return;
    commonRef?.read(vipProvider.notifier).init(_currentVipConfig);
  }

  void refreshADConfig() {
    try {
      final config = FirebaseRemoteConfig.instance;
      final configJson = config.getString('adConfigJson');
      String vipJson = config.getString('vipJson');
      String adBase64String = configJson.isEmpty ? testAdConfig : configJson;
      vipJson = vipJson.isEmpty ? testVipJson : vipJson;
      final adText = utf8.decode(base64Decode(adBase64String));
      _currentVipConfig = utf8.decode(base64Decode(vipJson));
      updateVipModels();
      showText = adText;
      final cc = config.getString("appConfigs");
      if (cc.isNotEmpty) {
        final temConfig = json.decode(utf8.decode(base64Decode(cc)));
        if (temConfig != null) {
          appConfigModel = AppConfigModel.fromJson(temConfig);
        }
      }
      Map cloakJson = json.decode(adText);
      _adInterval = cloakJson[RemoteConfigEnum.adInterval.name] ?? 60;
      mediaPlayPoint = cloakJson[RemoteConfigEnum.mediaPlayPoint.name] ?? 600;
      launchTime = cloakJson[RemoteConfigEnum.launchTime.name] ?? 7;
      nativeMayClick = cloakJson[RemoteConfigEnum.nativeMayClick.name] ?? 0.5;
      nativeShowTime = cloakJson[RemoteConfigEnum.nativeShowTime.name] ?? 3;
      playVideoN = cloakJson["playVideoN"] ?? 5; // 第n个视频
      playVideoY = cloakJson["playVideoY"] ?? 10; // 播放到第几秒展示广告
      playVideoMethod = cloakJson["playVideoMethod"] ?? 0; // 广告开关
      // playVideoMethod = 1; // 广告开关
      playVideoClickAdRate = double.parse(
        "${cloakJson["playVideoClickAdRate"] ?? 0}",
      ); // 点击广告概率
      closeAdRate = double.parse("${cloakJson["closeAdRate"] ?? 0}");
      // int playVideoN = 5; //n默认为5；y默认值修改为10s
      // int playVideoY = 10;// 播放到第几秒展示广告
      // int playVideoMethod = 0; //0按时间 1按次数
      for (final i in AdPositionEnum.values) {
        adDataMap[i] = _initADInfo(cloakJson, i);
      }
      admobHelper2.refreshADConfig();
      admobHelper3.refreshADConfig();
    } catch (e) {
      debugPrint('解析广告参数出现异常 $e}');
    }
  }

  List<BaseAdModel> _initADInfo(Map cloakJson, AdPositionEnum key) {
    List<BaseAdModel> list = [];
    if (cloakJson.keys.contains(key.name)) {
      List adJsonArray = cloakJson[key.name];
      for (final map in adJsonArray) {
        final t = BaseAdModel.fromMap(map, key);
        list.add(t);
      }
      list.sort((a, b) {
        return b.sort.compareTo(a.sort);
      });
    }
    return list;
  }

  void loadAll() {
    loadOpenAd(value: ThingSourceEnum.cp);
    loadDetail(value: ThingSourceEnum.cp);
    loadMedia(value: ThingSourceEnum.cp);
    loadNative(value: ThingSourceEnum.cp);
    admobHelper2.loadOpenAd(value: ThingSourceEnum.cp);
    Future.delayed(const Duration(seconds: 1)).then((e) => admobHelper3.loadOpenAd(value: ThingSourceEnum.cp));
  }

  Future<BaseAdModel?> _loadAd(
    List<BaseAdModel> models, {
    CommAdLoadListener? load,
    required ThingSourceEnum value,
  }) async {
    CommonReport.eventThings(
      ThingEnum.adReqPlR1Kacement,
      data: {"PuUTVimak": value.value, "gNAuA": 1},
    );
    for (final model in models) {
      final result = await model.load(listener: load);
      if (result) {
        return model;
      }
    }
    return null;
  }

  Future<bool> _showAD(
    BaseAdModel? model, {
    required ThingSourceEnum value,
    Future<bool> Function({required ThingSourceEnum value})? adLoader,
    ValueChanged<bool>? onReward,
    bool jumpTimeSpace = false,
  }) async {
    if (adShowing || globalOpenVip || isInVipAlertPage || isInVipPage) {
      debugPrint('ad is showing');
      return false;
    }
    if (jumpTimeSpace == false) {
      final nowDate = currentTime();
      final selfInterval = nowDate - lastShowTime;

      if (selfInterval < _adInterval * 1000) {
        CommonEvent.changePlayStatus(true);
        debugPrint('间隔时间不够不展示 all $selfInterval');
        return false;
      }
    }
    CommonReport.eventThings(
      ThingEnum.adNee8aQdShow,
      data: {"PuUTVimak": value.value, "gNAuA": 1},
    );

    CommonEvent.changePlayStatus(false);
    Completer<bool> closeCompleter = Completer();
    final isEnable = model?.isEnable() ?? false;
    if (!isEnable) {
      CommonEvent.showFailed(value, "no padding", isSecond: false);
      adShowing = true;
      if (jumpTimeSpace == false) {
        final r = await admobHelper2.showOpenAd(value: value);
        if (r) {
          lastShowTime = currentTime();
        }
        adShowing = false;
        return r;
      } else {
        adShowing = false;
        print("admob ad is not ready");
        return false;
      }
    }

    model?.showAD(
      listener: CommAdShowListener(
        success: (e) {
          adShowing = true;
          CommonEvent.showSuccessAd(
            value,
            isSecond: false,
            isSecondNativeAd: e,
          );
          debugPrint('广告展示成功 ${model.id} ${model.position} ${model.adType}');
        },
        error: (adError) async {
          debugPrint(
            '广告展示失败 ${model.position} ${model.adType} code: ${adError.code} ${adError.msg}',
          );
          CommonEvent.showFailed(value, adError.msg);
          closeCompleter.complete(false);
        },
        onClick: () {
          CommonEvent.adClick(value, false);
        },
        onClose: () async {
          if (jumpTimeSpace == false) {
            if (model.adType != ADType.rewarded) {
              await admobHelper2.showOpenAd(value: value);
            } else {
              await admobHelper3.showOpenAd(value: value);
            }
          }
          if (value == ThingSourceEnum.playBk ||
              value == ThingSourceEnum.chpage) {
            autoJumpVip?.call(true, true);
          }
          if (value == ThingSourceEnum.play ||
              ThingSourceEnum.play10 == value ||
              ThingSourceEnum.playLast == value) {
            showAdTag += 1;
            if (showAdTag % 2 == 0) {
              autoJumpVip?.call(false, true);
            }
          }
          adShowing = false;
          if (jumpTimeSpace == false) {
            lastShowTime = currentTime();
          }
          closeCompleter.complete(true);
          CommonEvent.onDismiss();
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
  Future<bool> loadOpenAd({required ThingSourceEnum value}) async {
    if (_openLoading) {
      debugPrint('开屏请求中不请求');
      return false;
    }
    if (_openAd?.isCacheAvailable() ?? false) {
      debugPrint('开屏缓存可用不重复请求');
      return false;
    }
    final list = adDataMap[AdPositionEnum.open];
    if (list == null) {
      return false;
    }

    _openLoading = true;
    _openAd = await _loadAd(
      list,
      value: value,
      load: CommAdLoadListener(
        error: (error) {
          CommonEvent.loadFail(value, false, error.code);
        },
      ),
    );
    _openLoading = false;
    if (_openAd != null) {
      CommonEvent.loadSuccess(value, false);
    }
    return _openAd != null;
  }

  Future<bool> showOpenAd({required ThingSourceEnum value}) async {
    return _showAD(_openAd, value: value, adLoader: loadOpenAd);
  }

  ///播放位置
  Future<bool> loadMedia({required ThingSourceEnum value}) async {
    if (_playerLoading) {
      debugPrint('竖屏播放请求中不请求');
      return false;
    }
    if (_playerAd?.isCacheAvailable() ?? false) {
      debugPrint('竖屏播放插屏缓存可用不重复请求');
      return false;
    }
    final list = adDataMap[AdPositionEnum.media];
    if (list == null) {
      return false;
    }
    _playerLoading = true;
    _playerAd = await _loadAd(
      list,
      value: value,
      load: CommAdLoadListener(
        error: (error) {
          CommonEvent.loadFail(value, false, error.code);
        },
      ),
    );
    _playerLoading = false;
    if (_playerAd != null) {
      CommonEvent.loadSuccess(value, false);
    }
    return _playerAd != null;
  }

  Future<bool> showMediaAd({required ThingSourceEnum value}) async {
    return await _showAD(_playerAd, value: value, adLoader: loadMedia);
  }

  Future<bool> loadDetail({required ThingSourceEnum value}) async {
    if (_channelLoading) {
      return false;
    }
    if (_channelAd?.isCacheAvailable() ?? false) {
      return false;
    }
    final list = adDataMap[AdPositionEnum.detail];
    if (list == null) return false;
    _channelAd = await _loadAd(
      list,
      value: value,
      load: CommAdLoadListener(
        error: (error) {
          CommonEvent.loadFail(value, false, error.code);
        },
      ),
    );
    _channelLoading = false;
    if (_channelAd != null) {
      CommonEvent.loadSuccess(value, false);
    }
    return _channelAd != null;
  }

  Future<bool> showDetail({required ThingSourceEnum value}) async {
    return _showAD(_channelAd, value: value, adLoader: loadDetail);
  }

  Future<bool> loadNative({required ThingSourceEnum value}) async {
    if (_nativeLoading) return false;
    if (_nativeAd?.isCacheAvailable() ?? false) return false;
    final list = adDataMap[AdPositionEnum.native];
    if (list == null) return false;
    _nativeLoading = true;
    _nativeAd = await _loadAd(
      list,
      value: value,
      load: CommAdLoadListener(
        error: (e) {
          CommonEvent.loadFail(value, false, e.code);
        },
      ),
    );
    _nativeLoading = false;
    if (_nativeAd != null) {
      CommonEvent.loadSuccess(value, false);
    }
    return _nativeAd != null;
  }

  Future<bool> loadPlayVideo({required ThingSourceEnum value}) async {
    if (_playVideoLoading) return false;
    if (_playVideoAd?.isCacheAvailable() ?? false) return false;
    final list = adDataMap[AdPositionEnum.playVideo];
    if (list == null) return false;
    _playVideoLoading = true;
    _playVideoAd = await _loadAd(
      list,
      value: value,
      load: CommAdLoadListener(
        error: (e) {
          CommonEvent.loadFail(value, false, e.code);
        },
      ),
    );
    _playVideoLoading = false;
    if (_playVideoAd != null) {
      CommonEvent.loadSuccess(value, false);
    }
    return _playVideoAd != null;
  }

  Future<bool> showPlayVideo({required ThingSourceEnum value}) async {
    return _showAD(
      _playVideoAd,
      value: value,
      adLoader: loadPlayVideo,
      jumpTimeSpace: true,
    );
  }
}
