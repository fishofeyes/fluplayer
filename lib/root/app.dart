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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.tightFor(
            width: 66,
            height: 66,
          ), // 自定义尺寸
          // 或复用标准约束：
          extendedSizeConstraints: BoxConstraints(
            minWidth: 80,
          ), // 扩展型 FAB 宽度[6](@ref)
        ),
      ),
      home: const RootPage(),
      navigatorObservers: [routeObserver],
      builder: EasyLoading.init(),
    );
  }
}
