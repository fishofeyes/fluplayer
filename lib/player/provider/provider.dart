import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final mediaProvider = StateProvider((ref) => 0.0);
final mediaStatusProvider = StateProvider<int>((ref) => 0);
final mediaSpeedProvider = StreamProvider.autoDispose<int>(
  (ref) => Stream.periodic(
    const Duration(milliseconds: 900),
    (e) => Random().nextInt(100),
  ),
);
