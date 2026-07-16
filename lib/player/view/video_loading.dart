import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/player/provider/provider.dart';
import 'package:fluplayer/vip/provider/provider.dart';
import 'package:fluplayer/vip/vip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoLoading extends ConsumerWidget {
  const VideoLoading({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final speed = ref.watch(mediaSpeedProvider).value ?? 0;
    final vip = globalOpenVip;
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
                child: Text("Current line congestion... ${speed}kb/s"),
              ),
            ),
            InkWell(
              onTap: () {
                if (vip) return;
                // commonPush(context, VipPage(isAuto: false, source: "ZpkXtfH"));
              },
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
