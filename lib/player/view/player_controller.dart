import 'package:fluplayer/common/common_format.dart';
import 'package:fluplayer/player/view/player_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerController extends StatelessWidget {
  final VideoPlayerController? controller;
  final Function()? onRotate;
  final bool isLast;
  final Function()? onLast;
  const PlayerController({
    super.key,
    this.controller,
    this.onRotate,
    this.isLast = false,
    this.onLast,
  });

  @override
  Widget build(BuildContext context) {
    if (controller == null) return const SizedBox();
    final position = controller!.value.position;
    final total = controller!.value.duration;
    final bottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 12,
      bottom: bottom == 0 ? 20 : 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller?.value.isPlaying == true) {
                      controller?.pause();
                    } else {
                      controller?.play();
                    }
                  },
                  child: Image.asset(
                    "assets/player/${controller?.value.isPlaying == true ? 'play' : 'supend'}.png",
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (isLast) return;
                    onLast?.call();
                  },
                  child: Opacity(
                    opacity: isLast ? 0.5 : 1,
                    child: Image.asset(
                      "assets/player/next.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: PlayerProgressBar(
                    controller!,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    colors: VideoProgressColors(
                      backgroundColor: Color(0xffbbbbbb),
                      playedColor: Color(0xffED9647),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${position.inSeconds.hhMM()}/${total.inSeconds.hhMM()}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: onRotate,
                  behavior: HitTestBehavior.translucent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Image.asset(
                      "assets/player/full.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
