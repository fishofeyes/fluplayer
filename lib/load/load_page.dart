import 'dart:async';

import 'package:fluplayer/common/common.dart';
import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
import 'package:fluplayer/common/common_ad/base_ad.dart';
import 'package:fluplayer/common/common_report/common_event.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/root/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/common_enum.dart';

class LoadPage extends ConsumerStatefulWidget {
  const LoadPage({super.key});

  @override
  ConsumerState<LoadPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<LoadPage> {
  int _launchTime = 7;
  double _width = 0;
  @override
  void initState() {
    super.initState();
    commonContext = context;
    commonRef = ref;
    _ump();
  }

  void _ump() async {
    final complete = Completer();
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        final r = await ConsentInformation.instance.isConsentFormAvailable();
        if (r) {
          ConsentForm.loadAndShowConsentFormIfRequired((formError) async {
            debugPrint("consent error: ${formError?.message}");
            final status = await ConsentInformation.instance.getConsentStatus();
            final config = RequestConfiguration(
              tagForUnderAgeOfConsent: status == ConsentStatus.required
                  ? TagForUnderAgeOfConsent.yes
                  : null,
            );
            MobileAds.instance.updateRequestConfiguration(config);
            complete.complete();
          });
        } else {
          complete.complete();
        }
      },
      (FormError error) {
        // Called when there's an error updating consent information.
        debugPrint("consent error: ${error.message}");
        complete.complete(error);
      },
    );
    await complete.future;
    _initLoad();
  }

  void _initLoad() async {
    final sp = await SharedPreferences.getInstance();
    admobHelper.loadAll();
    _launchTime = admobHelper.launchTime;
    _width = 200;
    setState(() {});
    final time = admobHelper.launchTime - 1;
    // ref.read(noAdProviderProvider.notifier).restore();
    await Future.delayed(Duration(seconds: time.clamp(0, time)));
    final canShow = sp.getBool(SharedStoreKey.firstInstall.name);
    if (canShow != null) {
      CommonEvent.showAd(AdPositionEnum.open, MySessionValue.copen);
    }
    sp.setBool(SharedStoreKey.firstInstall.name, true);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (t) => const RootPage()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   await admobManager2.loadOpenAd(value: MySessionValue.copen);
      //   admobManager2.showOpenAd(value: MySessionValue.copen);
      //   return;
      // }),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xff3E2309), Colors.black],
            end: Alignment.topCenter,
            begin: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.27),
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(28),
              child: Image.asset("assets/logo.png", width: 56, height: 56),
            ),
            const SizedBox(height: 16),
            const Text(
              "FluPlayer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xffED9647),
                height: 18 / 16,
              ),
            ),
            const Spacer(),
            SafeArea(
              child: Column(
                children: [
                  const Text(
                    "Please loading...",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 4,
                        width: 197,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.23),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: _launchTime),
                        height: 4,
                        width: _width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.12),
          ],
        ),
      ),
    );
  }
}
