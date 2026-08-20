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
      apiKey: "AIzaSyAyV96So8i4mPw30wRwZWlanrlrjj_YToE",
      appId: "1:1026087443559:ios:d38df4bcdb818a1786c8c2",
      messagingSenderId: "1026087443559",
      projectId: "fluplayer-ios",
    ),
  );
  await CommonHive.init();
  await admobHelper.init();

  runApp(ProviderScope(child: RootApp()));
}
