import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/model/out_user_model.dart';
import 'package:fluplayer/out/out_dir_page.dart';
import 'package:fluplayer/out/provider/out_user.dart';
import 'package:fluplayer/out/view/out_item.dart';
import 'package:fluplayer/out/view/out_section_group.dart';
import 'package:fluplayer/out/view/out_user_cover.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common_enum.dart';
import 'model/out_media_model.dart';

class OutUserPage extends ConsumerStatefulWidget {
  final OutUserModel? user;
  final OutModel model;
  const OutUserPage({super.key, this.user, required this.model});

  @override
  ConsumerState<OutUserPage> createState() => _OutUserPageState();
}

class _OutUserPageState extends ConsumerState<OutUserPage> {
  final _refreshController = EasyRefreshController(controlFinishLoad: true);
  String customKey = "detail";
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(outUserProvider(widget.model).notifier).initData();
    });
    // AdController.loadAd(AdModelType.detail, MySessionValue.chpage);
    // myFrom = widget.model.from;
    // AdController.showAd(
    //   AdModelType.detail,
    //   uid: widget.model.userId,
    //   source: ReportSource.channelpage,
    //   from: widget.model.from,
    //   value: MySessionValue.chpage,
    // );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141414),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/home/bg.png"),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: ExtendedImage.network(
              widget.user?.corver ?? "",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                child: Container(color: Colors.black45),
              ),
            ),
          ),
          Positioned(
            top: 49 + 20 + 52,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 229,
                decoration: BoxDecoration(
                  color: Color(0xff282018),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 49),
              Row(
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
                  const Spacer(),
                  // const VipEnterItem(from: VipEnterValue.clpage),
                  // const SizedBox(width: 12),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 19.0, right: 22, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.user?.name ?? '-',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutUserCover(url: widget.user?.corver),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              OutSectionGroup(
                index: tabIndex,
                onTap: (e) {
                  setState(() {
                    tabIndex = e;
                  });
                },
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(outUserProvider(widget.model));
                    ref.listen(outUserProvider(widget.model), (
                      oldValue,
                      newValue,
                    ) {
                      SchedulerBinding.instance.addPostFrameCallback((e) {
                        _refreshController.finishLoad(
                          newValue.isMore
                              ? IndicatorResult.noMore
                              : IndicatorResult.success,
                        );
                      });
                    });

                    List<OutMediaModel> list;
                    int commendLength = 0;
                    if (tabIndex == 0) {
                      list = state.files ?? [];
                    } else if (tabIndex == 1) {
                      list = state.tops ?? [];
                    } else {
                      list = state.recents ?? [];
                    }
                    int length = list.length;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff1C150F),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          EasyRefresh(
                            controller: _refreshController,
                            header: const CupertinoHeader(
                              triggerOffset: 20,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                            ),
                            footer: const CupertinoFooter(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              emptyWidget: SizedBox(),
                            ),
                            onRefresh: () async {
                              return ref
                                  .read(outUserProvider(widget.model).notifier)
                                  .initData();
                            },
                            onLoad: () async {
                              return ref
                                  .read(outUserProvider(widget.model).notifier)
                                  .load();
                            },
                            child: ListView.builder(
                              itemCount: length + commendLength,
                              padding: EdgeInsets.zero,
                              itemBuilder: (ctx, idx) {
                                OutMediaModel m = list[idx];
                                bool showHeader = false;
                                if (idx > 0) {
                                  if (list[idx].isRecommend &&
                                      !list[idx - 1].isRecommend) {
                                    showHeader = true;
                                  }
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: showHeader,
                                      child: Container(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                              start: 10,
                                              top: 16,
                                            ),
                                        color: const Color(0xff1C150F),
                                        width: double.infinity,
                                        child: const Text(
                                          "Recommend",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: idx == 0
                                          ? const BorderRadius.vertical(
                                              top: Radius.circular(8),
                                            )
                                          : BorderRadius.zero,
                                      child: OutItem(
                                        model: m,
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 12,
                                          top: 12,
                                        ),
                                        onTap: () {
                                          final r = ref.read(
                                            outUserProvider(
                                              widget.model,
                                            ).notifier,
                                          );
                                          if (m.directory) {
                                            commonPush(
                                              context,
                                              OutDirPage(
                                                model: widget.model,
                                                mediaModel: m,
                                                place: m.isRecommend
                                                    ? CommonReportSourceEnum
                                                          .userPageRecommend
                                                    : CommonReportSourceEnum
                                                          .userpage,
                                              ),
                                            );
                                          } else if (m.video) {
                                            commonPush(
                                              context,
                                              PlayerPage(
                                                model: m.convertModel(),
                                                models: list
                                                    .where((e) => e.video)
                                                    .map(
                                                      (e) => e.convertModel(),
                                                    )
                                                    .toList(),
                                                place: m.isRecommend
                                                    ? CommonReportSourceEnum
                                                          .userPageRecommend
                                                    : CommonReportSourceEnum
                                                          .userpage,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Visibility(
                                  visible: state.isLoading,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: state.noData,
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No data",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
