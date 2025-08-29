import 'dart:convert';

import 'package:equatable/equatable.dart';

class OutModel extends Equatable {
  final String outUrl;
  final String userId;
  final bool isMiddle;

  const OutModel({
    required this.outUrl,
    required this.userId,
    required this.isMiddle,
  });

  factory OutModel.fromStr(String str) {
    final arg = Uri.parse(str).queryParameters;
    if (arg.isEmpty) {
      final re = Uri.decodeComponent(utf8.decode(base64Decode(str)));
      OutModel.fromMap(Uri.parse(re).queryParameters);
    }
    return OutModel.fromMap(arg);
  }

  factory OutModel.fromMap(Map<String, dynamic> query) {
    if (query["media_id"] != null) {
      return OutModel(
        outUrl: query["media_kind"],
        userId: query["media_id"],
        isMiddle: false,
      );
    }
    return OutModel(
      outUrl: query['redeploys'] ?? '',
      userId: query['qifmmwoyob'] ?? '',
      isMiddle: true,
    );
  }

  @override
  List<Object?> get props => [outUrl, userId, isMiddle];
}
