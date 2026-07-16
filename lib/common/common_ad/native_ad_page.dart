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

class _NativeAdPageState extends State<NativeAdPage>
    with AutomaticKeepAliveClientMixin {
  Timer? _timer;
  int total = 10;
  bool mayClickAd = false;
  StreamSubscription<bool>? cancel;
  final rad = Random();
  bool isShowTop = true;
  @override
  void initState() {
    super.initState();
    total = admobHelper.nativeShowTime;
    if (widget.ad2 != null) {
      mayClickAd = rad.nextDouble() < admobHelper.closeAdRate;
      isShowTop = rad.nextBool();
    } else {
      mayClickAd = rad.nextDouble() < admobHelper.nativeMayClick;
    }
    _beginTimer();
    cancel = admobHelper.closeNativeAdController.stream.listen((e) {
      if (mounted) {
        setState(() {
          mayClickAd = false;
        });
      }
    });
  }

  void _beginTimer() {
    if (total != 0) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (e) {
        if (total == 0) {
          _timer?.cancel();
        } else {
          setState(() {
            total -= 1;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    cancel?.cancel();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double adWidth = 300;
    if (!screenPortraitUp) adWidth = 250;
    return Scaffold(
      backgroundColor: Colors.black,
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
                  child: AdWidget(
                    ad: widget.ad,
                    key: ValueKey(widget.ad.adUnitId),
                  ),
                ),
                Positioned(
                  child: Visibility(
                    visible: total == 0 && isShowTop,
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
                Positioned(
                  right: 4,
                  top: 4,
                  child: Visibility(
                    visible: total != 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black45,
                      ),
                      child: Text(
                        "$total",
                        style: const TextStyle(
                          fontSize: 14,
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
                    child: AdWidget(
                      ad: widget.ad2!,
                      key: ValueKey(widget.ad2!.adUnitId),
                    ),
                  ),
                  Positioned(
                    child: Visibility(
                      visible: total == 0 && isShowTop == false,
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
