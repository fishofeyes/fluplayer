import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:fluplayer/choose/choose_media.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/home/home_page.dart';
import 'package:fluplayer/home/model/home.dart';
import 'package:fluplayer/home/provider/home.dart';
import 'package:fluplayer/mine/mine_page.dart';
import 'package:fluplayer/root/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/common_enum.dart';
import '../common/common_report/common_event.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage>
    with WidgetsBindingObserver {
  int _index = 0;
  final data = [
    {"label": "home", "icon": "home", "select": "home_selected", "index": 0},
    {
      "label": "Setting",
      "icon": "setting",
      "select": "setting_selected",
      "index": 1,
    },
  ];
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    commonRef = ref;
    commonContext = context;
    WidgetsBinding.instance.addObserver(this);
    _track();
  }

  void _track() async {
    await Future.delayed(const Duration(seconds: 5));
    await AppTrackingTransparency.requestTrackingAuthorization();
    await Future.delayed(const Duration(seconds: 5));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLife(state);
  }

  void _appLife(AppLifecycleState appState) async {
    print("app life state = $appState");
    if (appState == AppLifecycleState.resumed) {
      CommonEvent.loadAd(AdPositionEnum.open, MySessionValue.hopen);
      final sp = await SharedPreferences.getInstance();
      final canShow = sp.getBool(SharedStoreKey.firstInstall.name);
      if (canShow != null) {
        CommonEvent.showAd(AdPositionEnum.open, MySessionValue.hopen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tabIndexProvider, (old, newvalue) {
      _index = newvalue;
      _pageController.jumpToPage(newvalue);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [HomePage(), MinePage(), ChooseMediaPage()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(tabIndexProvider.notifier).state = 2;
          await AppTrackingTransparency.requestTrackingAuthorization();
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(33),
          child: Image.asset("assets/home/add.png", width: 66, height: 66),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 0,
        height: 64,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        // shape: CircularNotchedRectangle(),
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        ),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xff3B2C1E), const Color(0xff141312)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            children: [
              ...data.map((e) {
                final index = e["index"]! as int;
                final selected = index == _index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = index;
                      setState(() {
                        _index = index;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/home/${e[selected ? "select" : "icon"]}.png",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${e['label']}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? Color(0xffED9647)
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
