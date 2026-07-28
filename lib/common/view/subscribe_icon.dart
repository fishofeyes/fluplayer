import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/vip/vip_page.dart';
import 'package:flutter/material.dart';

class SubscribeIcon extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String source;
  const SubscribeIcon({
    super.key,
    required this.source,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => commonPush(context, VipPage(isAuto: false, source: source)),
      child: Padding(
        padding: padding,
        child: Align(
          alignment: Alignment.centerRight,
          child: Image.asset("assets/pro_icon.png", height: 22),
        ),
      ),
    );
  }
}
