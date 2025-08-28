import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../../common/common.dart';
import '../provider/provider.dart';

class PlayerForwardView extends StatelessWidget {
  final int tag;
  final Function(int tag)? onTap;
  const PlayerForwardView({super.key, required this.tag, this.onTap});

  // 更新屏幕亮度
  void _updateBrightness(double delta) async {
    playerBrightness += delta;
    playerBrightness = playerBrightness.clamp(0.0, 1.0);
    commonRef?.read(mediaProvider.notifier).state = playerBrightness;
    commonRef?.read(mediaStatusProvider.notifier).state = 2;
    await ScreenBrightness.instance.setSystemScreenBrightness(playerBrightness);
  }

  // 更新设备音量
  void _updateVolume(double delta) async {
    playerVolume += delta;
    playerVolume = playerVolume.clamp(0.0, 1.0); // 限制范围在 0 到 1
    commonRef?.read(mediaProvider.notifier).state = playerVolume;
    commonRef?.read(mediaStatusProvider.notifier).state = 1;
    await FlutterVolumeController.setVolume(playerVolume);
  }

  void _dismiss() async {
    await Future.delayed(const Duration(milliseconds: 500));
    commonRef?.read(mediaStatusProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return tag == 1
        ? Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: size.width * 0.4,
            child: GestureDetector(
              onDoubleTap: () => onTap?.call(tag),
              onVerticalDragUpdate: (details) {
                _updateBrightness(-details.delta.dy / 400);
              },
              onVerticalDragCancel: _dismiss,
              onVerticalDragEnd: (e) => _dismiss(),
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          )
        : Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: size.width * 0.4,
            child: GestureDetector(
              onDoubleTap: () => onTap?.call(tag),
              onVerticalDragUpdate: (details) {
                _updateVolume(-details.delta.dy / 400);
              },
              onVerticalDragCancel: _dismiss,
              onVerticalDragEnd: (e) => _dismiss(),
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(),
            ),
          );
  }
}
