import 'package:flutter/material.dart';

class BackgroundTitleView extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const BackgroundTitleView({super.key, required this.title, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: 0,
          child: Image.asset(
            "assets/home/title_bg.png",
            fit: BoxFit.contain,
            height: 12,
            width: 42,
          ),
        ),
        Text(
          title,
          style:
              textStyle ??
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1,
              ),
        ),
      ],
    );
  }
}
