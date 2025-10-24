import 'package:flutter/material.dart';

class VipPot extends StatelessWidget {
  final String assetName;
  final String title;
  const VipPot({super.key, required this.assetName, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(0xffffc682).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(assetName, fit: BoxFit.fill),
        ),
        SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
