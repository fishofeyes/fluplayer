import 'package:fluplayer/common/view/common_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HavePermission extends StatelessWidget {
  const HavePermission({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xff323B1E), const Color(0xff131412)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsetsDirectional.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.translucent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Currently, there is no access to your photo album. Authorization is required to access it.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CommonButton(
                  title: "Open setting",
                  height: 56,
                  onTap: () {
                    openAppSettings();
                  },
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }
}
