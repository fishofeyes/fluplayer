import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/provider/recommend.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/provider/out_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      HttpHelperApi.openPage,
      isMiddle: isMiddle,
      params: {
        "navarin": uid,
        "eyases": "v2",
        "cocoonery": rPage, //页码
        "vibioid": pageSize, //分页大小
      },
    );
    final List? files = res['pend'];
    if (files != null) {
      final f = files
          .map(
            (e) => OutMediaModel.fromJson(
              e,
              e['fileMeta'],
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
      HttpHelperApi.openPage,
      isMiddle: model.isMiddle,
      params: {
        "navarin": model.userId,
        "eyases": "v2",
        "cocoonery": page, //页码
        "vibioid": pageSize, //分页大小
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
    final u = res["q15izceo7d"];
    final List? rect = res['usherism'];
    final List? top = res['hdkf'];
    final List? files = res['pend'];
    if (u != null) {
      final user = OutUserModel.fromJson(u);
      // await DatabaseHelper.instance.insertFollow(
      //   CommendModel(
      //     uid: user.id,
      //     uname: user.name,
      //     picture: user.picture,
      //     createDate: DateTime.now().millisecondsSinceEpoch,
      //     fromWeb: model.from,
      //   ),
      // );
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
                e['fileMeta'],
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
                e['fileMeta'],
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
              e['fileMeta'],
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
