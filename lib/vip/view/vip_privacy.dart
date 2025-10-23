import 'package:fluplayer/mine/privacy_page.dart';
import 'package:fluplayer/mine/terms_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';

class VipPrivacy extends StatelessWidget {
  const VipPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Terms of Service",
              recognizer: TapGestureRecognizer()
                ..onTap = () => commonPush(context, PrivacyPage()),
            ),
            TextSpan(text: " · "),
            TextSpan(
              text: "Privacy Policy",
              recognizer: TapGestureRecognizer()
                ..onTap = () => commonPush(context, const TermsPage()),
            ),
          ],
        ),
        style: TextStyle(
          fontSize: 10,
          color: Colors.white.withValues(alpha: 0.45),
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
