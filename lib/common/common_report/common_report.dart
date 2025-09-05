import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_aes.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common_enum.dart';

class CommonReport {
  static PackageInfo? _package;
  static IosDeviceInfo? _iosDevice;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _uuid = Uuid();
  static final _dio = Dio();
  static const host = isProd
      ? "https://test-fiddle.fluplayer.com/buggy/hoc"
      : "https://fiddle.fluplayer.com/air/equine";

  static Future<IosDeviceInfo?> device() async {
    _iosDevice ??= await DeviceInfoPlugin().iosInfo;
    return _iosDevice;
  }

  static Future<PackageInfo?> package() async {
    _package ??= await PackageInfo.fromPlatform();
    return _package;
  }

  static Future<String> uniqueId() async {
    String? uniqueId = await _storage.read(key: "S.uniqueId.name");
    if (uniqueId == null) {
      uniqueId = _uuid.v4();
      _storage.write(key: "s.uniqueId.name", value: uniqueId);
    }
    return uniqueId;
  }

  static Future<int> isNewUser() async {
    final sp = await SharedPreferences.getInstance();
    final isNru = sp.getInt(SharedStoreKey.newUser.name);
    if (isNru == null) {
      sp.setInt(
        SharedStoreKey.newUser.name,
        DateTime.now().millisecondsSinceEpoch,
      );
      return 1;
    }
    final nowDate = DateTime.now();
    final firstDate = DateTime.fromMillisecondsSinceEpoch(isNru);
    final isSameDay =
        nowDate.year == firstDate.year &&
        nowDate.month == firstDate.month &&
        nowDate.day == firstDate.day;
    return isSameDay ? 1 : 0;
  }

  // static Future<bool> _post(
  //   Map<String, dynamic> data, {
  //   bool retry = true,
  // }) async {
  //   try {
  //     await _dio.post("xxx", data: data);
  //     return true;
  //   } catch (e) {
  //     print("error ad: $e");
  //     if (retry == false) {
  //       // await DatabaseHelper.instance.insertTba(data);
  //     }
  //     return false;
  //   }
  // }

  // tba event
  static void myEvent(MySessionEvent e, {Map<String, dynamic>? data}) async {}

  // back event
  static Future<void> backEvent(
    CommonReportEnum report, {
    CommonReportSourceEnum? source,
    required bool? isMiddle,
    String? curr,
    String? uid,
    String? fid,
    double? val,
    String? outUrl,
  }) async {
    final p = await backEventParam(
      report: report,
      source: source,
      curr: curr,
      val: val,
      outUrl: outUrl,
      uid: uid,
      fId: fid,
    );
    try {
      final sp = await SharedPreferences.getInstance();
      isMiddle ??= sp.getBool(SharedStoreKey.isMiddle.name) ?? true;
      final res = await HttpHelper.request(
        HttpHelperApi.event,
        isMiddle: isMiddle,
        params: {"strasses": CommonAes.getAes(p)},
      );
      print("后台事件上报>>>>>>:$res");
    } catch (e) {
      print("后台事件上报>>>>>>:$e");
    }
  }

