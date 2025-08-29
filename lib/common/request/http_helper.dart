import 'package:dio/dio.dart';
import 'package:fluplayer/common/common_aes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HttpHelperApi {
  openPage("/v1/coffeebush/marmorize/tremors", "affiants"),
  openDec("/v1/baguet/ladydom/matriarchs/", "brainpans"),
  playUrl("/v1/warori/court/athamaunte/", "ploesti"),
  appPost("/v1/bulies/undashed", "bedazzle"),
  appRecommend("/v1/foldure/yelm", "l5rbrlmna8"),
  appRecommendDetail("/v1/melicerous/forlornity", "hemlock"),
  warning("/v1/hydrophora/mioses", "pernyi");

  final String desc;
  final String val;

  const HttpHelperApi(this.desc, this.val);
}

class HttpHelper {
  static final Dio _dio = Dio();
  static Future<dynamic> request(
    HttpHelperApi api, {
    Map<String, dynamic>? params,
    String? query,
    bool post = true,
    bool isMiddle = true,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final idx = sp.getInt(CommonAes.apiIdxKey[isMiddle]!) ?? 0;
    try {
      final url =
          CommonAes.getRequestUrl(isMiddle, idx) + api.desc + (query ?? '');
      final Options op = Options(
        contentType: "application/json",
        headers: {CommonAes.headerIdentifier: api.val},
      );
      Response response;
      if (post) {
        response = await _dio.post(url, data: params, options: op);
      } else {
        response = await _dio.get(url, queryParameters: params, options: op);
      }
      print("api: $url");
      print("data: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      // 处理Dio错误
      final saveIdx = idx + 1;
      sp.setInt(CommonAes.apiIdxKey[isMiddle]!, saveIdx >= 2 ? 0 : saveIdx);
      if (e.response != null) {
        print('请求失败: ${e.response?.statusCode} ${e.response?.data}');
        // 可以根据不同的状态码进行不同的处理
        return Future.error(e.response?.data);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print('连接超时');
        return Future.error('连接超时');
      } else if (e.type == DioExceptionType.cancel) {
        print('请求取消');
        return Future.error('请求取消');
      } else {
        print('请求失败: ${e.message}');
        return Future.error(e.message ?? '');
      }
    } catch (e) {
      // 处理其他错误
      print('请求失败: $e');
      return Future.error(e);
    }
  }
}
