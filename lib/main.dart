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
  PaintingBinding.instance.imageCache.maximumSize = 500;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20;
  await CommonApp.init();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDmlKMnRHm8ndMxh-5J2Zlxru2STf41b1M", appId: "1:1094189800146:android:b4899f316c9c23804ceb0b", projectId: "fluplayer---and", messagingSenderId: '1094189800146'));
  await CommonHive.init();
  await admobHelper.init();

  runApp(ProviderScope(child: RootApp()));
}
