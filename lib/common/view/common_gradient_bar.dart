import 'package:flutter/material.dart';

class CommonGradientBar extends StatelessWidget {
  final double progress; // 当前进度值，0.0 ~ 1.0
  final List<Color> gradientColors; // 渐变颜色列表
  final double height; // 进度条高度
  final Color? bgColor;

  const CommonGradientBar({
    super.key,
    required this.progress,
    required this.gradientColors,
    this.height = 4.0,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: bgColor ?? Colors.grey[300], // 背景颜色
      ),
      child: CustomPaint(
        painter: _GradientProgressPainter(
          progress: progress,
          gradientColors: gradientColors,
        ),
      ),
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;

  _GradientProgressPainter({
    required this.progress,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    Rect backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, Radius.circular(size.height / 2)),
      backgroundPaint,
    );

    // 绘制渐变进度条
    if (progress > 0) {
      Paint progressPaint = Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width * progress, size.height))
        ..style = PaintingStyle.fill;

      Rect progressRect = Rect.fromLTWH(
        0,
        0,
        size.width * progress,
        size.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(progressRect, Radius.circular(size.height / 2)),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 始终重绘
  }
}
