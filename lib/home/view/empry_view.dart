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
        Image.asset("assets/no_video_content.webp", width: 150, height: 150),
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
        CommonButton(
          title: "Import",
          onTap: () async {
            commonRef?.read(tabIndexProvider.notifier).state = 2;
          },
        ),
      ],
    );
  }
}
