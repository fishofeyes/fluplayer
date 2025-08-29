import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(presentLinkProvider(widget.model).notifier).initData();
    });
    BackReportService.presentUrl = widget.model.outUrl;
    // AdReportService.myEvent(MySessionEvent.landpag1lAeExpose);
    isLinkPagePop = true;
  }

  @override
  void dispose() {
    alertIds.remove(widget.model.outUrl);
    DeepLinkService.deepLink = null;
    BackReportService.presentUrl = null;
    _refreshController.dispose();
    globalVipPage?.call(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(presentLinkProvider(widget.model));
    ref.listen(presentLinkProvider(widget.model), (oldValue, newValue) {
      SchedulerBinding.instance.addPostFrameCallback((e) {
        _refreshController.finishLoad(
          newValue.isMore ? IndicatorResult.noMore : IndicatorResult.success,
        );
      });
    });
    final _idx = ref.watch(presentIdxProvider(customKey));
    ref.listen(presentIdxProvider(customKey), (old, val) {
      if (val == 2) {
        AdReportService.myEvent(MySessionEvent.landpageUpl1LFD0oadedExpose);
      }
      if (val > 0) {
        val = val - 1;
        final t = [MySessionValue.landHot, MySessionValue.landRect];
        AdController.loadAd(AdModelType.detail, t[val]);
        AdController.showAd(
          AdModelType.detail,
          from: widget.model.from,
          value: t[val],
        );
      }
    });

    List<PresentModel> list;
    int commendLength = 0;
    if (_idx == 0) {
      list = state.files ?? [];
      commendLength = state.recommends?.length ?? 0;
    } else if (_idx == 1) {
      list = state.tops ?? [];
    } else {
      list = state.recents ?? [];
    }
    int length = list.length;
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 56),
                MyHeader(
                  model: state.user,
                  onTap: () {
                    if (state.user != null) {
                      customPush(
                        context,
                        PresentDetailPage(
                          user: state.user,
                          model: widget.model,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: CustomView(
                    customKey: customKey,
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
                            .read(presentLinkProvider(widget.model).notifier)
                            .initData();
                      },
                      onLoad: () async {
                        return ref
                            .read(presentLinkProvider(widget.model).notifier)
                            .load();
                      },
                      child: ListView.builder(
                        itemCount: length + commendLength,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (ctx, idx) {
                          late PresentModel m;
                          bool showHeader = false;
                          if (idx < list.length) {
                            m = list[idx];
                          } else {
                            final commIdx = idx - length;
                            showHeader = commIdx == 0;
                            m = state.recommends![commIdx];
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
                                  color: const Color(
                                    0xff2440FE,
                                  ).withOpacity(0.12),
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
                                child: PresentItem(
                                  model: m,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 12,
                                    top: 12,
                                  ),
                                  onTap: () {
                                    final r = ref.read(
                                      presentLinkProvider(
                                        widget.model,
                                      ).notifier,
                                    );
                                    if (m.directory) {
                                      if (idx < list.length) {
                                        customPush(
                                          context,
                                          PresentDirPage(
                                            model: widget.model,
                                            item: m,
                                            value: "txzlrWJzW",
                                            source: ReportSource.landpage,
                                          ),
                                        );
                                      } else {
                                        customPush(
                                          context,
                                          PresentDirPage(
                                            model: OutModel(
                                              outUrl: "",
                                              userId: r.uid,
                                              from: r.fromWeb,
                                            ),
                                            item: m,
                                            value: "mygpO",
                                            source: ReportSource.landpage,
                                          ),
                                        );
                                      }
                                    } else if (m.video) {
                                      if (idx < list.length) {
                                        final t = m.convertModel(
                                          from: widget.model.from,
                                          link: widget.model.outUrl,
                                          userId: widget.model.userId,
                                        );
                                        final l = "txzlrWJzW、wFD、uRzo".split(
                                          '、',
                                        );
                                        AdReportService.myEvent(
                                          MySessionEvent.playSPmdU5ource,
                                          data: {"caycJ": l[_idx]},
                                        );
                                        customPush(
                                          context,
                                          VideoPlayPage(
                                            model: t,
                                            source: ReportSource.landpage,
                                            list: list
                                                .where((e) => e.video)
                                                .map(
                                                  (e) => e.convertModel(
                                                    from: widget.model.from,
                                                    link: widget.model.outUrl,
                                                    userId: widget.model.userId,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      } else {
                                        final t = m.convertModel(
                                          from: r.fromWeb,
                                          link: "",
                                          userId: r.uid,
                                        );
                                        final res = state.recommends
                                            ?.where((e) => e.video)
                                            .map(
                                              (e) => e.convertModel(
                                                from: r.fromWeb,
                                                link: "",
                                                userId: r.uid,
                                              ),
                                            )
                                            .toList();
                                        AdReportService.myEvent(
                                          MySessionEvent.playSPmdU5ource,
                                          data: {"caycJ": "mygpO"},
                                        );
                                        customPush(
                                          context,
                                          VideoPlayPage(
                                            model: t,
                                            source: ReportSource.landpage,
                                            list: res ?? [],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onReport: () {
                                    late VideoModel mm;
                                    if (idx < list.length) {
                                      mm = m.convertModel(
                                        from: widget.model.from,
                                        link: widget.model.outUrl,
                                        userId: widget.model.userId,
                                      );
                                    } else {
                                      final r = ref.read(
                                        presentLinkProvider(
                                          widget.model,
                                        ).notifier,
                                      );
                                      mm = m.convertModel(
                                        from: r.fromWeb,
                                        link: "",
                                        userId: r.uid,
                                      );
                                    }
                                    showBottom(
                                      context,
                                      AlertWarningView(
                                        model: mm,
                                        presentModel: m,
                                      ),
                                    );
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
