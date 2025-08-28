import 'package:fluplayer/common/view/common_gradient_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/provider.dart';

class PlayerMediaView extends ConsumerWidget {
  const PlayerMediaView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(mediaStatusProvider);
    final progress = ref.watch(mediaProvider);
    if (state == 0) return const SizedBox();
    return Positioned(
      left: 0,
      right: 0,
      top: 120,
      child: Center(
        child: Container(
          width: 180,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xff401F00).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(
                "assets/player/${state == 1 ? 'volume' : 'sun'}.png",
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CommonProgressBar(
                  progress: progress,
                  bgColor: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
