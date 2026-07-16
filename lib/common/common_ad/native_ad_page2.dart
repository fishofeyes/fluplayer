import 'dart:async';
import 'dart:math';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdPage2 extends StatefulWidget {
  final NativeAd? ad;
  final NativeAd? ad2;
  const NativeAdPage2({super.key, required this.ad, this.ad2});

  @override
  State<NativeAdPage2> createState() => _NativeAdPageState();
}

class _NativeAdPageState extends State<NativeAdPage2>
    with AutomaticKeepAliveClientMixin {
  bool mayClickAd = false;
  StreamSubscription<bool>? cancel;
  final rad = Random();
  bool isShowTop = true;
  @override
  void initState() {
    super.initState();
    if (widget.ad2 != null) {
      mayClickAd = rad.nextDouble() < admobHelper.closeAdRate;
      isShowTop = rad.nextBool();
    } else {
      mayClickAd = rad.nextDouble() < admobHelper.playVideoClickAdRate;
    }
    cancel = admobHelper.closeNativeAdController.stream.listen((e) {
      if (mounted) {
        setState(() {
          mayClickAd = false;
        });
      }
    });
  }

  @override
  void dispose() {
    cancel?.cancel();
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
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 25,
          runSpacing: 25,
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
                      : Container(),
                ),
                Positioned(
                  child: Visibility(
                    visible: isShowTop,
                    child: mayClickAd
                        ? IgnorePointer(
                            ignoring: true,
                            child: Container(
                              color: Colors.black45,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              color: Colors.black45,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if (widget.ad2 != null)
              Stack(
                children: [
                  Container(
                    width: adWidth,
                    height: adWidth,
                    alignment: Alignment.bottomCenter,
                    child: widget.ad2 != null
                        ? AdWidget(
                            ad: widget.ad2!,
                            key: ValueKey(widget.ad2!.adUnitId),
                          )
                        : Container(),
                  ),
                  Positioned(
                    child: Visibility(
                      visible: isShowTop == false,
                      child: mayClickAd
                          ? IgnorePointer(
                              ignoring: true,
                              child: Container(
                                color: Colors.black45,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                color: Colors.black45,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
