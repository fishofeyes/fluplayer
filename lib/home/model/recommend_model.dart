import 'package:hive/hive.dart';
part 'recommend_model.g.dart';

@HiveType(typeId: 2)
class RecommendModel {
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String? uname;
  @HiveField(2)
  final String? cover;
  @HiveField(3)
  final bool isMiddle;

  RecommendModel({this.uid, this.uname, this.cover, this.isMiddle = true});

  factory RecommendModel.fromJson(Map<String, dynamic> json, bool isMiddle) =>
      RecommendModel(
        uid: json["bemercy"],
        uname: json["nagger"],
        cover: json["marmorean"],
        isMiddle: isMiddle,
      );
}
