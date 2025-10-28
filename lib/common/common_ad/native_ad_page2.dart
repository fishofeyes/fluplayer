import 'dart:async';
import 'dart:math';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdPage2 extends StatefulWidget {
  final NativeAd? ad;
  const NativeAdPage2({super.key, required this.ad});

  @override
  State<NativeAdPage2> createState() => _NativeAdPageState();
}

class _NativeAdPageState extends State<NativeAdPage2>
    with AutomaticKeepAliveClientMixin {
  bool mayClickAd = false;
  @override
  void initState() {
    super.initState();
    mayClickAd = Random().nextDouble() < admobHelper.nativeMayClick;
    _initClose();
  }

  void _initClose() {
    nativeAdPlayVideoCloseAction = () {
      if (mounted) {
        setState(() {
          mayClickAd = false;
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double adWidth = 300;
    if (!screenPortraitUp) adWidth = 250;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: adWidth,
                  height: adWidth,
                  alignment: Alignment.bottomCenter,
                  child: widget.ad != null
                      ? AdWidget(
                          ad: widget.ad!,
                          key: ValueKey(widget.ad!.adUnitId),
                        )
                      : Container(color: Colors.red),
                ),
                Positioned(
                  child: mayClickAd
                      ? IgnorePointer(
                          ignoring: true,
                          child: Container(
                            color: Colors.black45,
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        )
                      : InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            color: Colors.black45,
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
