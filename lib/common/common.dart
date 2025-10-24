import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const isProd = false;
WidgetRef? commonRef;
BuildContext? commonContext;
bool screenPortraitUp = true;
bool commAppVip = false;
int playerForward = 0;
double playerBrightness = 0;
double playerVolume = 0;
Function()? nativeAdCloseAction;
Function(bool isPage)? autoJumpVip;
RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

enum SharedStoreKey {
  recommendUserId,
  isMiddle,
  userId,
  userEmail,
  userTags,
  firstInstall,
  newUser,
  userDistinctId,
  isInstall,
  firstTimeOpen,
}

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
