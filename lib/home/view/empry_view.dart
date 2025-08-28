import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/view/common_button.dart';
import 'package:fluplayer/root/provider/provider.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String? title;
  final double top;
  const EmptyView({super.key, this.title, this.top = 90});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: top, width: double.infinity),
        Image.asset("assets/home/empty.png", width: 156, height: 156),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 16.0),
          child: Text(
            title ?? 'Import your Videos',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            commonRef?.read(tabIndexProvider.notifier).state = 2;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/home/import_bg.png", height: 48),
              Text(
                "Import",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 22 / 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
