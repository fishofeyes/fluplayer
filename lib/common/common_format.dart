import 'dart:math';

import 'package:intl/intl.dart';

extension CommonFormat on int {
  String format([int point = 0]) {
    if (this <= 0) return "0B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(this) / log(1024)).floor();
    return '${(this / pow(1024, i)).toStringAsFixed(point)}${suffixes[i]}';
  }

  String time([String format = "yyyy/MM/dd HH:mm:ss"]) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this));
  }

  String hhMM() {
    int hours = this ~/ 3600;
    int minutes = (this % 3600) ~/ 60;
    int remainingSeconds = this % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    if (formattedHours == "00") {
      return '$formattedMinutes:$formattedSeconds';
    }
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}
