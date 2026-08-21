import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_aes.dart';
import 'package:fluplayer/common/common_app.dart';
import 'package:fluplayer/common/common_report/model/common_event_model.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common_enum.dart';
import '../common_hive.dart';

class CommonReport {
  static PackageInfo? _package;
  static AndroidDeviceInfo? _iosDevice;
  static const _uuid = Uuid();
  static String? outUrl;
  static String? fileId;
  static const host = "https://phase.fluplayerapp.com/dew/nodule";

  static Future<AndroidDeviceInfo> device() async {
    _iosDevice ??= await DeviceInfoPlugin().androidInfo;
    return _iosDevice!;
  }

  static Future<PackageInfo> package() async {
    _package ??= await PackageInfo.fromPlatform();
    return _package!;
  }

  static Future<String?> uniqueId() async {
    String? uniqueId = await AndroidId().getId();
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

  // tba event
  static void eventThings(ThingEnum e, {Map<String, dynamic>? data}) async {
    final p = await otherParams();
    _commonPost({
      ...p,
      "whop": e.value,
      if (data != null) e.value: {...data},
    });
  }

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
      print("后台事件上报>>>>>>${report.name}:$res, source: $source");
    } catch (e) {
      print("后台事件上报>>>>>>${report.name}:$e, source: $source");
    }
  }

  static Future<String> getDistickId() async {
    final sp = await SharedPreferences.getInstance();
    String? dId = sp.getString(SharedStoreKey.userDistinctId.name);
    if (dId == null) {
      dId = _uuid.v4();
      sp.setString(SharedStoreKey.userDistinctId.name, dId);
    }
    return dId;
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

    String? dId = await getDistickId();
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
      "pigments": {"phyllodia": p.packageName},
      "snuffly": await AdvertisingId.id(),
      "visioned": await AdvertisingId.id(),
      "bumpsy": "cmcc",
      "k8xi0hqumd": await uniqueId(),
      "phenakism": d.model,
      "incurable": p.version,
      "artworks": d.version.release,
      "anaseismic": PlatformDispatcher.instance.locales.first.countryCode,
      "u3nb2roago": dId, // distinct_id
      "pvxbxrmpzo": {
        "respired": {"cepes": d.model},
      },
      "proparia": "android",
      "3lkaprpcxz": DateTime.now().timeZoneOffset.inHours,
      "thetics": DateTime.now().millisecondsSinceEpoch,
      "civilizade": d.name,
      "rombowline": Platform.localeName,
      "wasting": await AdvertisingId.id(),
    };
    return res;
  }

  ///
  /// other platform ad event params
  ///
  static Future<Map<String, dynamic>> otherParams() async {
    final p = await package();
    final d = await device();
    final sp = await SharedPreferences.getInstance();

    String? dId = await getDistickId();
    return {
      "qs": p.packageName,
      "bizet": "exclude",
      "flip": p.version,
      "fill": dId,
      "pour": _uuid.v4(),
      "homeward": DateTime.now().millisecondsSinceEpoch,
      "marmoset": d.brand,
      "squishy": d.model,
      "somali": d.version.release,
      "parabola": "mnc",
      "omnibus": Platform.localeName,
      "monomial": "gp",
      "morsel": await uniqueId(),
      "acid": await AdvertisingId.id(),
      "lola%pSEsS": outUrl,
      "lola%eELXrc": fileId,
      "lola%jxMjP": sp.getString(SharedStoreKey.userEmail.name),
      "lola%kroulaXb": sp.getString(SharedStoreKey.userId.name),
      "lola%CdbP": sp.getBool(SharedStoreKey.isMiddle.name) == true
          ? "oOskWjNYM"
          : "CrYC",
      "lola%RqxmLFdTO": CommonApp.haveSim,
      "lola%hEWmQ": CommonApp.isSimulator,
      "lola%XIWzzPLm": CommonApp.isVip,
      "lola%VHQoGulpp": CommonApp.isPad,
    };
  }

  static Future<bool> _commonPost(
    Map<String, dynamic> data, {
    bool retry = true,
  }) async {
    try {
      await HttpHelper.dio2.post(host, data: data);
      return true;
    } catch (e) {
      print("error ad: $e");
      if (retry) {
        final m = CommonEventModel(
          id: _uuid.v4(),
          createTime: DateTime.now().millisecondsSinceEpoch,
          parameters: jsonEncode(data),
        );
        CommonHive.commonEventBox.put(m.id, m);
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
    try {
      final data = {
        ...p,
        "aesthete": "build/${pp.version}",
        "whop": "adrift",
        "lux": "Mozilla",
        "freetown": "juniper",
        "frazier": 0,
        "knit": 0,
        "gordon": 0,
        "marriott": 0,
        "monty": 0,
        "amoebae": 0,
      };
      final res = await _commonPost(data);
      if (res && user != null) {
        sp.setInt(SharedStoreKey.isInstall.name, 2);
      } else if (res && user == null) {
        sp.setInt(SharedStoreKey.isInstall.name, 1);
      }
    } catch (e) {
      print("error install: $e");
    }
  }

  static void adSessionEvent() async {
    final p = await otherParams();
    _commonPost({...p, "whop": "oppose"});
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
      "sweater": {
        "crook": m,
        "playtime": coin,
        "brood": network,
        "diogenes": adS,
        "float": adId,
        "currant": adP,
        "reason": adT,
      },
    });
  }

  static void reportFail() async {
    for (final i in CommonHive.commonEventBox.values) {
      bool isLessThanTwoDays =
          (DateTime.now().millisecondsSinceEpoch - i.createTime) <
          2 * 24 * 60 * 60 * 1000;
      if (isLessThanTwoDays == false) {
        CommonHive.commonEventBox.delete(i.id);
        continue;
      }
      final res = await _commonPost(jsonDecode(i.parameters), retry: false);
      if (res) {
        CommonHive.commonEventBox.delete(i.id);
      }
    }
  }
}
