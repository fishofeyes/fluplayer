import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/common/view/custom_list_view.dart';
import 'package:fluplayer/common/view/subscribe_icon.dart';
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

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(homeProvider.notifier).load();
    });
    CommonReport.eventThings(ThingEnum.homeEJ6gQHxpose);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(homeProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                const SizedBox(height: 55),
                SubscribeIcon(
                  padding: EdgeInsets.only(bottom: 16),
                  source: "WFZcIkYdR",
                ),
                Visibility(
                  visible: state.history.isNotEmpty,
                  child: const HomeHistoryView(),
                ),
                const RecommendHistoryGroup(),
                InkWell(
                  onTap: () async {
                    if (kDebugMode) {
                      // final androidId = await AndroidId().getId();
                      // print("--androidId--$androidId");
                      // await admobHelper3.loadOpenAd(value: ThingSourceEnum.pause);
                      // admobHelper3.showOpenAd(value: ThingSourceEnum.pause);
                      showDialog(
                        context: commonContext!,
                        barrierDismissible: false,
                        useSafeArea: false,
                        builder: (ctx) => OutPage(
                          model: OutModel(
                            // outUrl: "2087185249523482625",
                            outUrl: "2088086552596078593",
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
                              CommonReport.eventThings(
                                ThingEnum.playST5Xource,
                                data: {"PuUTVimak": "YVEQPmBnm"},
                              );
                              commonPush(
                                context,
                                PlayerPage(
                                  model: e,
                                  models: state.home,
                                  place: CommonReportSourceEnum.home,
                                  source: "YVEQPmBnm",
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

  @override
  bool get wantKeepAlive => true;
}
