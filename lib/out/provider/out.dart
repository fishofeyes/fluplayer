import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/request/http_helper.dart';
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
          if (f.isEmpty && isRequest) {
            isRequest = false;
            final one = ref
                .read(recommendProvider.notifier)
                .getOne(uid: model.userId);
            if (one != null) {
              uid = one.uid ?? '';
            }
            requestRecommend(false);
          }
          state = state.copyWith(
            files: [...?state.files, ...f],
            isMore: f.length < pageSize,
          );
        }
      } else {
        state = state.copyWith(isMore: true);
      }
    } catch (e) {
      CommonReport.myEvent(MySessionEvent.landpaCDZgeFail);
    }
  }

  Future<void> requestData({bool isLoad = false}) async {
    final res = await HttpHelper.request(
      HttpHelperApi.openData,
      isMiddle: model.isMiddle,
      params: {
        "douzainier": {"stemhcjx4m": model.outUrl}, // 未处理
        "phenyls": "v2",
        "spirogram": page, //页码
        "unfealty": pageSize, //分页大小
      },
    );
    if (res == null) {
      print("open data request err");
      return;
    }
    final u = res["sanbenito"];
    final List? rect = res['ariocarpus'];
    final List? top = res['rlzdve3axx'];
    final List? files = res['regrowing'];
    if (u != null) {
      final user = OutUserModel.fromJson(u);
      await ref
          .read(recommendProvider.notifier)
          .requestHistory(
            uid: user.id,
            tags: user.getTags(),
            isMiddle: model.isMiddle,
          );
      state = state.copyWith(user: user, isLoading: false);
      if (isReport == false) {
        // 拿到数据之后上报view_app
        isReport = true;
        CommonReport.backEvent(
          CommonReportEnum.commonView,
          isMiddle: model.isMiddle,
        );
      }
      final sp = await SharedPreferences.getInstance();

      if (sp.getString(SharedStoreKey.userEmail.name) == null) {
        CommonReport.backEvent(
          CommonReportEnum.commonDownload,
          isMiddle: model.isMiddle,
          linkId: model.outUrl,
        );
      }
      await sp.setString(SharedStoreKey.userEmail.name, user.email ?? "");
      await sp.setBool(SharedStoreKey.isMiddle.name, model.isMiddle);
    }
    if (rect != null) {
      state = state.copyWith(
        recents: rect
            .map(
              (e) => OutMediaModel.fromJson(
                e,
                e['unholiness'],
                model.userId,
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
                model.userId,
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
              model.userId,
              model.isMiddle,
              outUrl: model.outUrl,
            ),
          )
          .toList();
      loadMore = files.length < pageSize;
      if (isLoad) {
        state = state.copyWith(files: [...?state.files, ...f]);
      } else {
        if (f.length > 5) {
          final one = ref
              .read(recommendProvider.notifier)
              .getOne(uid: model.userId);
          if (one != null) {
            uid = one.uid ?? '';
          }
        }
        state = state.copyWith(files: f);
      }
      if (loadMore) {
        requestRecommend(false);
      }
    }
  }
}
