import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/provider/out_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'out_dir.g.dart';

@riverpod
class OutDir extends _$OutDir {
  int page = 1;
  int pageSize = 50;
  @override
  OutState build(OutModel model, String? dirId) {
    return OutState();
  }

  Future<void> initData() async {
    page = 1;
    await requestData();
  }

  Future<void> loadMore() async {
    page += 1;
    await requestData(isLoad: true);
  }

  Future<void> requestData({bool isLoad = false}) async {
    final res = await HttpHelper.request(
      HttpHelperApi.openFile,
      query: "${model.userId}/$dirId",
      post: false,
      isMiddle: model.isMiddle,
      params: {
        "current_page": page, //页码
        "page_size": pageSize, //分页大小
      },
    );
    final List? files = res['files'];
    if (files != null) {
      final f = files
          .map(
            (e) => OutMediaModel.fromDirJson(
              e,
              e["file_meta"],
              model.userId,
              model.isMiddle,
            ),
          )
          .toList();
      if (isLoad) {
        state = state.copyWith(
          files: [...?state.files, ...f],
          isMore: files.length < pageSize,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          files: f,
          isMore: files.length < pageSize,
          isLoading: false,
        );
      }
    }
  }
}
