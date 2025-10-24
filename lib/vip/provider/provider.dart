import 'package:flutter_riverpod/flutter_riverpod.dart';

String globalDefaultVipId = "";
bool globalOpenVip = false;
final vipChooseProvider = StateProvider.autoDispose<String>((ref) => "-");
