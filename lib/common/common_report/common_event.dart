import 'dart:async';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
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
  static final StreamController<bool> adShowController =
      StreamController.broadcast();

  static void onDismiss() {
    adShowController.add(false);
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

  static void showSuccessAd(MySessionValue value, {bool isSecond = false}) {
    adShowController.add(true);
    CommonReport.myEvent(
      MySessionEvent.adShowPH9FvSlacement,
      data: {"caycJ": value.value, "SuDJs": isSecond ? 2 : 1},
    ); // 统一上报到一个事件
  }

  static void showFailed(
    MySessionValue value,
    String e, {
    bool isSecond = false,
  }) {
    CommonReport.myEvent(
      MySessionEvent.adShowFail,
      data: {"caycJ": value.value, "gnHt": e, "SuDJs": isSecond ? 2 : 1},
    ); // 统一上报到一个事件
  }

  static void adClick(MySessionValue value, bool isSecond) {
    CommonReport.myEvent(
      MySessionEvent.adCI3llick,
      data: {"caycJ": value.value, "SuDJs": isSecond ? 2 : 1},
    );
  }

  static void loadFail(MySessionValue value, bool isSecond) {
    CommonReport.myEvent(
      MySessionEvent.adFzZ4ail,
      data: {"caycJ": value.value, "SuDJs": isSecond ? 2 : 1},
    );
  }

  static void loadSuccess(MySessionValue value, bool isSecond) {
    CommonReport.myEvent(
      MySessionEvent.adReNazqSuc,
      data: {"caycJ": value.value, "SuDJs": isSecond ? 2 : 1},
    );
  }

  static Future<bool> loadAd(
    AdPositionEnum position,
    MySessionValue value,
  ) async {
    switch (position) {
      case AdPositionEnum.open:
        return admobHelper.loadOpenAd(value: value);
      case AdPositionEnum.media:
        return admobHelper.loadMedia(value: value);
      case AdPositionEnum.detail:
        return admobHelper.loadDetail(value: value);
      case AdPositionEnum.native:
        return admobHelper.loadNative(value: value);
    }
  }

  static Future<bool> showAd(
    AdPositionEnum position,
    MySessionValue value, {
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
    // CommonReport.adParam(
    //   val,
    //   curr,
    //   network,
    //   adS,
    //   adId,
    //   _source?.name ?? "",
    //   adT,
    //   from: model.is,
    // );
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
