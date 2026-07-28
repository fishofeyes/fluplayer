import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/view/subscribe_icon.dart';
import 'package:flutter/material.dart';

class VideoTitle extends StatelessWidget {
  final String name;
  const VideoTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenPortraitUp ? 22 : 12,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Row(
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
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 16),
              child: SubscribeIcon(source: "cfyVVGNRM"),
            ),
          ],
        ),
      ),
    );
  }
}
