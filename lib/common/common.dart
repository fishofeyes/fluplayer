import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

WidgetRef? commonRef;
BuildContext? commonContext;
bool screenPortraitUp = true;
int playerForward = 0; // 初始音量值// 0: 默认， 1: 后退， 2， 前进
double playerBrightness = 0; // 初始音量值// 0: 默认， 1: 后退， 2， 前进
double playerVolume = 0; // 初始音量值// 0: 默认， 1: 后退， 2， 前进

Future<dynamic> commonPush(BuildContext context, Widget page) {
  return Navigator.push(context, CupertinoPageRoute(builder: (c) => page));
}

Future<dynamic> commonShowBottomSheet(
  BuildContext context,
  Widget child,
) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => child,
  );
}

Future<dynamic> commonShowDialog(BuildContext context, Widget child) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => child,
  );
}
