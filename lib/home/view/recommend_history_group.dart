import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/recommend/recommend_page.dart';
import 'package:fluplayer/recommend/view/recommend_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/recommend.dart';

class RecommendHistoryGroup extends ConsumerWidget {
  const RecommendHistoryGroup({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(recommendProvider);
    final list = state.showHistory;
    if (list.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackgroundTitleView(title: 'Channel'),
            GestureDetector(
              onTap: () {
                commonPush(context, RecommendPage());
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
                  Image.asset("assets/home/more2.png", width: 12, height: 12),
                ],
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.only(top: 12, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list
                .map((e) => RecommendHistory(model: e, isHome: true))
                .toList(),
          ),
        ),
      ],
    );
  }
}
