import 'package:fluplayer/choose/choose_media.dart';
import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/home/home_page.dart';
import 'package:fluplayer/mine/mine_page.dart';
import 'package:fluplayer/root/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  int index = 0;
  final data = [
    {"label": "home", "icon": "home", "select": "home_in", "index": 0},
    {"label": "Setting", "icon": "set", "select": "set_in", "index": 1},
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tabIndexProvider);
    ref.listen(tabIndexProvider, (old, newvalue) {
      _pageController.jumpToPage(newvalue);
    });
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [HomePage(), MinePage(), ChooseMediaPage()],
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(tabIndexProvider.notifier).state = 2;
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Image.asset("assets/add.webp", width: 66, height: 66),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 2,
        elevation: 0,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xff323B1E), const Color(0xff131412)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(bottom: bottom == 0 ? 0 : 12),
          child: Row(
            children: [
              ...data.map((e) {
                final index = e["index"]! as int;
                final selected = index == state;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      ref.read(tabIndexProvider.notifier).state = index;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/${e[selected ? "select" : "icon"]}.png",
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          "${e['label']}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(
                              alpha: selected ? 1.0 : 0.5,
                            ),
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
