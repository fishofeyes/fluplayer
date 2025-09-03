import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluplayer/common/common_enum.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/view/common_button.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/player/provider/play.dart';
import 'package:fluplayer/player/view/play_list.dart';
import 'package:fluplayer/player/view/player_controller.dart';
import 'package:fluplayer/player/view/player_forward.dart';
import 'package:fluplayer/player/view/player_media.dart';
import 'package:fluplayer/player/view/video_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../common/common.dart';
import '../common/common_af_helper.dart';

class PlayerPage extends ConsumerStatefulWidget {
  final List<HomeVideoModel> models;
  final HomeVideoModel model;
  final CommonReportSourceEnum place;
  const PlayerPage({
    super.key,
    required this.models,
    required this.model,
    required this.place,
  });

  @override
  ConsumerState<PlayerPage> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<PlayerPage> with RouteAware {
  VideoPlayerController? _controller;
  final ScrollController _scrollController = ScrollController();
  late HomeVideoModel model;
  bool _isVisible = true;
  Timer? _timer;
  double progress = 0.0;
  bool showedAd = false;
  String? error;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WakelockPlus.toggle(enable: true);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    model = widget.model;
    SchedulerBinding.instance.addPostFrameCallback((e) {
      final haveRecommend =
          widget.place != CommonReportSourceEnum.history &&
          widget.model.isMiddle != null;
      ref
          .read(playProvider.notifier)
          .initList(widget.models, model, haveRecommend);
    });
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context) != null) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WakelockPlus.toggle(enable: false);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.dispose();
    _timer?.cancel();
    _controller?.dispose();
    if (screenPortraitUp == false) {
      screenPortraitUp = true;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    super.dispose();
  }

  @override
  void didPop() {
    commonRef?.read(homeProvider.notifier).updatePosition(model, progress);
    super.didPop();
  }

  void _backReport() async {
    CommonReport.model = model;
    if (model.isMiddle != null) {
      await CommonReport.backEvent(
        CommonReportEnum.commonPlay,
        source: widget.place,
        isMiddle: model.isMiddle,
      );
    } else {
      final res = await CommonReport.backEvent(
        CommonReportEnum.commLocalPlay,
        isMiddle: model.isMiddle,
        source: widget.place,
      );
    }
    if (CommonAfHelper().isDeep == true) {
      await CommonReport.backEvent(
        CommonReportEnum.commUserActive,
        isMiddle: model.isMiddle,
        source: widget.place,
      );
      CommonAfHelper().isDeep = false;
    }
  }

  void _initVideo() async {
    _controller?.dispose();
    _controller = null;
    error = null;
    isLoading = true;
    _isVisible = true;
    setState(() {});
    try {
      if (model.isMiddle == null) {
        _controller = VideoPlayerController.file(File(model.path));
      } else {
        final r = await model.getRealLink();
        _controller = VideoPlayerController.networkUrl(Uri.parse(r));
      }
      await _controller!.initialize();
      ref.read(homeProvider.notifier).updatePosition(model, progress);
      isLoading = false;
      error = null;
      _controller?.addListener(() {
        if (!mounted) return;
        setState(() {});
        if (_controller?.value.isCompleted == true) {
          setState(() {
            _isVisible = true;
          });
          ref.read(playProvider.notifier).nextModel(true);
        }
        if (_controller != null) {
          progress =
              _controller!.value.position.inMilliseconds /
              _controller!.value.duration.inMilliseconds;
        }
      });
      if (model.position > 0 && model.position < 0.9) {
        await _controller!.seekTo(
          Duration(
            milliseconds:
                (model.position * _controller!.value.duration.inMilliseconds)
                    .toInt(),
          ),
        );
      }
      if (showedAd == false) {
        _controller!.play();
      }
      _resetTimer();
      _backReport();
    } catch (e) {
      _controller?.dispose();
      _controller = null;
      setState(() {
        isLoading = false;
        _isVisible = true;
        error = "Failed to load video";
      });
      print("video play err: $e");
    }
  }

  void _resetTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 3), () {
      if (_controller?.value.isPlaying == true) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  void _onUserActivity() {
    setState(() {
      _isVisible = true;
    });
    _resetTimer();
  }

  void _showList() async {
    if (screenPortraitUp) {
      showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        duration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        builder: (e) => AlertPlayList(controller: _scrollController),
      );
    } else {
      showGeneralDialog(
        context: context,
        barrierLabel: "list",
        barrierDismissible: true,
        barrierColor: Colors.black38,
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.height,
                height: double.infinity,
                child: child,
              ),
            ),
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) =>
            AlertPlayList(controller: _scrollController),
      );
    }
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = ref.read(playProvider.notifier).getIdx();
    _scrollController.animateTo(
      (87.0 * idx).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onRotate() async {
    screenPortraitUp = !screenPortraitUp;
    if (screenPortraitUp == false) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    Future.delayed(
      const Duration(milliseconds: 300),
    ).then((e) => setState(() {}));
  }

  void _forward(int tag) async {
    playerForward = tag;
    setState(() {});
    final curr = _controller?.value.position.inSeconds ?? 0;
    final total = _controller?.value.duration.inSeconds ?? 0;
    if (tag == 2) {
      _controller?.seekTo(Duration(seconds: (curr + 10).clamp(0, total)));
    } else {
      _controller?.seekTo(Duration(seconds: (curr - 10).clamp(0, total)));
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    playerForward = 0;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playProvider);
    ref.listen(playProvider, (old, newValue) {
      model = ref.read(playProvider.notifier).getModel();
      _initVideo();
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller != null && _controller?.value.isInitialized == true)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onUserActivity,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: _isVisible,
              child: IgnorePointer(
                ignoring: true,
                child: Container(color: Colors.black.withValues(alpha: 0.35)),
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: VideoTitle(name: model.name, onList: _showList),
          ),
          Visibility(
            visible: _isVisible,
            child: PlayerController(
              controller: _controller,
              onRotate: _onRotate,
              isLast: state.isLast,
              onLast: () {
                ref.read(playProvider.notifier).nextModel(true);
              },
            ),
          ),
          PlayerForwardView(tag: 1, onTap: _forward),
          PlayerForwardView(tag: 2, onTap: _forward),
          const PlayerMediaView(),
          Visibility(
            visible: playerForward > 0,
            child: Center(
              child: Container(
                width: 180,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xff401F00).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/player/${playerForward == 2 ? 'forward_go' : 'forward_back'}.png",
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      playerForward == 2 ? 'Forward 10s' : 'Rewind 10s',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: isLoading,
              child: CupertinoActivityIndicator(color: Colors.white),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: error != null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  error ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
