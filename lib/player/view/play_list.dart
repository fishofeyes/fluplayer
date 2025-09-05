import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/player/provider/play.dart';
import 'package:fluplayer/player/view/play_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertPlayList extends ConsumerStatefulWidget {
  final ScrollController controller;
  const AlertPlayList({super.key, required this.controller});

  @override
  ConsumerState<AlertPlayList> createState() => _AlertPlayListState();
}

class _AlertPlayListState extends ConsumerState<AlertPlayList> {
  final _refreshController = EasyRefreshController(controlFinishLoad: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playProvider);
    final size = MediaQuery.of(context).size;
    ref.listen(playProvider, (oldvalue, newValue) {
      _refreshController.finishLoad(
        newValue.noData ? IndicatorResult.noMore : IndicatorResult.success,
      );
    });
    return ClipRRect(
      borderRadius: screenPortraitUp == false
          ? BorderRadius.vertical(top: Radius.circular(24))
          : BorderRadius.zero,
      child: Container(
        height: size.height * 0.55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff3E2309), Color(0xff000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.only(top: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Playlist",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset("assets/player/close.png", width: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenPortraitUp == false ? 16 : 16),
            Expanded(
              child: EasyRefresh(
                controller: _refreshController,
                header: const CupertinoHeader(
                  foregroundColor: Colors.white,
                  triggerOffset: 20,
                  backgroundColor: Colors.transparent,
                ),
                footer: const CupertinoFooter(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  emptyWidget: SizedBox(),
                ),
                onRefresh: () async {
                  return ref.read(playProvider.notifier).getOtherMedia(false);
                },
                onLoad: () async {
                  return ref.read(playProvider.notifier).getOtherMedia(true);
                },
                child: ListView.builder(
                  itemCount: state.list.length,
                  controller: widget.controller,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, idx) {
                    return PlayListItem(data: state.list[idx]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
