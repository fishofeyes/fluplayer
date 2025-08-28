import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/common/view/custom_list_view.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/home/view/empry_view.dart';
import 'package:fluplayer/home/view/home_history.dart';
import 'package:fluplayer/home/view/home_video_view.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
            child: Image.asset("assets/bg.webp"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Visibility(
                  visible: state.history.isNotEmpty,
                  child: const HomeHistoryView(),
                ),
                const BackgroundTitleView(title: 'All videos'),
                const SizedBox(height: 12),
                Expanded(
                  child: state.home.isEmpty
                      ? EmptyView()
                      : SingleChildScrollView(
                          padding: const EdgeInsetsDirectional.only(
                            bottom: 150,
                          ),
                          child: CustomListView(
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
                                    PlayerPage(model: e, models: state.home),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
