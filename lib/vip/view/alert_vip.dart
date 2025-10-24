import 'package:fluplayer/vip/provider/provider.dart';
import 'package:fluplayer/vip/provider/vip.dart';
import 'package:fluplayer/vip/view/vip_buy.dart';
import 'package:fluplayer/vip/view/vip_privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertVip extends ConsumerStatefulWidget {
  const AlertVip({super.key});

  @override
  ConsumerState<AlertVip> createState() => _AlertVipState();
}

class _AlertVipState extends ConsumerState<AlertVip> {
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
                      onTap: () => ref.read(vipProvider.notifier).buyVip(),
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
