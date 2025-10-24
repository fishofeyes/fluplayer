import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/vip/provider/provider.dart';
import 'package:fluplayer/vip/view/alert_vip.dart';
import 'package:fluplayer/vip/vip_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_report/common_event.dart';

class CommonAutoVip {
  static SharedPreferences? share;

  static Future<void> _init() async {
    share ??= await SharedPreferences.getInstance();
  }

  static void _saveInt(String key, int value) {
    share?.setInt(key, value);
  }

  static int? _getInt(String key) {
    return share?.getInt(key);
  }

  static bool _checkSpace(String key) {
    bool go = false;
    final t = _getInt(key);
    if (t == null) {
      go = true;
    } else if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(t))
            .inSeconds >
        3600) {
      go = true;
    }
    return go;
  }

  static void jumpVip(BuildContext context, bool autoPage) async {
    await _init();
    bool go = false;
    String timeKey = "autoVip_${autoPage ? 'page' : 'pop'}";
    String countKey = "autoVipCount_${autoPage ? 'page' : 'pop'}";
    if (globalOpenVip) {
      go = false;
    } else if (_checkSpace("autoVip_${autoPage ? 'pop' : 'page'}")) {
      final count = _getInt(countKey) ?? 0;
      if (count < 3) {
        go = true;
        _saveInt(timeKey, DateTime.now().millisecondsSinceEpoch);
        _saveInt(countKey, count + 1);
      } else {
        final t = _getInt(timeKey) ?? 0;
        if (DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(t))
                .inSeconds >
            24 * 60 * 60) {
          _saveInt(timeKey, DateTime.now().millisecondsSinceEpoch);
          _saveInt(countKey, 1);
          go = true;
        }
      }
    }

    if (go) {
      CommonEvent.changePlayStatus(false);
      if (autoPage) {
        commonPush(context, VipPage());
      } else {
        commonShowDialog(context, AlertVip());
      }
    }
  }
}
