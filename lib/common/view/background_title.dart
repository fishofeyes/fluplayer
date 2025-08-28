import 'package:flutter/material.dart';

class BackgroundTitleView extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const BackgroundTitleView({super.key, required this.title, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xff2EE1F9).withOpacity(0), Color(0xff2758FD)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
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
              ),
        ),
      ],
    );
  }
}
