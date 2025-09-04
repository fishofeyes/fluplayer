import 'dart:convert';
import 'package:fluplayer/common/common_val.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/home/bg.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 58),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.asset(
                    "assets/player/back.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  "Terms of Service",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 12,
                    bottom: 60,
                  ),
                  child: Text(
                    utf8.decode(
                      base64Decode(commTerm.replaceAll("MxjgypeBUX", "")),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
