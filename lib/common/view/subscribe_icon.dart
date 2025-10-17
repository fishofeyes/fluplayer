import 'package:flutter/material.dart';

class SubscribeIcon extends StatelessWidget {
  const SubscribeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Image.asset("assets/pro_icon.png", height: 22),
    );
  }
}
