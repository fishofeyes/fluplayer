import 'dart:async';
import 'dart:math';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdPage extends StatefulWidget {
  final NativeAd ad;
  final NativeAd? ad2;
  const NativeAdPage({super.key, required this.ad, this.ad2});

  @override
  State<NativeAdPage> createState() => _NativeAdPageState();
}

class _NativeAdPageState extends State<NativeAdPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double adWidth = 300;
    if (!screenPortraitUp) adWidth = 250;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: adWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 25,
                runSpacing: 25,
                children: [
                  Container(
                    width: adWidth,
                    height: adWidth,
                    alignment: Alignment.bottomCenter,
                    child: AdWidget(
                      ad: widget.ad,
                      key: ValueKey(widget.ad.adUnitId),
                    ),
                  ),
                  if (widget.ad2 != null)
                    Container(
                      width: adWidth,
                      height: adWidth,
                      alignment: Alignment.bottomCenter,
                      child: AdWidget(
                        ad: widget.ad2!,
                        key: ValueKey(widget.ad2!.adUnitId),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
