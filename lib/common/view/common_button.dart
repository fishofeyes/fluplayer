import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final double? width;
  final double? height;
  final TextStyle? style;
  const CommonButton({
    super.key,
    this.onTap,
    required this.title,
    this.width,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xffCDFF45),
        ),
        child: Text(
          title,
          style:
              style ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
