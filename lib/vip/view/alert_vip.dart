import 'package:fluplayer/vip/provider/provider.dart';
import 'package:fluplayer/vip/provider/vip.dart';
import 'package:fluplayer/vip/view/vip_buy.dart';
import 'package:fluplayer/vip/view/vip_privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/common_enum.dart';
import '../../common/common_report/common_report.dart';

class AlertVip extends ConsumerStatefulWidget {
  final String source;
  const AlertVip({super.key, required this.source});

  @override
  ConsumerState<AlertVip> createState() => _AlertVipState();
}

class _AlertVipState extends ConsumerState<AlertVip> {
  Map<String, dynamic>? data;
  @override
  void initState() {
    super.initState();
    isInVipAlertPage = true;
    SchedulerBinding.instance.addPostFrameCallback((e) {
      ref.read(vipChooseProvider.notifier).state = globalDefaultVipId;
    });
    data = {"gNAuA_vip": "xBHdW", "fyzk": "vvbWKArjy", "bqaKMIx": widget.source};
    CommonReport.eventThings(ThingEnum.premiug8amExpose, data: data);
  }

  @override
  void dispose() {
    isInVipAlertPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final choose = ref.watch(vipChooseProvider);
    final state = ref.watch(vipProvider);
    ref.listen(vipProvider, (old, newv) {
      if (newv.isVip) {
        Navigator.pop(context);
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Color(0xff0E0700))),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 450,
                child: Image.asset("assets/vip/vipBg.png", fit: BoxFit.fill),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/vip/bigVip.png", height: 74),
                    SizedBox(height: 12),
                    ...state.models
                        .take(2)
                        .map(
                          (e) =>
                              VipBuy(model: e, choose: choose, isAlert: true),
                        ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => ref.read(vipProvider.notifier).buyVip(data),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/vip/vipBtnBg.png",
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(child: VipPrivacy()),
                  ],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Image.asset(
              "assets/vip/closeVip.png",
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}
