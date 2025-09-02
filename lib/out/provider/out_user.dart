import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/provider/recommend.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/provider/out_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      uid = model.userId;
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
    final res = await HttpHelper.request(
      HttpHelperApi.openData,
      isMiddle: isMiddle,
      params: {
        "uid": uid,
        "version": "v2",
        "current_page": rPage, //页码
        "page_size": pageSize, //分页大小
      },
    );
    final List? files = res['pend'];
    if (files != null) {
      final f = files
          .map(
            (e) => OutMediaModel.fromJson(
              e,
              e['file_meta'],
              uid,
              isMiddle,
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
            isMiddle = one.isMiddle;
          }
          requestRecommend(false);
        }
        state = state.copyWith(
          files: [...files, ...f],
          isMore: f.length < pageSize,
        );
      }
    } else {
      state = state.copyWith(isMore: true);
    }
  }

  Future<void> requestData({bool isLoad = false}) async {
    final res = await HttpHelper.request(
      HttpHelperApi.openData,
      isMiddle: model.isMiddle,
      params: {
        "uid": uid,
        "version": "v2",
        "current_page": rPage, //页码
        "page_size": pageSize, //分页大小
      },
    );
    if (res == null) {
      print("open data request err");
      return;
    }
    if (res.isEmpty) {
      state = state.copyWith(noData: true, isLoading: false);
      return;
    }
    final u = res["user"];
    final List? rect = res['recent_videos'];
    final List? top = res['top100_view_count_videos'];
    final List? files = res['files'];
    if (u != null) {
      final user = OutUserModel.fromJson(u);
      CommonHive.recommendBox.put(
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
          );
      state = state.copyWith(user: user, isLoading: false);
    }
    if (rect != null) {
      state = state.copyWith(
        recents: rect
            .map(
              (e) => OutMediaModel.fromJson(
                e,
                e['file_meta'],
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
                e['file_meta'],
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
              e['file_meta'],
              model.userId,
              model.isMiddle,
            ),
          )
          .toList();
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
  }
}
