import 'package:dio/dio.dart';

import '../common_enum.dart';

class CommonReport {
  static final _dio = Dio();

  static Future<bool> _post(
    Map<String, dynamic> data, {
    bool retry = true,
  }) async {
    try {
      await _dio.post("xxx", data: data);
      return true;
    } catch (e) {
      print("error ad: $e");
      if (retry == false) {
        // await DatabaseHelper.instance.insertTba(data);
      }
      return false;
    }
  }

  static void myEvent(MySessionEvent e, {Map<String, dynamic>? data}) async {}

  static void adEvent(
    double m,
    String coin,
    String network,
    String adS,
    String adId,
    String adP,
    String adT, {
    required bool isMiddle,
  }) async {
    // final p = await BackReportService.adPara({
    //   "language": {
    //     // "labium": 1000000,
    //     // "rpm": "USD",
    //     // "gleeful": "Facebook",
    //     // "trianon": "admob",
    //     // "tapis": "ca-app-pub-7068043263440714/7572461234",
    //     // "trashy": "page1_top_banner",
    //     // "advisor": "",
    //     // "analyses": "",
    //     // "nebulae": "native",
    //     "labium": m,
    //     "rpm": coin,
    //     "gleeful": network,
    //     "trianon": adS,
    //     "tapis": adId,
    //     "trashy": adP,
    //     "nebulae": adT,
    //   },
    // }, from);
    // _post(p);
  }
}
