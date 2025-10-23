import 'package:fluplayer/vip/model/vip_model.dart';
import 'package:fluplayer/vip/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VipBuy extends ConsumerWidget {
  final VipModel model;
  final String choose;
  final bool isAlert;
  const VipBuy({
    super.key,
    required this.model,
    required this.choose,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final isChoose = choose == model.id;
    return GestureDetector(
      onTap: () => ref.read(vipChooseProvider.notifier).state = model.id,
      child: Stack(
        children: [
          Container(
            height: isAlert ? 60 : 64,
            margin: EdgeInsets.only(top: isAlert ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isChoose ? Color(0xffED9647) : Colors.transparent,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  model.desc,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isChoose ? Color(0xffED9647) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: isAlert ? 8 : 12,
            child: Visibility(
              visible: model.tag,
              child: Image.asset("assets/vip/vipHot.png", height: 18),
            ),
          ),
        ],
      ),
    );
  }
}
