import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/common.dart';
import '../../common/common_enum.dart';
import '../../common/common_hive.dart';
import '../model/recommend_model.dart';

part 'recommend.g.dart';

@Riverpod(keepAlive: true)
class Recommend extends _$Recommend {
  bool isReport = true;
  @override
  RecommendState build() {
    return RecommendState();
  }

  Future<void> requestHistory({
    String? uid,
    List<Map<String, dynamic>>? tags,
    required bool isMiddle,
    bool refresh = true,
  }) async {
    final h = CommonHive.recommendBox.values.toList();
    h.sort((a, b) => b.createDate.compareTo(a.createDate));
    state = state.copyWith(history: h, showHistory: h);
    if (refresh || state.list.isEmpty) {
      return requestData(uid: uid, tags: tags, isMiddle: isMiddle);
    } else {
      final ids = state.history.map((e) => e.uid);
      final l2 = <RecommendModel>[];
      for (final m in state.list) {
        if (ids.contains(m.uid) == false) {
          l2.add(m);
        }
      }
      List<RecommendModel> showHistory = [...state.history];
      final random = Random();
      if (l2.isNotEmpty) {
        final randomIndex = random.nextInt(l2.length);
        if (showHistory.length < 3) {
          showHistory.add(l2[randomIndex]);
        } else {
          showHistory.insert(2, l2[randomIndex]);
        }
      }
      if (showHistory.length > 20) {
        showHistory = showHistory.take(20).toList();
      }
      state = state.copyWith(showHistory: showHistory);
    }
  }

  RecommendModel? getOne({String? uid}) {
    final random = Random();
    if (uid != null) {
      final t = state.list.isEmpty ? state.history : state.list;
      final l = t.where((e) => e.uid != uid).toList();
      if (l.isEmpty) return null;
      final randomIndex = random.nextInt(l.length);
      if (randomIndex < 0 || randomIndex > l.length) return null;
      return l[randomIndex];
    } else {
      final l = state.list.isEmpty ? state.history : state.list;
      if (l.isEmpty) return null;
      final randomIndex = random.nextInt(l.length);
      if (randomIndex < 0 || randomIndex > l.length) return null;
      return l[randomIndex];
    }
  }

  Future<void> requestData({
    String? uid,
    List<dynamic>? tags,
    bool? isMiddle,
  }) async {
    final sp = await SharedPreferences.getInstance();
    if (uid != null) {
      sp.setString(SharedStoreKey.recommendUserId.name, uid);
    } else {
      uid = sp.getString(SharedStoreKey.recommendUserId.name);
    }
    if (isMiddle == null) {
      isMiddle = sp.getBool(SharedStoreKey.isMiddle.name) ?? true;
    } else {
      sp.setBool(SharedStoreKey.isMiddle.name, isMiddle);
    }
    if (tags != null) {
      sp.setString(SharedStoreKey.userTags.name, jsonEncode(tags));
    }
    tags = jsonDecode(sp.getString(SharedStoreKey.userTags.name)!);
    if (uid == null) return;
    try {
      final res = await HttpHelper.request(
        HttpHelperApi.appUsers,
        isMiddle: isMiddle,
        params: {
          "fenestrae": uid, //站长id
          "logotype": "android", //系统(android , ios)
          "witchbells": Platform.localeName, //语言
          "lzbbtf7zpa": {"lm3asrinkf": tags}, // 未处理
        },
      );
      if (res is List) {
        if (res.isEmpty) {
          CommonReport.eventThings(
            ThingEnum.recommend_fail,
            data: {
              "PuUTVimak": "WFZcIkYdR",
              "fail_reason": "not data uid: $uid",
              "kroulaXb": uid,
            },
          );
        }
        final l = <RecommendModel>[];
        final ids = state.history.map((e) => e.uid);
        final l2 = <RecommendModel>[];
        for (final i in res) {
          final m = RecommendModel.fromJson(i, isMiddle);
          l.add(m);
          if (ids.contains(m.uid) == false) {
            l2.add(m);
          }
        }
        List<RecommendModel> showHistory = [...state.history];
        final random = Random();
        if (l.isEmpty) return;
        if (l2.isNotEmpty) {
          final randomIndex = random.nextInt(l2.length);
          if (showHistory.length < 3) {
            showHistory.add(l2[randomIndex]);
          } else {
            showHistory.insert(2, l2[randomIndex]);
          }
        }
        if (isReport) {
          isReport = false;
          CommonReport.eventThings(
            ThingEnum.homeChan8FvYXnelExpose,
            data: {"TTdYTwdcUy": state.history.length},
          );
        }
        if (showHistory.length > 20) {
          showHistory = showHistory.take(20).toList();
        }
        state = state.copyWith(list: l, showHistory: showHistory);
      }
    } catch (e) {
      CommonReport.eventThings(
        ThingEnum.recommend_fail,
        data: {"PuUTVimak": "WFZcIkYdR", "fail_reason": "$e", "kroulaXb": uid},
      );
    }
  }
}

class RecommendState {
  final List<RecommendModel> list;
  final List<RecommendModel> history;
  final List<RecommendModel> showHistory;

  RecommendState({
    this.list = const [],
    this.history = const [],
    this.showHistory = const [],
  });

  RecommendState copyWith({
    List<RecommendModel>? list,
    List<RecommendModel>? history,
    List<RecommendModel>? showHistory,
  }) {
    return RecommendState(
      list: list ?? this.list,
      history: history ?? this.history,
      showHistory: showHistory ?? this.showHistory,
    );
  }
}
