import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_report/common_event.dart';
import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/common/view/custom_list_view.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/home/view/empry_view.dart';
import 'package:fluplayer/home/view/home_history.dart';
import 'package:fluplayer/home/view/home_video_view.dart';
import 'package:fluplayer/home/view/recommend_history_group.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/out_page.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common_enum.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(homeProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/home/bg.png"),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Visibility(
                  visible: state.history.isNotEmpty,
                  child: const HomeHistoryView(),
                ),
                const RecommendHistoryGroup(),
                InkWell(
                  onTap: () {
                    if(kDebugMode) {
                      commonPush(
                        context,
                        OutPage(
                          model: OutModel(
                            outUrl: "1955514254387986434",
                            userId: "1745334294672449537",
                            isMiddle: true,
                          ),
                        ),
                      );
                    }
                  },
                  child: const BackgroundTitleView(title: 'All videos'),
                ),
                const SizedBox(height: 12),
                state.home.isEmpty
                    ? EmptyView()
                    : CustomListView(
                        itemCount: state.home.length,
                        itemsPerRow: 2,
                        itemSpacing: 15,
                        rowSpacing: 12,
                        itemBuilder: (ctx, index) {
                          return HomeVideoView(
                            model: state.home[index],
                            onTap: (e) {
                              commonPush(
                                context,
                                PlayerPage(
                                  model: e,
                                  models: state.home,
                                  place: CommonReportSourceEnum.home,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
