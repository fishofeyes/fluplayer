// import 'package:fluplayer/common/common.dart';
// import 'package:fluplayer/common/common_ad/admob_ad_helper.dart';
// import 'package:fluplayer/common/common_enum.dart';
// import 'package:fluplayer/common/common_report/common_report.dart';
// import 'package:fluplayer/common/view/background_title.dart';
// import 'package:collection/collection.dart';
// import 'package:fluplayer/vip/provider/provider.dart';
// import 'package:fluplayer/vip/provider/vip.dart';
// import 'package:fluplayer/vip/view/alert_vip.dart';
// import 'package:fluplayer/vip/view/vip_buy.dart';
// import 'package:fluplayer/vip/view/vip_pot.dart';
// import 'package:fluplayer/vip/view/vip_privacy.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../common/common_report/common_event.dart';
//
// class VipPage extends ConsumerStatefulWidget {
//   final bool isAuto;
//   final String source;
//   const VipPage({super.key, required this.isAuto, required this.source});
//
//   @override
//   ConsumerState<VipPage> createState() => _VipPageState();
// }
//
// class _VipPageState extends ConsumerState<VipPage> {
//   Map<String, dynamic>? data;
//   @override
//   void initState() {
//     super.initState();
//     data = {
//       "gNAuA": "bBtr",
//       "fyzk": widget.isAuto ? "vvbWKArjy" : "YvrXCXszRH",
//       "bqaKMIx": widget.source,
//     };
//     CommonEvent.changePlayStatus(false);
//     SchedulerBinding.instance.addPostFrameCallback((e) {
//       admobHelper.updateVipModels();
//       ref.read(vipChooseProvider.notifier).state = globalDefaultVipId;
//     });
//     EasyLoading.instance.userInteractions = false;
//     isInVipPage = true;
//     CommonReport.eventThings(ThingEnum.premiug8amExpose, data: data);
//   }
//
//   @override
//   void dispose() {
//     isInVipPage = false;
//     EasyLoading.instance.userInteractions = true;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(vipProvider);
//     final choose = ref.watch(vipChooseProvider);
//     final vips = state.models;
//     final bool isVip = state.isVip;
//     final gd = vips.firstWhereOrNull((e) => e.id == choose);
//     final desc = isVip
//         ? state.desc
//         : vipPriceMap[gd?.type ?? 3]?.replaceAll("##", gd?.desc ?? "");
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: 450,
//             child: Image.asset("assets/vip/vipBg.png", fit: BoxFit.fill),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16, right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         behavior: HitTestBehavior.translucent,
//                         child: Image.asset(
//                           "assets/player/back.png",
//                           width: 24,
//                           height: 24,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (isVip) return;
//                           ref.read(vipProvider.notifier).redeem(true);
//                         },
//                         child: Container(
//                           width: 83,
//                           height: 26,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(4),
//                             color: Color(0xff482E16).withValues(alpha: 0.5),
//                           ),
//                           child: Text(
//                             "Redeem",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Color(0xffed9647),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   IgnorePointer(
//                     ignoring: true,
//                     child: Transform.translate(
//                       offset: Offset(0, -10),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Image.asset("assets/vip/bigVip.png", height: 74),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 38),
//                   Align(
//                     alignment: AlignmentGeometry.centerLeft,
//                     child: BackgroundTitleView(title: 'Premium benefit'),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       VipPot(
//                         assetName: "assets/vip/vipAd.png",
//                         title: "No Ads",
//                       ),
//                       Container(
//                         height: 28,
//                         width: 1,
//                         margin: EdgeInsets.only(bottom: 30),
//                         color: Color(0xffffc692).withValues(alpha: 0.2),
//                       ),
//                       VipPot(
//                         assetName: "assets/vip/fast.png",
//                         title: "Speed up",
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 32),
//                   Expanded(
//                     child: Visibility(
//                       visible: isVip == false,
//                       replacement: Column(
//                         children: [
//                           SizedBox(height: 70),
//                           Text(
//                             '''
// Welcome!
// As a new member, you can now enjoy all premium features.''',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xffed9647),
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             BackgroundTitleView(title: 'Premium Plans'),
//                             ...vips.map(
//                               (e) => VipBuy(model: e, choose: choose),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Your subscription will keep renewing automatically until you cancel it, as mentioned in the terms. You have the option to cancel anytime. Just remember to cancel at least 24 hours before the next renewal to prevent extra charges. Also, please be aware that no refunds will be provided if your subscription period is still ongoing.",
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 color: Colors.white.withValues(alpha: 0.3),
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: isVip,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 31.0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             "Deadline：",
//                             style: TextStyle(
//                               color: Colors.white.withValues(alpha: 0.8),
//                             ),
//                           ),
//                           Container(
//                             height: 24,
//                             padding: EdgeInsets.only(left: 7, right: 5),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xff060100), Color(0xff9B3010)],
//                               ),
//                             ),
//                             child: Text(
//                               state.expired ?? "",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Text(
//                     desc ?? "-",
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white.withValues(alpha: 0.85),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 8),
//                   Visibility(
//                     visible: isVip == false,
//                     child: GestureDetector(
//                       onTap: () => ref.read(vipProvider.notifier).buyVip(data),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Image.asset(
//                             "assets/vip/vipBtnBg.png",
//                             width: double.infinity,
//                             fit: BoxFit.fill,
//                           ),
//                           Text(
//                             "Continue",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   VipPrivacy(),
//                   SizedBox(height: 12),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
