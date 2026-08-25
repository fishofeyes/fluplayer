import 'package:firebase_core/firebase_core.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/root/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/common_app.dart';
import 'common/common_report/common_report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CommonReport.uniqueId();
  HttpHelper.log();
  await CommonApp.init();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDKRVQj2V3z99ZrCuo9IDkte7KeL-GvKO4",
      appId: "1:581032080540:ios:eeb3f8323f86af67f5e959",
      messagingSenderId: "581032080540",
      projectId: "fluplayer-ios-6deb5",
    ),
  );
  await CommonHive.init();
  await admobHelper.init();

  runApp(ProviderScope(child: RootApp()));
}
