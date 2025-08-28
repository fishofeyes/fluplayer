import 'package:fluplayer/common/common.dart';
import 'package:flutter/material.dart';

class VideoTitle extends StatelessWidget {
  final String name;
  final Function()? onList;
  const VideoTitle({super.key, required this.name, this.onList});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenPortraitUp ? 30 : 54,
      left: 0,
      right: 0,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.asset("assets/back.webp", width: 24, height: 24),
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
                "assets/icon-list.webp",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
