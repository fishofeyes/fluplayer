import 'package:fluplayer/common/view/common_gradient_bar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Size _gSize = Size.zero;

class PlayerProgressBar extends StatefulWidget {
  const PlayerProgressBar(
    this.controller, {
    super.key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  });

  /// The [VideoPlayerController] that actually associates a video with this
  /// widget.
  final VideoPlayerController controller;

  /// The default colors used throughout the indicator.
  ///
  /// See [VideoProgressColors] for default values.
  final VideoProgressColors colors;

  /// When true, the widget will detect touch input and try to seek the video
  /// accordingly. The widget ignores such input when false.
  ///
  /// Defaults to false.
  final bool allowScrubbing;

  /// This allows for visual padding around the progress indicator that can
  /// still detect gestures via [allowScrubbing].
  ///
  /// Defaults to `top: 5.0`.
  final EdgeInsets padding;

  @override
  State<PlayerProgressBar> createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<PlayerProgressBar> {
  _VideoProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      final box = context.findRenderObject() as RenderBox?;
      if (box?.size != null) {
        _gSize = box!.size;
      }
      final size = _gSize;
      final progress =
          controller.value.position.inMilliseconds /
          controller.value.duration.inMilliseconds.toDouble();
      double offset =
          (size.width - 12 - 12 - 12) * (progress.isNaN ? 0 : progress);

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: maxBuffering / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
            backgroundColor: colors.backgroundColor,
          ),
          CommonGradientBar(
            progress: position / duration,
            gradientColors: const [Color(0xff2CE1F9), Color(0xff2335FF)],
          ),
          Positioned(
            left: offset,
            child: Container(
              width: 12,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return VideoScrubber(
        controller: controller,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}
