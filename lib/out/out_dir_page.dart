import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluplayer/out/model/out_media_model.dart';
import 'package:fluplayer/out/model/out_model.dart';
import 'package:fluplayer/out/provider/out_dir.dart';
import 'package:fluplayer/out/view/out_item.dart';
import 'package:fluplayer/player/player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/common.dart';

class OutDirPage extends ConsumerStatefulWidget {
  final OutModel model;
  final OutMediaModel mediaModel;
  const OutDirPage({super.key, required this.model, required this.mediaModel});

  @override
  ConsumerState<OutDirPage> createState() => _PresentDirPageState();
}

class _PresentDirPageState extends ConsumerState<OutDirPage> {
  final _refreshController = EasyRefreshController(controlFinishLoad: true);
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref
          .read(outDirProvider(widget.model, widget.mediaModel.id).notifier)
          .initData();
    });
    // AdController.loadAd(AdModelType.detail, MySessionValue.folder);
    // AdController.showAd(
    //   AdModelType.detail,
    //   from: widget.model.from,
    //   value: MySessionValue.folder,
    // );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(outDirProvider(widget.model, widget.mediaModel.id));
    ref.listen(outDirProvider(widget.model, widget.mediaModel.id), (
      oldvalue,
      newValue,
    ) {
      _refreshController.finishLoad(
        newValue.isMore ? IndicatorResult.noMore : IndicatorResult.success,
      );
    });
    final list = state.files ?? [];

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Image.asset(
                        "assets/back.webp",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  widget.mediaModel.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    EasyRefresh(
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
                            .read(
                              outDirProvider(
                                widget.model,
                                widget.mediaModel.id,
                              ).notifier,
                            )
                            .initData();
                      },
                      onLoad: () async {
                        return ref
                            .read(
                              outDirProvider(
                                widget.model,
                                widget.mediaModel.id,
                              ).notifier,
                            )
                            .loadMore();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsetsDirectional.only(
                          start: 13,
                          end: 12,
                        ),
                        itemCount: list.length,
                        itemBuilder: (ctx, idx) {
                          final m = list[idx];
                          return OutItem(
                            model: m,
                            bgColor: Colors.transparent,
                            onTap: () {
                              if (m.directory) {
                                commonPush(
                                  context,
                                  OutDirPage(
                                    model: widget.model,
                                    mediaModel: m,
                                  ),
                                );
                              } else if (m.video) {
                                commonPush(
                                  context,
                                  PlayerPage(
                                    model: m.convertModel(),
                                    models: list
                                        .where((e) => e.video)
                                        .map((e) => e.convertModel())
                                        .toList(),
                                  ),
                                );
                              }
                            },
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      bottom: 100,
                      child: Visibility(
                        visible: state.isLoading,
                        child: const Align(
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
