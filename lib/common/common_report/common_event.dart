import 'dart:async';

import 'package:fluplayer/home/model/home.dart';

import '../common_enum.dart';
import 'common_report.dart';

class CommonEvent {
  static HomeVideoModel? model;
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

  static void reportAd(
    double val,
    String curr,
    String network,
    String adS,
    String adId,
    String adT,
  ) {
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
