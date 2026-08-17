import 'dart:convert';

import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/provider/recommend.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/provider/out_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../common/common_enum.dart';
import '../../common/common_report/common_report.dart';
import '../../home/model/recommend_model.dart';

part 'out_user.g.dart';

@riverpod
class OutUser extends _$OutUser {
  int page = 1;
  int rPage = 0;
  int pageSize = 50;
  bool isReport = false;
  bool loadMore = false;
  bool isRequest = false;
  String uid = '';
  bool isMiddle = true;

  @override
  OutState build(OutModel model) {
    final one = ref.read(recommendProvider.notifier).getOne(uid: model.userId);
    if (one != null) {
      uid = one.uid ?? '';
      isMiddle = one.isMiddle;
    } else {
      isMiddle = model.isMiddle;
      uid = model.userId ?? "";
    }
    return OutState();
  }

  Future<void> initData() async {
    page = 1;
    await requestData();
  }

  Future<void> load() {
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
      final params = {
        "fishbones": uid,
        "phenyls": "v2",
        "spirogram": rPage, //页码
        "unfealty": pageSize, //分页大小
      };
      final res = await HttpHelper.request(
        HttpHelperApi.openData,
        isMiddle: isMiddle,
        params: params,
      );
      final List? files = res['regrowing'];
      if (files != null) {
        final f = files
            .map(
              (e) => OutMediaModel.fromJson(
                e,
                e['unholiness'],
                uid,
                isMiddle,
                isRecommend: true,
              ),
            )
            .toList();
        if (f.isEmpty && rPage == 1) {
          CommonReport.eventThings(
            ThingEnum.recommend_fail,
            data: {
              "PuUTVimak": "GGbBqDUBbq",
              "fail_reason": "file is empty isMiddle: $isMiddle",
              "kroulaXb": uid,
            },
          );
        }
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
              isMiddle = one.isMiddle;
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
      CommonReport.eventThings(
        ThingEnum.recommend_fail,
        data: {"PuUTVimak": "GGbBqDUBbq", "fail_reason": "$e"},
      );
    }
  }

  Future<void> requestData({bool isLoad = false}) async {
    final sp = await SharedPreferences.getInstance();
    try {
      final res = await HttpHelper.request(
        HttpHelperApi.openData,
        isMiddle: model.isMiddle,
        params: {
          "fishbones": model.userId,
          "phenyls": "v2",
          "spirogram": page, //页码
          "unfealty": pageSize, //分页大小
        },
      );
      if (res == null) {
        CommonReport.eventThings(
          ThingEnum.channel_fail,
          data: {
            "PuUTVimak": "no data, isMiddle: ${model.isMiddle}",
            "pSEsS": sp.getString(SharedStoreKey.outUrlId.name),
            "kroulaXb": model.userId,
          },
        );
        return;
      }
      if (res.isEmpty) {
        CommonReport.eventThings(
          ThingEnum.channel_fail,
          data: {
            "PuUTVimak": "no data, isMiddle: ${model.isMiddle}",
            "pSEsS": sp.getString(SharedStoreKey.outUrlId.name),
            "kroulaXb": model.userId,
          },
        );
        state = state.copyWith(noData: true, isLoading: false);
        return;
      }
      final u = res["sanbenito"];
      final List? rect = res['ariocarpus'];
      final List? top = res['rlzdve3axx'];
      final List? files = res['regrowing'];
      if (u != null) {
        final user = OutUserModel.fromJson(u);
        await CommonHive.recommendBox.put(
          user.id,
          RecommendModel(
            uid: user.id,
            uname: user.name,
            cover: user.corver,
            createDate: DateTime.now().millisecondsSinceEpoch,
            isMiddle: model.isMiddle,
          ),
        );
        ref
            .read(recommendProvider.notifier)
            .requestHistory(
              uid: user.id,
              tags: user.getTags(),
              isMiddle: model.isMiddle,
              refresh: false,
            );
        state = state.copyWith(user: user, isLoading: false);
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
              ),
            )
            .toList();
        if (f.isEmpty && page == 1) {
          CommonReport.eventThings(
            ThingEnum.channel_fail,
            data: {
              "PuUTVimak": "file empty no data isMiddle: ${model.isMiddle}",
              "pSEsS": sp.getString(SharedStoreKey.outUrlId.name),
              "kroulaXb": model.userId,
            },
          );
        }
        loadMore = f.length < pageSize;
        if (isLoad) {
          state = state.copyWith(files: [...?state.files, ...f]);
        } else {
          state = state.copyWith(files: f);
        }
        if (loadMore) {
          requestRecommend(false);
        }
      }
    } catch (e) {
      state  = state.copyWith(isLoading: false);
      // data: {"PuUTVimak": "$e", "pSEsS": model.outUrl, "kroulaXb": model.userId},
      CommonReport.eventThings(
        ThingEnum.channel_fail,
        data: {
          "PuUTVimak": "$e",
          "pSEsS": sp.getString(SharedStoreKey.outUrlId.name),
          "kroulaXb": model.userId,
        },
      );
    }
  }
}
