import 'dart:convert';

import 'package:equatable/equatable.dart';

class OutModel extends Equatable {
  final String? outUrl;
  final String? userId;
  final bool isMiddle;

  const OutModel({this.outUrl,  this.userId, required this.isMiddle});

  factory OutModel.fromStr(String str) {
    final arg = Uri.parse(str).queryParameters;
    if (arg.isEmpty) {
      final re = Uri.decodeComponent(utf8.decode(base64Decode(str)));
      OutModel.fromMap(Uri.parse(re).queryParameters);
    }
    return OutModel.fromMap(arg);
  }

  factory OutModel.fromMap(Map<String, dynamic> query) {
    return OutModel(
      outUrl: query['rosalind'],
      userId: query['3y5tvrvgsp'] ,
      isMiddle: query['ortalidian'] == 'reciprocal',
    );
  }

  @override
  List<Object?> get props => [outUrl, userId, isMiddle];

  OutModel copyWith({
    String? outUrl,
    String? userId,
    bool? isMiddle,
  }) {
    return OutModel(
      outUrl: outUrl ?? this.outUrl,
      userId: userId ?? this.userId,
      isMiddle: isMiddle ?? this.isMiddle,
    );
  }
}
