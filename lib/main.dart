import 'package:fluplayer/common/common_hive.dart';
import 'package:fluplayer/root/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CommonHive.init();
  runApp(ProviderScope(child: RootApp()));
}
