import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? style;
  const CustomGradientButton({
    super.key,
    this.onTap,
    required this.title,
    this.width,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 132,
        height: height ?? 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff2DE2F9), Color(0xff2558FD)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style:
              style ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
