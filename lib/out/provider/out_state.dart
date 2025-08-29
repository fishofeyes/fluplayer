import 'package:fluplayer/out/model/out_user_model.dart';

import '../model/out_media_model.dart';

class OutState {
  final OutUserModel? user;
  final List<OutMediaModel>? files;
  final List<OutMediaModel>? tops;
  final List<OutMediaModel>? recents;
  final bool isLoading;
  final bool noData;
  final bool isMore;

  OutState({
    this.user,
    this.files,
    this.tops,
    this.recents,
    this.isLoading = true,
    this.isMore = false,
    this.noData = false,
  });

  OutState copyWith({
    OutUserModel? user,
    List<OutMediaModel>? files,
    List<OutMediaModel>? tops,
    List<OutMediaModel>? recents,
    bool? isLoading,
    bool? isMore,
    bool? noData,
  }) {
    return OutState(
      user: user ?? this.user,
      files: files ?? this.files,
      tops: tops ?? this.tops,
      recents: recents ?? this.recents,
      isLoading: isLoading ?? this.isLoading,
      isMore: isMore ?? this.isMore,
      noData: noData ?? false,
    );
  }
}
