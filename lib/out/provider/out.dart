import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/model/recommend_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../common/common_enum.dart';
import '../../home/provider/recommend.dart';
import '../model/out_media_model.dart';
import 'out_state.dart';
part 'out.g.dart';

@riverpod
class Out extends _$Out {
  int page = 1;
  int pageSize = 50;
  bool isReport = false;
  bool loadMore = false;
  bool isRequest = true;
  int rPage = 0;
  String uid = "";
  @override
  OutState build(OutModel model) {
    return OutState();
  }

  Future<void> initData() async {
    page = 1;
    await requestData();
  }

  Future<void> load() async {
    if (loadMore) {
      rPage += 1;
      return requestRecommend(true);
    } else {
      page += 1;
      return requestData(isLoad: true);
    }
  }

  Future<void> requestRecommend(bool load) async {
    if (load == false) {
      rPage = 1;
    }
    try {
      final res = await HttpHelper.request(
        HttpHelperApi.openData,
        isMiddle: model.isMiddle,
        params: {
          "fishbones": uid,
          "phenyls": "v2",
          "spirogram": rPage, //页码
          "unfealty": pageSize, //分页大小
        },
      );
      final List? files = res['regrowing'];
      if (files != null) {
        final f = files
            .map(
              (e) => OutMediaModel.fromJson(
                e,
                e['unholiness'],
                uid,
                model.isMiddle,
                isRecommend: true,
              ),
            )
            .toList();
        if (load) {
          state = state.copyWith(
            files: [...?state.files, ...f],
            isMore: f.length < pageSize,
          );
        } else {
          state = state.copyWith(
            files: [...?state.files, ...f],
            isMore: f.length < pageSize,
          );
        }
      } else {
        state = state.copyWith(isMore: true);
      }
    } catch (e) {
      print("recommend error = $e");
    }
  }

  Future<void> requestData({bool isLoad = false}) async {
    try {
      final params = {
        if(model.outUrl != null) "douzainier": {"stemhcjx4m": model.outUrl} else "fishbones": model.userId, // 未处理
        "phenyls": "v2",
        "spirogram": page, //页码
        "unfealty": pageSize, //分页大小
      };
      final res = await HttpHelper.request(
        HttpHelperApi.openData,
        isMiddle: model.isMiddle,
        params: params);
      if (res == null) {
        CommonReport.eventThings(
          ThingEnum.landpa6EQy5geFail,
          data: {"PuUTVimak": "no data, isMiddle: ${model.isMiddle}", "errorInfo": jsonEncode(params)},
        );
        return;
      }
      final u = res["sanbenito"];
      final List? rect = res['ariocarpus'];
      final List? top = res['rlzdve3axx'];
      final List? files = res['regrowing'];
      String? userId = model.userId;
      if (u != null) {
        final user = OutUserModel.fromJson(u);
        userId ??= user.id;
        CommonHive.recommendBox.put(
          user.id,
          RecommendModel(
            uid: user.id,
            uname: user.name,
            cover: user.corver,
            isMiddle: model.isMiddle,
            createDate: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        await ref
            .read(recommendProvider.notifier)
            .requestHistory(
              uid: user.id,
              tags: user.getTags(),
              isMiddle: model.isMiddle,
            );
        state = state.copyWith(user: user, isLoading: false);
        final sp = await SharedPreferences.getInstance();
        await sp.setString(SharedStoreKey.userId.name, user.id);
        await sp.setBool(SharedStoreKey.isMiddle.name, model.isMiddle);
        CommonReport.adCreateEvent(user: user);
        if (sp.getString(SharedStoreKey.userEmail.name) == null) {
          CommonReport.backEvent(
            CommonReportEnum.commonDownload,
            isMiddle: model.isMiddle,
            outUrl: model.outUrl,
          );
        }
        await sp.setString(SharedStoreKey.userEmail.name, user.email ?? "");
        if (isReport == false) {
          // 拿到数据之后上报view_app
          isReport = true;
          CommonReport.backEvent(
            CommonReportEnum.commonView,
            isMiddle: model.isMiddle,
            outUrl: model.outUrl,
          );
        }
      }
      if (rect != null) {
        state = state.copyWith(
          recents: rect
              .map(
                (e) => OutMediaModel.fromJson(
                  e,
                  e['unholiness'],
                  userId,
                  model.isMiddle,
                  outUrl: model.outUrl,
                ),
              )
              .toList(),
          isLoading: false,
        );
      }
      if (top != null) {
        state = state.copyWith(
          tops: top
              .map(
                (e) => OutMediaModel.fromJson(
                  e,
                  e['unholiness'],
                  userId,
                  model.isMiddle,
                  outUrl: model.outUrl,
                ),
              )
              .toList(),
          isLoading: false,
        );
      }
      if (files != null) {
        final f = files
            .map(
              (e) => OutMediaModel.fromJson(
                e,
                e['unholiness'],
                userId,
                model.isMiddle,
                outUrl: model.outUrl,
              ),
            )
            .toList();
        loadMore = files.length < pageSize;
        if (isLoad) {
          state = state.copyWith(files: [...?state.files, ...f]);
        } else {
          if (uid.isEmpty) {
            if (f.length > 5) {
              final one = ref
                  .read(recommendProvider.notifier)
                  .getOne(uid: userId);
              if (one != null) {
                uid = one.uid ?? '';
              }
            } else {
              uid = userId ?? "";
            }
          }
          state = state.copyWith(files: f);
        }
        if (loadMore) {
          requestRecommend(false);
        }
      }
    } catch (e, et) {
      print("error = $e, info: ${et.toString()}");
      CommonReport.eventThings(
        ThingEnum.landpa6EQy5geFail,
        data: {"PuUTVimak": "$e", "errorInfo": "${et.toString()}"},
      );
    }
  }
}
