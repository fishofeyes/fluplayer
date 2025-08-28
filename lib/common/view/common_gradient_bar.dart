import 'package:flutter/material.dart';

class CommonProgressBar extends StatelessWidget {
  final double progress; // 当前进度值，0.0 ~ 1.0
  final double height; // 进度条高度
  final Color? bgColor;

  const CommonProgressBar({
    super.key,
    required this.progress,
    this.height = 4.0,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          backgroundColor: bgColor,
          minHeight: height,
          value: progress,
          color: Color(0xffED9647),
        ),
      ),
    );
  }
}
