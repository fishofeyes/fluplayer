import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_enum.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/home/view/history_item.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryMorePageState();
}

class _HistoryMorePageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/home/bg.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Image.asset(
                        "assets/player/back.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(homeProvider.notifier).deleteAll();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Image.asset(
                        "assets/home/delete.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 20 / 18,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: state.history.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (ctx, idx) {
                    return HistoryItem(
                      model: state.history[idx],
                      onDelete: (e) {
                        ref.read(homeProvider.notifier).deleteSingle(e);
                      },
                      onTap: (e) {
                        commonPush(
                          context,
                          PlayerPage(
                            model: e,
                            models: state.history,
                            place: CommonReportSourceEnum.history,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
