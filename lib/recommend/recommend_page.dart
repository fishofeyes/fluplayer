import 'package:fluplayer/common/view/background_title.dart';
import 'package:fluplayer/recommend/view/RecommendCell.dart';
import 'package:fluplayer/recommend/view/recommend_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/provider/recommend.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  void initState() {
    super.initState();
    // AdController.loadAd(AdModelType.detail, MySessionValue.chlistpage);
    // SharedPreferences.getInstance().then((sp) {
    //   final from = FromWeb.values[sp.getInt(CustomCacheKey.lastFrom.name) ?? 1];
    //   AdController.showAd(AdModelType.detail,
    //       from: from, value: MySessionValue.chlistpage);
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/bg.webp"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 58),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.asset("assets/back.webp", width: 24, height: 24),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 16.0),
                child: BackgroundTitleView(title: "Followed"),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(recommendProvider);
                  final history = state.history;
                  final list = state.list;
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsetsDirectional.only(
                              top: 12,
                              start: 12,
                              bottom: 32,
                            ),
                            itemCount: history.length,
                            itemBuilder: (context, idx) {
                              final e = history[idx];
                              return RecommendHistory(
                                model: e,
                                size: 68,
                                isHome: false,
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: 12),
                          child: BackgroundTitleView(title: "Recommended"),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(
                              top: 12,
                              start: 12,
                              end: 12,
                            ),
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff4A74FF).withOpacity(0.12),
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsetsDirectional.only(
                                start: 12,
                                end: 13,
                                bottom: 12,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, idx) {
                                return ReCommendCell(
                                  model: list[idx],
                                  idx: idx,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
