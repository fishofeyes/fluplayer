import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/model/recommend_model.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../home/provider/recommend.dart';

part 'play.g.dart';

@Riverpod(keepAlive: true)
class Play extends _$Play {
  RecommendModel? userModel;
  @override
  PlayState build() {
    return PlayState();
  }

  void initList(
    List<HomeVideoModel> list,
    HomeVideoModel model,
    bool haveRecommend,
  ) {
    if (list.isEmpty) return;
    state = state.copyWith(
      list: list,
      id: model.id,
      isFirst: model.id == list.first.id,
      isLast: model.id == list.last.id,
      haveRecommend: haveRecommend,
    );

    userModel = ref.read(recommendProvider.notifier).getOne();
    if (model.isMiddle != null) {
      getOtherMedia(false);
    }
  }

  void getOtherMedia(bool load) async {
    if (state.haveRecommend == false || userModel == null) {
      state = state.copyWith(noData: true);
      return;
    }
    final sort = [];
    final HomeVideoModel? m = state.list.lastOrNull;
    if (m == null) return;
    if (load) {
      sort.add(m.createDate);
      sort.add(m.id);
    }
    final res = await HttpHelper.request(
      HttpHelperApi.recommend,
      isMiddle: userModel!.isMiddle,
      params: {
        "families": userModel!.uid, // 用户ID
        "p9tqm_03j_": {"staves": sort}, // 排序索引依据
      },
    );
    List? l = res?['carbamine'];
    if (l != null) {
      final f = l
          .map(
            (e) => OutMediaModel.fromRecommend(
              e,
              e["pneumony"],
              userModel!.uid,
              userModel!.isMiddle,
            ).convertModel(recommend: true),
          )
          .toList();
      state = state.copyWith(
        list: [...state.list, ...f],
        noData: f.length < 50,
      );
    }
  }

  void tapModel(HomeVideoModel sender) {
    state = state.copyWith(
      id: sender.id,
      isFirst: sender.id == state.list.first.id,
      isLast: sender.id == state.list.last.id,
    );
  }

  void nextModel(bool isNext) {
    int idx = state.list.indexWhere((e) => e.id == state.id);
    if (isNext) {
      idx += 1;
      if (idx < state.list.length) {
        tapModel(state.list[idx]);
      }
    } else {
      idx -= 1;
      if (idx >= 0) {
        tapModel(state.list[idx]);
      }
    }
  }

  HomeVideoModel getModel() {
    return state.list.firstWhere((e) => e.id == state.id);
  }

  int getIdx() {
    return state.list.indexWhere((e) => e.id == state.id);
  }
}

class PlayState {
  final List<HomeVideoModel> list;
  final String id;
  final bool isFirst;
  final bool isLast;
  final bool noData;
  final bool haveRecommend;

  PlayState({
    this.list = const [],
    this.id = "",
    this.isFirst = true,
    this.isLast = false,
    this.noData = false,
    this.haveRecommend = false,
  });

  PlayState copyWith({
    List<HomeVideoModel>? list,
    String? id,
    bool? isFirst,
    bool? isLast,
    bool? noData,
    bool? haveRecommend,
  }) {
    return PlayState(
      list: list ?? this.list,
      id: id ?? this.id,
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
      noData: noData ?? this.noData,
      haveRecommend: haveRecommend ?? this.haveRecommend,
    );
  }
}
