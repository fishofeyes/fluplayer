import 'package:flutter/material.dart';

class ChooseAction extends StatelessWidget {
  final String title;
  final String img;
  final Function()? onTap;
  const ChooseAction({
    super.key,
    required this.title,
    required this.img,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff453526).withValues(alpha: 0.46),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 188,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/home/$img.png", width: 48, height: 48),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
