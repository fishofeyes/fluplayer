import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/home/history_page.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/home/view/home_video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../player/player_page.dart';

class HomeHistoryView extends ConsumerWidget {
  const HomeHistoryView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(homeProvider);
    final list = state.history.take(4).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackgroundTitleView(title: 'History'),
            GestureDetector(
              onTap: () {
                commonPush(context, HistoryPage());
              },
              child: Row(
                children: [
                  const Text(
                    "More",
                    style: TextStyle(
                      color: Color(0xff919191),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset("assets/more.webp", width: 12, height: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 158,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return HomeVideoView(
                model: list[index],
                onTap: (e) {
                  commonPush(context, PlayerPage(model: e, models: list));
                },
              );
            },
          ),
        ),
        const SizedBox(height: 23),
      ],
    );
  }
}
