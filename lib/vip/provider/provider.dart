import 'package:flutter_riverpod/flutter_riverpod.dart';

String globalDefaultVipId = "";
bool globalOpenVip = false;
bool isInVipPage = false;
bool isInVipAlertPage = false;
final vipChooseProvider = StateProvider.autoDispose<String>((ref) => "-");

// 1: week, 2: year, 3: lifetime
const vipPriceMap = {
  1: "Weekly subscription for ## with auto-renewal. Cancel anytime.",
  2: "Annual subscription for ## with auto-renewal. Cancel anytime.",
  3: "Lifetime validity upon purchase. No renewal required.",
};
