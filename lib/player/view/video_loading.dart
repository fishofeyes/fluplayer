import 'package:fluplayer/common/common.dart';
import 'package:flutter/material.dart';

class VideoLoading extends StatelessWidget {
  const VideoLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final vip = commAppVip;
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xffed9647),
                backgroundColor: Color(0xffed9647).withValues(alpha: 0.3),
                strokeWidth: 1.5,
              ),
            ),
            Visibility(
              visible: !vip,
              replacement: SizedBox(height: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text("Current line congestion... 78kb/s"),
              ),
            ),
            InkWell(
              child: Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  Image.asset("assets/hat_bg.png", height: 31),
                  Positioned(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: vip
                          ? [Text("Exclusive acceleration line")]
                          : [
                              Image.asset(
                                "assets/hat.png",
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(width: 4),
                              Text("Exclusive acceleration line"),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
