import 'package:fluplayer/common/common.dart';
import 'package:flutter/material.dart';

class VideoTitle extends StatelessWidget {
  final String name;
  final Function()? onList;
  const VideoTitle({super.key, required this.name, this.onList});

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
            GestureDetector(
              onTap: onList,
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset(
                  "assets/player/list.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
