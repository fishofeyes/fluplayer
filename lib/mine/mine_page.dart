import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/mine/privacy_page.dart';
import 'package:fluplayer/mine/terms_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String version = "1.0.0";
  bool showToast = false;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/bg.webp"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff262D39),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shrinkWrap: true,
                    children: [
                      SettingsTile(
                        title: 'Privacy Policy',
                        onTap: () {
                          commonPush(context, PrivacyPage());
                        },
                      ),
                      SettingsTile(
                        title: 'Terms of Service',
                        onTap: () {
                          commonPush(context, const TermsPage());
                        },
                      ),
                      SettingsTile(
                        title: 'Feedback',
                        onTap: () async {
                          const url = 'mailto://vagfrjg3@outlook.com';
                          await launchUrl(Uri.parse(url));
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'About',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              version,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
