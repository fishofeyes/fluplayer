import 'package:fluplayer/home/model/home.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play.g.dart';

@Riverpod(keepAlive: true)
class Play extends _$Play {
  @override
  PlayState build() {
    return PlayState();
  }

  void initList(List<HomeVideoModel> list, HomeVideoModel model) {
    if (list.isEmpty) return;
    state = state.copyWith(
      list: list,
      id: model.id,
      isFirst: model.id == list.first.id,
      isLast: model.id == list.last.id,
    );
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

  PlayState({
    this.list = const [],
    this.id = "",
    this.isFirst = true,
    this.isLast = false,
  });

  PlayState copyWith({
    List<HomeVideoModel>? list,
    String? id,
    bool? isFirst,
    bool? isLast,
  }) {
    return PlayState(
      list: list ?? this.list,
      id: id ?? this.id,
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
    );
  }
}
