import 'package:firebase_core/firebase_core.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/root/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpHelper.log();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CommonHive.init();
  await admobHelper.init();

  runApp(ProviderScope(child: RootApp()));
}
