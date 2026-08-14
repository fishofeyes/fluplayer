import 'package:flutter/material.dart';
import 'package:niuma_player/niuma_player.dart';
/// A scrubber to control [VideoPlayerController]s
class NiumaVideoScrubber extends StatefulWidget {
  /// Create a [VideoScrubber] handler with the given [child].
  ///
  /// [controller] is the [VideoPlayerController] that will be controlled by
  /// this scrubber.
  const NiumaVideoScrubber({super.key, required this.child, required this.controller});

  /// The widget that will be displayed inside the gesture detector.
  final Widget child;

  /// The [VideoPlayerController] that will be controlled by this scrubber.
  final NiumaPlayerController controller;

  @override
  State<NiumaVideoScrubber> createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<NiumaVideoScrubber> {
  bool _controllerWasPlaying = false;

  NiumaPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final box = context.findRenderObject()! as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative.clamp(0, 1.0);
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying && controller.value.position != controller.value.duration) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}