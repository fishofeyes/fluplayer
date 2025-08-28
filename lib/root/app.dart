import 'package:fluplayer/root/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../common/common.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xff141414),
        useMaterial3: true,
      ),
      home: const RootPage(),
      navigatorObservers: [routeObserver],
      builder: EasyLoading.init(),
    );
  }
}
