import 'dart:async';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper2.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_enum.dart';
import 'common_report.dart';

class CommonEvent {
  static String? _outUrl;
  static String? _fId;
  static CommonReportSourceEnum? _source;
  static bool _isMiddle = true;
  static final StreamController<bool> videoPlayController =
      StreamController.broadcast();

  static void onDismiss() {
    changePlayStatus(true);
    // Future.delayed(const Duration(milliseconds: 500)).then((e) {
    //   globalAdIsShow = false;
    // });
    // auto += 1;
    // if (auto == 2) {
    //   globalVipAlert?.call(false);
    // } else {
    //   globalVipPage?.call(true);
    // }
  }

  static void changePlayStatus(bool isPlay) {
    videoPlayController.add(isPlay);
  }

  static void showSuccessAd(
    ThingSourceEnum value, {
    bool isSecond = false,
    required bool isSecondNativeAd,
  }) {
    changePlayStatus(false);
    CommonReport.eventThings(
      ThingEnum.adShowPqEpOslacement,
      data: {
        "PuUTVimak": value.value,
        "gNAuA": isSecond ? 2 : 1,
        if (isSecondNativeAd) "QcaFyP3": 2,
      },
    ); // 统一上报到一个事件
  }

  static void showFailed(
    ThingSourceEnum value,
    String e, {
    bool isSecond = false,
  }) {
    CommonReport.eventThings(
      ThingEnum.adShoIjxp9wFail,
      data: {"PuUTVimak": value.value, "pAoJksW": e, "gNAuA": isSecond ? 2 : 1},
    ); // 统一上报到一个事件
  }

  static void adClick(ThingSourceEnum value, bool isSecond) {
    CommonReport.eventThings(
      ThingEnum.adCLfrDZlick,
      data: {"PuUTVimak": value.value, "gNAuA": isSecond ? 2 : 1},
    );
  }

  static void loadFail(ThingSourceEnum value, bool isSecond, String code) {
    CommonReport.eventThings(
      ThingEnum.adRe7aTtqFail,
      data: {
        "PuUTVimak": value.value,
        "gNAuA": isSecond ? 2 : 1,
        "pAoJksW": code,
      },
    );
  }

  static void loadSuccess(ThingSourceEnum value, bool isSecond) {
    CommonReport.eventThings(
      ThingEnum.adReuKkp8qSuc,
      data: {"PuUTVimak": value.value, "gNAuA": isSecond ? 2 : 1},
    );
  }

  static Future<bool> loadAd(
    AdPositionEnum position,
    ThingSourceEnum value,
  ) async {
    Future.delayed(const Duration(seconds: 1)).then((e) async {
      admobHelper2.loadOpenAd(value: value);
      await Future.delayed(const Duration(seconds: 1));
      admobHelper3.loadOpenAd(value: value);
    });
    switch (position) {
      case AdPositionEnum.open:
        return admobHelper.loadOpenAd(value: value);
      case AdPositionEnum.media:
        return admobHelper.loadMedia(value: value);
      case AdPositionEnum.detail:
        return admobHelper.loadDetail(value: value);
      case AdPositionEnum.native:
        return admobHelper.loadNative(value: value);
      case AdPositionEnum.playVideo:
        return admobHelper.loadPlayVideo(value: value);
    }
  }

  static Future<bool> showAd(
    AdPositionEnum position,
    ThingSourceEnum value, {
    String? outUrl,
    String? fId,
    CommonReportSourceEnum? source,
    bool? isMiddle,
  }) async {
    _fId = fId;
    _outUrl = outUrl;
    _source = source;
    _isMiddle =
        (isMiddle ??
            (await SharedPreferences.getInstance()).getBool(
              SharedStoreKey.isMiddle.name,
            )) ??
        true;
    switch (position) {
      case AdPositionEnum.open:
        return admobHelper.showOpenAd(value: value);
      case AdPositionEnum.media:
        return admobHelper.showMediaAd(value: value);
      case AdPositionEnum.detail:
        return admobHelper.showDetail(value: value);
      case AdPositionEnum.native:
        return false;
      case AdPositionEnum.playVideo:
        return admobHelper.showPlayVideo(value: value);
    }
  }

  static void reportAd(
    double val,
    String curr,
    String network,
    String adS,
    String adId,
    String adT,
  ) async {
    final sp = await SharedPreferences.getInstance();
    final uid = sp.getString(SharedStoreKey.userId.name);
    final rr = sp.getBool(SharedStoreKey.isMiddle.name);
    if (rr == _isMiddle) {
      CommonReport.backEvent(
        uid == null ? CommonReportEnum.commLocalAd : CommonReportEnum.commAd,
        isMiddle: _isMiddle,
        source: _source,
        outUrl: _outUrl,
        fid: _fId,
        val: val,
        uid: uid,
        curr: curr,
      );
    }
    CommonReport.adEvent(
      val,
      curr,
      network,
      adS,
      adId,
      _source?.name ?? "",
      adT,
    );
    // BackReportService.adEvent(
    //   curr,
    //   val,
    //   source: _source,
    //   uid: _uid,
    //   linkId: _linkId,
    //   fileId: _fileId,
    //   from: _from,
    //   adId: adId,
    // );
  }
}