  static Future<Map<String, dynamic>> backEventParam({
    required CommonReportEnum report,
    CommonReportSourceEnum? source,
    String? curr,
    String? outUrl,
    String? fId,
    String? uid,
    double? val,
  }) async {
    final p = await package();
    final d = await device();
    final sp = await SharedPreferences.getInstance();

    String? dId = sp.getString(SharedStoreKey.userDistinctId.name);
    if (dId == null) {
      dId = _uuid.v4();
      sp.setString(SharedStoreKey.userDistinctId.name, dId);
    }
    final res = {
      "underthief": _uuid.v4(),
      "rclame": report.key,
      "jibbooms": uid,
      "lyopoma": outUrl,
      "enceinte": fId,
      "ezdcflccnu": curr,
      "waterstead": val,
      "alfaqui": "v2",
      "utilizers": await uniqueId(),
      "4fiabarlcw": {"illuminate": source?.name},
      "vacate": await isNewUser(),
      "pigments": {"phyllodia": p?.packageName},
      "snuffly": await AdvertisingId.id(),
      "visioned": d?.identifierForVendor,
      "bumpsy": "cmcc",
      "phenakism": d?.model,
      "incurable": p?.version,
      "artworks": d?.systemVersion,
      "anaseismic": PlatformDispatcher.instance.locales.first.countryCode,
      "u3nb2roago": dId, // distinct_id
      "pvxbxrmpzo": {
        "respired": {"cepes": d?.model},
      },
      "proparia": "ios",
      "3lkaprpcxz": DateTime.now().timeZoneOffset.inHours,
      "thetics": DateTime.now().millisecondsSinceEpoch,
      "civilizade": d?.name,
      "rombowline": Platform.localeName,
      "wasting": await AdvertisingId.id(),
    };
    return res;
  }

  ///
  /// other platform ad event params
  ///
  static Future<Map<String, dynamic>> otherParams({
    String? fileId,
    String? outUrl,
  }) async {
    final p = await package();
    final d = await device();
    final sp = await SharedPreferences.getInstance();

    String? dId = sp.getString(SharedStoreKey.userDistinctId.name);
    if (dId == null) {
      dId = _uuid.v4();
      sp.setString(SharedStoreKey.userDistinctId.name, dId);
    }
    return {
      "diane": {"cellar": _uuid.v4(), "dopant": p?.packageName, "savage": dId},
      "solid": {
        "pl": "mcc",
        "louse": DateTime.now().millisecondsSinceEpoch,
        "rush": p?.version,
        "next": await AdvertisingId.id(),
        "spar": "",
        "stud": d?.name,
      },
      "agrimony": {
        "kafka": "motto",
        "dont": await AppTrackingTransparency.getAdvertisingIdentifier(),
        "hermann": Platform.localeName,
        "okay": "",
        "severe": null,
        "torrid": null,
      },
      "sec": {
        "advisory": d?.systemVersion,
        "cetacean": d?.model,
        "spite": await AdvertisingId.id(),
      },
      "scarlet": {
        "iplayer_linkid": "",
        "iplayer_resource": "",
        "iplayer_recent_email": "",
        "iplayer_recent_uid": "",
        "channel_platform": "",
      },
    };
  }

  static Future<bool> _commonPost(
    Map<String, dynamic> data, {
    bool retry = true,
  }) async {
    try {
      await _dio.post(host, data: data);
      return true;
    } catch (e) {
      print("error ad: $e");
      if (retry == false) {
        // await DatabaseHelper.instance.insertTba(data);
      }
      return false;
    }
  }

  // install
  static adCreateEvent({OutUserModel? user}) async {
    final sp = await SharedPreferences.getInstance();
    final reportStatus = sp.getInt(SharedStoreKey.isInstall.name);
    if (reportStatus == 2) return;
    if (reportStatus == 1 && user == null) return;
    final pp = await package();
    final p = await otherParams();
    _commonPost({
      ...p,
      "eucre": "build/${pp?.version}",
      "browne": "utm_source=google-play&utm_medium=organic",
      "diode": "Mozilla/5.0",
      "eluate": 0,
      "erasure": 0,
      "nagoya": 0,
      "confect": 0,
      "topmost": 0,
      "bernie": 0,
      "hello": "low",
    });
  }

  static void adSessionEvent() async {
    final p = await otherParams();
    _commonPost({...p, "hello": "lye"});
  }

  static void adEvent(
    double m,
    String coin,
    String network,
    String adS,
    String adId,
    String adP,
    String adT,
  ) async {
    final p = await otherParams();
    _commonPost({
      ...p,
      "arianism": {
        "stanford": m,
        "alb": coin,
        "forsworn": network,
        "wharf": adS,
        "sulfite": adId,
        "annex": adP,
        "azalea": adT,
      },
    });
  }
}
