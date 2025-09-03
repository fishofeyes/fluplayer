import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/out/out_dir_page.dart';
import 'package:fluplayer/out/out_user_page.dart';
import 'package:fluplayer/out/provider/out.dart';
import 'package:fluplayer/out/view/out_cover.dart';
import 'package:fluplayer/out/view/out_header.dart';
import 'package:fluplayer/out/view/out_item.dart';
import 'package:fluplayer/out/view/out_section_group.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/common.dart';
import '../common/common_af_helper.dart';
import '../common/common_enum.dart';
import 'model/out_media_model.dart';
import 'model/out_model.dart';

class OutPage extends ConsumerStatefulWidget {
  final OutModel model;
  const OutPage({super.key, required this.model});

  @override
  ConsumerState<OutPage> createState() => _PresentPageState();
}

class _PresentPageState extends ConsumerState<OutPage> {
  String customKey = 'home';
  final _refreshController = EasyRefreshController(controlFinishLoad: true);
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(outProvider(widget.model).notifier).initData();
    });
    // BackReportService.presentUrl = widget.model.outUrl;
    CommonReport.myEvent(MySessionEvent.landpag1lAeExpose);
    // isLinkPagePop = true;
  }

  @override
  void dispose() {
    // alertIds.remove(widget.model.outUrl);
    // DeepLinkService.deepLink = null;
    // BackReportService.presentUrl = null;
    CommonAfHelper().dismiss();
    _refreshController.dispose();
    // globalVipPage?.call(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(outProvider(widget.model));
    ref.listen(outProvider(widget.model), (oldValue, newValue) {
      SchedulerBinding.instance.addPostFrameCallback((e) {
        _refreshController.finishLoad(
          newValue.isMore ? IndicatorResult.noMore : IndicatorResult.success,
        );
      });
    });

    List<OutMediaModel> list;
    if (tabIndex == 0) {
      list = state.files ?? [];
    } else if (tabIndex == 1) {
      list = state.tops ?? [];
    } else {
      list = state.recents ?? [];
    }
    int length = list.length;
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
            top: 56,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 56),
                OutHeader(
                  model: state.user,
                  onTap: () {
                    if (state.user != null) {
                      commonPush(
                        context,
                        OutUserPage(user: state.user, model: widget.model),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                OutSectionGroup(
                  index: tabIndex,
                  onTap: (i) {
                    if (i == 2) {
                      CommonReport.myEvent(
                        MySessionEvent.landpageUpl1LFD0oadedExpose,
                      );
                    }
                    setState(() {
                      tabIndex = i;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff1C150F),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                        return ref
                            .read(outProvider(widget.model).notifier)
                            .initData();
                      },
                      onLoad: () async {
                        return ref
                            .read(outProvider(widget.model).notifier)
                            .load();
                      },
                      child: ListView.builder(
                        itemCount: length,
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
                                  padding: const EdgeInsetsDirectional.only(
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
                                    final r = ref
                                        .read(
                                          outProvider(widget.model).notifier,
                                        )
                                        .model;
                                    if (m.directory) {
                                      commonPush(
                                        context,
                                        OutDirPage(
                                          model: widget.model,
                                          mediaModel: m,
                                          place:
                                              CommonReportSourceEnum.landpage,
                                          // source: ReportSource.landpage,
                                        ),
                                      );
                                    } else if (m.video) {
                                      final res = list
                                          .where((e) => e.video)
                                          .map((e) => e.convertModel())
                                          .toList();
                                      CommonReport.myEvent(
                                        MySessionEvent.playSPmdU5ource,
                                        data: {"caycJ": "mygpO"},
                                      );
                                      commonPush(
                                        context,
                                        PlayerPage(
                                          model: m.convertModel(link: ""),
                                          place:
                                              CommonReportSourceEnum.landpage,
                                          models: res ?? [],
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
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: state.isLoading,
              child: const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
