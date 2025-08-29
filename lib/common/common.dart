import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/model/home.dart';

WidgetRef? commonRef;
BuildContext? commonContext;
bool screenPortraitUp = true;
int playerForward = 0;
double playerBrightness = 0;
double playerVolume = 0;
RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

enum SharedStoreKey { recommendUserId, isMiddle, userEmail, userTags }

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
